local externalStorage = require "plugin.externalStorage"
local json = require("json")
local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
local logo = display.newText( "External Storage Plugin", 0, 0, native.systemFontBold, 20 )
logo.x, logo.y = display.contentCenterX, 50
bg:setFillColor( 0,0,.4 )
local widget = require("widget")
local printFiles
local pathRes = system.pathForFile( "test.txt" )
local pathDocs =system.pathForFile("test.txt", system.DocumentsDirectory)
printFiles = widget.newButton( {
	label = "Print Files",
	id = "printFiles",
	onEvent = function ( e )
		if (e.phase == "began") then
			printFiles.alpha = .3
		else
			printFiles.alpha = 1
			print( "Files" )
			print( "----------------" )
			print( json.encode( externalStorage.listFiles()))
			print( "----------------" )
		end
	end
} )
printFiles.x, printFiles.y = display.contentCenterX, display.contentCenterY-100
local copyFiles
copyFiles = widget.newButton( {
	label = "Copy test.txt to phone",
	id = "copy",
	onEvent = function ( e )
		if (e.phase == "began") then
			copyFiles.alpha = .3
		else
			copyFiles.alpha = 1
			print( "copyFile status" )
			print( "----------------" )
			print( json.encode( externalStorage.copyFile(pathRes, "/test.txt")))
			print( "----------------" )
		end
	end
} )
copyFiles.x, copyFiles.y = display.contentCenterX, display.contentCenterY-50
local deleteFile
deleteFile = widget.newButton( {
	label = "Delete test.txt from phone",
	id = "copy",
	onEvent = function ( e )
		if (e.phase == "began") then
			deleteFile.alpha = .3
		else
			deleteFile.alpha = 1
			print( "Was file deleted?" )
			print( "----------------" )
			print( externalStorage.deleteFile("/test.txt") )
			print( "----------------" )
		end
	end
} )
deleteFile.x, deleteFile.y = display.contentCenterX, display.contentCenterY
local saveAndPrintFile
saveAndPrintFile = widget.newButton( {
	label = "Save and Print file",
	id = "saveAndPrintFile",
	onEvent = function ( e )
		if (e.phase == "began") then
			saveAndPrintFile.alpha = .3
		else
			saveAndPrintFile.alpha = 1
			externalStorage.getFile("/test.txt", pathDocs)
			local file = io.open( pathDocs, "r" )
			if file then
				local contents = file:read( "*a" )
				print( "file says:"..contents )
				io.close( file )
			else
				print("no file saved")
			end
		end
	end
} )
saveAndPrintFile.x, saveAndPrintFile.y = display.contentCenterX, display.contentCenterY+50
--other things to print off
print("print system info")
print( "----------------" )
print("MB of total space"..externalStorage.totalSpace().."/".."MB of available space"..externalStorage.spaceAvailable())
print("SD card hooked up and readable and writable?"..externalStorage.isSdCardConnected())
print( "----------------" )