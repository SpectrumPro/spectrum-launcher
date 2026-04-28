# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Engine, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name CoreLauncher extends CoreGlobal
## Core engine for managing the spectrum launcher


## Emitted when a cluster is added
signal clusters_added(clusters: Array)

## Emitted when a cluster is removed
signal clusters_removed(clusters: Array)

## Emitted when the given product has loaded all versions
signal product_versions_loaded(product: Product)

## Emitted when all product versions are reset during a reload
signal product_versions_reset()


## Base Github link
const GITHUB: String = "https://github.com"

## Base API Github link
const GITHUB_API: String = "https://api.github.com"

## Github orgnisation name
const ORG_NAME: String = "spectrumpro"


## Enum for Architecture
enum Arch {UNKNOWN, X86_64, X86_32, ARM64, ARM32, RV64, UNIVERSAL}

## Enum for OperatingSystem
enum OperatingSystem {UNKNOWN, LINUX, MACOS, WINDOWS, BSD, ANDROID}


## Maps OS feature flags to OperatingSystem enum
const OS_MAP: Dictionary[String, OperatingSystem] = {
	"linux": OperatingSystem.LINUX,
	"macos": OperatingSystem.MACOS,
	"windows": OperatingSystem.WINDOWS,
	"bsd": OperatingSystem.BSD,
}

## Maps OS feature flags to Arche num
const ARCH_MAP: Dictionary[String, Arch] = {
	"x86_64": Arch.X86_64,
	"x86_32": Arch.X86_32,
	"arm64": Arch.ARM64,
	"arm32": Arch.ARM32,
	"rv64": Arch.RV64,
}


## All clusters in this CoreLauncher
var _clusters: Array[Cluster]

## The Architecture of the current system
var _arch: Arch = Arch.UNKNOWN

## The OperatingSystem of the current system
var _operating_system: OperatingSystem = OperatingSystem.UNKNOWN

## All Spectrum Products that can be launched from this Launcher
var _products: Array[Product] = [
	Product.new("SpectrumClient", "Object-oriented lighting control framework, Client", "spectrum"),
	Product.new("SpectrumServer", "Object-oriented lighting control framework, Server", "spectrum-server"),
]


## init
func _init(p_uuid: String = "", ...p_args: Array[Variant]) -> void:
	super._init(p_uuid, p_args)
	_set_class_name("CoreLauncher")
	
	_settings.add_child_manager("Clusters", ChildManager.new(
		self,
		create_cluster,
		add_cluster,
		add_clusters,
		remove_cluster,
		remove_clusters,
		Callable(),
		Callable(),
		get_clusters,
		clusters_added,
		clusters_removed,
		LauncherItem,
		Cluster
	))
	
	for feature: String in OS_MAP:
		if OS.has_feature(feature):
			_operating_system = OS_MAP[feature]
			break
	
	for feature: String in ARCH_MAP:
		if OS.has_feature(feature):
			_arch = ARCH_MAP[feature]
			break


## ready
func _ready() -> void:
	reload_products()


## Reloads all products
func reload_products() -> void:
	_remove_known_versions()
	
	for product: Product in _products:
		var data: Array = load("res://tmp_data/" + product.repo_name + ".json").data
		_process_api_result(product, data)
		#var request: HTTPRequest = HTTPRequest.new()
		#add_child(request)
		#
		#request.request_completed.connect(_on_request_completed.bind(request, product))
		#request.request(product.get_github_api_link() + "/releases")


## Creates a new Cluster
func create_cluster(_p_classname: String = "") -> Cluster:
	var new_cluster: Cluster = Cluster.new()
	
	add_cluster(new_cluster)
	return new_cluster


## Adds a cluster to this CoreLauncher
func add_cluster(p_cluster: Cluster, p_no_signal: bool = false) -> bool:
	if _clusters.has(p_cluster):
		return false
	
	_clusters.append(p_cluster)
	ComponentDB.register_component(p_cluster)
	
	p_cluster.delete_requested.connect(remove_cluster.bind(p_cluster))
	
	if not p_no_signal:
		clusters_added.emit([p_cluster])
	
	return true


