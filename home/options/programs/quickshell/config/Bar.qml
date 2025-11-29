import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    readonly property int spacing: 5
    readonly property int marginLR: 4
    
    anchors.fill: parent
    radius: 9.5;
    color: "white"

        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

    RowLayout {
        spacing: spacing

        ClockModule {}
    }

    RowLayout {
        spacing: spacing
    }

    RowLayout {
        spacing: spacing
    }
}
