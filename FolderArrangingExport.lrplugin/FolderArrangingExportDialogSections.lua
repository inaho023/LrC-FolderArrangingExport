--[[----------------------------------------------------------------------------
フォルダー仕分け書き出しプラグイン
----------------------------------------------------------------------------]]--
--============================================================================--
-- Lightroom SDK
--============================================================================--
local lrView    = import 'LrView'
local lrBinding = import 'LrBinding'
--============================================================================--
FolderArrangingExportDialogSections = {}
--============================================================================--
local function updateExportStatus( propertyTable )

	local message = nil

	repeat
		-- 仕分けルール１
		if propertyTable.arrangeRuleChoise1 == '' then
			propertyTable.arrangeRuleCustomText1 = ''
			propertyTable.arrangeRuleChoise2 = ''
			propertyTable.arrangeRuleCustomText2 = ''
			propertyTable.arrangeRuleChoise3 = ''
			propertyTable.arrangeRuleCustomText3 = ''
			propertyTable.arrangeRuleChoise4 = ''
			propertyTable.arrangeRuleCustomText4 = ''
			propertyTable.arrangeRuleChoise5 = ''
			propertyTable.arrangeRuleCustomText5 = ''
			break
		end
		if propertyTable.arrangeRuleChoise1 ~= 'CustomText' then
			propertyTable.arrangeRuleCustomText1 = ''
			break
		end
		if propertyTable.arrangeRuleChoise1 == 'CustomText' and propertyTable.arrangeRuleCustomText1 == '' then
			message = 'カスタムテキスト１を入力してください。'
			break
		end
		-- 仕分けルール２
		if propertyTable.arrangeRuleChoise2 == '' then
			propertyTable.arrangeRuleCustomText2 = ''
			propertyTable.arrangeRuleChoise3 = ''
			propertyTable.arrangeRuleCustomText3 = ''
			propertyTable.arrangeRuleChoise4 = ''
			propertyTable.arrangeRuleCustomText4 = ''
			propertyTable.arrangeRuleChoise5 = ''
			propertyTable.arrangeRuleCustomText5 = ''
			break
		end
		if propertyTable.arrangeRuleChoise2 ~= 'CustomText' then
			propertyTable.arrangeRuleCustomText2 = ''
			break
		end
		if propertyTable.arrangeRuleChoise2 == 'CustomText' and propertyTable.arrangeRuleCustomText2 == '' then
			message = 'カスタムテキスト２を入力してください。'
			break
		end
		-- 仕分けルール３
		if propertyTable.arrangeRuleChoise3 == '' then
			propertyTable.arrangeRuleCustomText3 = ''
			propertyTable.arrangeRuleChoise4 = ''
			propertyTable.arrangeRuleCustomText4 = ''
			propertyTable.arrangeRuleChoise5 = ''
			propertyTable.arrangeRuleCustomText5 = ''
			break
		end
		if propertyTable.arrangeRuleChoise3 ~= 'CustomText' then
			propertyTable.arrangeRuleCustomText3 = ''
			break
		end
		if propertyTable.arrangeRuleChoise3 == 'CustomText' and propertyTable.arrangeRuleCustomText3 == '' then
			message = 'カスタムテキスト３を入力してください。'
			break
		end
		-- 仕分けルール４
		if propertyTable.arrangeRuleChoise4 == '' then
			propertyTable.arrangeRuleCustomText4 = ''
			propertyTable.arrangeRuleChoise5 = ''
			propertyTable.arrangeRuleCustomText5 = ''
			break
		end
		if propertyTable.arrangeRuleChoise4 ~= 'CustomText' then
			propertyTable.arrangeRuleCustomText4 = ''
			break
		end
		if propertyTable.arrangeRuleChoise4 == 'CustomText' and propertyTable.arrangeRuleCustomText4 == '' then
			message = 'カスタムテキスト４を入力してください。'
			break
		end
		-- 仕分けルール４
		if propertyTable.arrangeRuleChoise5 == '' then
			propertyTable.arrangeRuleCustomText5 = ''
			break
		end
		if propertyTable.arrangeRuleChoise5 ~= 'CustomText' then
			propertyTable.arrangeRuleCustomText5 = ''
			break
		end
		if propertyTable.arrangeRuleChoise5 == 'CustomText' and propertyTable.arrangeRuleCustomText5 == '' then
			message = 'カスタムテキスト５を入力してください。'
			break
		end
	until true

	if message then
		propertyTable.message = message
		propertyTable.hasError = true
		propertyTable.hasNoError = false
		propertyTable.LR_cantExportBecause = message
	else
		propertyTable.message = nil
		propertyTable.hasError = false
		propertyTable.hasNoError = true
		propertyTable.LR_cantExportBecause = nil
	end

end

-------------------------------------------------------------------------------

