# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name ComponentClassList extends CoreClassListDB
## Contains a list of all the classes used in this project


## Init
func _init(p_uuid: String = "", ...p_args: Array[Variant]) -> void:
	super._init(p_uuid, p_args)
	_set_class_name("ComponentClassList")


## ready
func _ready() -> void:
	_gbc_index = Data.get_gbc_config(LauncherItem)
	_global_class_tree = {
		"LauncherItem": {
			"Instance": {
				"ProgramInstance": {
					"ProgramInstance": ProgramInstance,
					"ProductInstance": ProductInstance,
				},
				"Instance": Instance,
			},
			"LauncherItem": LauncherItem,
			"Cluster": Cluster,
		}
	}
	
	super._ready()
