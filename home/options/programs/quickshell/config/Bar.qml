import QtQuick
import QtQuick.Layouts

Rectangle {
    readonly property int marginLR: 3;
    
    anchors.fill: parent;
    radius: 5;
    color: "white";

    RowLayout {
        spacing: 5;

        anchors.left: parent.left;
        anchors.leftMargin: marginLR; // qmllint disable
        anchors.verticalCenter: parent.verticalCenter;

        Text {
            text: "aaa"
        }
        Text {
            text: "aaa"
        }
    }
}
