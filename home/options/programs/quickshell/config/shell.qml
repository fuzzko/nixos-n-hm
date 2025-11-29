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
        top: 10;
        left: marginLR;
        right: marginLR;
    }
    // qmllint enable
    
    implicitHeight: 30;

    color: "transparent";

    Bar {}
}
