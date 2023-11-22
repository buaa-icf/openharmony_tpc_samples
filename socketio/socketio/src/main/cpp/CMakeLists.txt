# the minimum version of CMake.
cmake_minimum_required(VERSION 3.4.1)
project(client_socket_c)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})


##------------ source  start -------------
#配置参数
option(USE_SUBMODULES "Use source in local submodules instead of system libraries" ON)
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(DEFAULT_BUILD_TYPE "Release")
    message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
    set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)

    # Set the possible values of build type for cmake-gui
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

message(STATUS ">>>>> '${CMAKE_CURRENT_LIST_DIR}' ")

# 查找当前目录下的所有源文件
# 并将文件保存到 ALL_SRC 变量
aux_source_directory(${CMAKE_CURRENT_LIST_DIR}/socketio/src ALL_SRC)
aux_source_directory(${CMAKE_CURRENT_LIST_DIR}/socketio/src/internal ALL_SRC)

#file GLOB命令主要用于匹配规则在指定的目录内匹配到所需要的文件
file(GLOB ALL_HEADERS ${CMAKE_CURRENT_LIST_DIR}/socketio/src/*.h)

# 添加cmake编译参数
add_definitions(

    # These will force ASIO to compile without Boost
    -DBOOST_DATE_TIME_NO_LIB
    -DBOOST_REGEX_NO_LIB
    -DASIO_STANDALONE

    # These will force sioclient to compile with C++11
    -D_WEBSOCKETPP_CPP11_STL_
    -D_WEBSOCKETPP_CPP11_FUNCTIONAL_
    -D_WEBSOCKETPP_CPP11_TYPE_TRAITS_
    -D_WEBSOCKETPP_CPP11_CHRONO_
)

# 生成链接库
add_library(sioclient ${ALL_SRC})

if(USE_SUBMODULES)
    set(MODULE_INCLUDE_DIRS
        ${CMAKE_CURRENT_LIST_DIR}/socketio/lib/websocketpp
        ${CMAKE_CURRENT_LIST_DIR}/socketio/lib/rapidjson/include
        ${CMAKE_CURRENT_LIST_DIR}/socketio/lib/asio/asio/include
    )
else()
    find_package(websocketpp CONFIG REQUIRED)
    find_package(asio CONFIG REQUIRED)
    find_package(RapidJSON CONFIG REQUIRED)
    target_link_libraries(sioclient PRIVATE websocketpp::websocketpp asio asio::asio rapidjson)
endif()

#指定目标包含的头文件路径。
target_include_directories(sioclient PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    PRIVATE
    ${MODULE_INCLUDE_DIRS}
)

if(CMAKE_VERSION VERSION_GREATER "3.1")
    set_property(TARGET sioclient PROPERTY CXX_STANDARD 11)
    set_property(TARGET sioclient PROPERTY CXX_STANDARD_REQUIRED ON)
else()
    set_property(TARGET sioclient APPEND_STRING PROPERTY COMPILE_FLAGS "-std=c++11")
endif()

list(APPEND TARGET_LIBRARIES sioclient)

export(PACKAGE sioclient)

include(GNUInstallDirs)

install(FILES ${ALL_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(TARGETS ${TARGET_LIBRARIES} EXPORT sioclientTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# === generate a CMake Config File ===
include(CMakePackageConfigHelpers)
set(ConfigPackageLocation ${CMAKE_INSTALL_LIBDIR}/cmake/sioclient)
string(REGEX REPLACE "([^;]+)" "find_dependency(\\1)" _find_dependency_calls "${_package_dependencies}")
string(REPLACE ";" "\n" _find_dependency_calls "${_find_dependency_calls}")

#write_basic_package_version_file(
#    "${CMAKE_CURRENT_BINARY_DIR}/sioclient/sioclientConfigVersion.cmake"
#    VERSION ${sioclient_VERSION}
#    COMPATIBILITY AnyNewerVersion
#)

export(EXPORT sioclientTargets
    FILE "${CMAKE_CURRENT_BINARY_DIR}/sioclient/sioclientTargets.cmake"
    NAMESPACE sioclient::
)

configure_package_config_file(sioclientConfig.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/sioclient/sioclientConfig.cmake"
    INSTALL_DESTINATION "${ConfigPackageLocation}"
)

install(EXPORT sioclientTargets
    NAMESPACE
    sioclient::
    DESTINATION
    ${ConfigPackageLocation}
)
install(
    FILES
    "${CMAKE_CURRENT_BINARY_DIR}/sioclient/sioclientConfig.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/sioclient/sioclientConfigVersion.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/sioclient/sioclientTargets.cmake"
    DESTINATION
    ${ConfigPackageLocation}
)

##------------ source  end -------------

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include
                    ${NATIVERENDER_ROOT_PATH}/socketio/src
                    ${NATIVERENDER_ROOT_PATH}/socketio/src/internal
                    )

add_library(client_socket_c SHARED client_socket.cpp)
target_link_libraries(client_socket_c PUBLIC sioclient libace_napi.z.so libc++.a libhilog_ndk.z.so)
#target_link_libraries(client_socket_c PUBLIC sioclient libace_napi.z.so)