## Adds mutiple Clusters
func add_clusters(p_clusters: Array) -> void:
	var just_added_clusters: Array[Cluster]
	
	for cluster: Variant in p_clusters:
		if cluster is Cluster and add_cluster(cluster, true):
			just_added_clusters.append(cluster)
	
	if just_added_clusters:
		clusters_added.emit(just_added_clusters)


## Removes a cluster from this CoreLauncher
func remove_cluster(p_cluster: Cluster, p_no_signal: bool = false) -> bool:
	if not _clusters.has(p_cluster):
		return false
	
	_clusters.erase(p_cluster)
	ComponentDB.deregister_component(p_cluster)
	
	if not p_no_signal:
		clusters_removed.emit([p_cluster])
	
	return true


## Removes mutiple Clusters
func remove_clusters(p_clusters: Array) -> void:
	var just_removed_clusters: Array[Cluster]
	
	for cluster: Variant in p_clusters:
		if cluster is Cluster and remove_cluster(cluster, true):
			just_removed_clusters.append(cluster)
	
	if just_removed_clusters:
		clusters_removed.emit(just_removed_clusters)


## Returns all the clusters
func get_clusters() -> Array[Cluster]:
	return _clusters


## Returns the SettingsManager
func get_settings() -> SettingsManager:
	return _settings


## Returns the Architecture of the current system
func get_arch() -> Arch:
	return _arch


## Returns the OperatingSystem of the current system
func get_operating_system() -> OperatingSystem:
	return _operating_system


## Returns all the Products
func get_products() -> Array[Product]:
	return _products.duplicate()


## Removes all known versions of all products
func _remove_known_versions() -> void:
	product_versions_reset.emit()
	
	for product: Product in _products:
		for version: Version in product.versions:
			for asset: Asset in version.assets:
				asset.free()
			
			version.assets.clear()
		
		product.versions.clear()


## Process data from the API result
func _process_api_result(p_product: Product, p_result: Array) -> void:
	for release: Variant in p_result:
		if release is Dictionary:
			var new_version: Version = Version.new(
				type_convert(release.get("name", ""), TYPE_STRING),
				Time.get_unix_time_from_datetime_string(type_convert(release.get("published_at", ""), TYPE_STRING))
			)
			
			p_product.versions.append(new_version)
			new_version.product = p_product
			
			for asset: Variant in type_convert(release.get("assets", []), TYPE_ARRAY):
				if asset is Dictionary:
					_process_asset(asset, new_version)
	
	p_product.versions_loaded = true
	product_versions_loaded.emit(p_product)


## Processes the asset dictonary into a Asset object
func _process_asset(p_asset: Dictionary, p_version: Version) -> void:
	var asset_name: String = type_convert(p_asset.get("name", ""), TYPE_STRING)
	var arch: Arch = Arch.UNKNOWN
	var os: OperatingSystem = OperatingSystem.UNKNOWN
	var asset_version: String = p_version.version_number
	
	var name_split: PackedStringArray = asset_name.split(".")
	if name_split.size() >= 4:
		asset_name = name_split[0]
		arch = get_arch_from_string(name_split[1])
		os = get_os_from_string(name_split[2])
		
		if name_split[3].begins_with("dev"):
			asset_version = name_split[3]
	
	var new_asset: Asset = Asset.new(
		asset_name,
		type_convert(p_asset.get("size", 0), TYPE_INT),
		asset_version,
		arch,
		os,
		type_convert(p_asset.get("browser_download_url", ""), TYPE_STRING)
	)
	
	p_version.assets.append(new_asset)
	p_version.assets_sorted.get_or_add(os, {})[arch] = new_asset
	new_asset.version = p_version
	
	if new_asset.arch == _arch and new_asset.operating_system == _operating_system:
		p_version.compatible_assets.append(new_asset)


