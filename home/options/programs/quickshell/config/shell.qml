import Quickshell
import QtQuick

PanelWindow // qmllint disable
{
    readonly property int marginLR: 9;

    anchors {
        top: true;
        left: true;
        right: true;
    }

    // qmllint disable
    margins {
        top: 3;
        left: marginLR;
        right: marginLR;
    }
    // qmllint enable
    
    implicitHeight: 30;

    color: "transparent";

    Rectangle {
        anchors.fill: parent;
        radius: 5;
        color: "white";
    }
}
