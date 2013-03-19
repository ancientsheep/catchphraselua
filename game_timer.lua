module(...,package.seeall);

function new()
	local game_timer = {};

	-- create our group
	game_timer.group = display.newGroup(0,0);
	game_timer.group:setReferencePoint(display.TopLeftReferencePoint);

	-- setup / create our text field
	game_timer.textField = display.newText("45",50,10,"Akzidenz-Grotesk BQ Bold",14);
	game_timer.textField:setTextColor(255,255,255);
	game_timer.textField:setReferencePoint(display.TopLeftReferencePoint);
	game_timer.textField.x,game_timer.textField.y=0,0;
	game_timer.group:insert(game_timer.textField);

	-- set game time to zero
	game_timer.time = 0;

	--base time remaining for ticking speed stages
	game_timer.tickTimeStage1 = 45;
	game_timer.tickTimeStage2 = 30;
	game_timer.tickTimeStage3 = 15;

	--random time remaining for ticking speed stages
	game_timer.tickTimeRandomStage1 = math.random(-5, 5);
	game_timer.tickTimeRandomStage2 = math.random(-5, 5);
	game_timer.tickTimeRandomStage3 = math.random(-5, 5);

	-- set timer
	function game_timer:setTime(time,expire_func)
		print("game_timer :: setTime - "..time);
		game_timer.time = time;
		game_timer.expireFunction = expire_func;
		game_timer:updateTime();
	end

	-- start game timer
	function game_timer:startTimer()
		print("game_timer :: startTimer");
--		game_timer.timer = timer.performWithDelay(1000,function()
--			game_timer.time = game_timer.time - 1;
--			if game_timer.time <= 0 then
				-- timer expired
--			end

			-- update time
--			game_timer:updateTime();
--			if game_timer.time > 0 then
--				game_timer:startTimer();
--			end
--		end,1);

		game_timer:loopTimer();

		-- start ticking sound
		game_timer:startTicking();
	end

	function game_timer:loopTimer()
		print("game_timer :: loopTimer");
		game_timer.time = game_timer.time - 1;
		if game_timer.time <= 0 then
			-- timer expired
		end

		-- update time
		game_timer:updateTime();
		if game_timer.time > 0 then
			game_timer.timer = timer.performWithDelay(1000, game_timer.loopTimer);
		end
	end

	-- clock expired
	function game_timer:expire()
		print("game_timer :: expired");
		game_timer:expireFunction();
		timer.cancel(game_timer.timer);

		game_timer:stopTicking();
	end

	-- update time
	function game_timer:updateTime()
		game_timer.textField.text = game_timer.time;

		if(game_timer.time <= 0) then
			game_timer:expire();
		end
	end

	-- end game timer
	function game_timer:stopTimer()
		print("game_timer :: stopTimer");
		timer.cancel(game_timer.timer);

		game_timer:stopTicking();
	end

	function game_timer:destroy()
		print("game_timer :: destroy");
		game_timer:stopTimer();
		game_timer:stopTicking();
		game_timer.expireFunction = nil;

	end

	function game_timer:startTicking()

		game_timer:loopTicking();
	end

	function game_timer:loopTicking()

		local delay = 1000;

		if(game_timer.time <= game_timer.tickTimeStage1 + game_timer.tickTimeRandomStage1) then delay = 800; end
		if(game_timer.time <= game_timer.tickTimeStage2 + game_timer.tickTimeRandomStage2) then delay = 600; end
		if(game_timer.time <= game_timer.tickTimeStage3 + game_timer.tickTimeRandomStage3) then delay = 400; end

		audioManager:playSound("clock_tick");

		game_timer.ticking = timer.performWithDelay(delay, game_timer.loopTicking, 1);

		print("tick!");
	end

	function game_timer:stopTicking()

		timer.cancel(game_timer.ticking);
	end

	return game_timer;
end