import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property string moduleDataDir: ""
    property string moduleId: "smiley-bar-widget"

    readonly property string cfgDir: Directories.state + "/smiley-bar-widget"
    readonly property string cfgPath: cfgDir + "/config.json"

    // True until the FileView has finished its first load. Skips the very
    // first onCheckedChanged that fires when each ConfigSwitch initialises
    // — otherwise it would overwrite the file with the Switch's default
    // state before we've read what's on disk.
    property bool _loading: true

    width: parent ? parent.width : 0
    implicitHeight: col.implicitHeight

    FileView {
        id: cfgFile
        path: root.cfgPath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            symbolField.text = cfg.currentSymbol !== undefined
                ? String(cfg.currentSymbol) : ":)"
            root._loading = false
        }
        onLoadFailed: {
            symbolField.text = ":)"
            root._loading = false
        }

        JsonAdapter {
            id: cfg
            property var currentSymbol
            property bool enableLeftClick: true
            property bool enableRightClick: true
        }
    }

    Process { id: mkdirProc }

    function persist() {
        mkdirProc.command = ["mkdir", "-p", root.cfgDir]
        mkdirProc.running = true
        cfgFile.writeAdapter()
    }

    Component.onCompleted: {
        mkdirProc.command = ["mkdir", "-p", root.cfgDir]
        mkdirProc.running = true
    }

    ColumnLayout {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 8

        StyledText {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            color: Appearance.colors.colSubtext
            text: Translation.tr("Symbol shown in the bar. Left-click cycles a random emoji; right-click opens the picker.")
            font.pixelSize: Appearance.font.pixelSize.small
        }

        ContentSubsectionLabel {
            text: Translation.tr("Current symbol")
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            MaterialTextField {
                id: symbolField
                Layout.fillWidth: true
                placeholderText: ":)"
                onEditingFinished: {
                    cfg.currentSymbol = symbolField.text
                    root.persist()
                }
            }
            RippleButtonWithIcon {
                materialIcon: "save"
                mainText: Translation.tr("Save")
                onClicked: {
                    cfg.currentSymbol = symbolField.text
                    root.persist()
                }
            }
            RippleButtonWithIcon {
                materialIcon: "casino"
                mainText: Translation.tr("Random")
                onClicked: {
                    const e = [":)", ":/", ":D", ":(", "^_^", "ツ",
                        "(¬‿¬)", "(◕‿◕)", "ʕ•ᴥ•ʔ", "(o_o)"]
                    symbolField.text = e[Math.floor(Math.random() * e.length)]
                    cfg.currentSymbol = symbolField.text
                    root.persist()
                }
            }
        }

        ContentSubsectionLabel {
            text: Translation.tr("Click behaviour")
        }
        ConfigSwitch {
            Layout.fillWidth: true
            text: Translation.tr("Left-click: pick a random symbol")
            checked: cfg.enableLeftClick
            onCheckedChanged: {
                if (root._loading) return
                if (cfg.enableLeftClick !== checked) {
                    cfg.enableLeftClick = checked
                    root.persist()
                }
            }
        }
        ConfigSwitch {
            Layout.fillWidth: true
            text: Translation.tr("Right-click: open the picker")
            checked: cfg.enableRightClick
            onCheckedChanged: {
                if (root._loading) return
                if (cfg.enableRightClick !== checked) {
                    cfg.enableRightClick = checked
                    root.persist()
                }
            }
        }
    }
}
