-----------------------------------------------------------------------------------------
--
-- sun_rays.lua - most important screen
--
-----------------------------------------------------------------------------------------

module(...,package.seeall);

function new()

	local sun = {};
	
	--create the sun rays
	local sunRays = display.newGroup(0,0);




	-- create sun rays 
	sun.rays1 = display.newImageRect("assets/main_menu/sun_rays.png",1071,1072);
	sun.rays1:setReferencePoint(display.CenterReferencePoint);
	sun.rays1.x,sun.rays1.y = display.contentWidth/2,display.contentHeight/2;
	--game.group:insert(sunRays);
	sun.rays1.alpha = 0.2;
	sun.rays1.blendMode = "add";

	-- create sun rays 2 
	sun.rays2 = display.newImageRect("assets/main_menu/sun_rays.png",1071,1072);
	sun.rays2:setReferencePoint(display.CenterReferencePoint);
	sun.rays2.x,sun.rays2.y = display.contentWidth/2,display.contentHeight/2;
	--game.group:insert(sunRays);
	sun.rays2.alpha = 0.05;
	sun.rays2.blendMode = "add";

	sunRays:insert(sun.rays1);
	sunRays:insert(sun.rays2);

	-- return group
	sunRays:setReferencePoint(display.CenterReferencePoint);
	sun.sunRays = sunRays;

	-- loop to animate our sun rays in rotation over and over again
	function sun:animateRays()
		sun.rays1.rotation = 0;
		transition.to(sun.rays1,{time=30000,rotation=360,onComplete=sun.animateRays});
	end

	function sun:animateRays2()
		sun.rays2.rotation = 0;
		transition.to(sun.rays2,{time=50000,rotation=-360,onComplete=sun.animateRays2});
	end

	-- destroy and remove event isteners
	function sun:destroy()

	end

	sun:animateRays();
	sun:animateRays2();

	return sun;
end