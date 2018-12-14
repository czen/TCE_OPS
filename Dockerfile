FROM ubuntu:18.04

RUN apt-get update && \
    apt-get -y install p7zip-full && \
    apt-get -y install qt5-default libqt5svg5-dev && \
    apt-get -y install wget && \
    apt-get clean && \
    apt-get -y autoremove
    
RUN ./install_tzdata.sh
    
RUN apt-get -y install libwxgtk3.0-dev && \
    apt-get -y install libboost-all-dev && \
    apt-get -y install tcl8.6-dev && \ 
    apt-get -y install libedit-dev && \ 
    apt-get -y install libsqlite3-dev && \
    apt-get -y install sqlite3 && \
    apt-get -y install libxerces-c-dev && \
    apt-get -y install g++ make && \
    apt-get -y install latex2html && \
    apt-get -y install libffi-dev && \
    apt-get -y install autoconf automake libtool subversion git cmake
    
RUN git clone https://github.com/cpc/tce.git tce-devel

RUN cd tce-devel/tce && \
    tools/scripts/install_llvm_7.0.sh $HOME/local
      
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/local/lib && \
    export PATH=$PATH:$HOME/local/bin && \
    export LDFLAGS=-L$HOME/local/lib && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib/tce && \
    ./autogen.sh && \
    ./configure --prefix=$HOME/local && \
    make && \
    make install
    
RUN mkdir ~/Src && \
    cd ~/Src && \
    wget http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz && \
    wget http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz  && \
    tar -xvf llvm-3.3.src.tar.gz && \
    tar -xvf cfe-3.3.src.tar.gz && \
    mv -T cfe-3.3.src llvm-3.3.src/tools/clang && \
    mkdir llvm-3.3.build && \
    cd llvm-3.3.build && \
    cmake \
      -D CMAKE_BUILD_TYPE=Debug \
      -D LLVM_REQUIRES_RTTI=1 \
      -D LLVM_TARGETS_TO_BUILD="X86;Sparc;ARM" \
      -D BUILD_SHARED_LIBS=1  \
      -D LLVM_INCLUDE_EXAMPLES=0 \
      -D LLVM_INCLUDE_TESTS=0 \
      -D CMAKE_INSTALL_PREFIX=~/Lib/llvm-3.3.install \      
      ../llvm-3.3.src && \
    make  && \
    make install
