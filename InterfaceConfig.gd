static var config: Dictionary[String, Variant] = {
	"scale_factor": 1,
	"save_ui_on_quit": true,
	"default_ui_panel": UICore,
	"window_popup_config": {
		UISettings:				CoreInterface.PopupConfig.new("UISettings", ""),
		UIVersionManager:		CoreInterface.PopupConfig.new("UIVersionManager", ""),
	},
	"command_palette_default_items": [
		CommandPaletteEntry.new(
			Launcher.get_settings(), 
			"Launcher"
		),
		CommandPaletteEntry.new(
			Interface.get_settings(), 
			"Interface"
		),
		CommandPaletteEntry.new(
			Popups.get_settings(), 
			"Popups"
		),
	]
}
