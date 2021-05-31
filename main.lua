
local externalStorage = require "plugin.externalStorage"
local json = require "json"
local widget = require( "widget" )


local logo = display.newText( "External Storage Plugin", 0, 0, native.systemFontBold, 20 )
logo.x, logo.y = display.contentCenterX, 50

---------------------------------------------------------------------------------------

local function Button1Released(e)
	native.showPopup( "requestAppPermission", {  appPermission = "Storage",
												 urgency = "Critical",
												 listener = function ( e )   end } )
	return true
end


local function Button2Released(e)
	local text1
	local text2 = externalStorage.totalSpace()
	local text3 = externalStorage.spaceAvailable()
	local text4 = externalStorage.dcim
	local text5 = externalStorage.getExternalFilesDir(externalStorage.dcim)
	local sdcardpath = externalStorage.sdCardPath()
	local text6 = "sdCardPath returns a " .. type(sdcardpath)
	local text7 = ""

	if (externalStorage.isSdCardConnected()) then text1 = "isSdCardConnected = OK"
											 else text1 = "isSdCardConnected = NO"		end
	if (not text2) then text2 = "totalSpace nil"
				   else text2 = "totalSpace = " .. text2	end

	if (not text3) then text3 = "spaceAvailable nil"
				   else text3 = "spaceAvailable = " .. text3	end

	if (not text4) then text4 = "dcim nil"
				   else text4 = "dcim = " .. text4	end

	if (not text5) then text5 = "getExternalFilesDir nil"
				   else text5 = "getExternalFilesDir = " .. text5	end

	if (type(sdcardpath) == "string") then text7 = "sdCardPath = " .. sdcardpath   end

	native.showAlert( "INFO:", text1 .. "\n\n" .. text2 .. "\n\n" .. text3 .. "\n\n"
								.. text4 .. "\n\n" .. text5 .. "\n\n" .. text6 .. "\n\n" .. text7
								.. "\n\n Sd Card Writeable: ".. tostring(externalStorage.isSdCardWriteable()), { "OK" } )
	return true
end


local function Button3Released(e)
	local text = json.encode( externalStorage.listFiles(externalStorage.sdCardPath(), true))
	if (not text) then
		text = "nil"
	end
	native.showAlert( "LIST:", text, { "OK" } )
	return true
end
local function doesFileExist( fname, path )

    local results = false

    -- Path for the file
    local filePath = system.pathForFile( fname, path )

    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )

        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- File exists!
            print( "File found: " .. fname )
            results = true
            -- Close the file handle
            file:close()
        end
    end

    return results
end
function copyFile( srcName, srcPath, dstName, dstPath, overwrite )

    local results = false

    local fileExists = doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end

    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end

    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = system.pathForFile( dstName, dstPath )

    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )

    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end

    results = 2  -- 2 = File copied successfully!

    -- Close file handles
    rfh:close()
    wfh:close()

    return results
end

local function Button4Released(e)
	externalStorage.makeFolder(externalStorage.sdCardPath() .. "/folder", true)
	native.showAlert( "Make Folder:", "Folder created", { "OK" } )
	return true
end

-- copyFile( "file.png.txt", nil, "file.png", system.DocumentsDirectory, true )
local function Button5Released(e)

	local pathCorona = system.pathForFile( "file.png", system.DocumentsDirectory )

	if externalStorage.doesFileExist(externalStorage.sdCardPath(), true) then
		local copyResult = externalStorage.copyFile(pathCorona, externalStorage.sdCardPath() .. "file.png", true)

		native.showAlert( "Make Folder:", "Result: " .. copyResult, { "OK" } )
	end

	return true
end



---------------------------------------------------------------------------------------

local Group = display.newGroup()

widget.setTheme("widget_theme_android_holo_light")




local Button1 = widget.newButton({
    	width = 150,	   	height = 40,	    	label = "Storage Permission",
        labelColor = {      default = { 0.60, 0.30, 0.14 },
							over = { 0.79, 0.48, 0.30 }         },
    	labelYOffset = 0,  	font = native.systemFontBold,
    	fontSize = 12,    	emboss = false,
    	onRelease = Button1Released
    })
Group:insert(Button1)
Button1.x, Button1.y = display.contentCenterX, 100


local Button2 = widget.newButton({
    	width = 150,	   	height = 40,	    	label = "SD Card info",
        labelColor = {      default = { 0.60, 0.30, 0.14 },
							over = { 0.79, 0.48, 0.30 }         },
    	labelYOffset = 0,  	font = native.systemFontBold,
    	fontSize = 12,    	emboss = false,
    	onRelease = Button2Released
    })
Group:insert(Button2)
Button2.x, Button2.y = display.contentCenterX, 150


local Button3 = widget.newButton({
    	width = 150,	   	height = 40,	    	label = "List Files",
        labelColor = {      default = { 0.60, 0.30, 0.14 },
							over = { 0.79, 0.48, 0.30 }         },
    	labelYOffset = 0,  	font = native.systemFontBold,
    	fontSize = 12,    	emboss = false,
    	onRelease = Button3Released
    })
Group:insert(Button3)
Button3.x, Button3.y = display.contentCenterX, 200


local Button4 = widget.newButton({
    	width = 150,	   	height = 40,	    	label = "Make Folder",
        labelColor = {      default = { 0.60, 0.30, 0.14 },
							over = { 0.79, 0.48, 0.30 }         },
    	labelYOffset = 0,  	font = native.systemFontBold,
    	fontSize = 12,    	emboss = false,
    	onRelease = Button4Released
    })
Group:insert(Button4)
Button4.x, Button4.y = display.contentCenterX, 250


local Button5 = widget.newButton({
    	width = 150,	   	height = 40,	    	label = "Copy to SD",
        labelColor = {      default = { 0.60, 0.30, 0.14 },
							over = { 0.79, 0.48, 0.30 }         },
    	labelYOffset = 0,  	font = native.systemFontBold,
    	fontSize = 12,    	emboss = false,
    	onRelease = Button5Released
    })
Group:insert(Button5)
Button5.x, Button5.y = display.contentCenterX, 300
