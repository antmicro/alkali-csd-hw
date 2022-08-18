FROM debian:buster

RUN apt update

# Install Vivado
RUN apt install -y \
  wget \
  x11-xserver-utils \
  libxtst6 \
  build-essential \
  xsltproc \
  bzip2 \
  tcl \
  libtinfo5

COPY Xilinx_Vivado_2019.2_1106_2127.tar.gz /
COPY install_config.txt /

RUN tar -xzf Xilinx_Vivado_2019.2_1106_2127.tar.gz && \
    /Xilinx_Vivado_2019.2_1106_2127/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config install_config.txt && \
    rm -rf Xilinx_Vivado_2019.2_1106_2127*
RUN rm install_config.txt

# Install system dependencies
RUN apt install -y \
  curl \
  default-jdk \
  git \
  make \
  python3 \
  python3-pip \
  wget

# Install python dependencies
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN rm requirements.txt

# Install Chisel
RUN wget www.scala-lang.org/files/archive/scala-2.13.0.deb
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt update
RUN dpkg -i scala*.deb
RUN apt install -y sbt=1.4.9

# Install formating tools
RUN apt install -y shellcheck
COPY --from=mvdan/shfmt /bin/shfmt /bin/shfmt

# Install make 4.3
RUN wget https://ftp.gnu.org/gnu/make/make-4.3.tar.gz
RUN tar xf make-4.3.tar.gz && cd make-4.3 && ./configure && make -j$(nproc)
RUN cp make-4.3/make /opt/.
RUN rm -rf make-4.3*
ENV PATH="/opt:${PATH}"

# Configure entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
