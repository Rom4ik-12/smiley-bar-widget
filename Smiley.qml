import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    implicitWidth: label.implicitWidth + 20
    implicitHeight: 40

    property var emojis: [
        ":)", ":/", ">.<", ">-<", ">_<", ":D", ":(", "O_o", "B-)", "^_^",
        "ツ", "¯\\_(ツ)_/¯", "( ͡° 3 ͡°)", "(¬‿¬)", "(◣_◢)", "ಠ_◣", "◕‿◕", "ᵔᴥ◕",
        "ʕ•ᴥ•ʔ", "(▀̿Ĺ̯▀̿ ̿)", "(づ｡◕‿‿◕｡)づ", "༼ つ ◕_◕ ༼", "(v_v)", "(o_o)", "(-_-)"
    ]
    
    property var distros: [
        "", "", "", "", "", "", "", "", "", "", "", "󰙯", 
        "", "󰢮", "", "", "󰖳", "", "", "", "", "", "", "", 
        "", "", "", "", "", "", "", "", "", "", "", "", 
        "", "", "", "", "", "", "", "", "󰈺"
    ]

    property string currentSymbol: ":)"

    StyledText {
        id: label
        anchors.centerIn: parent
        text: root.currentSymbol
        font.pixelSize: Appearance.font.pixelSize.normal
        color: Appearance.colors.colOnSurface
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        z: 999

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton) {
                pickerMenu.x = -pickerMenu.width / 2 + root.width / 2
                pickerMenu.y = root.height + 5
                pickerMenu.open()
            } else {
                root.currentSymbol = root.emojis[Math.floor(Math.random() * root.emojis.length)]
            }
        }
    }

    Popup {
        id: pickerMenu
        padding: 12
        width: 360
        height: 280
        
        background: Rectangle {
            color: Appearance.colors.colLayer2
            radius: Appearance.rounding.medium
            border.color: Appearance.colors.colOutlineVariant
            border.width: 1
        }

        contentItem: RowLayout {
            spacing: 12
            anchors.fill: parent
            
            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                StyledText {
                    text: "эмодзи"
                    font.weight: Font.Bold
                    font.pixelSize: 11
                    Layout.alignment: Qt.AlignHCenter
                    opacity: 0.6
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentWidth: flow1.width

                    Flow {
                        id: flow1
                        width: 155
                        spacing: 4
                        Repeater {
                            model: root.emojis
                            delegate: itemDelegate
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillHeight: true
                width: 1
                color: Appearance.colors.colOutlineVariant
                opacity: 0.2
            }

            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true
                Layout.fillHeight: true

                StyledText {
                    text: "системы"
                    font.weight: Font.Bold
                    font.pixelSize: 11
                    Layout.alignment: Qt.AlignHCenter
                    opacity: 0.6
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentWidth: flow2.width

                    Flow {
                        id: flow2
                        width: 155
                        spacing: 4
                        Repeater {
                            model: root.distros
                            delegate: itemDelegate
                        }
                    }
                }
            }
        }
    }

    Component {
        id: itemDelegate
        MouseArea {
            width: 34
            height: 34
            hoverEnabled: true
            
            Rectangle {
                anchors.fill: parent
                color: parent.containsMouse ? Appearance.colors.colLayer2Hover : "transparent"
                radius: 6
            }

            StyledText {
                anchors.centerIn: parent
                text: modelData
                font.pixelSize: 14
                color: parent.containsMouse ? Appearance.colors.colPrimary : Appearance.colors.colOnSurface
            }

            onClicked: {
                root.currentSymbol = modelData
                pickerMenu.close()
            }
        }
    }
}
