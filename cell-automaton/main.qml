import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    id: mainWindow
    width: workPanel.width + buttonsPanel.width
    height: workPanel.height
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    visible: true
    title: qsTr("cellular-automaton")

    property int cellsRows: 32
    property int cellsColumns: 32
    property int cellSize: 15

    onCellsRowsChanged: {
        workPanel.height = cellsRows * cellSize + 10 * 2
        mainWindow.maximumHeight = height
        mainWindow.minimumHeight = height
    }

    onCellsColumnsChanged: {
        workPanel.width = cellsColumns * cellSize + 10 * 2
        mainWindow.maximumWidth = width
        mainWindow.minimumWidth = width
    }

    WorkPanel {
        id: workPanel
        width: cellsColumns * cellSize + 10 * 2
        height: cellsRows * cellSize + 10 * 2

        anchors {
            left: parent.left
        }
    }

    ButtonsPanel {
        id: buttonsPanel
        width: 200
        height: workPanel.height

        anchors {
            right: parent.right
        }
    }
}
