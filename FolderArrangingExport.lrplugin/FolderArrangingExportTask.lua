--[[----------------------------------------------------------------------------
フォルダー仕分け書き出しプラグイン
----------------------------------------------------------------------------]]--
--============================================================================--
-- Lightroom API
--============================================================================--
local lrPathUtils	= import 'LrPathUtils'
local lrFileUtils	= import 'LrFileUtils'
-- local lrDialogs		= import 'LrDialogs'
--============================================================================--
FolderArrangingExportTask = {}
--============================================================================--
-- local function sleep(s)
--   local ntime = os.time() + s
--   repeat until os.time() > ntime
-- end
--============================================================================--
local function getBaseName( fullPath )
	-- 変数定義
	local indexStart
	local indexEnd
	local baseName
	-- フルパスからパスと拡張子を削除
	baseName = lrPathUtils.removeExtension( lrPathUtils.leafName( fullPath ) )
	-- ベース名から自動付加文字列のインデックスを取得
	indexStart , indexEnd = baseName:find( '%-%d$' )
	-- ベース名から付加文字列を削除
	if indexStart ~= nil then
		baseName = baseName:sub( 1 , indexStart - 1 )
	end
	-- 拡張子を削除したファイル名を返す
	return baseName
end
--============================================================================--
local function getArrangeRule( arrangeRuleChoice , customText , photo )
	local arrangeRule = ''
	if arrangeRuleChoice == '' or arrangeRuleChoice == nil then
		arrangeRule = ''
	elseif arrangeRuleChoice == 'CustomText' then
		arrangeRule = customText
	elseif arrangeRuleChoice:find( 'headline' ) then
		arrangeRule = photo:getFormattedMetadata( 'headline' )
		if arrangeRuleChoice:find( '_I' ) then
			arrangeRule = arrangeRule:gsub( '【(.+)】','%1', 1 )
		elseif arrangeRuleChoice:find( '_O' ) then
			arrangeRule = arrangeRule:gsub( '【.+】','', 1 )
		end
	elseif arrangeRuleChoice:find( 'title' ) then
		arrangeRule = photo:getFormattedMetadata( 'title' )
		if arrangeRuleChoice:find( '_I' ) then
			arrangeRule = arrangeRule:gsub( '【(.+)】','%1', 1 )
		elseif arrangeRuleChoice:find( '_O' ) then
			arrangeRule = arrangeRule:gsub( '【.+】','', 1 )
		end
	elseif arrangeRuleChoice:find( 'caption' ) then
		arrangeRule = photo:getFormattedMetadata( 'caption' )
		if arrangeRuleChoice:find( '_I' )  then
			arrangeRule = arrangeRule:gsub( '.+【(.+)】.+','%1', 1 )
		elseif arrangeRuleChoice:find( '_O' ) then
			arrangeRule = arrangeRule:gsub( '【.+】','', 1 )
		end
	elseif arrangeRuleChoice:find( 'dateTimeOriginal' ) then
        arrangeRule = photo:getFormattedMetadata( 'dateTimeOriginal' )
		if arrangeRuleChoice:find( '_%-' ) then
			arrangeRule = arrangeRule:sub( 1 , 4 ) .. '-' .. arrangeRule:sub( 6 , 7 )
		elseif arrangeRuleChoice:find( '_Y' ) then
			arrangeRule = arrangeRule:sub( 1 , 4 )
		elseif arrangeRuleChoice:find( '_M' ) then
			arrangeRule = arrangeRule:sub( 6 , 7 )
		end
	elseif arrangeRuleChoice:find( 'dateTimeProcess' ) then
		if arrangeRuleChoice:find( '_%-' ) then
			arrangeRule = tostring(os.date( '%Y-%m-%d' ))
		elseif arrangeRuleChoice:find( '_Y' ) then
			arrangeRule = tostring(os.date( '%Y' ))
		elseif arrangeRuleChoice:find( '_M' ) then
			arrangeRule = tostring(os.date( '%m' ))
		elseif arrangeRuleChoice:find( '_D' ) then
			arrangeRule = tostring(os.date( '%d' ))
		end
	else
		arrangeRule = photo:getFormattedMetadata( arrangeRuleChoice )
	end
	-- 
	return arrangeRule
