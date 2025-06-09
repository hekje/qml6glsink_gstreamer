cmake_minimum_required(VERSION 3.16)

project(gst-qmlsink-example LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# Get the absolute path to the gstreamer-custom directory
get_filename_component(GST_CUSTOM_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../gstreamer-custom" ABSOLUTE)

# Override pkg-config search path to prioritize local GStreamer
set(ENV{PKG_CONFIG_PATH} "${GST_CUSTOM_ROOT}/lib/x86_64-linux-gnu/pkgconfig:${GST_CUSTOM_ROOT}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")

# Find GStreamer, GLib, and related libraries using pkg-config
find_package(PkgConfig REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)
pkg_check_modules(GSTREAMER REQUIRED gstreamer-1.0)
pkg_check_modules(GST_PLUGINS_BASE REQUIRED gstreamer-plugins-base-1.0)
pkg_check_modules(GST_VIDEO REQUIRED gstreamer-video-1.0)
pkg_check_modules(GST_GL REQUIRED gstreamer-gl-1.0)
pkg_check_modules(GLIB REQUIRED glib-2.0) # Add GLib


# Override GStreamer include directories to prioritize custom GStreamer
set(GSTREAMER_INCLUDE_DIRS
    "${GST_CUSTOM_ROOT}/include"
    "${GST_CUSTOM_ROOT}/include/gstreamer-1.0"
)

set(GST_PLUGINS_BASE_INCLUDE_DIRS
    "${GST_CUSTOM_ROOT}/include/gstreamer-1.0"
    "${GST_CUSTOM_ROOT}/include"
)
set(GST_VIDEO_INCLUDE_DIRS
    "${GST_CUSTOM_ROOT}/include/gstreamer-1.0"
    "${GST_CUSTOM_ROOT}/include"
)
set(GST_GL_INCLUDE_DIRS
    "${GST_CUSTOM_ROOT}/include/gstreamer-1.0"
    "${GST_CUSTOM_ROOT}/include"
)

# Include GLib headers (from system or custom GLib installation)
set(GLIB_INCLUDE_DIRS
    ${GLIB_INCLUDE_DIRS} # From pkg-config
    "/usr/include/glib-2.0" # Fallback for system GLib
    "/usr/lib/x86_64-linux-gnu/glib-2.0/include" # For glibconfig.h
)

# Override library directories (if needed)
set(GSTREAMER_LIBRARIES
    "${GST_CUSTOM_ROOT}/lib/x86_64-linux-gnu/libgstreamer-1.0.so"
)
set(GST_PLUGINS_BASE_LIBRARIES
    "${GST_CUSTOM_ROOT}/lib/x86_64-linux-gnu/libgstpbutils-1.0.so"
)
set(GST_VIDEO_LIBRARIES
    "${GST_CUSTOM_ROOT}/lib/x86_64-linux-gnu/libgstvideo-1.0.so"
)
set(GST_GL_LIBRARIES
    "${GST_CUSTOM_ROOT}/lib/x86_64-linux-gnu/libgstgl-1.0.so"
)
set(GLIB_LIBRARIES ${GLIB_LIBRARIES}) # From pkg-config

message(STATUS "gst-qmlsink-example - CMAKE_SOURCE_DIR = ${CMAKE_SOURCE_DIR}")	# Project top/root
message(STATUS "gst-qmlsink-example - PROJECT_SOURCE_DIR = ${PROJECT_SOURCE_DIR}")
message(STATUS "gst-qmlsink-example - CMAKE_CURRENT_SOURCE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}")
get_filename_component(CAMERA_PARENT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" DIRECTORY)
message(STATUS "gst-qmlsink-example - CAMERA_PARENT_DIR = ${CAMERA_PARENT_DIR}")

message(STATUS "gst-qmlsink-example - ==================================================")
message(STATUS "gst-qmlsink-example - ")
message(STATUS "gst-qmlsink-example - GSTREAMER")
message(STATUS "gst-qmlsink-example - ")
message(STATUS "gst-qmlsink-example - ==================================================")
message(STATUS "gst-qmlsink-example - GSTREAMER_INCLUDE_DIRS = ${GSTREAMER_INCLUDE_DIRS}")
message(STATUS "gst-qmlsink-example - GST_PLUGINS_BASE_INCLUDE_DIRS = ${GST_PLUGINS_BASE_INCLUDE_DIRS}")
message(STATUS "gst-qmlsink-example - GST_VIDEO_INCLUDE_DIRS = ${GST_VIDEO_INCLUDE_DIRS}")
message(STATUS "gst-qmlsink-example - GST_GL_INCLUDE_DIRS = ${GST_GL_INCLUDE_DIRS}")
message(STATUS "gst-qmlsink-example - GLIB_INCLUDE_DIRS = ${GLIB_INCLUDE_DIRS}")

message(STATUS "gst-qmlsink-example - GSTREAMER_LIBRARIES = ${GSTREAMER_LIBRARIES}")
message(STATUS "gst-qmlsink-example - GST_PLUGINS_BASE_LIBRARIES = ${GST_PLUGINS_BASE_LIBRARIES}")
message(STATUS "gst-qmlsink-example - GST_VIDEO_LIBRARIES = ${GST_VIDEO_LIBRARIES}")
message(STATUS "gst-qmlsink-example - GST_GL_LIBRARIES = ${GST_GL_LIBRARIES}")
message(STATUS "gst-qmlsink-example - GLIB_LIBRARIES = ${GLIB_LIBRARIES}")

#message(STATUS "gst-qmlsink-example - PKG_CONFIG_PATH = ${PKG_CONFIG_PATH}")

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include 
    ${GSTREAMER_INCLUDE_DIRS}
    ${GST_PLUGINS_BASE_INCLUDE_DIRS}
    ${GST_VIDEO_INCLUDE_DIRS}
    ${GST_GL_INCLUDE_DIRS}
    ${GLIB_INCLUDE_DIRS}
)

# Add QML resources
qt6_add_resources(QML_RESOURCE qmlsink.qrc)

add_executable(play
    main.cpp
    ${QML_RESOURCE}
)

target_include_directories(play PRIVATE
    ${Qt6Core_INCLUDE_DIRS}	
    ${Qt6Quick_INCLUDE_DIRS}  	
    ${Qt6Qml_INCLUDE_DIRS}    	
    ${PROJECT_SOURCE_DIR}/include    
    ${GSTREAMER_INCLUDE_DIRS}
    ${GST_PLUGINS_BASE_INCLUDE_DIRS}
    ${GST_VIDEO_INCLUDE_DIRS}
    ${GST_GL_INCLUDE_DIRS}
    ${GLIB_INCLUDE_DIRS}
)

target_link_libraries(play PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
    ${GSTREAMER_LIBRARIES}
    ${GST_PLUGINS_BASE_LIBRARIES}
    ${GST_VIDEO_LIBRARIES}
    ${GST_GL_LIBRARIES}
    ${GLIB_LIBRARIES} 
    gobject-2.0
)

target_compile_options(play PRIVATE
    ${GSTREAMER_CFLAGS_OTHER}
    ${GST_PLUGINS_BASE_CFLAGS_OTHER}
    ${GST_VIDEO_CFLAGS_OTHER}
    ${GST_GL_CFLAGS_OTHER}
)

# Install target
include(GNUInstallDirs)
install(TARGETS play RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# RPath to local GStreamer and Qt install
set_target_properties(play PROPERTIES
    INSTALL_RPATH
        "${GST_CUSTOM_ROOT}/lib/x86_64-linux-gnu;/home/$ENV{USER}/Qt/6.6.3/gcc_64/lib"
)

