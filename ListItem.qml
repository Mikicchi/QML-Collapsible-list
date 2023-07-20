import QtQuick 2.0
// import QtQuick 2.15

Item {
    id: container
    width: 325
    height: 48 

    property string fontName: "Helvetica" // Font
    property int fontSize: 10 // Font size
    property color fontColor: "#000000" // Font color
	property color fontOverColor: "white" // Font color selected
	property color fontIconColor: fontColor // En caso de que sean iconos de Fontawesome (No habilitado)
    property bool fontBold: false // Negrita
    property string text: ""
    property bool selected: false // Seleccionado
    property bool selectable: false // Si se puede seleccionar
    property int textIndent: 0
	property alias source: icon.source // Informar el icono directamente
	property bool withIcon : false // Si tiene icono
	property bool rotate : false
	property string snd_cmd;
	property string type;
	property string opToolTip;
    signal clicked;

    clip: true
    onSelectedChanged: selected ? state = 'selected' : state = ''
    
    // Fondo
	Rectangle{
		id: background
		height:parent.height;
		width:parent.width;
		gradient: Gradient {
            GradientStop {id: gra1;  position: 0.0; color: "#FFF" }
            GradientStop {id: gra2; position: 1.0; color: "#FFF" }
        }
	}

    // Rectangulo para indicar que ha sido seleccionado
    Rectangle{
		id: rectSeleccionado
		height: parent.height;
		width: 8;
		gradient: Gradient {
            GradientStop {id: gra1Seleccionado;  position: 0.0; color: "#FFF" }
            GradientStop {id: gra2Seleccionado; position: 1.0; color: "#FFF" }
        }
	}
    
    // Icono del registro
	Image {
        id: icon
        width: 24
        height: 24
        anchors {
            left: parent.left
            leftMargin: 8 + textIndent
            verticalCenter: container.verticalCenter
        }
    }
	
    // Texto del registro
	Text {
        id: itemText
        anchors {
            left: container.withIcon ? icon.right : parent.left
            top: parent.top
            right: parent.right
            topMargin: 4
            bottomMargin: 4
            leftMargin:  container.withIcon ? 8 : textIndent + 24
			rightMargin:  25
            verticalCenter: parent.verticalCenter
        }
        font {
            family: container.fontName
            pointSize:container.fontSize;
            bold: container.fontBold
        }
        color: container.fontColor
        elide: Text.ElideRight
        text: container.text 
        verticalAlignment: Text.AlignVCenter
		/*ToolTip {
            id: toolTip1
            parent: itemText.handle
            visible: false
            text: itemText.text
            delay: 1000
            y: mouseArea.mouseY + 15
            x: mouseArea.mouseX - 35
        }*/
    }

    // Señal
    MouseArea {
        id: mouseArea
        anchors.fill: parent
		hoverEnabled: true
        onClicked: {
			if(  type=="A" || type=="P" ) root.selected = snd_cmd;
			    container.clicked();
		}
        onReleased:	(selectable && !selected) ? selected = true : selected = false

    }

    // Estados del item
    states: [
        State {
            name: 'pressed'; when: mouseArea.pressed
            PropertyChanges { target: gra1; color:"#D8CFC7"} // Gradiente 1
			PropertyChanges { target: gra2; color:"#D8CFC7"} // Gradiente 2
        },
        State {
            name: 'selected'; when: (root.selected == snd_cmd) && selectable
            PropertyChanges { target: gra1; color:"#D8CFC7"} // Gradiente 1 Fondo
			PropertyChanges { target: gra2; color:"#D8CFC7"} // Gradiente 2 Fondo
            PropertyChanges { target: icon; anchors.leftMargin : anchors.leftMargin + 8;} // Desplazar el icono 8px a la derecha
			//PropertyChanges { target: itemText; color:fontOverColor}
			
            PropertyChanges { target: gra1Seleccionado; color:"#00A443"} // Gradiente 1 Rectangulo
			PropertyChanges { target: gra2Seleccionado; color:"#00A443"} // Gradiente 2 Rectangulo
        },
		State {
            name: 'hover'; when: mouseArea.containsMouse
            PropertyChanges { target: gra1; color:"#f6faf3"} // Gradiente 1
			PropertyChanges { target: gra2; color:"#f6faf3"} // Gradiente 2
			//PropertyChanges { target: toolTip1; visible: true} // ToolTip
        }
    ]
}