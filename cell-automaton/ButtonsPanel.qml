import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQml.Models 2.1
import QtQuick.Layouts 1.12

import QtQml 2.12

Item {
    Rectangle {
        anchors.fill: parent
        border.width: 1
        border.color: "black"

        Rectangle {
            width: parent.width - 20
            height: sizesColumn.height + 20

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 10
            }

            radius: 2

            border.width: 1
            border.color: "gray"

            antialiasing: true

            ButtonGroup {
                id: xRadioGroup
            }

            Column {
                id: sizesColumn

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    topMargin: 10
                }

                spacing: 10

                Text {
                    text: "  Work area size:"
                }

                Repeater {
                    id: xGraphsRBs
                    model: ["32x32", "44x44", "56x56"]
                    delegate: RadioButton {
                        width: 300
                        height: 20
                        text: modelData
                        checked: !index
                        ButtonGroup.group: xRadioGroup
                        onCheckedChanged: {
                            if (checked) {
                                switch (index) {
                                case 0: {
                                    cellsRows = cellsColumns = 32
                                    break
                                }
                                case 1: {
                                    cellsRows = cellsColumns = 44
                                    break
                                }
                                case 2: {
                                    cellsRows = cellsColumns = 56
                                    break
                                }
                                }
                                workPanel.isWorkTimerRunning = false
                                startStopButtonText.text = "Start"

                                workPanel.fillEmpty()
                            }
                        }
                    }
                }
            }
        }

        Column {
            id: buttonsColumn
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 10
            }

            spacing: 10

            ButtonTemplate {
                id: startStopButton

                width: parent.width
                height: 30

                Text {
                    id: startStopButtonText
                    text: qsTr("Start")
                    anchors.centerIn: parent
                }

                function onMouseClicked() {
                    workPanel.isWorkTimerRunning = !workPanel.isWorkTimerRunning
                    if (workPanel.isWorkTimerRunning)
                        startStopButtonText.text = "Stop"
                    else
                        startStopButtonText.text = "Start"
                }
            }

            ButtonTemplate {
                id: stepButton

                width: parent.width
                height: 30

                enabled: !workPanel.isWorkTimerRunning

                Text {
                    id: stepButtonText
                    text: qsTr("One step")
                    anchors.centerIn: parent
                }

                function onMouseClicked() {
                    workPanel.analize(true)
                }
            }

            ButtonTemplate {
                id: clearButton

                width: parent.width
                height: 30

                Text {
                    id: clearButtonText
                    text: qsTr("Clear")
                    anchors.centerIn: parent
                }

                function onMouseClicked() {
                    workPanel.fillEmpty()

                    workPanel.isWorkTimerRunning = false
                    startStopButtonText.text = "Start"
                }
            }
        }
    }
}
