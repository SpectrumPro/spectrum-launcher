# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name ComponentClassList extends ClassListDB
## Contains a list of all the classes used in this project


## Init
func _init() -> void:
	_global_class_tree = {
		"LauncherItem": {
			"LauncherItem": LauncherItem,
			"Cluster": Cluster,
			"Instance": Instance
		}
	}
