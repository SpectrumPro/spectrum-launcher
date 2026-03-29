## Internal actions
static var internal_actions: Dictionary[String, Callable] = {
	"ui_cancel": Interface.hide_all_popup_panels,
	"command_palette": handle_command_palette_action,
}

## Config
static var config: Dictionary[String, Variant] = {
	"internal_actions": internal_actions
}


## Handles the action for opening UICommandPalette
static func handle_command_palette_action() -> void:
	Interface.toggle_popup_visable(UICommandPalette, InputServer)
