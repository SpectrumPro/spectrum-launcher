# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name CoreComponentDB extends CoreObjectDB
## Contains a list of all the classes used in this project


## Returns true if the given component is allowed in this ObjectDB
func is_component_allowed(p_component: Object) -> bool:
	return p_component is LauncherItem
