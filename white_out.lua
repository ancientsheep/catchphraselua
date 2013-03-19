module(...,package.seeall);

function new()
	--print("white_out : new");

	local wo ={};

	wo.bk = display.newRect(0,0,display.contentWidth,display.contentHeight);
	wo.bk:setFillColor(255,255,255);
	wo.bk.isVisible = false;
	wo.bk.blendMode = "add";
	wo.startAlpha = 1.0;

	function wo:setColor(r,g,b)
		--print("white_out : setColor "..r..","..g..","..b);
		wo.bk:setFillColor(r,g,b);
	end

	function wo:flash(wo_time)
		--print("white_out : flash - "..tostring(wo_time));
		wo.bk.isVisible = true;
		wo.bk.alpha = wo.startAlpha;

		transition.to(wo.bk,{
							time=wo_time,
							alpha=0,
							onComplete=wo.destroy
							});

	end

	function wo:destroy()
		--print("white_out : destroy");
		wo.bk:removeSelf();
	end

	return wo;
end