## Called when an HTTP request is completed
func _on_request_completed(_p_result: int, p_response_code: int, _p_headers: PackedStringArray, p_body: PackedByteArray, p_request: HTTPRequest, p_product: Product):
	var as_text: String = p_body.get_string_from_ascii()
	var result: Variant = JSON.parse_string(as_text)
	
	match p_response_code:
		HTTPClient.RESPONSE_OK when typeof(result) == TYPE_ARRAY:
			_process_api_result(p_product, result)
	
	p_request.queue_free()


## Returns the Arch enum from the given string
static func get_arch_from_string(p_string: String) -> Arch:
	match p_string.to_lower().replace(" ", "").replace("_", ""):
		"x8664": 
			return Arch.X86_64
		"arm64": 
			return Arch.ARM64
		"universal": 
			return Arch.UNIVERSAL
		_: 
			return Arch.UNKNOWN


## Returns the OperatingSystem from the given string
static func get_os_from_string(p_string: String) -> OperatingSystem:
	match p_string.to_lower().replace(" ", "").replace("_", ""):
		"macos": 
			return OperatingSystem.MACOS
		"linux":
			return OperatingSystem.LINUX
		"windows":
			return OperatingSystem.WINDOWS
		_:
			return OperatingSystem.UNKNOWN


## Class to repersent a Spectrum product
class Product extends Object:
	## The name of this Product
	var product_name: String
	
	## The description of this Product
	var product_description
	
	## The name of the Github repo
	var repo_name: String
	
	## All versions of this Product
	var versions: Array[Version]
	
	## True if all versions have been loaded
	var versions_loaded: bool
	
	
	## init
	func _init(p_product_name: String, p_product_description: String, p_repo_name: String) -> void:
		product_name = p_product_name
		product_description = p_product_description
		repo_name = p_repo_name
	
	
	## Returns the https github link for this products repo
	func get_github_link() -> String:
		return "/".join([Launcher.GITHUB, Launcher.ORG_NAME, repo_name])
	
	
	## Returns the https github api link for this products repo
	func get_github_api_link() -> String:
		return "/".join([Launcher.GITHUB_API, "repos", Launcher.ORG_NAME, repo_name])


## Repersents a version of this Product
class Version extends Object:
	## The number of this version
	var version_number: String
	
	## UTC+0 unix timestamp of the release date
	var release_date: float
	
	## All Assets of this version
	var assets: Array[Asset]
	
	## Stores all assets sorted by OperatingSystem and Arch
	var assets_sorted: Dictionary[OperatingSystem, Dictionary]
	
	## All assets that are compatible with this systems OS and Arch
	var compatible_assets: Array[Asset]
	
	## The Product object this Version is apart of
	var product: Product
	
	
	## init
	func _init(p_version_number: String, p_release_date: float) -> void:
		version_number = p_version_number
		release_date = p_release_date


## Repersents an asset of this Product
class Asset extends Object:
	## The name of this Asset
	var asset_name: String
	
	## The size of this Asset in bytes
	var asset_size: int 
	
	## The version number of this asset, may be the git commit hash
	var asset_version: String
	
	## The Architecture of this asset
	var arch: Arch = Arch.UNKNOWN
	
	## The OperatingSystem of this asset
	var operating_system: OperatingSystem = OperatingSystem.UNKNOWN
	
	## The https download URL for this Asset
	var download_url: String
	
	## The Version object this asset is part of
	var version: Version
	
	
	## init
	func _init(p_asset_name: String, p_asset_size: int, p_asset_version: String, p_arch: Arch, p_operating_system: OperatingSystem, p_download_url: String) -> void:
		asset_name = p_asset_name
		asset_size = p_asset_size
		asset_version = p_asset_version
		arch = p_arch
		operating_system = p_operating_system
		download_url = p_download_url
