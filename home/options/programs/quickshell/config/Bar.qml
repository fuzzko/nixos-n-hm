import Quickshell
import QtQuick
import QtQuick.Layouts

import "./Modules"
import "./Extras"

Rectangle {
    readonly property int spacing: 5
    readonly property int marginLR: 4

    anchors.fill: parent
    radius: 9.5
    color: "white"

    RowLayout {
        spacing: spacing

        anchors.fill: parent
        anchors.margins: parent.marginLR
        Layout.alignment: Qt.AlignLeft | Qt.AlignCenter

        ClockModule {}
    }

    RowLayout {
        spacing: spacing
    }

    RowLayout {
        spacing: spacing
    }
}
