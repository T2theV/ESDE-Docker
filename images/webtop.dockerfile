# syntax=docker/dockerfile:latest
  # ==================================================
  # =  ====  ====  =========  ========================
  # =  ====  ====  =========  ========================
  # =  ====  ====  =========  ======  ================
  # =  ====  ====  ===   ===  =====    ===   ===    ==
  # =   ==    ==  ===  =  ==    ====  ===     ==  =  =
  # ==  ==    ==  ===     ==  =  ===  ===  =  ==  =  =
  # ==  ==    ==  ===  =====  =  ===  ===  =  ==    ==
  # ===    ==    ====  =  ==  =  ===  ===  =  ==  ====
  # ====  ====  ======   ===    ====   ===   ===  ====
  # ==================================================

  FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble AS webtop-emulation 

  # set version label
  ARG BUILD_DATE
  ARG VERSION
  LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
  LABEL maintainer="T2theV"
  LABEL org.opencontainers.image.source https://github.com/T2theV/ESDE-Docker
  
  # title
  ENV TITLE="ESDE"
  
  # prevent Ubuntu's firefox stub from being installed
  ADD https://github.com/linuxserver/docker-webtop.git#ubuntu-mate:root/etc/apt/preferences.d /etc/apt/preferences.d
  
  RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
    echo "**** add icon ****" && \
    curl -o \
      /kclient/public/icon.png \
      https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png && \
    echo "**** install packages ****" && \
    add-apt-repository -y ppa:mozillateam/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
      ayatana-indicator-application \
      firefox \
      mate-applets \
      mate-applet-brisk-menu \
      mate-terminal \
      pluma \
      ubuntu-mate-artwork \
      ubuntu-mate-default-settings \
      ubuntu-mate-desktop \
      ubuntu-mate-icon-themes && \
    echo "**** mate tweaks ****" && \
    rm -f \
      /etc/xdg/autostart/mate-power-manager.desktop \
      /etc/xdg/autostart/mate-screensaver.desktop && \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf \
      /config/.cache \
      /config/.launchpadlib \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /tmp/*
  
  # add local files
  ADD https://github.com/linuxserver/docker-webtop.git#ubuntu-mate:root /
  
  # ports and volumes
  EXPOSE 3000
  VOLUME /config
  
  
    ######### Customize Container Here ###########
   
  RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && apt-get --no-install-recommends install -y \
  build-essential \
  git \
  ffmpeg \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev \
  libevdev-dev \
  libusb-1.0-0-dev \
  libxrandr-dev \
  libxi-dev \
  libpangocairo-1.0-0 \
  qt6-base-private-dev \
  libqt6svg6-dev \
  libbluetooth-dev \
  libasound2-dev \
  libpulse-dev \
  libgl1-mesa-dev \
  libcurl4-openssl-dev \
  libopenal-dev \
  libglew-dev \
  zlib1g-dev \
  libedit-dev \
  libvulkan-dev \
  libudev-dev \
  libsdl2-2.0 \
  libsdl2-dev \
  libjack-dev \
  libsndio-dev \
  cmake \
  libmbedtls-dev \
  libpugixml-dev \
  libpoppler-cpp-dev \
  libfreeimage-dev \
  libavfilter-dev \
  libgit2-dev \
  libxcb-cursor0 \
  libxcb-cursor-dev \
  gettext \
  libharfbuzz-dev \
  libicu-dev \
  miniupnpc
  
    
    # RUN --mount=type=cache,target=/root/.cache/pip python3 -m pip install pdftotext
    
      # Dolphin Emulator
      RUN --mount=type=bind,from=dolphin-dist,source=/,target=/dolphin,rw \
        cd /dolphin/build && make install
    
      #RCPS3 
      # RUN --mount=type=bind,from=qt-base,source=/qt6,target=/qt6,rw cd /qt6/qt6_build && cmake --install .
      #RUN --mount=type=bind,from=qt-base,source=/qt6,target=/qt6,rw cd qt6/qt6-build && cmake --install .
      #RUN --mount=type=bind,from=rpcs3,source=/rpcs3_build,target=/rpcs3_build \
           # cd/ /rpcs3_build/ && make install
      COPY --from=rpcs3-dist /usr/local/Qt /usr/local/Qt
      COPY --from=rpcs3-dist /rpcs3_build/bin/ /rpcs3/
      ENV PATH=$PATH:/rpcs3
      
      #ESDE
      RUN --mount=type=bind,from=esde-dist,source=/build,target=/build,rw \
        --mount=type=bind,from=esde-dist,source=/esde,target=/esde,rw \
        cd /build && make install
  
  
    run add-apt-repository -y ppa:ubuntu-toolchain-r/test
  
    RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && apt-get --no-install-recommends install -y \
    libstdc++6 wget
    RUN <<EOT
      wget https://apt.llvm.org/llvm.sh
      chmod +x llvm.sh
      ./llvm.sh 20
EOT

    ADD https://github.com/LizardByte/Sunshine/releases/download/v2025.122.141614/sunshine-ubuntu-24.04-amd64.deb /config/sunshine.deb
    RUN apt install -y /config/sunshine.deb && rm /config/sunshine.deb
    COPY images/webtop-files/kasmrun.run /etc/s6-overlay/s6-rc.d/svc-kasmvnc/run
    # COPY images/webtop-files/svc-sunshine /etc/s6-overlay/s6-rc.d/svc-sunshine
    # RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/svc-sunshine
    COPY images/webtop-files/defaults/startwm.sh /defaults/startwm.sh
      ######### End Customizations ###########
