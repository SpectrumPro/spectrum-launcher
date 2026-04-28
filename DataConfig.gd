class_name DataConfig extends Object
## Class to store config for Data


## Class to store SubType keys
class SubType:
	enum Type {
		NULL,						## No Type
		INT_CID,					## A Component ID
		OBJECT_LAUNCHERITEM,		## A EngineComponent
		OBJECT_UIPANEL,				## A UIPanel
		PACKEDSCENE_UIPANEL,		## A UIPanel PackedScene
	}


## Config for Data
var config: Dictionary[String, Variant] = {
	"gbc_index": {
		"LauncherItem": GBCIndexConfig.new(LauncherItem, ComponentDB, ClassList, Launcher.get_settings().get_child_manager("Clusters"))
	}
}
