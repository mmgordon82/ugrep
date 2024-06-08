# Build the ugrep image
#   $ docker build -t ugrep .
#
# Execute ugrep in the container (mount the host / directory in the container /mnt directory)
#   $ docker run -v /:/mnt -it ugrep --help
# or run bash in the container instead:
#   $ docker run --entrypoint /bin/bash -v /:/mnt -it ugrep
#   $ ugrep --help

FROM ubuntu

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    pkg-config \
    make \
    vim \
    git \
    clang \
    wget \
    unzip \
    libpcre2-dev \
    libz-dev \
    libbz2-dev \
    liblzma-dev \
    liblz4-dev \
    libzstd-dev \
    libbrotli-dev

WORKDIR /ugrep

# Clone ugrep from GitHub
RUN git clone --single-branch --depth=1 https://github.com/Genivia/ugrep /ugrep

# Local build of ugrep
# If you want to build ugrep from a local source, uncomment the following line:
# ADD . /ugrep

# Statically build ugrep
ENV CPPFLAGS="-DPCRE2_STATIC -static"
RUN autoreconf -fi
RUN ./build.sh --enable-static --without-brotli
RUN make install

ENTRYPOINT [ "ugrep" ]