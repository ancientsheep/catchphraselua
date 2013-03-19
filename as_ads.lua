module(...,package.seeall);

local ads = require("ads");

function new()

	local ad = {};

	-- init ad network
	function ad:init()
		--ads.init("inmobi","3cf7191fd40c4829a9e8d64701a3e48b");
	end

	-- show ad
	function ad:show()
		--ads.show("banner320x48",{x=0,y=100,interval=60,testMode=true});
	end

	-- hide ad
	function ads:hide()
		--ads.hide();
	end

	return ad;
end