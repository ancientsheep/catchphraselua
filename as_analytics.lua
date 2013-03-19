module(...,package.seeall);

analytics = require("analytics");

local isAmazon = false;

function new()

	local anal = {};

	anal.free_keys = {};
	anal.free_keys[1] = "78MRMJ2MTT5RCRXQ2RXP";		--iphone
	anal.free_keys[2] = "W2R9TFKZN6RYBT25WNMH";   	--ipad
	anal.free_keys[3] = "XFJRR2KF4M5CPZCCKCKT"; 	--android amazon
	anal.free_keys[4] = "BQDQ9BXPQ9CVC6D5QSPG";		--android play

	-----------------------------------------------------
	-- start analytics based on device and platform type
	-----------------------------------------------------
	function anal:startup()
		local platform = system.getInfo("platformName");
		local model = system.getInfo("model");

		print("as_analytics : start... "..platform);

		------------------
		-- android
		if platform == "Android" then
			print(" .. Android");

			-- is amazon
			if isAmazon == true then
				print(" .. Amazon");
				analytics.init(anal.free_keys[3]);
			-- is google play
			else
				print(" .. Google Play");
				analytics.init(anal.free_keys[4]);
			end

		else
			print(" .. iOS");

			if (model == "iPhone Simulator") or (model == "iPhone") then
				print(" .. iPhone");
				analytics.init(anal.free_keys[1]);
			else
				print(" .. iPad");
				analytics.init(anal.free_keys[2]);
			end
		end
	end

	-----------------------------------------------------
	-- log event in flurry
	-----------------------------------------------------

	function anal:logEvent(evt)
		print("as_analytics : logEvent - " .. evt);
		analytics.logEvent(evt);
	end

	anal:logEvent("Analytics Started");

	return anal;
end