# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Controller, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name UISettings extends UIPanel
## Settings Tab


## The SettingsManagerView to show system settings
@onready var launcher_manager: SettingsManagerView = %LauncherManager

## The SettingsManagerView to show system settings
@onready var interface_manager: SettingsManagerView = %InterfaceManagerView


## init
func _init() -> void:
	super._init()
	
	_set_class_name("UISettings")


## ready
func _ready() -> void:
	launcher_manager.set_manager(Launcher.get_settings())
	interface_manager.set_manager(Interface.get_settings())
