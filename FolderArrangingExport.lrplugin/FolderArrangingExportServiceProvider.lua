--[[----------------------------------------------------------------------------
フォルダー仕分け書き出しプラグイン
----------------------------------------------------------------------------]]--
--============================================================================--
require 'FolderArrangingExportDialogSections'
require 'FolderArrangingExportTask'
--============================================================================--

return {

  allowFileFormats = nil, -- nil equates to all available formats

	allowColorSpaces = nil, -- nil equates to all color spaces

	exportPresetFields = {
		{ key = 'arrangeRuleChoise1'			, default = '' },
		{ key = 'arrangeRuleCustomText1'	, default = '' },
		{ key = 'arrangeRuleChoise2'			, default = '' },
		{ key = 'arrangeRuleCustomText2'	, default = '' },
		{ key = 'arrangeRuleChoise3'			, default = '' },
		{ key = 'arrangeRuleCustomText3'	, default = '' },
		{ key = 'arrangeRuleChoise4'			, default = '' },
		{ key = 'arrangeRuleCustomText4'	, default = '' },
		{ key = 'arrangeRuleChoise5'			, default = '' },
		{ key = 'arrangeRuleCustomText5'	, default = '' },
	},

	startDialog = FolderArrangingExportDialogSections.startDialog,

	sectionsForBottomOfDialog = FolderArrangingExportDialogSections.sectionsForBottomOfDialog,

	processRenderedPhotos = FolderArrangingExportTask.processRenderedPhotos,
	
}
