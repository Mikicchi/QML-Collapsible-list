import QtQuick 2.0

Item {
    id: root
    width: 325
    height: 640

    property int animationDuration: 100 // Duración animación desplegar
    property int indent: 20 // Indentación hijos
    property string headerItemFontName: "Helvetica" // Font
    property int headerItemFontSize: 10 // Font size
    property color headerItemFontColor: "#323232" // Font color
    property color headerItemOverColor: "#5c881a" // Font color item seleccionado
    property string subItemFontName: "Helvetica" // Font hijos
    property int subItemFontSize: headerItemFontSize - 2 // Font size hijos 
    property color subItemFontColor: "#323232" // Font color hijos
    property color subItemFontOverColor: "#5c881a" // Font color item seleccionado hijos
    property variant theModel; // Modelo de datos
    property string selected: "999" // Para indicar que el item esta seleccionado y ¿mandar señal de click?

    signal itemClicked(string opcion, string tipo, string title, string icoChar)

    // Función recursiva para generar las sublistas de manera dinámica
    function generateSubItems(items) {
        var subItems = [];
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            var listItem = listItemComponent.createObject(root);
            listItem.itemTitle = item.title;
            listItem.opcionAccion = item.opcionAccion;
            listItem.opcionTipo = item.opcionTipo;
            listItem.opcionToolTip = item.opcionToolTip;
            listItem.icon = item.icon;
            listItem.cheatSheet = item.cheatSheet;
            listItem.subItems = generateSubItems(item.subItems); // Llamada recursiva para las sublistas
            subItems.push(listItem);
        }
        return subItems;
    }

     // Función para calcular la altura de los elementos principales y subelementos visibles
    function calculateHeight() {
        var totalHeight = headerItemRect.height;
        if (expanded) {
            for (var i = 0; i < subItemsRect.children.length; i++) {
                var subItem = subItemsRect.children[i];
                if (subItem.visible) {
                    totalHeight += subItem.height;
                }
            }
        }
        return totalHeight;
    }

    // Lista que contiene los registros
    ListView {
        id: listView
        height: parent.height
        anchors {
            left: parent.left
            right: parent.right
        }
        model: theModel;
        delegate: listViewDelegate
        focus: true
        spacing: 0
    }

    Component {
        id: listViewDelegate
        Item {
            id: delegate
            property int itemHeight: 48
            //property alias expandedItemCount: subItemsRect.children.length
            property bool expanded: false
            x: 0; y: 0;
            width: listView.width
            height: calculateHeight() // Calcular dinámicamente la altura

            // Clase ListItem
            ListItem {
                id: headerItemRect
                x: 0; y: 0
                width: parent.width
                height: parent.itemHeight
                text: itemTitle
                fontName: root.headerItemFontName
                fontSize: root.headerItemFontSize
                fontColor: root.headerItemFontColor
                fontOverColor: root.headerItemOverColor
                selectable: true
                rotate: subItems.length > 0;
                source: "data:image/png;base64," + cheatSheet;
                withIcon: subItems.length ? true : icon;
                snd_cmd: opcionAccion
                type: opcionTipo
                opToolTip: opcionToolTip;

                // Icono < para indicar que tiene una lista desplegable
                Text {
                    id: aIcon
                    rotation: expanded ? 90 : 180
                    visible: subItems.length
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: 15
                    }
                    font.pointSize: headerItemRect.fontSize + 2
                    font.family: fontMaterialDesign.name
                    font.weight: Font.ExtraBold
                    color: expanded ? root.headerItemOverColor : headerItemRect.fontColor
                    text: "\uf105"
                }

                onClicked: {
                    expanded = !expanded;
                    subItemsRect.visible = expanded; // Mostrar u ocultar las sublistas
                    if (type == "A" || type == "P" || type == "C") {
                        itemClicked(snd_cmd, type, opToolTip, source);
                    }
                }
            }

            // Items de la lista desplegable
            Item {
                id: subItemsRect
                visible: false // Ocultar las sublistas inicialmente
                //property int itemHeight: delegate.itemHeight
                y: headerItemRect.height
                width: parent.width
                height: expanded ? expandedItemCount * itemHeight : 0
                clip: true
                opacity: 1
                Behavior on height {
                    SequentialAnimation {
                        NumberAnimation { duration: root.animationDuration; easing.type: Easing.InOutQuad }
                        ScriptAction { script: ListView.view.positionViewAtIndex(index, ListView.Contain) }
                    }
                }

                Column {
                    width: parent.width
                    Repeater {
                        model: subItems
                        ListItem {
                            width: delegate.width
                            height: subItemsRect.itemHeight
                            text: itemTitle
                            fontName: root.subItemFontName
                            fontSize: root.subItemFontSize
                            fontColor: root.subItemFontColor
                            fontOverColor: root.subItemFontOverColor
                            textIndent: root.indent
                            selectable: true;
                            source: "data:image/png;base64," + cheatSheet
                            withIcon: icon
                            opToolTip: opcionToolTip;
                            snd_cmd: opcionAccion
                            type: opcionTipo
                            onClicked: {
                                itemClicked(snd_cmd, type, opToolTip, source)
                            }
                            Column {
                                width: subItemsRect.width
                                Repeater {
                                    model: subItems
                                    ListItem {
                                        width: delegate.width
                                        height: subItemsRect.itemHeight
                                        text: itemTitle
                                        fontName: root.subItemFontName
                                        fontSize: root.subItemFontSize
                                        fontColor: root.subItemFontColor
                                        fontOverColor: root.subItemFontOverColor
                                        textIndent: root.indent
                                        selectable: true;
                                        source: "data:image/png;base64," + cheatSheet
                                        withIcon: icon
                                        opToolTip: opcionToolTip;
                                        snd_cmd: opcionAccion
                                        type: opcionTipo
                                        onClicked: {
                                            itemClicked(snd_cmd, type, opToolTip, source)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: listItemComponent
        ListItem {
            width: listView.width
            height: headerItemRect.height
            text: ""
            fontName: root.headerItemFontName
            fontSize: root.headerItemFontSize
            fontColor: root.headerItemFontColor
            fontOverColor: root.headerItemOverColor
            selectable: true
            source: "data:image/png;base64,"
            withIcon: false
            onClicked: {
                itemClicked("", "", "", "");
            }
        }
    }
}
