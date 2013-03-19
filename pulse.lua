
module(...,package.seeall);

local tweeners = require("as_tweeners");

function new(obj)
	local pulser = {};
	pulser.obj = obj;

	-- paramters
	pulser.active = true;
	pulser.delay = 0;
	pulser.animTime = 1000;
	pulser.scaleTo = 1.3;
	pulser.scaleFrom = 1.0;
	--[[pulser.transTo = tweeners.easeOutBounce;
	pulser.transFrom = tweeners.easeOutBounce;--]]

	pulser.transTo = easing.linear;
	pulser.transFrom = easing.linear;

	function pulser:startPulse()
		--print("pulse : startPulse : active - ");

		if pulser.active==true then
			transition.to(pulser.obj,{time=1000,
						time=pulser.animTime,
						xScale=pulser.scaleTo,
						yScale=pulser.scaleTo,
						transition=pulser.transTo,
						onComplete=pulser.restartPulse})
		end
	end

	function pulser:restartPulse()
		--print("pulse : restartPulse ");

		if pulser.active==true then
			transition.to(pulser.obj,{time=1000,
							time=pulser.animTime,
							xScale=pulser.scaleFrom,
							yScale=pulser.scaleFrom,
							transition=pulser.transFrom,
							onComplete=pulser.startPulse});
		end
	end

	function pulser:stopPulse()
		pulser.active = false;
	end


	return pulser;
end
