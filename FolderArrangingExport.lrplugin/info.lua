--[[----------------------------------------------------------------------------
フォルダー自動振り分けエクスポート for Lightroom Classic
----------------------------------------------------------------------------]]--
return {

	LrSdkVersion = 7.0 ,

	LrSdkMinimumVersion = 1.3 , -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'space.inaho.folder_arranging_export' ,

	LrPluginName = LOC '$$$/FolderArrangingExport/PluginName=フォルダー自動振り分けエクスポート for Lightroom Classic' ,

	LrExportServiceProvider = {
		title = 'フォルダー自動振り分けエクスポート for Lightroom Classic' ,
		file = 'FolderArrangingExportServiceProvider.lua' ,
	} ,

	VERSION = { major=0 , minor=1 , revision=2 , build='0' }

}
