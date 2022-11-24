#
# Copyright 2021-2022 Western Digital Corporation or its affiliates
# Copyright 2021-2022 Antmicro
#
# SPDX-License-Identifier: Apache-2.0

FROM debian:buster

RUN apt update

# Install Vivado
RUN apt install -y \
  build-essential \
  bzip2 \
  curl \
  default-jdk \
  git \
  libtinfo5 \
  libxtst6 \
  make \
  python3 \
  python3-pip \
  tcl \
  wget \
  x11-xserver-utils \
  xsltproc

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
