QT += qml quick

TEMPLATE = lib
CONFIG += plugin
TARGET = Graphics

INCLUDEPATH += include

HEADERS += include/graphics.h \
           

SOURCES += source/graphics.cpp \
           

RESOURCES += gui/qml.qrc

# Define the QML module
qmldir.files = qmldir
INSTALLS += qmldir

