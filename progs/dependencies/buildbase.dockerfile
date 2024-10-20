# syntax=docker/dockerfile:latest
# ====================================================================
# =      ===============  =====  =======      ========================
# =  ===  ==============  =====  =======  ===  =======================
# =  ====  =============  =====  =======  ====  ======================
# =  ===  ===  =  ==  ==  =====  =======  ===  ====   ====   ====   ==
# =      ====  =  ======  ===    =======      ====  =  ==  =  ==  =  =
# =  ===  ===  =  ==  ==  ==  =  =======  ===  ======  ===  ====     =
# =  ====  ==  =  ==  ==  ==  =  =======  ====  ===    ====  ===  ====
# =  ===  ===  =  ==  ==  ==  =  =======  ===  ===  =  ==  =  ==  =  =
# =      =====    ==  ==  ===    =======      =====    ===   ====   ==
# ====================================================================

FROM ubuntu:jammy AS build-base01
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt update && apt-get --no-install-recommends install -y \
  build-essential \
  git \
  cmake \
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
  clang-format \
  libavfilter-dev \
  libfreeimage-dev \
  libfreetype6-dev \
  libgit2-dev \
  libpugixml-dev \
  libpoppler-cpp-dev \
  ca-certificates \
  gettext \
  libharfbuzz-dev \
  libicu-dev \
  ccache

  RUN ccache -M 0 --set-config=compiler_check=content --set-config=sloppiness=include_file_ctime,include_file_mtime
