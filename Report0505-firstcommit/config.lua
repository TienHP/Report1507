local ratio = display.pixelHeight/display.pixelWidth

application = {
	content = {
		width = ratio > 1.5 and 800 or math.ceil(1200/ratio),
		height = ratio < 1.5 and 1200 or math.ceil(800*ratio),
		scale = 'letterbox',
		fps = 30,

		imageSuffix = {
			['@2x'] = 1.3,
		},--end suffix
	},--end content
} -- end application