#!/usr/bin/env python3.6

"""
class for each instance of the STC unit
"""
from ctypes import *
import numpy as np
import logging
import sys
import time
import threading
import serial
import subprocess

RX_FIFO = 0
TX_FIFO = 4
STAT_REG = 8
CTRL_REG = 12


class U_LITE(object):
    def __init__(self, fd, so):
        """
        init method
        :param fd: c_longlong: opened file descriptor for the hardware
        :param inst: int: instance number
        :param r: register spec object
        :param so: shared object
        """

        self.fd = fd
        self.so = so
        if (sys.argv[1] == "zynqmp"):
            self.base = 0x00000000 #sfw.basalt_addr('UART')
        elif (sys.argv[1] == "buildroot"):
            self.base = 0x00800000 #sfw.basalt_addr('UART')
        else:
            exit()
        #self.base = 0x00000000 #sfw.basalt_addr('UART')
        #self.base = 0xff010000 #sfw.basalt_addr('UART')
        #self.base = sfw.basalt_addr('UART')
        self.wfifo_depth=16
        self.rfifo_depth=16

    def rd32(self, addr):
        """
        reads a register from the raw address
        :param addr: int: will be converted to uint32
        :return: int
        """
        regaddr = c_uint(addr)
        regval = c_int(-1)
        retval = self.so.read_word(self.fd, byref(regaddr), byref(regval))
        #print("attempting to read from %08x, got %08x"%(addr, regval.value))
        return regval.value

    def wr32(self, addr, data):
        """
        reads a register from the raw address
        :param addr: int: will be converted to uint32
        :param data: int: will be converted to uint32
        :return: int
        """
        regaddr = c_uint(addr)
        regval = c_uint(data)
        #print("attempting to write to %08x : %08x"%(addr, data))
        retval = self.so.write_word(self.fd, byref(regaddr), byref(regval))
        return regval.value

    def get_reg(self, raddr, roffset=0):
        """
        read a register by reg name,
        :param rname: str: hierarchically separated by '.'
        :param roffset: int: register offset in unit increments (not byte offset)
        :return: int
        """
        addr = raddr
        addr += self.base
        addr += roffset * 4
        return self.rd32(addr)

    def set_reg(self, rname, rdata, roffset=0):
        """
        read a register by reg name,
        :param rname: str: hierarchically separated by '.'
        :param rdata: int: write data
        :param roffset: int: register offset in unit increments (not byte offset)
        :return: int
        """
        addr = rname
        addr += self.base
        addr += roffset*4
        return self.wr32(addr, rdata)

    def send_cmd(self, cmd):
        # convert to ascii list
        cmd = cmd + '\n'
        alist = [ord(ele) for sub in cmd for ele in sub]
        # send while tx_fifo is not full
        for a in alist:
            while True:
                t_full = self.get_reg(STAT_REG) & 0x8
                if not t_full:
                    self.set_reg(TX_FIFO, a)
                    break
                else:
                    #print("waiting on !tx_full")
                    time.sleep(0.02)
                
    def send(self, slist):
        for a in slist:
            while True:
                t_full = self.get_reg(STAT_REG) & 0x8
                if not t_full:
                    self.set_reg(TX_FIFO, a)
                    break
                else:
                    #print("waiting on !tx_full")
                    time.sleep(0.02)
              
    def recv(self):
        # initially wait for at least 1 byte time (in case it is on the fly)
        time.sleep(0.0001) # 10/115200
        r_nempty = self.get_reg(STAT_REG) & 0x1
        ret = b''
        while r_nempty:
            ret = ret + bytes([self.get_reg(RX_FIFO) & 0xFF])
            r_nempty = self.get_reg(STAT_REG) & 0x1
            if not r_nempty:
                # if empty, wait for 1 byte duration (in case a byte is on the fly)
                time.sleep(0.0001)
                # and recheck the status
                r_nempty = self.get_reg(STAT_REG) & 0x1
            
        return ret
    
            
    def get_fld(self, rname, fname):
        """
        read a register by field name
        :param rname: str: hierarchically separated by '.'
        :param fname: str: field name
        :return: int: masked and stc_offset adjusted
        """
        reg = self.r.get_address('fast', 'fast.'+rname)
        for field in reg['fields']:
            if field.name == fname:
                fwidth = field.width
                fidx = field.loidx
                #print("get %s %s %s"%(fname, fwidth, fidx))
        rdata = self.get_reg(rname)
        return (rdata >> fidx) & ((2**fwidth)-1)

    def set_fld(self, rname, fname, fdata):
        reg = self.r.get_address('fast', 'fast.'+rname)
        for field in reg['fields']:
            if field.name == fname:
                fwidth = field.width
                fidx = field.loidx
                #print("set %s %s %s"%(fname, fwidth, fidx))
        rdata = self.get_reg(rname)
        mask = ((2**fwidth)-1) << fidx
        rdata &= ~mask
        rdata |= (fdata << fidx)
        self.set_reg(rname, rdata)

    def set_flds(self, rname, fdict):
        reg = self.r.get_address('fast', 'fast.'+rname)
        mask = 0
        wdata = 0
        for fname in fdict.keys():
            fmask = 0
            fdata = fdict[fname]
            for field in reg['fields']:
                if field.name == fname:
                    fwidth = field.width
                    fidx = field.loidx
                    #print(fname, fwidth, fidx)
                    fmask = ((2 ** fwidth) - 1) << fidx
                    wdata |= (fdata << fidx)
            mask += fmask
            assert fmask > 0 # to fail loudly if  any field is invalid
        rdata = self.get_reg(rname)
        rdata &= ~mask
        rdata |= wdata
        self.set_reg(rname, wdata)


