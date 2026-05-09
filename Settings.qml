import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    property string moduleDataDir
    property string moduleId

    spacing: 8

    FileView {
        id: cfg
        path: moduleDataDir + "/config.json"
        watchChanges: true
    }

    function updateConfig(key, value) {
        const c = JSON.parse(cfg.text || "{}");
        c[key] = value;
        cfg.setText(JSON.stringify(c, null, 2));
    }

    function getConfig() {
        return JSON.parse(cfg.text || "{}");
    }

    ConfigRow {
        label: "Дублировать на все мониторы"
        StyledSwitch {
            checked: getConfig().duplicateOnMonitors ?? true
            onClicked: updateConfig("duplicateOnMonitors", !checked)
        }
    }

    ConfigRow {
        label: "Рандом при левом клике"
        StyledSwitch {
            checked: getConfig().enableLeftClick ?? true
            onClicked: updateConfig("enableLeftClick", !checked)
        }
    }

    ConfigRow {
        label: "Меню при правом клике"
        StyledSwitch {
            checked: getConfig().enableRightClick ?? true
            onClicked: updateConfig("enableRightClick", !checked)
        }
    }

    ConfigRow {
        label: "Текущий символ"
        StyledTextField {
            text: getConfig().currentSymbol ?? ":)"
            onEditingFinished: updateConfig("currentSymbol", text)
        }
    }
}
