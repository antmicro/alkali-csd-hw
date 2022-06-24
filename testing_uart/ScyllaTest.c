/*
 * This file is part of the Xilinx DMA IP Core driver tools for Linux
 *
 * Copyright (c) 2016-present,  Xilinx, Inc.
 * All rights reserved.
 *
 * This source code is licensed under both the BSD-style license (found in the
 * LICENSE file in the root directory of this source tree) and the GPLv2 (found
 * in the COPYING file in the root directory of this source tree).
 * You may select, at your option, one of the above-listed licenses.
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <byteswap.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <ctype.h>
#include <termios.h>

#include <sys/types.h>
#include <sys/mman.h>

/* ltoh: little to host */
/* htol: little to host */
#if __BYTE_ORDER == __LITTLE_ENDIAN
#define ltohl(x)       (x)
#define ltohs(x)       (x)
#define htoll(x)       (x)
#define htols(x)       (x)
#elif __BYTE_ORDER == __BIG_ENDIAN
#define ltohl(x)     __bswap_32(x)
#define ltohs(x)     __bswap_16(x)
#define htoll(x)     __bswap_32(x)
#define htols(x)     __bswap_16(x)
#endif

#define FATAL do { fprintf(stderr, "Error at line %d, file %s (%d) [%s]\n", __LINE__, __FILE__, errno, strerror(errno)); exit(1); } while(0)

#define CRIT_PRINT(...) do { printf(__VA_ARGS__); } while (0)

// Enable to help debug, disable to reduce clutter
#if 0
#define DBG_PRINT(...)  do { printf(__VA_ARGS__); } while (0)
#else
#define DBG_PRINT(...)  
#endif // 0

long long int MAP_SIZE;
//#define MAP_MASK (MAP_SIZE - 1)

/*-------------------------------------------------------------------*/
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Reference for ctypes documentation                               */
/*                                                                   */
/*          https://docs.python.org/3/library/ctypes.html            */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*-------------------------------------------------------------------*/

/* Function prototypes */
int init_dev(char * devname, long long * ret_fd, long long int M_SIZE);
int read_word (long long fd, long long * pOffset, unsigned int * pValue );
int read_array(long long inpfd, long long  * pOffset, long long *  size, char * *hostbuf);
int write_array(long long inpfd, long long  * pOffset, long long *  size, char * *hostbuf);
int read_byte (long long fd, long long * pOffset, unsigned char * pValue );
int write_word(long long fd, long long * pOffset, unsigned int * pValue );
int close_dev(long long fd);

/* Maybe add 
int dma_pcie2axi(long long *src,long long *dest, int *len_bytes);
int dma_axi2pcie(long long *src,long long *dest, int *len_bytes);

int dma_pcie2pldram(long long *src,long long *dest, int *len_bytes);
int dma_pcie2psdram(long long *src,long long *dest, int *len_bytes);

int dma_pldram2pcie(long long *src,long long *dest, int *len_bytes);
int dma_psdram2pcie(long long *src,long long *dest, int *len_bytes);

int dma_pl2psdram(long long *src,long long *dest, int *len_bytes);
int dma_ps2pldram(long long *src,long long *dest, int *len_bytes);

*/

void * map_base = NULL;

int opnfd = 0;

int init_dev(char * devname, long long * ret_fd, long long int M_SIZE) 
{       
        MAP_SIZE = M_SIZE;
	if ((opnfd = open(devname, O_RDWR | O_SYNC)) < 0)
		FATAL;
	//CRIT_PRINT("character device %s opened.\n", devname);
	fflush(stdout);

	/* map one page */
	map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, opnfd, 0);
	if (map_base == (void *)-1)
		FATAL;
	//CRIT_PRINT("Memory mapped at address %p.\n", map_base);
	//CRIT_PRINT("MAP_SIZE %ld.\n",MAP_SIZE);
	//CRIT_PRINT("PROT_READ %d.\n",PROT_READ);
	//CRIT_PRINT("PROT_WRITE %d.\n",PROT_WRITE);
	//CRIT_PRINT("MAP_SHARED %d.\n",MAP_SHARED);
	fflush(stdout);

    *ret_fd = (long long) opnfd;

    //DBG_PRINT("c: devname %s  opnfd 0x%016llX map_base 0x%016llX\n", devname, (long long) opnfd, (long long) map_base);
    return 0;
}

int read_word(long long inpfd, long long  * pOffset, unsigned int * pValue )
{
    if (inpfd != (long long) opnfd) 
    {  
        CRIT_PRINT("c: map_base 0x%016llX read_word: fd 0x%016llX Offset 0x%08llx Value 0x%08x opnfd 0x%016llX\n",(long long)map_base, (long long)inpfd,*pOffset,*pValue,(long long) opnfd);
        FATAL;
        return -1;
    }
    if (*pOffset >= MAP_SIZE)
    {
        CRIT_PRINT("c: map_base 0x%016llX read_word: fd 0x%016llX Offset 0x%08llx Value 0x%08x \n",(long long)map_base, (long long)inpfd,*pOffset,*pValue);
        FATAL;
        return -2;
    }
    
    long long oldval = *pValue;
    *pValue = * (int * )(map_base+*pOffset);
    //DBG_PRINT("c: read_word: map_base 0x%016llx Offset 0x%08llx Value %08x\n",map_base,*pOffset,*pValue);

    return 0;
}

