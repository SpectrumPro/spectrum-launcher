# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Controller, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name UICore extends Control
## UICore


## Boot splash fade time in seconds
const BOOT_SPLASH_FADE_TIME: float = 0.3


## The Control element containing the boot splash
@export var boot_splash: Control


## Ready
func _ready() -> void:
	boot_splash.show()
	get_tree().create_tween().tween_property(boot_splash, "modulate", Color.TRANSPARENT, BOOT_SPLASH_FADE_TIME).finished.connect(boot_splash.hide)
