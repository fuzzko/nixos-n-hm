import QtQuick
import QtQuick.Layouts

Rectangle {
    anchors.fill: parent;
    radius: 5;
    color: "white";

    RowLayout {
        spacing: 3;

        anchors.left: parent.left;

        Text {
            text: "aaa"
        }
        Text {
            text: "aaa"
        }
    }
}
