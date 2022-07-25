ARG IMAGE_BASE

FROM ${IMAGE_BASE}
ARG IMAGE_BASE
ARG REPO_ROOT

RUN echo "Using ${IMAGE_BASE} docker image as a base..."
RUN echo "Repository root set to be ${REPO_ROOT}..."

# system dependencies

RUN apt update -y && apt install -y \
  curl \
  default-jdk \
  git \
  make \
  python3 \
  python3-pip \
  wget

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN rm requirements.txt

# chisel dependencies

RUN wget www.scala-lang.org/files/archive/scala-2.13.0.deb
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt update
RUN dpkg -i scala*.deb
RUN apt install -y sbt=1.4.9

# format

RUN apt install -y shellcheck
COPY --from=mvdan/shfmt /bin/shfmt /bin/shfmt