int read_byte(long long inpfd, long long  * pOffset, unsigned char * pValue )
{
    if (inpfd != (long long) opnfd) 
    {  
        CRIT_PRINT("c: map_base 0x%016llX read_word: fd 0x%016llX Offset 0x%08llx Value 0x%08x opnfd 0x%016llX\n",(long long)map_base, (long long)inpfd,*pOffset,*pValue,(long long) opnfd);
        FATAL;
        return -1;
    }
    if (*pOffset >= MAP_SIZE)
    {
        CRIT_PRINT("c: map_base 0x%016llX read_word: fd 0x%016llX Offset 0x%08llx Value 0x%08x \n",(long long)map_base, (long long)inpfd,*pOffset,*pValue);
        FATAL;
        return -2;
    }
    
    long long oldval = *pValue;
    *pValue = * (char * )(map_base+*pOffset);
    //DBG_PRINT("c: read_word: map_base 0x%016llx Offset 0x%08llx Value %08x\n",map_base,*pOffset,*pValue);

    return 0;
}


int read_array(long long inpfd, long long  * pOffset, long long * size, char * *hostbuf) {

    char *buffer ;

    buffer = *hostbuf;

    printf("Read Size : %lld\n",(long long) *size);
    //check if buffer is 4K aligned
    if (((uint64_t)buffer & 0x3FF) != 0)
    {
		CRIT_PRINT("c: read_mem buffer not aligned ");
        FATAL;
        return -2;
    }

    if (inpfd != (long long) opnfd) 
    {  
        CRIT_PRINT("c: map_base 0x%016llX read_word: fd 0x%016llX Offset 0x%08llx opnfd 0x%016llX\n",(long long)map_base, (long long)inpfd,*pOffset,(long long) opnfd);
        FATAL;
        return -1;
    }
    if (*pOffset >= MAP_SIZE)
    {
        CRIT_PRINT("c: map_base 0x%016llX read_word: fd 0x%016llX Offset 0x%08llx\n",(long long)map_base, (long long)inpfd,*pOffset);
        FATAL;
        return -2;
    }
    
    //for (int i=0; i<(*size); ++i)
    //    *(buffer+i) = * (char * )(map_base+*pOffset+i);

    memcpy(buffer, map_base+*pOffset, *size);
    return 0;
}

int write_array(long long inpfd, long long  * pOffset, long long *  size, char * *hostbuf) {

    char *buffer ;

    buffer = *hostbuf;
    printf("Write Size : %lld\n",(long long) *size);
    //check if buffer is 4K aligned
    if (((uint64_t)buffer & 0x3FF) != 0)
    {
		CRIT_PRINT("c: read_mem buffer not aligned ");
        FATAL;
        return -2;
    }

    if (inpfd != (long long) opnfd) 
    {  
        CRIT_PRINT("c: map_base 0x%016llX read_word: fd 0x%016llX Offset 0x%08llx opnfd 0x%016llX\n",(long long)map_base, (long long)inpfd,*pOffset,(long long) opnfd);
        FATAL;
        return -1;
    }
    if (*pOffset >= MAP_SIZE)
    {
        CRIT_PRINT("c: map_base 0x%016llX read_word: fd 0x%016llX Offset 0x%08llx\n",(long long)map_base, (long long)inpfd,*pOffset);
        FATAL;
        return -2;
    }
    char* memptr = map_base+*pOffset;
    //for (int i=0; i<(*size); ++i) {
    //    DBG_PRINT("d: iter %d: attempting write to %016llx with data %02x at buffer %016x\n", i, memptr, *buffer, buffer); 
    //    * (memptr++) = *(buffer++);
    //}

    memcpy(map_base+*pOffset, buffer, *size);

    return 0;
}

int write_word(long long inpfd, long long * pOffset, unsigned int * pValue )
{
    if (inpfd != (long long) opnfd) 
    {
        CRIT_PRINT("c: map_base 0x%016llX read_word: inpfd 0x%016llX Offset 0x%08llx Value 0x%08x \n",(long long)map_base, (long long)inpfd,*pOffset,*pValue);
        FATAL;
        return -1;
    }
    if (*pOffset >= MAP_SIZE)
    {
        CRIT_PRINT("c: map_base 0x%016llX read_word: inpfd 0x%016llX Offset 0x%08llx Value 0x%08x \n",(long long)map_base, (long long)inpfd,*pOffset,*pValue);
        FATAL;
        return -2;
    }

    * (int * )(map_base+*pOffset) = *pValue;
    //DBG_PRINT("c: write_word: map_base 0x%016llx Offset 0x%04llx oldValue %08x newValue %08x\n",map_base,*pOffset,*pValue);

    return 0;
}

int close_dev(long long inpfd)
{
    if (inpfd != (long long) opnfd) 
    {
        CRIT_PRINT("c: close_dev : map_base 0x%016llX inpfd 0x%016llX opnfd 0x%016llX\n",(long long)map_base, (long long)inpfd, (long long)opnfd);
        return -1;
    }

	if (munmap(map_base, MAP_SIZE) == -1)
		FATAL;
	close(opnfd);

   // CRIT_PRINT("Closed device handle\n");
    opnfd = 0;
    return 0;
}

