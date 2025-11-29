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

        Revealer {
            implicitHeight: text.implicitHeight
            implicitWidth: text.implicitWidth
            
            MouseArea {
                onClicked: parent.reveal = !parent.reveal
            }
            
            reveal: false

            Text {
                id: text
                text: "aaa"
            }
        }
    }

    RowLayout {
        spacing: spacing
    }

    RowLayout {
        spacing: spacing
    }
}
