# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name Cluster extends LauncherItem
## Class to repersent a cluster of instances


## Emitted when an instance is added
signal instance_added(p_instance: Instance)

## Emitted when an instance is removed
signal instance_removed(p_instance: Instance)


## All instances in this Cluster
var _instances: Array[Instance]


## init
func _init() -> void:
	super._init()
	_set_class_name("Cluster")


## Creates a new Instance
func create_instance() -> Instance:
	var new_instance: Instance = Instance.new()
	
	add_instance(new_instance)
	return new_instance


## Adds a preexisting instance
func add_instance(p_instance: Instance, p_no_signal: bool = false) -> void:
	if p_instance.get_cluster():
		return
	
	p_instance._set_cluster(p_instance)
	_instances.append(p_instance)
	
	if not p_no_signal:
		instance_added.emit(p_instance)


## Removes an instance
func remove_instance(p_instance: Instance, p_no_signal: bool = false) -> bool:
	if not p_instance.get_cluster() != self:
		return false
	
	_instances.erase(p_instance)
	
	if not p_no_signal:
		instance_removed.emit(p_instance)
	
	return true


## Returns all the instances in this Cluster
func get_instances() -> Array[Instance]:
	return _instances.duplicate()


## Returns serialized version of this LauncherItem
func serialize() -> Dictionary:
	return super.serialize().merged({
		"instances": seralise_component_array(_instances)
	})


## Loades this object from a serialized version
func deserialize(p_serialized_data: Dictionary) -> void:
	var seralized_instances: Array = type_convert(p_serialized_data.get("instances", []), TYPE_ARRAY)
	var instances: Array[LauncherItem] = deseralise_component_array(seralized_instances)
	
	for instance: LauncherItem in instances:
		if instance is Instance:
			add_instance(instance, true)