function FolderArrangingExportDialogSections.startDialog( propertyTable )

	propertyTable:addObserver( 'arrangeRuleChoise1'			, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleCustomText1'	, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleChoise2'			, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleCustomText2'	, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleChoise3'			, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleCustomText3'	, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleChoise4'			, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleCustomText4'	, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleChoise5'			, updateExportStatus )
	propertyTable:addObserver( 'arrangeRuleCustomText5'	, updateExportStatus )

	updateExportStatus( propertyTable )

end

-------------------------------------------------------------------------------

function FolderArrangingExportDialogSections.sectionsForBottomOfDialog( _, propertyTable )

	local f     = lrView.osFactory()
	local bind  = lrView.bind
	local share = lrView.share

	local result = {

		{
			title = LOC '$$$/FolderArrangingExport/ExportDialog/ArrangeRule=仕分けルール',

			f:row {
				f:static_text {
					title = LOC '$$$/FolderArrangingExport/ExportDialog/ArrangeRuleChoise1=仕分けルール１ :',
					alignment = 'right',
					width = share 'labelWidth'
				},
				f:popup_menu {
					fill_horizontal = 1,
					value = bind 'arrangeRuleChoise1',
					items = {
						{ title = '＜なし＞'										,	value = ''										},
						{ title = '＜カスタムテキスト＞'				,	value = 'CustomText'					},
						{ title = '処理年月日（YYYY-MM-DD）'		,	value = 'dateTimeProcess_-'		},
						{ title = '処理年（YYYY）'							,	value = 'dateTimeProcess_Y'		},
						{ title = '処理月（MM）'								,	value = 'dateTimeProcess_M'		},
						{ title = '処理日（DD）'								,	value = 'dateTimeProcess_D'		},
						{ title = 'カテゴリー'									,	value = 'iptcCategory'				},
						{ title = 'ヘッドライン'								,	value = 'headline'						},
						{ title = 'ヘッドライン（先頭【】内）'	,	value = 'headline_I'					},
						{ title = 'ヘッドライン（先頭【】外）'	,	value = 'headline_O'					},
						{ title = 'タイトル'										,	value = 'title'								},
						{ title = 'タイトル（先頭【】内）'			,	value = 'title_I'							},
						{ title = 'タイトル（先頭【】外）'			,	value = 'title_O'							},
						{ title = '説明'												,	value = 'caption'							},
						{ title = '説明（先頭【】内）'					,	value = 'caption_I'						},
						{ title = '説明（先頭【】外）'					,	value = 'caption_O'						},
						{ title = '撮影年月日（YYYY-MM-DD）'		,	value = 'dateTimeOriginal_-'	},
						{ title = '撮影年（YYYY）'							,	value = 'dateTimeOriginal_Y'	},
						{ title = '撮影月（MM）'								,	value = 'dateTimeOriginal_M'	},
						{ title = '撮影日（DD）'								,	value = 'dateTimeOriginal_D'	},
						{ title = 'カメラメーカー'							,	value = 'cameraMake'					},
						{ title = 'カメラモデル'								,	value = 'cameraModel'					},
					},
					enabled = true,
					visible = true,
				},
				f:edit_field {
					width = share 'labelWidth',
					value = bind 'arrangeRuleCustomText1',
					enabled = lrBinding.keyEquals( 'arrangeRuleChoise1' , 'CustomText' , propertyTable ),
					visible = true
				},
			},
			f:row {
				f:static_text {
					title = LOC '$$$/FolderArrangingExport/ExportDialog/ArrangeRuleChoise2=仕分けルール２ :',
					alignment = 'right',
					width = share 'labelWidth',
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise1' , '' , propertyTable),
				},
				f:popup_menu {
					fill_horizontal = 1,
					value = bind 'arrangeRuleChoise2',
					items = {
						{ title = '＜なし＞'										,	value = ''										},
						{ title = '＜カスタムテキスト＞'				,	value = 'CustomText'					},
						{ title = '処理年月日（YYYY-MM-DD）'		,	value = 'dateTimeProcess_-'		},
						{ title = '処理年（YYYY）'							,	value = 'dateTimeProcess_Y'		},
						{ title = '処理月（MM）'								,	value = 'dateTimeProcess_M'		},
						{ title = '処理日（DD）'								,	value = 'dateTimeProcess_D'		},
						{ title = 'カテゴリー'									,	value = 'iptcCategory'				},
						{ title = 'ヘッドライン'								,	value = 'headline'						},
						{ title = 'ヘッドライン（先頭【】内）'	,	value = 'headline_I'					},
						{ title = 'ヘッドライン（先頭【】外）'	,	value = 'headline_O'					},
						{ title = 'タイトル'										,	value = 'title'								},
						{ title = 'タイトル（先頭【】内）'			,	value = 'title_I'							},
						{ title = 'タイトル（先頭【】外）'			,	value = 'title_O'							},
						{ title = '説明'												,	value = 'caption'							},
						{ title = '説明（先頭【】内）'					,	value = 'caption_I'						},
						{ title = '説明（先頭【】外）'					,	value = 'caption_O'						},
						{ title = '撮影年月日（YYYY-MM-DD）'		,	value = 'dateTimeOriginal_-'	},
						{ title = '撮影年（YYYY）'							,	value = 'dateTimeOriginal_Y'	},
						{ title = '撮影月（MM）'								,	value = 'dateTimeOriginal_M'	},
						{ title = '撮影日（DD）'								,	value = 'dateTimeOriginal_D'	},
						{ title = 'カメラメーカー'							,	value = 'cameraMake'					},
						{ title = 'カメラモデル'								,	value = 'cameraModel'					},
					},
					enabled = lrBinding.keyIsNot( 'arrangeRuleChoise1' , '' , propertyTable ),
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise1' , '' , propertyTable ),
				},
				f:edit_field {
					width = share 'labelWidth',
					value = bind 'arrangeRuleCustomText2',
					enabled = lrBinding.keyEquals( 'arrangeRuleChoise2' , 'CustomText' , propertyTable ),
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise1' , '' , propertyTable ),
				},
			},
			f:row {
				f:static_text {
					title = LOC '$$$/FolderArrangingExport/ExportDialog/ArrangeRuleChoise3=仕分けルール３ :',
					alignment = 'right',
					width = share 'labelWidth',
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise2' , '' ),
				},
				f:popup_menu {
					fill_horizontal = 1,
					value = bind 'arrangeRuleChoise3',
					items = {
						{ title = '＜なし＞'										,	value = ''										},
						{ title = '＜カスタムテキスト＞'				,	value = 'CustomText'					},
						{ title = '処理年月日（YYYY-MM-DD）'		,	value = 'dateTimeProcess_-'		},
						{ title = '処理年（YYYY）'							,	value = 'dateTimeProcess_Y'		},
						{ title = '処理月（MM）'								,	value = 'dateTimeProcess_M'		},
						{ title = '処理日（DD）'								,	value = 'dateTimeProcess_D'		},
						{ title = 'カテゴリー'									,	value = 'iptcCategory'				},
						{ title = 'ヘッドライン'								,	value = 'headline'						},
						{ title = 'ヘッドライン（先頭【】内）'	,	value = 'headline_I'					},
						{ title = 'ヘッドライン（先頭【】外）'	,	value = 'headline_O'					},
						{ title = 'タイトル'										,	value = 'title'								},
						{ title = 'タイトル（先頭【】内）'			,	value = 'title_I'							},
						{ title = 'タイトル（先頭【】外）'			,	value = 'title_O'							},
						{ title = '説明'												,	value = 'caption'							},
						{ title = '説明（先頭【】内）'					,	value = 'caption_I'						},
						{ title = '説明（先頭【】外）'					,	value = 'caption_O'						},
						{ title = '撮影年月日（YYYY-MM-DD）'		,	value = 'dateTimeOriginal_-'	},
						{ title = '撮影年（YYYY）'							,	value = 'dateTimeOriginal_Y'	},
						{ title = '撮影月（MM）'								,	value = 'dateTimeOriginal_M'	},
						{ title = '撮影日（DD）'								,	value = 'dateTimeOriginal_D'	},
						{ title = 'カメラメーカー'							,	value = 'cameraMake'					},
						{ title = 'カメラモデル'								,	value = 'cameraModel'					},
					},
					enabled = lrBinding.keyIsNot( 'arrangeRuleChoise2' , '' , propertyTable ),
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise2' , '' , propertyTable ),
				},
				f:edit_field {
					width = share 'labelWidth',
					value = bind 'arrangeRuleCustomText3',
					enabled = lrBinding.keyEquals( 'arrangeRuleChoise3' , 'CustomText' , propertyTable ),
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise2' , '' , propertyTable ),
				},
			},
			f:row {
				f:static_text {
					title = LOC '$$$/FolderArrangingExport/ExportDialog/ArrangeRuleChoise4=仕分けルール４ :',
					alignment = 'right',
					width = share 'labelWidth',
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise3' , '' ),
				},
				f:popup_menu {
					fill_horizontal = 1,
					value = bind 'arrangeRuleChoise4',
					items = {
						{ title = '＜なし＞'										,	value = ''										},
						{ title = '＜カスタムテキスト＞'				,	value = 'CustomText'					},
						{ title = '処理年月日（YYYY-MM-DD）'		,	value = 'dateTimeProcess_-'		},
						{ title = '処理年（YYYY）'							,	value = 'dateTimeProcess_Y'		},
						{ title = '処理月（MM）'								,	value = 'dateTimeProcess_M'		},
						{ title = '処理日（DD）'								,	value = 'dateTimeProcess_D'		},
						{ title = 'カテゴリー'									,	value = 'iptcCategory'				},
						{ title = 'ヘッドライン'								,	value = 'headline'						},
						{ title = 'ヘッドライン（先頭【】内）'	,	value = 'headline_I'					},
						{ title = 'ヘッドライン（先頭【】外）'	,	value = 'headline_O'					},
						{ title = 'タイトル'										,	value = 'title'								},
						{ title = 'タイトル（先頭【】内）'			,	value = 'title_I'							},
						{ title = 'タイトル（先頭【】外）'			,	value = 'title_O'							},
						{ title = '説明'												,	value = 'caption'							},
						{ title = '説明（先頭【】内）'					,	value = 'caption_I'						},
						{ title = '説明（先頭【】外）'					,	value = 'caption_O'						},
						{ title = '撮影年月日（YYYY-MM-DD）'		,	value = 'dateTimeOriginal_-'	},
						{ title = '撮影年（YYYY）'							,	value = 'dateTimeOriginal_Y'	},
						{ title = '撮影月（MM）'								,	value = 'dateTimeOriginal_M'	},
						{ title = '撮影日（DD）'								,	value = 'dateTimeOriginal_D'	},
						{ title = 'カメラメーカー'							,	value = 'cameraMake'					},
						{ title = 'カメラモデル'								,	value = 'cameraModel'					},
					},
					enabled = lrBinding.keyIsNot( 'arrangeRuleChoise3' , '' , propertyTable ),
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise3' , '' , propertyTable ),
				},
				f:edit_field {
					width = share 'labelWidth',
					value = bind 'arrangeRuleCustomText4',
					enabled = lrBinding.keyEquals( 'arrangeRuleChoise4' , 'CustomText' , propertyTable ),
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise3' , '' , propertyTable ),
				},
			},
			f:row {
				f:static_text {
					title = LOC '$$$/FolderArrangingExport/ExportDialog/ArrangeRuleChoise5=仕分けルール５ :',
					alignment = 'right',
					width = share 'labelWidth',
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise4' , '' ),
				},
				f:popup_menu {
					fill_horizontal = 1,
					value = bind 'arrangeRuleChoise5',
					items = {
						{ title = '＜なし＞'										,	value = ''										},
						{ title = '＜カスタムテキスト＞'				,	value = 'CustomText'					},
						{ title = '処理年月日（YYYY-MM-DD）'		,	value = 'dateTimeProcess_-'		},
						{ title = '処理年（YYYY）'							,	value = 'dateTimeProcess_Y'		},
						{ title = '処理月（MM）'								,	value = 'dateTimeProcess_M'		},
						{ title = '処理日（DD）'								,	value = 'dateTimeProcess_D'		},
						{ title = 'カテゴリー'									,	value = 'iptcCategory'				},
						{ title = 'ヘッドライン'								,	value = 'headline'						},
						{ title = 'ヘッドライン（先頭【】内）'	,	value = 'headline_I'					},
						{ title = 'ヘッドライン（先頭【】外）'	,	value = 'headline_O'					},
						{ title = 'タイトル'										,	value = 'title'								},
						{ title = 'タイトル（先頭【】内）'			,	value = 'title_I'							},
						{ title = 'タイトル（先頭【】外）'			,	value = 'title_O'							},
						{ title = '説明'												,	value = 'caption'							},
						{ title = '説明（先頭【】内）'					,	value = 'caption_I'						},
						{ title = '説明（先頭【】外）'					,	value = 'caption_O'						},
						{ title = '撮影年月日（YYYY-MM-DD）'		,	value = 'dateTimeOriginal_-'	},
						{ title = '撮影年（YYYY）'							,	value = 'dateTimeOriginal_Y'	},
						{ title = '撮影月（MM）'								,	value = 'dateTimeOriginal_M'	},
						{ title = '撮影日（DD）'								,	value = 'dateTimeOriginal_D'	},
						{ title = 'カメラメーカー'							,	value = 'cameraMake'					},
						{ title = 'カメラモデル'								,	value = 'cameraModel'					},
					},
					enabled = lrBinding.keyIsNot( 'arrangeRuleChoise4' , '' , propertyTable ),
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise4' , '' , propertyTable ),
				},
				f:edit_field {
					width = share 'labelWidth',
					value = bind 'arrangeRuleCustomText5',
					enabled = lrBinding.keyEquals( 'arrangeRuleChoise5' , 'CustomText' , propertyTable ),
					visible = lrBinding.keyIsNot( 'arrangeRuleChoise4' , '' , propertyTable ),
				},
			},
		},
	}

	return result

end
