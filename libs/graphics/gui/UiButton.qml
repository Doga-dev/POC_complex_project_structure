import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: rootItem; objectName: "UiButton"
    text: "Button"

    states: [
        State {
            name: "Pressed"; when: pressed
            PropertyChanges {
                target: rootItem
                color: "red"
            }
        }
    ]
} // Button : rootItem

