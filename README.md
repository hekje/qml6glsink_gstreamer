# README #
# qml6glsink_gstreamer

This repository builds a custom GStreamer with qml6glsink support and provides a minimal Qt6/QML application demonstrating its use.

## What is this repository for? ##

Build a custom GStreamer stack with QML6 support

Avoid dependency on system-installed GStreamer

Run a Qt6 + QML example using qml6glsink

Version: 1.0.0

## How do I get set up? ##

Summary of set up

```bash
git clone --recurse-submodules <your-repo-url>
cd qml6glsink_gstreamer
./build_gstreamer.sh
```

Configuration

The script installs GStreamer to the gstreamer-custom/ folder at the repo root.
If this folder already exists, it will be cleared and recreated.

Dependencies

Qt 6.6 or later (with QML and Quick modules)

CMake 3.16+

Meson and Ninja build systems

A C++17-compatible compiler

GStreamer:
https://gitlab.freedesktop.org/gstreamer/gstreamer.git third-party/gstreamer
Version 1.26.1

pkg-config

How to build the example

First, configure environment variables to use Qt 6.6.3 
(Note: You may need to adjust the paths according to your local installation):

```bash
export PKG_CONFIG_PATH=/home/$USER/Qt/6.6.3/gcc_64/lib/pkgconfig:$PKG_CONFIG_PATH
export CMAKE_PREFIX_PATH=/home/$USER/Qt/6.6.3/gcc_64
export PATH=/home/$USER/Qt/6.6.3/gcc_64/bin:$PATH
export LD_LIBRARY_PATH=/home/$USER/Qt/6.6.3/gcc_64/lib:/<your path>/qml6glsink_gstreamer/gstreamer-custom/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
```


```bash
cd example
mkdir -p build && cd build
cmake ../src
make
```

How to run the example

Before running the example C++/QML application, you need to configure your environment variables to ensure that Qt, GStreamer, and related libraries are correctly located.

Add the following lines to your terminal session
(Note: You may need to adjust the paths according to your local installation):

```bash
export QT_QPA_PLATFORM=xcb
export LD_LIBRARY_PATH=/home/$USER/Qt/6.6.3/gcc_64/lib:qml6glsink_gstreamer/gstreamer-custom/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
export GST_PLUGIN_PATH=/<your path>/qml6glsink_gstreamer/gstreamer-custom/lib/x86_64-linux-gnu/gstreamer-1.0
export QML_IMPORT_PATH=/home/$USER/Qt/6.6.3/gcc_64/qml:$QML_IMPORT_PATH

```

```bash
./play
```


