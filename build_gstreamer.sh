#!/bin/bash

# Exit on any error
set -e

# User-configurable Qt installation directory
QT_INSTALL_DIR="/home/$USER/Qt/6.6.3/gcc_64"

# Find the root of the git project
GIT_ROOT=$(git rev-parse --show-toplevel)

# Define custom GStreamer install directory inside the git project
GSTREAMER_INSTALL_DIR="${GIT_ROOT}/gstreamer-custom"

# Create or empty the gstreamer-custom directory
if [ -d "${GSTREAMER_INSTALL_DIR}" ]; then
    echo "Cleaning existing directory: ${GSTREAMER_INSTALL_DIR}"
    rm -rf "${GSTREAMER_INSTALL_DIR:?}/"*
else
    echo "Creating directory: ${GSTREAMER_INSTALL_DIR}"
    mkdir -p "${GSTREAMER_INSTALL_DIR}"
fi

echo "Using GStreamer installation directory: ${GSTREAMER_INSTALL_DIR}"

# Update package lists and install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y build-essential meson ninja-build git \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  libglib2.0-dev liborc-dev pkg-config \
  qt6-declarative-dev qt6-base-dev qt6-wayland \
  libsrt-openssl-dev \
  libsrtp2-dev

# Set environment variables for Qt and GStreamer
echo "Setting up environment variables..."
export PKG_CONFIG_PATH="${QT_INSTALL_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}"
export CMAKE_PREFIX_PATH="${QT_INSTALL_DIR}"
export PATH="${QT_INSTALL_DIR}/bin:${PATH}"
export LD_LIBRARY_PATH="${QT_INSTALL_DIR}/lib:${GSTREAMER_INSTALL_DIR}/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}"

# Change to the gstreamer submodule directory
echo "Changing to gstreamer submodule directory..."
cd "${GIT_ROOT}/third-party/gstreamer"

# Create build directory and run meson setup
echo "Configuring build with meson..."
meson setup builddir \
  --prefix="${GSTREAMER_INSTALL_DIR}" \
  -Dqt6=enabled \
  -Dgood=enabled \
  -Dbad=enabled \
  -Dugly=enabled \
  -Dgst-plugins-bad:libsrt=enabled \
  -Dgst-plugins-bad:msdk=disabled \
  -Dintrospection=disabled #\
# Enable if setup has been done and you only want to reconfigure
#  --reconfigure

# Build the project
echo "Building with ninja..."
ninja -C builddir -j$(nproc)

# Install the build
echo "Installing..."
python3 -m mesonbuild.mesonmain install -C builddir

# Set up GStreamer plugin path and verify installation
echo "Verifying installation..."
export GST_PLUGIN_PATH="${GSTREAMER_INSTALL_DIR}/lib/x86_64-linux-gnu/gstreamer-1.0"
gst-inspect-1.0 qml6glsink

echo "Build and installation completed successfully!"

