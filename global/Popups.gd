# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name InterfacePopups extends CorePopups
## Collection of shortcuts for opening UIPopups


## init 
func _init(p_uuid: String = "", ...p_args: Array[Variant]) -> void:
	super._init(p_uuid, p_args)
	
	_settings.register_control("OpenVersionManager", Data.Type.ACTION, VersionManager.bind(self), Callable(), [])


## Opens UIVersionManager
func VersionManager(p_source: Node) -> Promise:
	return Interface.show_window_popup(UIVersionManager, p_source, null)
