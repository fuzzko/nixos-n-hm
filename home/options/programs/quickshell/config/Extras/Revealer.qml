import QtQuick

Item {
    id: root
    
    enum TransitionType {
        None,
        CrossFade,
        SlideDown,
        SlideUp,
        SlideLeft,
        SlideRight
    }

    property alias container: content.data
    required property bool reveal
    property Revealer.TransitionType transitionType: Revealer.TransitionType.CrossFade // qmllint disable
    property int duration
    property var easing

    QtObject {
        id: previous
        property var value: ({
            opacity: content.opacity,
            x: content.x,
            y: content.y,
        })
    }

    Item {
        id: content

        states: [
            State {
                name: "crossfade"
                when: !root.reveal && root.transitionType == Revealer.TransitionType.CrossFade // qmllint disable
                PropertyChanges {
                    content.opacity: 0
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "opacity,x,y"
                easing: root.easing
            }
        }
    }
}
