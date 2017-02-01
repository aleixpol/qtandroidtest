qt5_add_resources(extrasrcs resources.qrc)
add_library(qqc2app SHARED main.cpp ${extrasrcs})
target_link_libraries(qqc2app Qt5::Gui Qt5::Quick)
