# Building
```
mkdir build
cd build
cmake .. -DCMAKE_SYSTEM_NAME=Android   -DCMAKE_SYSTEM_VERSION=21   -DCMAKE_ANDROID_ARCH_ABI=armeabi-v7a -DCMAKE_ANDROID_NDK=/opt/android-ndk  -DCMAKE_ANDROID_STL_TYPE=gnustl_shared -DCMAKE_INSTALL_PREFIX=$HOME/android/install -DCMAKE_PREFIX_PATH=$HOME/android/qt5/qtbase -DQTANDROID_EXPORTED_TARGET=qqc2app -DANDROID_APK_DIR=`pwd`/../data
make
make create-apk-qqc2app
adb install -r qqc2app_build_apk//bin/QtApp-debug.apk
```
