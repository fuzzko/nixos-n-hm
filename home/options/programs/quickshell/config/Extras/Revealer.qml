import QtQuick

Item {
    id: revealer
    
    enum Transition {
        None,
        CrossFade,
        SlideDown,
        SlideUp,
        SlideLeft,
        SlideRight
    }
    
    required property bool reveal
    property Transition transitionType: Revealer.Transition.CrossFade
    default property alias content: child.children

    states: [
        State {
            name: "reveal"
            when: revealer.transitionType === Revealer.Transition.CrossFade

            PropertyChanges {
                child.opacity: 100
            }
        }
    ]

    Item {
        id: child
        
    }
}
