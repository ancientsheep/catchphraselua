-----------------------------------------------------------------------------------------
--
-- splash_as.lua
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require("widget");
local tweener = require("as_tweeners");

local menuItems = {};
local fireworkTimer;
local fireworkCount;
local bubbles;
local fbButton;
local inAppNotification = require("in_app_notification").new();

--fps
local fps = require("fps").new();

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

--[[
MAIN MENU ITEM CLICK EVENTS --]]

function moreGamesClick(event)
	print("main_menu :: moreGamesClick");
	-- go to options scene
	storyboard.gotoScene("web_view_scene","slideLeft",200)
end

-- play clicked
function playClick(event)
	print("main_menu :: playClick");
	-- go to options scene
	--storyboard.gotoScene("game_mode_screen","slideLeft",200)

	--set our game mode
	scoreKeeper.gameMode = "team_hot";
	storyboard.gotoScene("game_teamnames_scene","slideLeft",200);
end

--options clicked
function optionsClick(event)
	print("main_menu :: optionsClick");
	-- go to options scene
	storyboard.gotoScene("options_screen","slideLeft",200)
end

-- how to play clicked
function howToPlayClick(event)
	print("main_menu :: howToPlayClick");
	-- go to options scene
	storyboard.gotoScene("how_to_play","slideLeft",200) 
end

-- how to play clicked
function downloadClick(event)
	print("main_menu :: downloadClick");
	-- go to options scene
	storyboard.gotoScene("downloads","slideLeft",200) 
end

-- more games clicked
function moreGamesClick(event)
	print("main_menu :: moreGamesClick");
	-- go to options scene
	storyboard.gotoScene("more_games_scene","slideLeft",200) 
end

-- Called when the scene's view does not exist:
function scene:createScene( event )

	print("main_menu :: createScene");

	as_analytics:logEvent("main_menu : createScene");

	local group = self.view

	-- main menu bk
	local bk  = display.newImageRect("assets/main_menu/main_menu_bk.jpg",2000,display.contentHeight);
	bk:setReferencePoint(display.TopLeftReferencePoint);
	bk.x,bk.y = 0,0;
	group:insert(bk);

	-- animated sun rays
	local rays = require("sun_rays").new();
	rays.sunRays.x = 0;
	group:insert(rays.sunRays);

	bubbles = require("particles_bubbles").new();
	bubbles.startEmitting();
	group:insert(bubbles.group);

	-- logo
	local logo  = display.newImageRect("assets/main_menu/logo.png",233,241);
	logo:setReferencePoint(display.CenterReferencePoint);
	logo.x,logo.y = logo.width/2+20,logo.height/2+10;
	group:insert(logo);

	--set sun rays to logo
	rays.sunRays.x = logo.x;
	rays.sunRays.y = logo.y;

	local pulseLogo = require("pulse").new(logo);
	pulseLogo.scaleTo = 1.05;
	pulseLogo.animTime = 2000;
	pulseLogo.startPulse();

	-- Insert play button
	local playButton = widget.newButton{
		label="",
		defaultFile="assets/main_menu/play.png",
		overFile="assets/main_menu/play.png",
		width=184, height=70,
		onRelease = playClick
	}
	playButton:setReferencePoint(display.TopRightReferencePoint);
	playButton.x = display.contentWidth - 30;
	playButton.y = 50;
	group:insert(playButton);

	-- Insert how to play buttons
	local howtoButton = widget.newButton{
		label="",
		defaultFile="assets/main_menu/howtoplay.png",
		overFile="assets/main_menu/howtoplay.png",
		width=196, height=57,
		onRelease = howToPlayClick
	}
	howtoButton:setReferencePoint(display.TopRightReferencePoint);
	howtoButton.x = display.contentWidth - 20;
	howtoButton.y = 106;
	group:insert(howtoButton);

	-- Insert download button
	local downloadButton = widget.newButton{
		label="",
		defaultFile="assets/main_menu/downloads.png",
		overFile="assets/main_menu/downloads.png",
		width=191, height=57,
		onRelease = downloadClick
	}
	downloadButton:setReferencePoint(display.TopRightReferencePoint);
	downloadButton.x = display.contentWidth - 20;
	downloadButton.y = 151;

	group:insert(downloadButton);

	-- more games
	local moreGames = widget.newButton{
		label="",
		defaultFile="assets/main_menu/more_games.png",
		overFile="assets/main_menu/more_games.png",
		width=191, height=57,
		onRelease = moreGamesClick
	}
	moreGames:setReferencePoint(display.TopRightReferencePoint);
	moreGames.x = display.contentWidth - 20;
	moreGames.y = 196;
	group:insert(moreGames);

	-- add our menu items to group
	menuItems.play = playButton;
	--menuItems.options = optionsButton;
	menuItems.howto = howtoButton;
	menuItems.downloads = downloadButton;
	menuItems.moreGames = moreGames;

	fbButton = fb:createFacebookButton();
	group:insert(fbButton.button);

	fbButton.button.x = 50;
	fbButton.button.y = display.contentHeight-80;

	--create ancientsheep website button
	local asWebsite = widget.newButton{
		label="",
		defaultFile="assets/main_menu/ancientsheep_website.png",
		overFile="assets/main_menu/ancientsheep_website.png",
		width=314, height=40,
		onRelease = downloadClick
	}
	asWebsite:setReferencePoint(display.TopRightReferencePoint);
	asWebsite.x = display.contentWidth;
	asWebsite.y = 0;

	group:insert(asWebsite);

	-- add fps
	group:insert(fps.group);

	--create audioButtons
	createFooter(group);

	--in app notification
	group:insert(inAppNotification.group);

	animateIn();

	-- add event to app rater
	local app_rater = require("as_rate_app").rateMe({
        android = "xxxxxxxx", 
        ios = "518069710" 
    });


	


	--local ad = require("as_ads").new();
	--ad:show();

	--light rays
	-- add lightrays
	--[[local lightrays = require("light_rays").new();
	lightrays.create();
	group:insert(lightrays.group);

	lightrays.group.x = display.contentWidth/2;
	lightrays.group.y = display.contentHeight/2;--]]

	--local pulser = require("pulse").new(bk);
	--pulser.startPulse();

	--testing white out


