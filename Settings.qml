import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    property string moduleDataDir
    property string moduleId

    Layout.fillWidth: true
    spacing: 8

    FileView {
        id: cfg
        path: moduleDataDir + "/config.json"
        watchChanges: true
    }

    function updateConfig(key, value) {
        let c;
        try {
            c = JSON.parse(cfg.text || "{}");
        } catch(e) {
            c = {};
        }
        c[key] = value;
        cfg.setText(JSON.stringify(c, null, 2));
    }

    function getConfig() {
        try {
            return JSON.parse(cfg.text || "{}");
        } catch(e) {
            return {};
        }
    }

    ConfigRow {
        Layout.fillWidth: true
        label: "Дублировать на все мониторы"
        StyledSwitch {
            checked: getConfig().duplicateOnMonitors ?? true
            onClicked: updateConfig("duplicateOnMonitors", !checked)
        }
    }

    ConfigRow {
        Layout.fillWidth: true
        label: "Рандом при левом клике"
        StyledSwitch {
            checked: getConfig().enableLeftClick ?? true
            onClicked: updateConfig("enableLeftClick", !checked)
        }
    }

    ConfigRow {
        Layout.fillWidth: true
        label: "Меню при правом клике"
        StyledSwitch {
            checked: getConfig().enableRightClick ?? true
            onClicked: updateConfig("enableRightClick", !checked)
        }
    }

    ConfigRow {
        Layout.fillWidth: true
        label: "Текущий символ"
        StyledTextField {
            text: getConfig().currentSymbol ?? ":)"
            onEditingFinished: updateConfig("currentSymbol", text)
        }
    }
}
