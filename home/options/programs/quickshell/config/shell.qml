import Quickshell
import QtQuick

PanelWindow // qmllint disable uncreatable-type
{
    anchors {
        top: true
        left: true
        right: true
    }

    margins //
    {
        top: 5
    }
    
    implicitHeight: 30

    Text {
        anchors.centerIn: parent

        text: "haloooaa"
    }
}
