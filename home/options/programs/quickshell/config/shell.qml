import Quickshell
import QtQuick

PanelWindow // qmllint disable
{
    anchors {
        top: true;
        left: true;
        right: true;
    }

    margins.top: 3; // qmllint disable
    
    implicitHeight: 30;

    color: "transparent";

    Rectangle {
        anchors.fill: parent;
        radius: 5;
        color: "white";
    }
}
