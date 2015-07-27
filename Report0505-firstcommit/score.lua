local M = {}

function M.init( options )

	 local customOptions = options or {}
	 local opt = {}
	 opt.fontSize = customOptions.fontSize or 24
	 opt.font = customOptions.font or native.systemFontBold
	 opt.x = customOptions.x or display.contentCenterX
	 opt.y = customOptions.y or display.contentCenterY
	 opt.maxDigits = customOptions.maxDigits or 6
	 opt.leadingZeros = customOptions.leadingZeros or false
	 M.fileName = customOptions.fileName or 'score.txt'


	 local prefix = ''
	 if opt.leadingZeros then
	 	prefix = '0'
	 end

	 M.formatStr = '%' .. prefix .. opt.maxDigits .. 'd'
	 M.scoreText = display.newText( string.format( M.formatStr, 0), opt.x, opt.y, opt.font, opt.fontSize )
	 return M.scoreText
end

function M.set( value )
	-- body
	M.score = value
	M.scoreText.text = string.format( M.formatStr, value )
end

function M.get ()
	return M.score
end

function M.add (value)
	M.score = M.score + value
	M.scoreText.text = string.format( M.formatStr, M.score )
end

function M.save()
	local path = system.pathForFile( M.fileName, system.DocumentsDirectory )
	local file = io.open( path, 'w' )

	if file then
		local content = tostring( M.score )
		file:write( content )
		io.close( file )
		return true
	else
		print( 'Error: could not read', M.fileName, '.')
		return false
	end
end

function M.load()
	local path = system.pathForFile( M.fileName, system.DocumentsDirectory )
	local file = io.open( path, 'r' )
	if file then
		local content = file:read('*a')
		local score = tonumber( content )
		io.close( file )
		return score
	end
	print ('Error: could not read from file', M.fileName, '.')
	return nil
end

return M