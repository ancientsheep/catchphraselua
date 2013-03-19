-----------------------------------------------------------------------------------------
--
-- game_mode_selection.lua - most important screen
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene();
local json = require("json");

-- include Corona's "widget" library
local widget = require("widget");

--max sliders
local sliderStartY = 45;
local slider1;
local slider2;
local slider3;
local slider4;
local slider5;

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

function backClick()
	print("game_options_screen :: backClick");

	storyboard.gotoScene("main_menu","slideRight",200);
end

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("game_options_screen :: createScene");

	as_analytics:logEvent("game_options_screen : createScene")

	local group = self.view;

	-- load our game mode settings
	local settings_playto = preference.getValue("playto");
	local settings_clockto = preference.getValue("clockto");
	
	if(settings_playto == nil) then settings_playto = 1; end
	if(settings_clockto == nil) then settings_clockto = 1; end
	-- finished loading game mode settings

	-- main menu bk
	local bk  = display.newImageRect("assets/game_options_screen/blue_bk.jpg",615,392);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	group:insert(bk);

	-- table bk
	local tableBk  = display.newImageRect("assets/game_options_screen/table_bk.jpg",237,392);
	tableBk:setReferencePoint(display.TopRightReferencePoint);
	tableBk.x,tableBk.y = display.contentWidth,0;
	group:insert(tableBk);

	-- animated sun rays
	local rays = require("sun_rays").new();
	rays.sunRays.x = 0;
	group:insert(rays.sunRays);


	if(scoreKeeper.gameMode == "team_hot") then
		setupTeamHotPotato(group);
	elseif(scoreKeeper.gameMode == "elim_hot") then
		setupElimHotPotato(group);
	elseif(scoreKeeper.gameMode == "high_score") then
		setupHighScore(group);
	elseif(scoreKeeper.gameMode == "party_mode") then
		setupPartyMode(group);
	end

	-- add our category pack list / table view
	local catList = require("category_table_view").new();
	group:insert(catList.list);

	--Play! button clicked
	function startGameClick()
		print("game_options_screen :: startGameClick");

		scoreKeeper:reset();

		-- reset word list
		global_categories.word_list = nil;
		global_categories.word_list = {};

		-- check number of categories selected
		if #catList.list.word_list == 0 then
			-- no categories selected, lets throw error
			local alert = native.showAlert("Whoops","You must select at least ONE category before you can play.", 
                                        { "Close"});
		else
			-- build our word list
			for i=1,#catList.list.word_list do
				local listToLoad = json.decode(catList.list.json_data[catList.list.word_list[i]]);
				print(" .. load word list "..listToLoad.url_title);

				-- load list
				local loadedList = require("categories").loadCategory(listToLoad.url_title);

				-- loop through an add words to word list
				for i=1,#loadedList.words do
					global_categories.word_list[#global_categories.word_list+1] = loadedList.words[i];
				end
			end

			print("Combined words for game! .. "..json.encode(combinedWords));

			-- grab our settings and pass / store them
			setupGameSettings();


			--set play to 
			--scoreKeeper.playTo = tonumber(slider1.currValue());
			--set amount of time + rand
			--scoreKeeper.clock = tonumber(slider2.currValue());

			-- save our game mode settings
			--preference.save({playto=slider1.currIndex});
			--preference.save({clockto=slider2.currIndex});

			--[[if(scoreKeeper.gameMode == "team_hot" or scoreKeeper.gameMode == "high_score") then
				print("Game mode requires team name");
				storyboard.gotoScene("game_teamnames_scene","slideLeft",200);
			else--]]
				storyboard.gotoScene("score_screen","slideLeft",200);
			--end
		end
	end

	-- play button
	local playButton = widget.newButton{
		label="",
		defaultFile="assets/game_options_screen/play_game_navi.png",
		overFile="assets/game_options_screen/play_game_navi.png",
		width=142, height=32,
		onRelease = startGameClick
	}
	playButton:setReferencePoint(display.TopRightReferencePoint);
	playButton.x = display.contentWidth-5;
	playButton.y = 3;
	
	--add navigation bar
	local navi = require("navi_bar").newBar();
	navi:setup(backClick,scoreKeeper.gameMode);
	group:insert(navi.group);

	--add play button over top of navigation
	group:insert(playButton);
end

function setupGameSettings()
	print("setupGameSettings");

	if(scoreKeeper.gameMode == "team_hot") then
		--play to count
		scoreKeeper.playTo = tonumber(slider1.currValue());
		scoreKeeper.playToText = slider2.currValue();
		scoreKeeper.clock = tonumber(slider3.currValue());
		scoreKeeper.wordSkips = tonumber(slider4.currValue());

	elseif(scoreKeeper.gameMode == "elim_hot") then
		scoreKeeper.clock = tonumber(slider1.currValue());
		scoreKeeper.wordSkips = tonumber(slider2.currValue());

	elseif(scoreKeeper.gameMode == "high_score") then
		--play to count
		scoreKeeper.playTo = tonumber(slider1.currValue());
		scoreKeeper.playToText = slider2.currValue();
		scoreKeeper.clock = tonumber(slider3.currValue());

		-- no skipping
		if(tonumber(slider4.currValue())==1) then
			-- prevent word skips
			scoreKeeper.wordSkips = 0;
		else
			scoreKeeper.wordSkipsPenalty = tonumber(slider4.currValue());
		end

	elseif(scoreKeeper.gameMode == "party_mode") then
		
	end
end


function setupTeamHotPotato(group)
	print("setupTeamHotPotato");

	-- play to
	slider1 = require("slider").new("Play to",{"1","2","3","4","5","6","7","8","9","10","11","12","13"},7);
	slider1.setup();
	slider1.group.x,slider1.group.y = display.contentWidth/4,sliderStartY;
	group:insert(slider1.group);

	-- rounds or points
	slider2 = require("slider").new("Rounds/Points",{"Rounds","Points"},1);
	slider2.setup();
	slider2.group.x,slider2.group.y = display.contentWidth/4,sliderStartY+slider1.spacing;
	group:insert(slider2.group);

	-- timer
	slider3 = require("slider").new("Timer",{"60","120","180","240"},2);
	slider3.setup();
	slider3.group.x,slider3.group.y = display.contentWidth/4,sliderStartY+slider1.spacing*2;
	group:insert(slider3.group);

	-- word skips
	slider4 = require("slider").new("Word Skips per Player",{"None","1","2","Infinite"},1,{"0","1","2","-1"});
	slider4.setup();
	slider4.group.x,slider4.group.y = display.contentWidth/4,sliderStartY+slider1.spacing*3;
	group:insert(slider4.group);
end

function setupElimHotPotato(group)
	print("setupElimHotPotato");

	-- timer
	slider1 = require("slider").new("Timer",{"60","120","180","240"},1);
	slider1.setup();
	slider1.group.x,slider1.group.y = display.contentWidth/4,sliderStartY;
	group:insert(slider1.group);

	-- rounds or points
	slider2 = require("slider").new("Word skips",{"0","1","2","Infinite"},1,{"0","1","2","-1"});
	slider2.setup();
	slider2.group.x,slider2.group.y = display.contentWidth/4,sliderStartY+slider1.spacing;
	group:insert(slider2.group);
end

function setupHighScore(group)
	print("setupHighScore");

	-- play to
	slider1 = require("slider").new("Play to",{"1","2","3","4","5","6","7","8","9","10","11","12","13"},1);
	slider1.setup();
	slider1.group.x,slider1.group.y = display.contentWidth/4,sliderStartY;
	group:insert(slider1.group);

	-- rounds or points
	slider2 = require("slider").new("Rounds/Points",{"Rounds","Points"},1,{"rounds","points"});
	slider2.setup();
	slider2.group.x,slider2.group.y = display.contentWidth/4,sliderStartY+slider1.spacing;
	group:insert(slider2.group);

	-- timer
	slider3 = require("slider").new("Timer",{"60","120","180","240"},1);
	slider3.setup();
	slider3.group.x,slider3.group.y = display.contentWidth/4,sliderStartY+slider1.spacing*2;
	group:insert(slider3.group);

	-- rounds or points
	slider4 = require("slider").new("Word skip penalty",{"No skipping","0","-1","-2","-3","-4"},1,{"1","0","-1","-2","-3","-4"});
	slider4.setup();
	slider4.group.x,slider4.group.y = display.contentWidth/4,sliderStartY+slider1.spacing*3;
	group:insert(slider4.group);
end

function setupPartyMode(group)
	print("setupPartyMode");


	-- timer
	slider1 = require("slider").new("Timer",{"None","60","120","180","240"},1,{"-1","60","120","180","240"});
	slider1.setup();
	slider1.group.x,slider1.group.y = display.contentWidth/4,sliderStartY;
	group:insert(slider1.group);

	-- word skips
	slider2 = require("slider").new("Word skips",{"None","1","2","Infinite"},1,{"0","1","2","-1"});
	slider2.setup();
	slider2.group.x,slider2.group.y = display.contentWidth/4,sliderStartY+slider1.spacing;
	group:insert(slider2.group);

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("game_options_screen :: enterScene");

	local group = self.view;

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view;

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("game_options_screen :: exitScene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("game_options_screen :: destroyScene");
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene




