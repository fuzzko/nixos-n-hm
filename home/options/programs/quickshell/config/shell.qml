import Quickshell
import QtQuick

PanelWindow // qmllint disable uncreatable-type
{
    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 1
    }
    
    implicitHeight: 30

    Text {
        anchors.centerIn: parent

        text: "haloooaa"
    }
}
