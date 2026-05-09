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
    
    // Внутреннее состояние для независимой работы на разных мониторах
    property string localSymbol: cfg.currentSymbol !== undefined ? cfg.currentSymbol : ":)"
    
    // Настройки из конфига
    readonly property bool optDuplicate: cfg.duplicateOnMonitors !== false
    readonly property bool optLeftClick: cfg.enableLeftClick !== false
    readonly property bool optRightClick: cfg.enableRightClick !== false

    // Текст, который реально отображается
    readonly property string displaySymbol: optDuplicate ? (cfg.currentSymbol !== undefined ? cfg.currentSymbol : ":)") : localSymbol

    // Виджет всегда виден на всех мониторах
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
            property var duplicateOnMonitors
            property var enableLeftClick
            property var enableRightClick
        }
    }
    
    // Синхронизируем локальный символ, если настройки были изменены в GUI
    Connections {
        target: cfg
        function onCurrentSymbolChanged() {
            if (!optDuplicate) {
                root.localSymbol = cfg.currentSymbol;
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
        text: root.displaySymbol
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
                if (root.optRightClick) {
                    pickerMenu.visible = !pickerMenu.visible
                }
            } else {
                if (root.optLeftClick) {
                    const next = root.emojis[Math.floor(Math.random() * root.emojis.length)];
                    if (root.optDuplicate) {
                        cfg.currentSymbol = next;
                        cfgFile.writeAdapter();
                    } else {
                        root.localSymbol = next;
                    }
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
                if (root.optDuplicate) {
                    cfg.currentSymbol = modelData;
                    cfgFile.writeAdapter();
                } else {
                    root.localSymbol = modelData;
                }
                pickerMenu.visible = false
            }
        }
    }
}
