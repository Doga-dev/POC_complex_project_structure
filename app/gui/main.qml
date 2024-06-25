import QtQuick 2.15
import QtQuick.Controls 2.15

import Graphics 1.0
import graphics 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Button {
        text: qsTr("Press Me")
        anchors.centerIn: parent
        onPressed: text = qsTr("Pressed")
        onReleased: text = qsTr("Released")
    }
}
