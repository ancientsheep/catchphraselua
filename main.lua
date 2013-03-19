--start the profiler
--profiler = require "Profiler" --you should make these lines as the first 2 lines of code in main.lua
--profiler.startProfiler{mode = 4} --otherwise, profiler may not see all  your variables

--profiler.fullSnapshot(); 



-- push notification start
local launchArgs = ...
local json = require "json"

if launchArgs and launchArgs.notification then
    native.showAlert("launchArgs",json.encode(launchArgs.notification),{"OK"});
    --hmmmph
end

-- notification listener
local function onNotification(event)
    if event.type == "remoteRegistration" then
        native.showAlert("remoteRegistration",event.token,{"OK"});
    	-- hit url with the event.token
    elseif event.type == "remote" then
        native.showAlert("remote",json.encode(event),{"OK"});
        --entered app via notification
    end
end

Runtime:addEventListener("notification",onNotification);
-- push notification end



-- hide the status bar
display.setStatusBar(display.HiddenStatusBar);

-- start analytics
as_analytics = require("as_analytics").new();
as_analytics:startup();

-- ads
as_ads = require("as_ads").new();
as_ads:init();
as_ads:show();

-- load preferences
preference = require("preference");

--load facebook manager
fb = require("facebook_manager").new();

-- globals
audioManager = require("audio_manager").new();
audioManager:preloadSounds();
-- load our categories
global_categories = require("categories").loadAll();
--local tester = require("categories").testDB();

-- score keper
scoreKeeper = require("score_keeper").new();

-- store
as_store = require("as_store").init();

-- is this the lite version?
isLiteVersion = true;


--ios text height fix, probably very kludged
textOffsetFix = {};
textOffsetFix.use = false;
function textOffsetFix:offset(distance) --return the input if running on iOS, otherwise return 0
	if(textOffsetFix.use) then
		return distance
	end
	return 0;
end
if( string.sub( system.getInfo("model"), 1, 2 ) == "iP" ) then textOffsetFix.use = true; end -- if the model starts with 'iP' as in 'iPod', 'iPad', or 'iPhone', it must be iOS


--seed random num generator
math.randomseed(os.time());

-- include the Corona "storyboard" module
local storyboard = require("storyboard");

-- load splash screen
--storyboard.gotoScene("splash_as");

--jump right into main menu for rapid protyping. comment out for final build
storyboard.gotoScene("main_menu");
--profiler.fullSnapshot(); 

--storyboard.gotoScene("game_screen","fade",1000);
