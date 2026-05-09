[🇷🇺 Русский](README.ru.md) | [🇬🇧 English](README.md)

# Smiley bar widget

Виджет для панели с выбором эмодзи. Левый клик — случайный выбор, правый клик — открытие меню выбора.

Это модуль для системы [illogical-impulse-plugins](https://github.com/Rom4ik-12/illogical-impulse-plugins).

![smiley в баре](screen.jpg)

## Установка

### Через менеджер модулей

1. Открой **Настройки → Модули → Установка модуля**
2. Вставь ссылку и нажми **Установить**:
   ```
   https://github.com/Rom4ik-12/smiley-bar-widget/releases/latest/download/smiley-bar-widget.qsmod
   ```
3. Включи модуль в разделе **Установлено**.

### Вручную

```sh
cd ~/.config/illogical-impulse/user_modules
curl -LO https://github.com/Rom4ik-12/smiley-bar-widget/releases/latest/download/smiley-bar-widget.qsmod
unzip smiley-bar-widget.qsmod -d smiley-bar-widget
```

Затем включи в **Настройки → Модули**.

## Кастомизация

Отредактируй `Smiley.qml` — корневой элемент попадает прямо в слот панели:

```qml
StyledText {
    text: ":)"
    font.pixelSize: Appearance.font.pixelSize.normal
    color: Appearance.colors.colOnLayer0
}
```

Замени текст на `MaterialSymbol`, `Image` или любой QtQuick-элемент.

## Требования

- Установлен [illogical-impulse-plugins](https://github.com/Rom4ik-12/illogical-impulse-plugins)
- quickshell с конфигом illogical-impulse
