# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name Instance extends LauncherItem
## Class to repersent a single instance of a program


## Emitted when the cluster is changed
signal cluster_changed(cluster: Cluster)


## The Cluster this instance belongs to
var _cluster: Cluster


## init
func _init(p_uuid: String = UUID.v4(), ...p_args: Array[Variant]) -> void:
	super._init(p_uuid, p_args)
	
	set_uname("Instance")
	_set_class_name("Instance")
	
	_settings.register_status("Cluster", Data.Type.OBJECT, get_cluster, [cluster_changed])


## Returns the Cluster this Instance belongs to
func get_cluster() -> Cluster:
	return _cluster


## Sets the Cluster this Instance belongs to
func _set_cluster(p_cluster) -> void:
	_cluster = p_cluster
	cluster_changed.emit(_cluster)
