# Copyright (c) 2026 Liam Sherwin. All rights reserved.
# This file is part of the Spectrum Lighting Controller, licensed under the GPL v3.0 or later.
# See the LICENSE file for details.

class_name UIVersionManagerManagerTab extends Control
## Manager Tab for UIVersionManager


## Enum for InstanceColumns
enum InstanceColumns {NAME, RELEASE_DATE, SIZE, STATUS}

## Enum for QueueColumns
enum QueueColumns {NAME, SIZE}

## Enum for VersionStatus
enum VersionStatus {AVAILABLE, DOWNLOADED, UNSUPPORTED}


## The InstanceTable Table
@onready var _instance_table: Table = %InstanceTable

## The QueueTable Table
@onready var _queue_table: Table = %QueueTable

## The DeleteSelected Button
@onready var _delete_selected: Button = %DeleteSelected

## The QueueSelected Button
@onready var _queue_selected: Button = %QueueSelected

## The RemoveSelected Button
@onready var _remove_selected: Button = %RemoveSelected

## The DownloadAll Button
@onready var _download_all: Button = %DownloadAll

## The DownloadSize Label
@onready var _download_size: Label = %DownloadSize


## RefMap for Table.Row: Launcher.Product
var _product_rows: RefMap = RefMap.new()

## RefMap for Table.Row: Launcher.Product.Version
var _version_rows: RefMap = RefMap.new()

## RefMap for Table.Row: Launcher.Product.Version.Asset
var _asset_rows: RefMap = RefMap.new()


## ready
func _ready() -> void:
	_queue_table.set_show_index_bar(false)
	
	for column: String in InstanceColumns.keys():
		_instance_table.add_column(column.capitalize(), Data.Type.STRING)
	
	for column: String in QueueColumns.keys():
		_queue_table.add_column(column.capitalize(), Data.Type.STRING)
	
	Launcher.product_versions_loaded.connect(_load_product)
	Launcher.product_versions_reset.connect(reset)
	
	for product: Launcher.Product in Launcher.get_products():
		if product.versions_loaded:
			_load_product(product)


## Resets this ManagerTab
func reset() -> void:
	_instance_table.clear()
	_queue_table.clear()
	
	_delete_selected.set_disabled(true)
	_queue_selected.set_disabled(true)
	_remove_selected.set_disabled(true)
	_download_all.set_disabled(true)
	
	_download_size.set_text("0.0Gb")
	
	_product_rows.clear()
	_version_rows.clear()
	_asset_rows.clear()


## Loads the given product into the table
func _load_product(p_product: Launcher.Product) -> void:
	var product_row: Table.Row = _instance_table.add_row({
		InstanceColumns.NAME: p_product.product_name,
	})
	_product_rows.map(product_row, p_product)
	
	for version: Launcher.Version in p_product.versions:
		var version_row: Table.Row = product_row.add_sub_row({
			InstanceColumns.NAME: version.version_number,
			InstanceColumns.RELEASE_DATE: Time.get_date_string_from_unix_time(int(version.release_date)),
		})
		_version_rows.map(version_row, version_row)
		
		if version.compatible_assets.size() == 1:
			var human_size: String = String.humanize_size(version.compatible_assets[0].asset_size)
			
			version_row.set_cell_data(_instance_table.get_column(InstanceColumns.SIZE), human_size)
			version_row.set_cell_data(_instance_table.get_column(InstanceColumns.STATUS), _get_status(VersionStatus.AVAILABLE))
			
		elif version.compatible_assets.size():
			for asset: Launcher.Asset in version.assets:
				var asset_row: Table.Row = version_row.add_sub_row({
					InstanceColumns.NAME: " ".join([asset.asset_version, Launcher.Arch.keys()[asset.arch], Launcher.OperatingSystem.keys()[asset.operating_system]]),
					InstanceColumns.SIZE: String.humanize_size(asset.asset_size),
					InstanceColumns.STATUS: _get_status(VersionStatus.AVAILABLE)
				})
				_asset_rows.map(asset_row, asset)
			
		else:
			version_row.set_cell_data(_instance_table.get_column(InstanceColumns.STATUS), _get_status(VersionStatus.UNSUPPORTED))


## Returns the string of the given VersionStatus
func _get_status(p_status: VersionStatus) -> String:
	return VersionStatus.keys()[p_status].capitalize()
