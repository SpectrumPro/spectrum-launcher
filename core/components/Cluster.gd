# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name Cluster extends LauncherItem
## Class to repersent a cluster of instances


## Emitted when an instance is added
signal instances_added(p_instances: Array[Instance])

## Emitted when an instance is removed
signal instances_removed(p_instances: Array[Instance])


## All instances in this Cluster
var _instances: Array[Instance]


## init
func _init(p_uuid: String = UUID.v4(), ...p_args: Array[Variant]) -> void:
	super._init(p_uuid, p_args)
	
	set_uname("Cluster")
	_set_class_name("Cluster")
	
	_settings.add_child_manager("Instances", ChildManager.new(
		self, 
		create_instance,
		add_instance,
		add_instances,
		remove_instance,
		remove_instances,
		Callable(),
		Callable(),
		get_instances,
		instances_added,
		instances_removed,
		LauncherItem,
		Instance
	))


## Creates a new Instance
func create_instance(p_classname: String) -> Instance:
	if not ClassList.has_class(p_classname, "Instance"):
		return null
	
	var new_instance: Instance = ClassList.get_class_script(p_classname).new()
	
	add_instance(new_instance)
	return new_instance


## Adds a preexisting instance
func add_instance(p_instance: Instance, p_no_signal: bool = false) -> bool:
	if p_instance.get_cluster():
		return false
	
	p_instance._set_cluster(self)
	_instances.append(p_instance)
	
	p_instance.delete_requested.connect(remove_instance.bind(p_instance))
	ComponentDB.register_component(p_instance)
	
	if not p_no_signal:
		instances_added.emit([p_instance])
	
	return true


## Adds mutiple instances
func add_instances(p_instances: Array, p_no_signal: bool) -> void:
	var just_added_instances: Array[Instance]
	
	for instance: Variant in p_instances:
		if instance is Instance:
			if add_instance(instance, true):
				just_added_instances.append(instance)
	
	if not p_no_signal:
		instances_added.emit(just_added_instances)


## Removes an instance
func remove_instance(p_instance: Instance, p_no_signal: bool = false) -> bool:
	if p_instance.get_cluster() != self:
		return false
	
	_instances.erase(p_instance)
	p_instance._set_cluster(null)
	
	ComponentDB.deregister_component(p_instance)
	
	if not p_no_signal:
		instances_removed.emit([p_instance])
	
	return true


## Adds mutiple instances
func remove_instances(p_instances: Array, p_no_signal: bool) -> void:
	var just_removed_instances: Array[Instance]
	
	for instance: Variant in p_instances:
		if instance is Instance:
			if remove_instance(instance, true):
				just_removed_instances.append(instance)
	
	if not p_no_signal:
		instances_removed.emit(just_removed_instances)


## Returns all the instances in this Cluster
func get_instances() -> Array[Instance]:
	return _instances.duplicate()


## Returns a JSON-compliant dictionary containing a serialized version of this object.
func serialize(p_flags: Data.SerializationFlags) -> Dictionary[String, Variant]:
	return super.serialize(p_flags).merged({
		"instances": seralise_component_array(_instances, p_flags)
	})


## Deserializes data either read from disk or returned by serialize().
func deserialize(p_serialized_data: Dictionary, p_flags: Data.SerializationFlags) -> void:
	super.deserialize(p_serialized_data, p_flags)
	
	var seralized_instances: Array = type_convert(p_serialized_data.get("instances", []), TYPE_ARRAY)
	var instances: Array[LauncherItem] = deseralise_component_array(seralized_instances, p_flags)
	
	for instance: LauncherItem in instances:
		if instance is Instance:
			add_instance(instance, true)
