module(...,package.seeall);

local storyboard = require("storyboard");
local scene = storyboard.newScene();
local widget = require("widget");
local facebook = require("facebook");

local appId  = '194041857401932'    -- Add  your App ID here
local apiKey = 'cb2be4582438986e8464766da6aa6f0c'   -- Not needed at this time


function new()
	print("facebook_manager : new()");
	local fb = {};

	-- create individual faebook button
	-- sexy factory function. hot damn i'm good!

	function fb:createFacebookButton()
		print("facebook_manager : createFBLoginButton");
		local fb_button = {};

		function fb_button:fb_click(evt)
			print("fb_button : fb_click");
			-- photo uploading requires the "publish_stream" permission
			facebook.login(appId,fb.fbListener,{"publish_stream"});
		end

		fb_button.button = widget.newButton{
				label="",
				defaultFile="assets/facebook/facebook_login.png",
				overFile="assets/facebook/facebook_login.png",
				width=178, height=31,
				onRelease = fb_button.fb_click
			}
		fb_button.button:setReferencePoint(display.BottomLeftReferencePoint);
		
		return fb_button;
	end

	-- facebook listener for all facebook events
	function fb:fbListener( event )
	    if event.isError then
	        native.showAlert("Facebook Error",event.response,{"Close"});
	    else
	    	native.showAlert("Facebook API","FACEBOOK LOGGED IN!!",{"Close"});

	        if event.type == "session" and event.phase == "login" then
	            -- login was a success; call function
	            onLoginSuccess()
	        
	        elseif event.type == "request" then
	            -- this block is executed upon successful facebook.request() call
	 
	            native.showAlert( "Success", "The photo has been uploaded.", { "OK" } )
	        end
	    end
	end


	return fb;
end