end
--============================================================================--
function FolderArrangingExportTask.processRenderedPhotos( functionContext, exportContext )

	-- Make a local reference to the export parameters.
	local exportSession	= exportContext.exportSession
	local exportParams	= exportContext.propertyTable
	local exportPhoto 	= nil
	local progressScope	= exportContext:configureProgress { title = 'フォルダー仕分け書き出し（ ' .. tostring( exportSession:countRenditions() ) .. ' 件 ）'  }

	local fileCount		= 0

	local arrangeRule1
	local arrangeRule2
	local arrangeRule3
	local arrangeRule4
	local arrangeRule5

	local folderName
	local fileExtention
	local fileBaseName
	local newFullPath
	local newFullName

	local result
	local pathOrMessage

	progressScope:attachToFunctionContext( functionContext )

	for i , rendition in exportSession:renditions{ progressScope = progressScope , stopIfCanceled = true } do
		-- 変数初期化
		exportPhoto = rendition.photo
		-- キャンセルなら終了
		if progressScope:isCanceled() then
			break
		end
		-- フルパスを分解
		folderName		= lrPathUtils.parent( rendition.destinationPath )
		fileBaseName	= getBaseName( rendition.destinationPath )
		fileExtention	= lrPathUtils.extension( rendition.destinationPath )
		-- 仕分けルールで指定されたメタデータを取得
		arrangeRule1 = getArrangeRule( exportParams.arrangeRuleChoise1 , exportParams.arrangeRuleCustomText1 , exportPhoto )
		arrangeRule2 = getArrangeRule( exportParams.arrangeRuleChoise2 , exportParams.arrangeRuleCustomText2 , exportPhoto )
		arrangeRule3 = getArrangeRule( exportParams.arrangeRuleChoise3 , exportParams.arrangeRuleCustomText3 , exportPhoto )
		arrangeRule4 = getArrangeRule( exportParams.arrangeRuleChoise4 , exportParams.arrangeRuleCustomText4 , exportPhoto )
		arrangeRule5 = getArrangeRule( exportParams.arrangeRuleChoise5 , exportParams.arrangeRuleCustomText5 , exportPhoto )
		-- 仕分けルールに基づいて仕分け先フォルダーを生成
		newFullPath		= folderName
		if arrangeRule1 ~= '' and arrangeRule1 ~= nil then
			newFullPath	= lrPathUtils.child( newFullPath , arrangeRule1 )
		end
		if arrangeRule2 ~= '' and arrangeRule2 ~= nil then
			newFullPath	= lrPathUtils.child( newFullPath , arrangeRule2 )
		end
		if arrangeRule3 ~= '' and arrangeRule3 ~= nil then
			newFullPath	= lrPathUtils.child( newFullPath , arrangeRule3 )
		end
		if arrangeRule4 ~= '' and arrangeRule4 ~= nil then
			newFullPath	= lrPathUtils.child( newFullPath , arrangeRule4 )
		end
		if arrangeRule5 ~= '' and arrangeRule5 ~= nil then
			newFullPath	= lrPathUtils.child( newFullPath , arrangeRule5 )
		end
		lrFileUtils.createAllDirectories( newFullPath )
		-- エクスポート処理
		result , pathOrMessage = rendition:waitForRender()
		-- ファイル移動処理
		if result then
			-- 移動先ファイルのフルパスを構築
			newFullName	= lrPathUtils.child( newFullPath , fileBaseName .. '-1.' .. fileExtention )
			-- ファイル移動処理
			if lrFileUtils.exists( newFullName ) then
				-- ファイルカウンター初期化
				fileCount = 0
				-- 先頭の文字列が同じファイルを検索
				for FilePath in lrFileUtils.files( newFullPath ) do
					-- ファイル名を先頭から比較して一致したらカウンターをインクリメント
					if getBaseName( FilePath ):find( fileBaseName , 1 , true ) then
						fileCount = fileCount + 1
					end
				end
				-- 移動先ファイルのフルパスを再構築
				newFullName	= lrPathUtils.child( newFullPath , fileBaseName .. '-' .. tostring( fileCount + 1 ) .. '.' .. fileExtention )
			end
			-- ファイルを移動
			lrFileUtils.move( rendition.destinationPath , newFullName )
		end
	end
end
