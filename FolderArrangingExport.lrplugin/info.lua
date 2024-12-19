--[[----------------------------------------------------------------------------
フォルダー仕分け書き出しプラグイン
----------------------------------------------------------------------------]]--
return {

	LrSdkVersion = 7.0 ,

	LrSdkMinimumVersion = 1.3 , -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'space.inaho.folder_arranging_export' ,

	LrPluginName = LOC '$$$/FolderArrangingExport/PluginName=フォルダー仕分けエクスポート' ,

	LrExportServiceProvider = {
		title = 'フォルダー仕分けエクスポート' ,
		file = 'FolderArrangingExportServiceProvider.lua' ,
	} ,

	VERSION = { major=0 , minor=1 , revision=2 , build='0' }

}