if __name__ == "__main__":
    ScyllaDUT = cdll.LoadLibrary("./libScyllaTest.so")
    Scyllafd = c_longlong()

    if (len(sys.argv) < 2):
        print("please give argument (zynqmp/buildroot)")
        exit()

    tmpcmd = 'lspci'.split()
    out = subprocess.check_output(tmpcmd)
    pciedevlst = out.decode('utf8').splitlines()
    device=[]
    for devline in pciedevlst:
        if devline.find('Western Digital Device') !=-1:
            ID = devline.split()[0]
            device.append(ID)

    boardid = ("/sys/bus/pci/devices/0000:"+str(device[1])+"/resource2").encode('utf8') 
    
    
    retval = ScyllaDUT.init_dev(c_char_p(boardid), byref(Scyllafd), 16*1024*1024)

    #retval = ScyllaDUT.init_dev(c_char_p(b"/dev/xdma0_user"), byref(Scyllafd), sfw.get_map_size())
    #print("ScyllaDUT.init Scyllafd 0x{:016X} retval {}\n".format(Scyllafd.value, retval))

    ul0 = U_LITE(fd=Scyllafd, so=ScyllaDUT)

    print("Press ENTER for Console")
    #ser = serial.Serial(sys.argv[1], timeout=0.001)
    
    def ul_writer():
        
        while True:
            #host_i = sys.stdin.read()
            #host_i = ser.read(16)
            host_i = input()
            if len(host_i) >= 0:
                #logging.warning('host_i: %s'%host_i)
                #print('host_i: %s'%host_i)
                #ul0.send_cmd(host_i.encode('utf-8'))
                ul0.send_cmd(host_i)
            else:
                #logging.warning('nothing from host')
                #sys.stdout.write('nothing from host')
                pass
            #logging.warning('waiting in writer')
            #print('waiting in writer')
            time.sleep(0.02)

            
    
    def ul_reader():
        while True:
            ul_i = ul0.recv()
            if len(ul_i) > 0:
                #logging.warning('ul_i: %s'%ul_i)
                #print('ul_i: %s'%ul_i)
                #var_byte = ul_i.decode("ASCII")
                #print(format.("\xf7"))
                sys.stdout.write(ul_i.decode('utf-8'))
                #sys.stdout.write(ul_i.decode('utf-8'))
                #ser.write(ul_i.decode('utf-8'))
                #ser.write(ul_i)
                #ser.flush()
            else:
                #logging.warning('nothing from ul')
                #sys.stdout.write('nothing from ul')
                pass
                
            time.sleep(0.02)
    
        f.close()            
    
    #stc0.print_status()
     
    ul0.set_reg(CTRL_REG, 3)
    ul0.set_reg(CTRL_REG, 0)

    #stc0.send_cmd("sf probe")
    #stc0.send(b'abcd')
    #stc0.send_cmd("fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
    time.sleep(0.1)
    #for i in range(16):
    #    #stc0.set_reg(TX_FIFO, ord('a'))
    #    print ('rx_fifo', stc0.get_reg(RX_FIFO))
    #    #time.sleep(0.1)
    #    print ('status', stc0.get_reg(STAT_REG)),
    #print (stc0.recv())
    r = threading.Thread(target=ul_reader)
    w = threading.Thread(target=ul_writer)
    r.start()
    w.start()
    #ul_writer()
    
