import QtQuick
import QtQuick.Layouts

Rectangle {
    anchors.fill: parent;
    radius: 5;
    color: "white";

    RowLayout {
        spacing: 5;

        anchors.left: parent.left;

        Text {
            text: "aaa"
        }
        Text {
            text: "aaa"
        }
    }
}
