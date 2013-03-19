module(...,package.seeall);

-- include Corona's "widget" library
local widget = require("widget");

function new(selectImg,notSelectImg,texter,width,height,clickEvent)
	print("radio_button : new()");

	--setup initial table
	local radio_button = {};
	radio_button.selectedImg = selectImg;
	radio_button.notSelectedImg = notSelectImg;
	radio_button.text = texter;
	radio_button.clickEvent = clickEvent;
	radio_button.isSelected = false;

	-- creat button group
	radio_button.group = display.newGroup(0,0,width,height);

	-- set selected state
	function radio_button:setSelected(isSelected)
		if(radio_button.button ~= nil) then
			radio_button.group:remove(radio_button.button);
		end

		local useImage;

		--setup correct image to use
		if isSelected==true then
			useImage = radio_button.selectedImg;
		else
			useImage = radio_button.notSelectedImg;
		end

		radio_button.isSelected = isSelected;

		print("radio_button : setSelected Img = "..useImage);
		--print("radio_button : images = select:"..radio_button.selectedImg.." not="..radio_button.notSelectedImg);

		-- create button with state
		local button = widget.newButton{
			label=radio_button.text,
			defaultFile=useImage,
			overFile=useImage,
			width=radio_button.width, height=radio_button.height,
			onRelease = radio_button.clickEvent
		}
		button:setReferencePoint(display.TopLeftReferencePoint);
		button.x = 0;
		button.y = 0;
		radio_button.group:insert(button);

		radio_button.button = button;
	end

	function radio_button:selected()
		return radio_button.isSelected;
	end

	return radio_button;

end