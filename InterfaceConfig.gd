static var config: Dictionary[String, Variant] = {
	"scale_factor": 1,
	"save_ui_on_quit": true,
	"default_ui_panel": UICore,
	"window_popup_config": {},
	"startup_notices": [],
}


## static init
static func _static_init() -> void:
	(func ():
		Interface.add_command_palette_entry(CommandPaletteEntry.new(Launcher.get_settings(), "Launcher"))
		Interface.add_command_palette_entry(CommandPaletteEntry.new(Interface.get_settings(), "Interface"))
	).call_deferred()
