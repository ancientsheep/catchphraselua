application = {
	content = {
		width = 320,
		height = 480, 
		scale = "zoomStretch",
		fps = 60,
		
	
        imageSuffix = {
		    ["@2x"] = 1.5,
		}
	
	},

    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
}
