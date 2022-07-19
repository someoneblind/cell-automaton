import QtQuick 2.0
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Item {
    opacity: enabled ? 1 : 0.3

    Rectangle {
        id: button
        width: parent.width
        height: parent.height
        radius: 2
        border.width: 1
        border.color: buttonMA.pressed ? "lightgray" : "#545454"
        antialiasing: true
    }

    DropShadow {
        anchors.fill: button
        cached: true
        radius: 2
        horizontalOffset: 0
        verticalOffset: 0
        samples: 8
        color: "#40000000"
        source: button
    }

    Rectangle {
        id: buttonInnerRect
        anchors.fill: parent
        anchors.margins: 3
        radius: 2.5
        color: "white"
        antialiasing: true
    }

    DropShadow {
        anchors.fill: buttonInnerRect
        cached: true
        radius: 4
        horizontalOffset: 0
        verticalOffset: 0
        samples: 8
        color: buttonMA.pressed ? "#00000000" : "#20000000"
        source: buttonInnerRect
    }

    MouseArea {
        id: buttonMA
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            forceActiveFocus()
            onMouseClicked()
        }
    }
}
