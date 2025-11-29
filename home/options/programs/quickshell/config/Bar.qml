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

        ClockModule {}
    }

    RowLayout {
        spacing: spacing

        anchors.centerIn: parent
    }

    RowLayout {
        spacing: spacing

        anchors.right: parent.right
        anchors.rightMargin: marginLR /* qmllint disable */ // same as the above
        anchors.verticalCenter: parent.verticalCenter
    }
}
