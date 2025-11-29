import QtQuick
import QtQuick.Layouts

Rectangle {
    readonly property int spacing: 5
    readonly property int marginLR: 4
    
    anchors.fill: parent
    radius: 8;
    color: "white"

    RowLayout {
        spacing: spacing

        anchors.left: parent.left
        anchors.leftMargin: marginLR /* qmllint disable */ // too lazy to define `id`
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: "aaa"
        }
        Text {
            text: "aaa"
        }
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
