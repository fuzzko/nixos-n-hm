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

    default property alias container: content.data
    required property bool reveal
    property Revealer.TransitionType transitionType: Revealer.TransitionType.CrossFade // qmllint disable
    property int duration
    property var easing

    Item {
        id: content
        opacity: 0

        states: [
            State {
                name: "crossfade"
                when: !root.reveal && root.transitionType == Revealer.TransitionType.CrossFade // qmllint disable
                PropertyChanges {
                    content.opacity: 100
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
