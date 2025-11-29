import Quickshell
import QtQuick

PanelWindow // qmllint disable uncreatable-type
{
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 30

    Text {
        anchors.centerIn: parent

        text: "halooo"
    }
}
