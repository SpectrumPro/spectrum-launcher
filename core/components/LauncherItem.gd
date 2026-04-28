# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name LauncherItem extends RefCounted
## Base class for all launcher items


## Emitted when the name of this instance is changed
signal name_changed(p_name)

## Emitted when this object is to be deleted (freed from memory). 
signal delete_requested()


## The name of this LauncherItem
var _name: String = "LauncherItem"

## The classname of this LauncherItem
var _class_name: String = "LauncherItem"

## The class tree for this LauncherItem
var _class_tree: Array[String] = []

## The UUID of this LauncherItem
var _uuid: String = UUID.v4()

## The SettingsManager for this LauncherItem
var _settings: SettingsManager = SettingsManager.new()


## init
func _init(p_uuid: String = UUID.v4(), ..._p_args: Array[Variant]) -> void:
	_uuid = p_uuid
	
	_settings.set_owner(self)
	_settings.set_inheritance_array(_class_tree)
	
	set_uname("LauncherItem")
	_set_class_name(_class_name)
	
	_settings.register_setting("Name", Data.Type.STRING, set_uname, get_uname, [name_changed])


## Seralizes an array of LauncherItems
static func seralise_component_array(p_array: Array, p_flags: Data.SerializationFlags = Data.SerializationFlags.NONE) -> Array[Dictionary]:
	var result: Array[Dictionary]
	
	for component: Variant in p_array:
		if component is LauncherItem:
			result.append(component.serialize(p_flags))
	
	return result


## Deseralizes an array of seralized LauncherItems
static func deseralise_component_array(p_array: Array, p_flags: Data.SerializationFlags = Data.SerializationFlags.NONE) -> Array[LauncherItem]:
	var result: Array[LauncherItem]
	
	for seralized_component: Variant in p_array:
		if seralized_component is Dictionary and seralized_component.has("class_name"):
			var component: LauncherItem = ClassList.get_class_script(seralized_component.class_name).new()
	
			component.deserialize(seralized_component, p_flags)
			result.append(component)
	
	return result


## Returns the name of this LauncherItem
func get_uname() -> String:
	return _name


## Returns the UUID of this LauncherItem
func get_uuid() -> String:
	return _uuid


## Returns the SettingsManager for this LauncherItem
func get_settings() -> SettingsManager:
	return _settings


## Returns the classname of this LauncherItem
func get_class_name() -> String:
	return _class_name


## Returns the class tree of this LauncherItem
func get_class_tree() -> Array[String]:
	return _class_tree.duplicate()


## Returns the base class of this object
func get_base_class() -> String:
	return _class_tree[-1]


## Sets the name of this LauncherItem
func set_uname(p_name: String, p_no_signal: bool = false) -> void:
	_name = p_name
	
	if not p_no_signal:
		name_changed.emit(_name)


## Emits the delete_requested signal to notify that this object should be deleted.
func delete() -> void:
	delete_requested.emit()


## Returns a JSON-compliant dictionary containing a serialized version of this object.
func serialize(p_flags: Data.SerializationFlags) -> Dictionary[String, Variant]:
	return {
		"name": _name,
		"class_name": _class_name,
	}.merged({} if p_flags & Data.SerializationFlags.NO_UUID else {
		"uuid": _uuid,
	})


## Deserializes data either read from disk or returned by serialize().
func deserialize(p_serialized_data: Dictionary, p_flags: Data.SerializationFlags) -> void:
	set_uname(type_convert(p_serialized_data.get("name", _name), TYPE_STRING), true)
	
	if not p_flags & Data.SerializationFlags.NO_UUID:
		_uuid = type_convert(p_serialized_data.get("uuid", _uuid), TYPE_STRING)


## Sets the classname of this LauncherItem
func _set_class_name(p_classname) -> void:
	_class_name = p_classname
	_class_tree.append(p_classname)
