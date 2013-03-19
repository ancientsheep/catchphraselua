-----------------------------------------------------------------------------------------
--
-- game_over_screen.lua
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget");
local fireworkTimer;
local explosion;
local pulse1,pulse2;

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

function backClick()
	print("game_over_screen :: backClick");

	storyboard.gotoScene("main_menu","slideRight",200);
end

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("game_over_screen :: createScene");

	local group = self.view

	-- main menu bk
	local bk  = display.newImageRect("assets/game_screen/game_bg.jpg",display.contentWidth,display.contentHeight);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	group:insert(bk);

	-- overlay
	local overlay  = display.newImageRect("assets/game_screen/bk_overlay.jpg",480,320);
	overlay:setReferencePoint(display.TopLeftReferencePoint);
	overlay.x,overlay.y = 0,0;
	overlay.blendMode = "multiply";
	group:insert(overlay);

	-- animated sun rays
	local rays = require("sun_rays").new();
	rays.sunRays.x = display.contentWidth/2;
	group:insert(rays.sunRays);

	-- team txt image
	local teamName  = display.newImageRect("assets/game_over_screen/team.png",150,23);
	teamName:setReferencePoint(display.TopCenterReferencePoint);
	teamName.x,teamName.y = display.contentWidth/2,44;
	group:insert(teamName);


	local winnerName = "";
	if(scoreKeeper.team1_score > scoreKeeper.team2_score) then
		winnerName = scoreKeeper.team1_name;
	else
		winnerName = scoreKeeper.team2_name;
	end

	-- team 2 score
	local team2score = display.newText(winnerName,50,20,"Soup of Justice",50);
	team2score:setTextColor(255,255,255);
	team2score:setReferencePoint(display.TopCenterReferencePoint);
	team2score.x,team2score.y=display.contentWidth/2,55;
	group:insert(team2score);


	-- wins
 	local wins  = display.newImageRect("assets/game_over_screen/wins.png",207,89);
	wins:setReferencePoint(display.TopCenterReferencePoint);
	wins.x,wins.y = display.contentWidth/2,110;
	group:insert(wins);

	-- wins pulse
	pulse1 = require("pulse").new(wins);
	pulse1.animTime = 500;
	pulse1.scaleTo = 1.1;
	pulse1:startPulse();



	-- team score bks
	-- team 1 bk
	local team1bk  = display.newImageRect("assets/score_screen/team1_bk.png",212,101);
	team1bk:setReferencePoint(display.BottomLeftReferencePoint);
	team1bk.x,team1bk.y = 0,display.contentHeight-10;
	group:insert(team1bk);

	-- team 2 bk
	local team2bk  = display.newImageRect("assets/score_screen/team2_bk.png",212,99);
	team2bk:setReferencePoint(display.BottomRightReferencePoint);
	team2bk.x,team2bk.y = display.contentWidth,display.contentHeight-10;
	group:insert(team2bk);

	-- team names
	-- team 1 name
	local team1name = display.newText(scoreKeeper.team1_name,50,20,"Soup of Justice",20);
	team1name:setTextColor(255,255,255);
	team1name:setReferencePoint(display.TopLeftReferencePoint);
	team1name.x,team1name.y=10,team1bk.y-90;
	group:insert(team1name);

	-- team 2 name
	local team2name = display.newText(scoreKeeper.team2_name,20,20,"Soup of Justice",20);
	team2name:setTextColor(255,255,255);
	team2name:setReferencePoint(display.TopRightReferencePoint);
	team2name.x,team2name.y=display.contentWidth-10,team2bk.y-90;
	group:insert(team2name);

	-- scores
	-- team 1 score
	local team1score = display.newText(scoreKeeper.team1_score,50,20,"Soup of Justice",50);
	team1score:setTextColor(255,255,255);
	team1score:setReferencePoint(display.TopLeftReferencePoint);
	team1score.x,team1score.y=20,team1bk.y-70;
	group:insert(team1score);

	-- team 2 score
	local team2score = display.newText(scoreKeeper.team2_score,50,20,"Soup of Justice",50);
	team2score:setTextColor(255,255,255);
	team2score:setReferencePoint(display.TopRightReferencePoint);
	team2score.x,team2score.y=display.contentWidth-10,team2bk.y-70;
	group:insert(team2score);


	--medal god rays
	-- add lightrays
	local lightrays = require("light_rays").new();
	lightrays.create();
	group:insert(lightrays.group);
	

	-- medal
	local medal  = display.newImageRect("assets/game_over_screen/medal.png",83,116);
	medal:setReferencePoint(display.CenterCenterReferencePoint);

	if(scoreKeeper.team1_score > scoreKeeper.team2_score) then
		medal.x,medal.y = 115,team1bk.y-80;
	else
		medal.x,medal.y = display.contentWidth-115,team2bk.y-80;
	end

	group:insert(medal);

	pulse2 = require("pulse").new(medal);
	pulse2:startPulse();

	lightrays.group.x = medal.x;
	lightrays.group.y = medal.y;

	--add navigation bar
	local navi = require("navi_bar").newBar();
	navi:setup(backClick,"Congratulations!");
	group:insert(navi.group);



	function createFirework(event)
		--print("createFirework");

		local rndTimer = math.random(700,3000);

		--explosions
		explosion = require("particle_explosion").new();
		explosion.origin.x = math.random(0,display.contentWidth);
		explosion.origin.y = math.random(0,display.contentHeight);
		explosion:startExplosion();
		--group:insert(explosion.group);

		--start fireworks
		fireworkTimer = timer.performWithDelay(math.random(0,rndTimer),createFirework);
	end

	--start fireworks
	fireworkTimer = timer.performWithDelay(math.random(0,300),createFirework);
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("options :: enterScene");

	local group = self.view
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.

	-- play audio
	audioManager:playMusic("music_victory.mp3",-1);
	audioManager.resumeMusicChannel();
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)

	--stop music
	audioManager.stopMusicChannel();
	print("game_over_screen :: exitScene");
	explosion:endParticleSystem();
	timer.cancel(fireworkTimer);

	pulse1:stopPulse();
	pulse2:stopPulse();

	storyboard.removeScene("game_over_scene");
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("game_over_screen :: destroyScene");
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




