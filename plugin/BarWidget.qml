import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy-edges"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    // Crop / border-corners glyph (Nerd Font)
    text: "󰩫"
    horizontalMargin: 7.5
    onPressed: function(buttonCode) {
      if (!root.bar) return
      // Right-click: draw healthy region with the mouse
      if (buttonCode === Qt.RightButton)
        root.bar.run("omarchy-edges select")
      else
        root.bar.run("omarchy-edges gui")
    }
  }
}
