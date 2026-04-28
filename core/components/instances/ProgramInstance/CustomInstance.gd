# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name CustomInstance extends Instance
## Class to repersent a instance of a custom or third party binary


## init
func _init(p_uuid: String = UUID.v4(), ...p_args: Array[Variant]) -> void:
	super._init(p_uuid, p_args)
	
	set_uname("CustomInstance")
	_set_class_name("CustomInstance")
