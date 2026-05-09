import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    property string moduleDataDir
    property string moduleId

    spacing: 0

    FileView {
        id: cfgFile
        path: Directories.state + "/smiley-bar-widget/config.json"
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: cfgFile.writeAdapter()
        onLoadFailed: cfgFile.writeAdapter()
        
        JsonAdapter {
            id: cfg
            property bool enableLeftClick: true
            property bool enableRightClick: true
        }
    }

    ConfigSwitch {
        text: "Рандом при левом клике"
        checked: cfg.enableLeftClick
        onCheckedChanged: cfg.enableLeftClick = checked
    }

    ConfigSwitch {
        text: "Меню при правом клике"
        checked: cfg.enableRightClick
        onCheckedChanged: cfg.enableRightClick = checked
    }
}
