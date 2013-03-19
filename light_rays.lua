module(...,package.seeall);

function new()

	local lightrays = {};

	-- light ray properties
	lightrays.numRays = 15;
	lightrays.blendMode = "add";

	lightrays.images = {};
	lightrays.scale = 0.4;
	lightrays.enabled = false;

	-- create our light rays
	function lightrays:create()
		--print("light_rays.lua :: create");

		lightrays.enabled = true;

		-- create group
		lightrays.group = display.newGroup(0,0,50,50);

		-- repeat animation for individual ray
		function reanimateRay(obj)
			--print("ligh_rays : repeatAnimation - "..obj.name);

			--reset object
			obj.alpha = math.random(0,100)/100*.5;
			obj.rotation = math.random(0,360)*1.0;

			local rotTo = math.random(0,360)*1.0;
			local randTime = math.random(1000,5000);
			local delayer = math.random(0,4000);

			if(lightrays.enabled == true) then
				transition.to(obj,{rotation = rotTo,time=randTime,alpha=0,onComplete=reanimateRay});
			end
		end

		for i=1,lightrays.numRays do

			local scaler = math.random(100,100)/100;
			local randImage = math.random(3,3);

			-- create lightray image
			lightrays.images[i] = display.newImage("assets/special_fx/light_rays/light_ray"..randImage..".jpg",0,0,300,300);
			-- set scale
			--lightrays.images[i].xScale = scaler;
			--lightrays.images[i].yScale = scaler;
			lightrays.images[i]:setReferencePoint(display.CenterReferencePoint);
			lightrays.images[i].blendMode = lightrays.blendMode;
			

			lightrays.images[i].alpha = math.random(0,100)/100*0.5;
			lightrays.images[i].rotation = math.random(0,360)*1.0;
			lightrays.images[i].name = "ray"..i;

			local rotTo = math.random(0,360)*1.0;
			local randTime = math.random(1000,5000);
			

			
			
			lightrays.group:insert(lightrays.images[i]);

			

			transition.to(lightrays.images[i],{rotation = rotTo,
											time=randTime,
											alpha=0,
											onComplete=reanimateRay});
		end

		lightrays.group:setReferencePoint(display.CenterReferencePoint);

		lightrays.group.xScale =  lightrays.scale;
		lightrays.group.yScale = lightrays.scale;
	end

	function lightrays:stopAnimating()
		--print('lightrays : stopAnimating');

		lightrays.enabled = false;
	end



	return lightrays;
end