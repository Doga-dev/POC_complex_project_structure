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

# Define the QML module
qmldir.files = qmldir
INSTALLS += qmldir

