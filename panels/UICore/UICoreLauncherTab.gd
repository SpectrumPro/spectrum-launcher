# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Controller, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name UICoreLauncherTab extends Control
## Launcher tab


## The Container to show all ClusterItems
@onready var cluster_container: VBoxContainer = %ClusterContainer

## The DeleteCluster Button
@onready var delete_cluster_button: Button = %DeleteCluster

## The SettingsManagerView to manage a Cluster
@onready var cluster_manager: SettingsManagerView = %ClusterManagerView

## The Label to show when no cluster is selected
@onready var no_selected_label: Label = %NoSelectedCluster


## RefMap for Cluster: ClusterItem
var _clusters: RefMap = RefMap.new()

## The current selected Cluster
var _selected_cluster: Cluster

## SignalGroup for ClusterItem
var _cluster_item_connections: SignalGroup = SignalGroup.new([
	_on_cluster_item_clicked
]).set_prefix("_on_cluster_item_")


## Ready
func _ready() -> void:
	Launcher.clusters_added.connect(_add_clusters)
	Launcher.clusters_removed.connect(_remove_clusters)


## Sets the selected Cluster
func set_selected(p_cluster: Cluster) -> void:
	if is_instance_valid(_selected_cluster):
		_clusters.left(_selected_cluster).set_selected(false)
	
	_selected_cluster = p_cluster
	cluster_manager.reset()
	
	var is_valid: bool = is_instance_valid(_selected_cluster)
	
	delete_cluster_button.set_disabled(not is_valid)
	cluster_manager.set_visible(is_valid)
	no_selected_label.set_visible(not is_valid)
	
	if not is_valid:
		return
	
	_clusters.left(_selected_cluster).set_selected(true)
	cluster_manager.set_manager(p_cluster.get_settings())


## Adds a Cluster to the list
func _add_cluster(p_cluster: Cluster) -> void:
	var new_item: ClusterItem = preload("res://components/ClusterItem/ClusterItem.tscn").instantiate()
	
	_cluster_item_connections.connect_object(new_item, true)
	new_item.set_cluster(p_cluster)
	
	_clusters.map(p_cluster, new_item)
	cluster_container.add_child(new_item)


## Adds mutiple clusters to the list
func _add_clusters(p_clusters: Array) -> void:
	for cluster: Cluster in p_clusters:
		_add_cluster(cluster)


## Removes a cluster from the list
func _remove_cluster(p_cluster: Cluster) -> void:
	if _clusters.has_left(p_cluster):
		_cluster_item_connections.disconnect_object(p_cluster, true)
		
		if _selected_cluster == p_cluster:
			set_selected(null)
		
		_clusters.left(p_cluster).queue_free()
		_clusters.erase_left(p_cluster)


## Adds mutiple clusters to the list
func _remove_clusters(p_clusters: Array) -> void:
	for cluster: Cluster in p_clusters:
		_remove_cluster(cluster)


## Called when a ClusterItem is clicked
func _on_cluster_item_clicked(p_item: ClusterItem) -> void:
	set_selected(_clusters.right(p_item))


## Called when the CreateCluster button is pressed
func _on_create_cluster_pressed() -> void:
	var cluster: Cluster = Launcher.create_cluster()
	
	Interface.show_window_popup(UIPopupSettingsModule, self, cluster.get_settings().get_entry("Name"))
	set_selected(cluster)


## Called when the DeleteCluster Button is pressed
func _on_delete_cluster_pressed() -> void:
	Popups.confirm_delete_components(self, [_selected_cluster])


## Called when the OpenChildManager button is pressed
func _on_open_child_manager_pressed() -> void:
	Popups.UChildManager(self, Launcher.get_settings().get_child_manager("Clusters"))


## Called for each GUI input on the ClusterContainer
func _on_cluster_container_gui_input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseButton and p_event.is_pressed():
		p_event = p_event as InputEventMouseButton
		
		match p_event.get_button_index():
			MOUSE_BUTTON_LEFT:
				set_selected(null)
