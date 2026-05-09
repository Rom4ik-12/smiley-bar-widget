import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    
    // Локальное состояние для этого экземпляра виджета
    property string currentSymbol: cfg.currentSymbol !== undefined ? cfg.currentSymbol : ":)"

    implicitWidth: label.implicitWidth + 20
    implicitHeight: 40

    FileView {
        id: cfgFile
        path: Directories.state + "/smiley-bar-widget/config.json"
        watchChanges: true
        onFileChanged: reload()
        
        JsonAdapter {
            id: cfg
            property var currentSymbol
            property bool enableLeftClick: true
            property bool enableRightClick: true
        }
    }
    
    // Если символ изменили в настройках (глобально), обновляем локальный символ везде
    Connections {
        target: cfg
        function onCurrentSymbolChanged() {
            if (cfg.currentSymbol !== undefined) {
                root.currentSymbol = cfg.currentSymbol;
            }
        }
    }

    property var emojis: [
        ":)", ":/", ">.<", ">-<", ">_<", ":D", ":(", "O_o", "B-)", "^_^",
        "ツ", "¯\\_(ツ)_/¯", "( ͡° 3 ͡°)", "(¬‿¬)", "(◣_◢)", "ಠ_◣", "◕‿◕", "ᵔᴥ◕",
        "ʕ•ᴥ•ʔ", "(▀̿Ĺ̯▀̿ ̿)", "(づ｡◕‿‿◕｡)づ", "༼ つ ◕_◕ ༼", "(v_v)", "(o_o)", "(-_-)"
    ]
    
    property var distros: [
        "", "", "", "", "", "", "", "", "", "", "󰙯", 
        "", "󰢮", "", "", "󰖳", "", "", "", "", "", "", "", 
        "", "", "", "", "", "", "", "", "", "", "", "", 
        "", "", "", "", "", "", "", "", "󰈺", ""
    ]

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
                if (cfg.enableRightClick) {
                    pickerMenu.visible = !pickerMenu.visible
                }
            } else {
                if (cfg.enableLeftClick) {
                    // Клик меняет символ ТОЛЬКО локально на этом мониторе
                    root.currentSymbol = root.emojis[Math.floor(Math.random() * root.emojis.length)];
                }
            }
        }
    }

    PopupWindow {
        id: pickerMenu
        visible: false
        width: 380
        height: 300
        color: "transparent"

        anchor {
            item: root
            gravity: Config.options.bar.bottom ? Edges.Top : Edges.Bottom
        }

        Rectangle {
            anchors.fill: parent
            color: Appearance.colors.colLayer2
            radius: Appearance.rounding.medium
            border.color: Appearance.colors.colOutlineVariant
            border.width: 1

            Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 16
                
                Column {
                    spacing: 8
                    width: 170
                    
                    StyledText {
                        width: parent.width
                        text: "эмодзи"
                        font.weight: Font.Bold
                        font.pixelSize: 11
                        horizontalAlignment: Text.AlignHCenter
                        opacity: 0.6
                    }

                    ScrollView {
                        width: 170
                        height: 240
                        clip: true
                        contentWidth: flow1.width

                        Flow {
                            id: flow1
                            width: 160
                            spacing: 4
                            Repeater {
                                model: root.emojis
                                delegate: itemDelegate
                            }
                        }
                    }
                }

                Rectangle {
                    height: parent.height
                    width: 1
                    color: Appearance.colors.colOutlineVariant
                    opacity: 0.2
                }

                Column {
                    spacing: 8
                    width: 170

                    StyledText {
                        width: parent.width
                        text: "системы"
                        font.weight: Font.Bold
                        font.pixelSize: 11
                        horizontalAlignment: Text.AlignHCenter
                        opacity: 0.6
                    }

                    ScrollView {
                        width: 170
                        height: 240
                        clip: true
                        contentWidth: flow2.width

                        Flow {
                            id: flow2
                            width: 160
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
    }

    Component {
        id: itemDelegate
        MouseArea {
            width: 36
            height: 36
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
                // Выбор в меню меняет символ ТОЛЬКО локально
                root.currentSymbol = modelData;
                pickerMenu.visible = false
            }
        }
    }
}
