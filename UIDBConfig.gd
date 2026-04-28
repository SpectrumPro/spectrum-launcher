## File path for all UIPanels
const UI_PANEL_LOCATION: String = "res://panels/"

## File path for all UIPanels
const UI_POPUP_LOCATION: String = "res://panels/popups/"

## File path for all UIComponents
const UI_COMPONENT_LOCATION: String = "res://components/"

## File path for all UIPanels
const DATA_INPUT_LOCATION: String = "res://components/DataInputs/"

## File path for all UIPanels
const ICON_LOCATION: String = "res://assets/icons/"


## All user defined UIPanels
static var panels: Dictionary[String, PackedScene] = {
	"UICore":				load(_p("UICore")),
	"UISettings":			load(_p("UISettings")),
	"UIVersionManager":		load(_p("UIVersionManager")),
}

## All user defined UIPanels
static var popups: Dictionary[String, PackedScene]

## All user defined UIPanels
static var components: Dictionary[String, PackedScene] = {
	"ClusterItem":			load(_c("ClusterItem")),
	"InstanceTag":			load(_c("InstanceTag"))
}

## All user defined UIPanels
static var data_inputs: Dictionary[Data.Type, Variant] = {}

## All user defined UIPanels
static var class_icons: Dictionary[String, PackedScene] = {}

## Categorys of the user defined panels
static var panels_by_category: Dictionary[String, Array] = {
	"System": [
		"UICore",
		"UISettings",
	]
}

## Config
static var config: Dictionary[String, Variant] = {
	"panels": panels,
	"popups": popups,
	"components": components,
	"data_inputs": data_inputs,
	"class_icons": class_icons,
	"panels_by_category": panels_by_category
}


## Returns the file path of a UIPanel
static func _p(p_panel_class: String) -> String:
	return str(UI_PANEL_LOCATION, p_panel_class, "/", p_panel_class, ".tscn")


## Returns the file path of a UIPopup
static func _u(p_popup_class: String) -> String:
	return str(UI_POPUP_LOCATION, p_popup_class, "/", p_popup_class, ".tscn")


## Returns the file path of a UIComponent
static func _c(p_component_class: String) -> String:
	return str(UI_COMPONENT_LOCATION, p_component_class, "/", p_component_class, ".tscn")


## Returns the file path of a DataInput
static func _d(p_data_input_class: String) -> String:
	return str(DATA_INPUT_LOCATION, p_data_input_class, "/", p_data_input_class, ".tscn")


## Returns the file path of a Icon
static func _i(p_data_input_class: String) -> String:
	return str(ICON_LOCATION, p_data_input_class, ".svg")
