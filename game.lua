module(...,package.seeall);

local storyboard = require("storyboard");

-- include Corona's "widget" library
local widget = require("widget");

-- actual game goes here. wasn't working out being located inside game_scene
-- separate file works much better

local team1score;
local team2score;

--buttons
local passButton;

-- dialog options
local function backDialogOptions(event)
	if(event.action == "clicked") then
		local button = event.index;
		if button == 1 then
			--reset num skips used
			scoreKeeper.wordSkipsCurr = 0;
			storyboard.gotoScene("score_screen","slideRight",200);
		
		elseif button == 2 then
			-- do nothing
		end
	end
end

-- back button clicked
function backClick()
	print("game :: backClick");
	native.showAlert("End Round", "Are you sure you want to end this round?", { "Yes", "No" }, backDialogOptions);
end

--update the team scores text
function updateScoresText()
	team1score.text = tostring(scoreKeeper.team1_score);
	team2score.text = tostring(scoreKeeper.team2_score);
end

function new()
	
	game = {};

	-- create and setup all initial game assets
	function game:setup()
		-- create our game group
		game.group = display.newGroup(0,0,display.contentWidth,display.contentHeight);
		game.group:setReferencePoint(display.TopLeftReferencePoint);

		-- main menu bk
		local bk  = display.newImageRect("assets/game_screen/game_bg.jpg",480,320);
		bk:setReferencePoint(display.TopLeftReferencePoint);
		bk.x,bk.y = 0,0;
		game.group:insert(bk);

		-- overlay
		local overlay  = display.newImageRect("assets/game_screen/bk_overlay.jpg",480,320);
		overlay:setReferencePoint(display.TopLeftReferencePoint);
		overlay.x,overlay.y = 0,0;
		overlay.blendMode = "multiply";
		game.group:insert(overlay);

		--create the sun rays
		local sunRays  = require("sun_rays").new();
		game.group:insert(sunRays.sunRays);

		-- lcd bk
		local lcdBk  = display.newImageRect("assets/game_screen/lcd_bk.png",430,94);
		lcdBk:setReferencePoint(display.CenterReferencePoint);
		lcdBk.x,lcdBk.y = display.contentWidth/2,123;
		game.group:insert(lcdBk);
		game.lcdBk = lcdBk;


		-- make sure skip button is disabled

		-- pass button
		passButton = widget.newButton{
			label="",
			defaultFile="assets/game_screen/pass.png",
			overFile="assets/game_screen/pass.png",
			width=128, height=40,
			onRelease = game.passClick
		}
		passButton:setReferencePoint(display.CenterReferencePoint);
		passButton.x = display.contentWidth/2;
		passButton.y = 290;
		game.group:insert(passButton);

		--disable skip button
		if(scoreKeeper.wordSkips == 0) then
			passButton.alpha = 0.5;
			passButton.onRelease = nil;
		end

		-- next button
		local nextButton = widget.newButton{
			label="",
			defaultFile="assets/game_screen/next.png",
			overFile="assets/game_screen/next.png",
			width=264*.8, height=74*.8,
			onRelease = game.nextWordClick
		}
		nextButton:setReferencePoint(display.CenterReferencePoint);
		nextButton.x = display.contentWidth/2;
		nextButton.y = 210;
		game.group:insert(nextButton);

		--add navigation bar
		local navi = require("navi_bar").newBar();
		navi:setup(backClick);
		game.group:insert(navi.group);

		-- pause button
		local pauseButton = widget.newButton{
			label="",
			labelColor={default={255},overFile={200}},
			defaultFile="assets/navi_bar/pause_button.png",
			overFile="assets/navi_bar/pause_button.png",
			width=30, height=30,
			onRelease = game.pauseClick
		}
		pauseButton:setReferencePoint(display.TopRightReferencePoint);
		pauseButton.x = display.contentWidth - 10;
		pauseButton.y = 5;

		game.group:insert(pauseButton);

		--round #
		local roundBk  = display.newImageRect("assets/game_screen/round_header.png",111,68);
		roundBk:setReferencePoint(display.CenterReferencePoint);
		roundBk.x,roundBk.y = display.contentWidth/2,roundBk.height/2;
		game.group:insert(roundBk);

		-- current round text
		local currRound = display.newText(scoreKeeper.currRound,380,15,"Soup of Justice",15);
		currRound:setTextColor(255,255,255);
		currRound:setReferencePoint(display.CenterReferencePoint);
		currRound.x,currRound.y=roundBk.x+23,roundBk.y;
		currRound.rotation=-5;
		game.group:insert(currRound);

		-- game timer
		local gameTimer = require("game_timer").new();
		gameTimer:setTime(scoreKeeper.clock,game.clockExpired);
		gameTimer:startTimer();
		game.group:insert(gameTimer.group);
		game.gameTimer = gameTimer;

		--fps
		local fps = require("fps").new();
		game.group:insert(fps.group);

		-- create current game word
		local gameWord = display.newText("GAME WORD HERE",380,40,"Soup of Justice",35);
		gameWord:setTextColor(255,255,255);
		gameWord:setReferencePoint(display.CenterReferencePoint);
		gameWord.x,gameWord.y=display.contentWidth/2,122 + textOffsetFix:offset(5);
		game.group:insert(gameWord);
		game.gameWord = gameWord;

		-- team 1 score hud

		--team 1 hud bk
		local team1hud  = display.newImageRect("assets/game_screen/team1_bk.png",122,99);
		team1hud:setReferencePoint(display.TopLeftReferencePoint);
		team1hud.x,team1hud.y = 0,200;
		game.group:insert(team1hud);


		--team 2 hud bk
		local team2hud  = display.newImageRect("assets/game_screen/team2_bk.png",122,98);
		team2hud:setReferencePoint(display.TopRightReferencePoint);
		team2hud.x,team2hud.y = display.contentWidth,200;
		game.group:insert(team2hud);

		-- scores
		-- team 1 score
		team1score = display.newText("15",50,20,"Soup of Justice",50);
		team1score:setTextColor(255,255,255);
		team1score:setReferencePoint(display.TopLeftReferencePoint);
		team1score.x,team1score.y=20,227 + textOffsetFix:offset(13);
		game.group:insert(team1score);
		game.team1score = team1score;

		-- team 2 score
		team2score = display.newText("25",50,20,"Soup of Justice",50);
		team2score:setTextColor(255,255,255);
		team2score:setReferencePoint(display.TopLeftReferencePoint);
		team2score.x,team2score.y=display.contentWidth-60,227 + textOffsetFix:offset(13);
		game.group:insert(team2score);
		game.team2score = team2score;

		-- start off with random word
		game:randomizeWord();
		game:updateHUD();

		--game:playClockMusic(1);

		--times up overlay
		local timesup = require("times_up").new();
		game.group:insert(timesup.group);
		game.timesup = timesup;

		--pause dialog
		local pauseDialog = require("dialog_pause").new(game.skipRound, game.restartRound, game.unpauseClick);
		game.group:insert(pauseDialog.group);
		game.pauseDialog = pauseDialog;

		--update team scores
		updateScoresText();
	end

	function game:playClockMusic(speed)
		--audioManager:playClock(-1);
	end

	-- update the hud (scores, etc)
	function game:updateHUD()
		print("game : updateHUD");
		game.team1score.text = tostring(scoreKeeper.team1_score);
		game.team2score.text = tostring(scoreKeeper.team2_score);
	end

	-- next word click
	function game:nextWordClick(event)
		print("game : nextWordClick");

		--reset workd skips
		scoreKeeper.wordSkipsCurr = 0;

		--enable skip button?
		if (scoreKeeper.wordSkipsCurr < scoreKeeper.wordSkips) or (scoreKeeper.wordSkips==-1) then
			passButton.alpha = 1;
			passButton.onRelease = game.passClick
		end

		--firework
		--[[local explosion = require("particle_explosion").new();
		explosion.origin.x = math.random(0,display.contentWidth/2);
		explosion.origin.y = math.random(0,display.contentHeight);
		explosion.doFlash = false;
		explosion:startExplosion();]]--

		--flash screen
		local white_out = require("white_out").new();
		white_out:flash(200);

		--randomize current word
		game:randomizeWord();
		-- sound fx
		audioManager:playSound("next_word");
		--animate
		game.lcdBk:scale(1.5,1.5);
		game.gameWord:scale(2.5,2.5);
		game.gameWord.alpha = 0;
		transition.to(game.lcdBk,{xScale=1.0,yScale=1.0,time=200,transition=easing.outQuad});
		transition.to(game.gameWord,{xScale=1.0,yScale=1.0,alpha=1,time=140,transition=easing.outQuad});
	end

	-- next word click
	function game:passClick(event)
		print("game : passClick");

		--how many times has user clicked?

		scoreKeeper.wordSkipsCurr = scoreKeeper.wordSkipsCurr+1;

		--disable skip button
		if(scoreKeeper.wordSkipsCurr >= scoreKeeper.wordSkips) and (scoreKeeper.wordSkips~=-1) then
			passButton.alpha = 0.5;
			passButton.onRelease = nil;
		end

		--red flash screen
		local white_out = require("white_out").new();
		white_out:setColor(255,0,0);
		white_out:flash(200);

		--randomize current word
		game:randomizeWord();
		-- sound fx
		audioManager:playSound("pass");
		--animate
		game.lcdBk:scale(1.5,1.5);
		game.gameWord:scale(2.5,2.5);
		game.gameWord.alpha = 0;
		transition.to(game.lcdBk,{xScale=1.0,yScale=1.0,time=100,transition=easing.outQuad});
		transition.to(game.gameWord,{xScale=1.0,yScale=1.0,alpha=1,time=140,transition=easing.outQuad});
	end

	--randomize word
	function game:randomizeWord()
		--local rndWord = math.random(1,#global_categories.word_list);

		local word = global_categories:randomWord();

		print("game_screen : randomizeWord "..word);

		--randomize word
		game.gameWord.text = word;

--		print(string.len(word));

		if(string.len(word) > 20) then

			--show smaller text size of string length is greather than 20
			game.gameWord.size = 25 / display.contentScaleX;
		else

			-- otherwize, show normal text size
			game.gameWord.size = 35 / display.contentScaleX;
		end

		--save current word to score keeper
		scoreKeeper.current_word = word;
	end

	function game:pauseClick(event)

		print("game pause");

		game.gameTimer:stopTimer();
		game.gameWord.alpha = 0;
		game.pauseDialog:display(true);
	end

	function game:unpauseClick(event)

		print("game unpause");

		game.gameTimer:startTimer();
		game.gameWord.alpha = 1;
		game.pauseDialog:display(false);
	end

	function game:skipRound(event)

		print("skip round");

		scoreKeeper.wordSkipsCurr = 0;
		storyboard.gotoScene("score_screen","slideRight",200);
	end

	function game:restartRound(event)

		print("restart round");

		game.gameTimer.time = scoreKeeper.clock;
		game.gameTimer:startTimer();

		scoreKeeper.wordSkipsCurr = 0;
		--enable skip button?
		if (scoreKeeper.wordSkipsCurr < scoreKeeper.wordSkips) or (scoreKeeper.wordSkips==-1) then
			passButton.alpha = 1;
			passButton.onRelease = game.passClick
		end

		game.gameWord.alpha = 1;
		game:randomizeWord();
		game.pauseDialog:display(false);
	end

	--clock expired
	function game:clockExpired()
		print("game :: clockExpired");
		audioManager:playSound("round_over");
		--audioManager:stopClock();

		-- show times up screen
		game.timesup:fadeIn();

	end

	--update game
	function game:updateGame()
		print('game : updateGame');
		updateScoresText();
	end

	function game:destroy()
		print('game : destroy');
		game.gameTimer:destroy();
		game.pauseDialog:destroy();
	end

	return game;
end

