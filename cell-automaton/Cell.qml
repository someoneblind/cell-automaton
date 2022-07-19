import QtQuick 2.0

Item {
    Rectangle {
        anchors.fill: parent
        border.width: 1
        border.color: isLiving ? "white" : "black"
        color: isLiving ? "black" : "white"
        radius: 3

        Text {
            anchors.centerIn: parent
            text: aroundCount
            color: isLiving ? "white" : "black"
            font.pointSize: 6
        }
    }
}
