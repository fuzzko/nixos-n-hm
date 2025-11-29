import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    readonly property int spacing: 5
    readonly property int marginLR: 4
    
    anchors.fill: parent
    radius: 9.5;
    color: "white"

    RowLayout {
        spacing: spacing
            Layout.alignment: Qt.AlignCenter

        ClockModule {
        }
    }

    RowLayout {
        spacing: spacing
    }

    RowLayout {
        spacing: spacing
    }
}
