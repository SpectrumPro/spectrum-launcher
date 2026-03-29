# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Controller, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name ClusterItem extends Control
## ClusterItem for showing a Cluster in the UI


## Emitted when this ClusterItem is clicked
signal clicked()


## The selected border color of this ClusterItem
const SelectedColor: Color = Color("#3574ff")

## The selected border width of this ClusterItem
const SelectedBorderWidth: int = 2


## The NameLabel to display the cluster name
@export var name_label: Label

## The StatusLED
@export var status_led: Panel

## The StatusLabel for displaying the running status
@export var status_label: Label


## The Cluster
var _cluster: Cluster

## Selected state
var _selected: bool

## Default border color
var _default_color: Color

## Default border width
var _default_border_width: int

## SignalGroup for Cluster
var _cluster_connections: SignalGroup = SignalGroup.new([], {
	"name_changed": _set_name
}).set_prefix("_on_cluster_")


## ready
func _ready() -> void:
	add_theme_stylebox_override("panel", get_theme_stylebox("panel").duplicate())
	_default_color = get_theme_stylebox("panel").get_border_color()
	_default_border_width = get_theme_stylebox("panel").get_border_width(MARGIN_TOP)


## Sets the cluster
func set_cluster(p_cluster: Cluster) -> void:
	_cluster_connections.disconnect_object(_cluster)
	_cluster = p_cluster
	_cluster_connections.connect_object(_cluster)
	
	var is_valid: bool = is_instance_valid(_cluster)
	
	if not is_valid:
		return
	
	_set_name(_cluster.get_name())


## Sets the selected state of this ClusterItem
func set_selected(p_selected: bool) -> void:
	var color: Color = SelectedColor if p_selected else _default_color
	var border_width: int = SelectedBorderWidth if p_selected else _default_border_width
	var style_box: StyleBoxFlat = get_theme_stylebox("panel")
	
	style_box.set_border_color(color)
	style_box.set_border_width_all(border_width)
	
	_selected = p_selected


## Returns the selected state
func is_selected() -> bool:
	return _selected


## Sets the name label
func _set_name(p_name: String) -> void:
	name_label.set_text(p_name)


## Called for each GUI input
func _on_gui_input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseButton and p_event.is_pressed():
		p_event = p_event as InputEventMouseButton
		
		match p_event.get_button_index():
			MOUSE_BUTTON_LEFT:
				clicked.emit()
