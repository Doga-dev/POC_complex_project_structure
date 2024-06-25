QT += qml quick

TEMPLATE = lib
CONFIG += plugin
TARGET = graphics

INCLUDEPATH += include

HEADERS += include/graphics.h \
           

SOURCES += source/graphics.cpp \
           

RESOURCES += gui/qml.qrc

# Use the DESTDIR variable for the output directory
DESTDIR = $$DESTDIR

# Specify the path to qmldir
qmldir.files = gui/qmldir
qmldir.path = $$OUT_PWD/gui

# Define the QML module
INSTALLS += qmldir

