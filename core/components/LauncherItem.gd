# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name LauncherItem extends RefCounted
## Base class for all launcher items


## Emitted when the name of this instance is changed
signal name_changed(p_name)


## The name of this LauncherItem
var _name: String = "UnNamed LauncherItem"

## The classname of this LauncherItem
var _class_name: String = "LauncherItem"

## The class tree for this LauncherItem
var _class_tree: Array[String] = [_class_name]

## The UUID of this LauncherItem
var _uuid: String = UUID.v4()

## The SettingsManager for this LauncherItem
var _settings: SettingsManager = SettingsManager.new()


## init
func _init() -> void:
	_settings.set_owner(self)
	_settings.set_inheritance_array(_class_tree)
	_settings.register_setting("Name", Data.Type.STRING, set_name, get_name, [name_changed])


## Seralizes an array of LauncherItems
static func seralise_component_array(array: Array) -> Array[Dictionary]:
	var result: Array[Dictionary]
	
	for component: Variant in array:
		if component is LauncherItem:
			result.append(component.serialize())
	
	return result


## Deseralizes an array of seralized LauncherItems
static func deseralise_component_array(array: Array) -> Array[LauncherItem]:
	var result: Array[LauncherItem]
	
	for seralized_component: Variant in array:
		if seralized_component is Dictionary and seralized_component.has("class_name"):
			var component: LauncherItem = ClassList.get_class_script(seralized_component.class_name).new()
	
			component.deserialize(seralized_component)
			result.append(component)
	
	return result


## Returns the name of this LauncherItem
func get_name() -> String:
	return _name


## Returns the UUID of this LauncherItem
func get_uuid() -> String:
	return _uuid


## Returns the SettingsManager for this LauncherItem
func get_settings_manager() -> SettingsManager:
	return _settings


## Returns the classname of this LauncherItem
func get_classname() -> String:
	return _class_name


## Returns the class tree of this LauncherItem
func get_class_tree() -> void:
	return _class_tree.duplicate()


## Sets the name of this LauncherItem
func set_name(p_name: String, p_no_signal: bool = false) -> void:
	_name = p_name
	
	if not p_no_signal:
		name_changed.emit(_name)


## Sets the classname of this LauncherItem
func _set_class_name(p_classname) -> void:
	_class_name = p_classname
	_class_tree.append(p_classname)


## Returns serialized version of this LauncherItem
func serialize() -> Dictionary:
	return {
		"name": _name,
		"class_name": _class_name,
	}


## Loades this object from a serialized version
func deserialize(p_serialized_data: Dictionary) -> void:
	set_name(type_convert(p_serialized_data.get("name", _name), TYPE_STRING), true)