end

-- create audio button
function createFooter(group)
	print("main_menu : createAudioButtons");

	-- Insert music button
	local musicButton = widget.newButton{
		label="",
		defaultFile="assets/main_menu/music_on.png",
		overFile="assets/main_menu/music_on.png",
		width=45, height=53,
		onRelease = musicClick
	}
	musicButton:setReferencePoint(display.BottomRightReferencePoint);
	musicButton.x = display.contentWidth - 115;
	musicButton.y = display.contentHeight;
	group:insert(musicButton);

	-- Insert audio button
	local soundButton = widget.newButton{
		label="",
		defaultFile="assets/main_menu/sound_on.png",
		overFile="assets/main_menu/sound_on.png",
		width=45, height=53,
		onRelease = soundClick
	}
	soundButton:setReferencePoint(display.BottomRightReferencePoint);
	soundButton.x = display.contentWidth - 50;
	soundButton.y = display.contentHeight;
	group:insert(soundButton);

	menuItems.soundButton = soundButton;
	menuItems.musicButton = musicButton;

	--create footer background
	local footerBk  = display.newImageRect("assets/main_menu/footer_bk.png",253,43);
	footerBk:setReferencePoint(display.BottomRightReferencePoint);
	footerBk.x,footerBk.y = display.contentWidth,display.contentHeight;
	group:insert(footerBk);
end

