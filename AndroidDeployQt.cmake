if (NOT CMAKE_SYSTEM_NAME STREQUAL "Android")
    return()
endif()

macro(ANDROID_SDK_VERSION OUTPUT_VAR)
    set(path "${ANDROID_SDK_ROOT}/build-tools/")
    string(LENGTH ${path} length)

    file(GLOB children LIST_DIRECTORIES TRUE ${path}*)
    foreach(v ${children})
        string(SUBSTRING ${v} ${length} -1 ${OUTPUT_VAR})
    endforeach()
endmacro()

set(CREATEAPK_TARGET_NAME "create-apk-${QTANDROID_EXPORTED_TARGET}")
# Need to ensure we only get in here once, as this file is included twice:
# from CMakeDetermineSystem.cmake and from CMakeSystem.cmake generated within the
# build directory.
if(DEFINED QTANDROID_EXPORTED_TARGET AND NOT TARGET ${CREATEAPK_TARGET_NAME})
    if(NOT DEFINED ANDROID_APK_DIR)
        message(FATAL_ERROR "Define an apk dir to initialize from using -DANDROID_APK_DIR=<path>. The specified directory must contain the AndroidManifest.xml file.")
    elseif(NOT EXISTS "${ANDROID_APK_DIR}/AndroidManifest.xml")
        message(FATAL_ERROR "Cannot find ${ANDROID_APK_DIR}/AndroidManifest.xml according to ANDROID_APK_DIR")
    endif()

    find_package(Qt5Core REQUIRED)

    set(ANDROID_SDK_ROOT "$ENV{ANDROID_SDK_ROOT}")

    android_sdk_version(ANDROID_SDK_BUILD_TOOLS_REVISION)

#     CMAKE_AR:FILEPATH=/opt/android-ndk/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ar
    string(REGEX MATCH "${CMAKE_ANDROID_NDK}/toolchains/(.+)-([^-]+)/prebuilt/${CMAKE_ANDROID_NDK_TOOLCHAIN_HOST_TAG}/bin/.+" "" ${CMAKE_AR})
    set(ANDROID_TOOLCHAIN ${CMAKE_MATCH_1})
    set(ANDROID_TOOLCHAIN_VERSION ${CMAKE_MATCH_2})

    set(EXPORT_DIR "${CMAKE_BINARY_DIR}/${QTANDROID_EXPORTED_TARGET}_build_apk/")
    set(EXECUTABLE_DESTINATION_PATH "${EXPORT_DIR}/libs/${CMAKE_ANDROID_ARCH_ABI}/lib${QTANDROID_EXPORTED_TARGET}.so")
    configure_file("${CMAKE_CURRENT_LIST_DIR}/deployment-file.json.in" "${QTANDROID_EXPORTED_TARGET}-deployment.json.in")

    add_custom_target(${CREATEAPK_TARGET_NAME}
        COMMAND cmake -E echo "Generating $<TARGET_NAME:${QTANDROID_EXPORTED_TARGET}> with $<TARGET_FILE_DIR:Qt5::qmake>/androiddeployqt"
        COMMAND cmake -E remove_directory "${EXPORT_DIR}"
        COMMAND cmake -E copy_directory "${ANDROID_APK_DIR}" "${EXPORT_DIR}"
        COMMAND cmake -E copy "$<TARGET_FILE:${QTANDROID_EXPORTED_TARGET}>" "${EXECUTABLE_DESTINATION_PATH}"
        COMMAND cmake -DINPUT_FILE="${QTANDROID_EXPORTED_TARGET}-deployment.json.in" -DOUTPUT_FILE="${QTANDROID_EXPORTED_TARGET}-deployment.json" "-DTARGET_DIR=$<TARGET_FILE_DIR:${QTANDROID_EXPORTED_TARGET}>" "-DTARGET_NAME=${QTANDROID_EXPORTED_TARGET}" "-DEXPORT_DIR=${CMAKE_INSTALL_PREFIX}" -P ${CMAKE_CURRENT_LIST_DIR}/specifydependencies.cmake
        COMMAND $<TARGET_FILE_DIR:Qt5::qmake>/androiddeployqt --input "${QTANDROID_EXPORTED_TARGET}-deployment.json" --output "${EXPORT_DIR}" --deployment bundled "\\$(ARGS)"
    )
else()
    message(STATUS "You can export a target by specifying -DQTANDROID_EXPORTED_TARGET=<targetname>")
endif()
