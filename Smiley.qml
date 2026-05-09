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
    implicitWidth: (getConfig().duplicateOnMonitors ?? true) || (root.QsWindow.screen.name === "eDP-1") ? label.implicitWidth + 20 : 0
    visible: (getConfig().duplicateOnMonitors ?? true) || (root.QsWindow.screen.name === "eDP-1")
    implicitHeight: 40

    FileView {
        id: cfg
        path: Directories.state + "/user/smiley-bar-widget/config.json"
        watchChanges: true
    }

    function getConfig() {
        return JSON.parse(cfg.text || "{}");
    }

    function updateConfig(key, value) {
        const c = getConfig();
        c[key] = value;
        cfg.setText(JSON.stringify(c, null, 2));
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

    property string currentSymbol: getConfig().currentSymbol ?? ":)"
    
    Connections {
        target: cfg
        function onTextChanged() {
            const config = getConfig();
            if (config.duplicateOnMonitors ?? true) {
                root.currentSymbol = config.currentSymbol ?? ":)";
            }
        }
    }

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
            const config = getConfig();
            if (mouse.button === Qt.RightButton) {
                if (config.enableRightClick ?? true) {
                    pickerMenu.visible = !pickerMenu.visible
                }
            } else {
                if (config.enableLeftClick ?? true) {
                    const next = root.emojis[Math.floor(Math.random() * root.emojis.length)];
                    if (config.duplicateOnMonitors ?? true) {
                        updateConfig("currentSymbol", next);
                    } else {
                        root.currentSymbol = next;
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
                if (getConfig().duplicateOnMonitors ?? true) {
                    updateConfig("currentSymbol", modelData);
                } else {
                    root.currentSymbol = modelData;
                }
                pickerMenu.visible = false
            }
        }
    }
}
