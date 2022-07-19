import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQml.Models 2.1
import QtQml 2.12

Item {
    property bool isWorkTimerRunning: false
    property bool isHovered: false

    function fillEmpty() {
        workListModel.clear()
        tempListModel.clear()
        for (var i = 0; i < workGrid.rows; ++i) {
            for (var j = 0; j < workGrid.columns; ++j) {
                workListModel.append({'aroundCount': 0, 'isLiving': false})
                tempListModel.append({'aroundCount': 0, 'isLiving': false})
            }
        }
    }

    function analize(isUpdLiving) {
        for (var i = 0; i < workGrid.rows; ++i) { // rows
            for (var j = 0; j < workGrid.columns ; ++j) { // columns

                var aroundCellsCount = 0

                // top
                if ((i > 0) && (j > 0) && workListModel.get((j - 1) + (i - 1) * workGrid.rows).isLiving)
                    ++aroundCellsCount
                if ((i > 0) && workListModel.get(j + (i - 1) * workGrid.rows).isLiving)
                    ++aroundCellsCount
                if ((i > 0) && (j < (workGrid.columns - 1)) && workListModel.get((j + 1) + (i - 1) * workGrid.rows).isLiving)
                    ++aroundCellsCount

                // mid
                if ((j > 0) && workListModel.get((j - 1) + i * workGrid.rows).isLiving)
                    ++aroundCellsCount
                if ((j < (workGrid.columns - 1)) && workListModel.get((j + 1) + i * workGrid.rows).isLiving)
                    ++aroundCellsCount

                // bottom
                if ((i < (workGrid.rows - 1)) && (j > 0) && workListModel.get((j - 1) + (i + 1) * workGrid.rows).isLiving)
                    ++aroundCellsCount
                if ((i < (workGrid.rows - 1)) && workListModel.get(j + (i + 1) * workGrid.rows).isLiving)
                    ++aroundCellsCount
                if ((i < (workGrid.rows - 1)) && (j < (workGrid.columns - 1)) && workListModel.get((j + 1) + (i + 1) * workGrid.rows).isLiving)
                    ++aroundCellsCount

                if (isUpdLiving) {
                    if (workListModel.get(j + i * workGrid.columns).isLiving) {
                        if ((aroundCellsCount === 2) || (aroundCellsCount === 3)) {
                            tempListModel.get(j + i * workGrid.columns).isLiving = true
                        }
                        else {
                            tempListModel.get(j + i * workGrid.columns).isLiving = false
                        }
                    }
                    else {
                        if (aroundCellsCount === 3) {
                            tempListModel.get(j + i * workGrid.columns).isLiving = true
                        }
                        else {
                            tempListModel.get(j + i * workGrid.columns).isLiving = false
                        }
                    }
                }
                else {
                    workListModel.get(j + i * workGrid.columns).aroundCount = aroundCellsCount
                }
            }
        }

        if (isUpdLiving) {
            for (var wlm = 0; wlm < workListModel.count; ++wlm) {
                workListModel.get(wlm).isLiving = tempListModel.get(wlm).isLiving
            }
            analize(false)
        }
    }

    ListModel {
        id: workListModel
    }

    ListModel {
        id: tempListModel
    }

    Rectangle {
        id: workRec
        anchors.fill: parent
        border.width: 1
        border.color: "black"

        Grid {
            id: workGrid
            anchors {
                fill: parent
                margins: 10
            }

            columns: cellsColumns
            rows: cellsRows

            Repeater {
                id: workRepeater
                model: workListModel
                delegate: Cell {
                    width: cellSize
                    height: width
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            pressAndHoldInterval: 100

            property int lastCellId: -1

            function cellLiveChange(x, y, isClicked) {
                if ((x < workGrid.anchors.leftMargin) ||
                        (y < workGrid.anchors.topMargin) ||
                        (x >= (workGrid.width + workGrid.anchors.leftMargin)) ||
                        (y >= (workGrid.height + workGrid.anchors.topMargin)))
                    return

                var tmpX = Math.floor((x - workGrid.anchors.leftMargin) / cellSize)
                var tmpY = Math.floor((y - workGrid.anchors.topMargin) / cellSize)

                var cellId = tmpX + tmpY * workGrid.columns
                if ((lastCellId != cellId) || isClicked) {
                    workListModel.get(cellId).isLiving = !workListModel.get(cellId).isLiving
                    analize(false)
                    if (!isClicked)
                        lastCellId = cellId
                }
            }

            onClicked: {
                cellLiveChange(mouse.x, mouse.y, true)
            }

            onPressAndHold: {
                isHovered = true
                cellLiveChange(mouse.x, mouse.y, false)
            }

            onReleased: {
                isHovered = false
                lastCellId = -1
            }

            onPositionChanged: {
                if (isHovered) {
                    cellLiveChange(mouse.x, mouse.y, false)
                }
            }
        }
    }

    Timer {
        id: workTimer
        interval: 100; running: isWorkTimerRunning; repeat: true
        onTriggered: {
            analize(true)
        }
    }

}
