# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name CoreLauncher extends Node
## Core engine for managing the spectrum launcher


## Emitted when a cluster is added
signal cluster_added(cluster: Cluster)

## Emitted when a cluster is removed
signal cluster_removed(cluster: Cluster)


## All clusters in this CoreEngine
var _clusters: Array[Cluster]

## The SettingsManager for this CoreEngine
var _settings: SettingsManager = SettingsManager.new()


## init
func _init() -> void:
	_settings.set_owner(self)
	_settings.set_inheritance_array(["CoreLauncher"])



## Creates a new Cluster
func create_cluster() -> Cluster:
	var new_cluster: Cluster = Cluster.new()
	
	add_cluster(new_cluster)
	return new_cluster


## Adds a cluster to this CoreEngine
func add_cluster(p_cluster) -> bool:
	if _clusters.has(p_cluster):
		return false
	
	_clusters.append(p_cluster)
	cluster_added.emit(p_cluster)
	
	return true


## Removes a cluster from this CoreEngine
func remove_cluster(p_cluster) -> bool:
	if not _clusters.has(p_cluster):
		return false
	
	_clusters.erase(p_cluster)
	cluster_removed.emit(p_cluster)
	return true


## Returns the SettingsManager
func get_settings() -> SettingsManager:
	return _settings
