import QtQuick
import QtQuick.Layouts

Rectangle {    
    anchors.fill: parent;
    radius: 5;
    color: "white";

    RowLayout {
        readonly property int marginLR: 3;
        spacing: 5;

        anchors.left: parent.left;
        anchors.leftMargin: marginLR;
        anchors.verticalCenter: parent.verticalCenter;

        Text {
            text: "aaa"
        }
        Text {
            text: "aaa"
        }
    }
}