-- update audio buttons
function updateAudioButton()
	print("main_menu : updateAudioButton");

	--music button graphics
	if audioManager.music_disabled == true then 
		menuItems.musicButton.defaultFile="assets/main_menu/music_off.png";
		menuItems.musicButton.overFile="assets/main_menu/music_off.png";
	else
		menuItems.musicButton.defaultFile="assets/main_menu/music_on.png";
		menuItems.musicButton.overFile="assets/main_menu/music_on.png";
	end

	--sound button graphics
	if audioManager.sfx_disabled == true then 
		menuItems.soundButton.defaultFile="assets/main_menu/sound_off.png";
		menuItems.soundButton.overFile="assets/main_menu/sound_off.png";
	else
		menuItems.soundButton.defaultFile="assets/main_menu/sound_off.png";
		menuItems.soundButton.overFile="assets/main_menu/sound_off.png";
	end

	-- save audio prefs
	audioManager:saveAudioPreferences();
end

function musicClick(event)
	print("main_menu : musicClick");
	if audioManager.music_disabled == true then 
		audioManager.music_disabled = false;
	else
		audioManager.music_disabled = true;
	end
	updateAudioButton();
end

function soundClick(event)
	print("main_menu : soundClick");
	if audioManager.sfx_disabled == true then 
		audioManager.sfx_disabled = false;
	else
		audioManager.sfx_disabled = true;
	end
	updateAudioButton();
end

--animate our menu items in (x1)
function animateIn()
	--animate our buttons in
	local initialDelay = 200;
	local animTime = 1000;
	local animDelayPerItem = 100;
	local animateXPos = display.contentWidth-20;
	local easing = tweener.easeOutBounce;

	-- play
	menuItems.play.x = display.contentWidth+menuItems.play.width;
	transition.to(menuItems.play,{time=animTime,x=animateXPos,delay=initialDelay+animDelayPerItem,transition=easing});


	-- how to play
	menuItems.howto.x = display.contentWidth+menuItems.howto.width;
	transition.to(menuItems.howto,{time=animTime,x=animateXPos,delay=initialDelay+animDelayPerItem*2,transition=easing});

	-- how to play
	menuItems.downloads.x = display.contentWidth+menuItems.downloads.width;
	transition.to(menuItems.downloads,{time=animTime,x=animateXPos,delay=initialDelay+animDelayPerItem*3,transition=easing});

	-- more games
	menuItems.moreGames.x = display.contentWidth+menuItems.downloads.width;
	transition.to(menuItems.moreGames,{time=animTime,x=animateXPos,delay=initialDelay+animDelayPerItem*4,transition=easing});

	-- music
	menuItems.musicButton.y = display.contentWidth+menuItems.musicButton.height;
	transition.to(menuItems.musicButton,{time=animTime,y=display.contentHeight,delay=initialDelay+animDelayPerItem*5,transition=easing});

	-- sound
	menuItems.soundButton.y = display.contentWidth+menuItems.soundButton.height;
	transition.to(menuItems.soundButton,{time=animTime,y=display.contentHeight,delay=initialDelay+animDelayPerItem*6,transition=easing});

	-- facebook
	fbButton.button.y = display.contentHeight+fbButton.button.height+40;
	transition.to(fbButton.button,{time=animTime,y=display.contentHeight-10,delay=initialDelay+animDelayPerItem*7,transition=easing});
end



function createFirework(event)
	--print("createFirework");

	--[[local rndTimer = math.random(500,2000);

	--test particles
	explosion = require("particle_explosion").new();
	explosion.origin.x = math.random(0,display.contentWidth);
	explosion.origin.y = math.random(0,display.contentHeight);
	explosion:startExplosion();
	--group:insert(explosion.group);--]]

	--start fireworks
	--fireworkTimer = timer.performWithDelay(rndTimer,createFirework);
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print("splash_as :: enterScene");

	storyboard.purgeAll();

	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-- play audio
	--audioManager:stopMusicChannel();
	--audioManager:playMusic("main_menu2.mp3",-1);
	--audioManager.resumeMusicChannel();

	--start fireworks
	fireworkTimer = timer.performWithDelay(math.random(1000,3000),createFirework);

	--check for notification
	inAppNotification:checkForNewNotification();

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	print("main_menu :: exitScene");

	-- stop timers
	timer.cancel(fireworkTimer);
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("main_menu :: destroyScene");
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




