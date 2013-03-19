module(...,package.seeall);

function new()
	local bubbles = {};

	-- particle settinigs
	bubbles.numParticles = 400;
	bubbles.force = 1;
	bubbles.rotationForce = 5;
	bubbles.group = display.newGroup(0,0);
	bubbles.group:setReferencePoint(display.TopLeftReferencePoint);

	bubbles.origin = {};
	bubbles.origin.x = 0;
	bubbles.origin.y = display.contentHeight/2;

	bubbles.emitterRate = 500;
	bubbles.emitterRateRandom = 200;

	--create particles
	bubbles.particles = {};

	--handle to add bubble timer
	bubbles.timer = nil;


	-- add bubble to emitter
	function bubbles:addBubble()
		--print("particles_bubbles : addBubble");

		local particle = {};
		particle.index = 1;

		-- load random image
		local rndImage = math.random(1,4);
		particle.image = display.newImage("assets/particles/speech_bubble.png");
	
		particle.image.x = bubbles.origin.x;
		particle.image.y = bubbles.origin.y;

		local scaler = math.random(50,100)/100;
		local opacity = math.random(0,100)/100;
		particle.image.alpha = opacity;

		particle.image.width = particle.image.width*scaler;
		particle.image.height = particle.image.height*scaler;
		particle.image:setReferencePoint(display.CenterReferencePoint);
		--particle.image.blendMode = "add";
		--randomize speed
		particle.speed = {};
		particle.speed.x = math.random(20,30)/30*bubbles.force;
		particle.speed.y = math.random(-100,100)/100*bubbles.force;

		particle.speed.rotation = math.random(-100,100)/100*bubbles.rotationForce;
		bubbles.particles[#bubbles.particles+1]=particle;

		bubbles.group:insert(bubbles.particles[#bubbles.particles].image);

	end

	-- generate the bubbles
	function bubbles:startEmitting()
		--start timer for adding bubbles
		timer.performWithDelay(500,bubbles.addBubble,0);
		bubbles:addBubble();
		bubbles:startAnimating();
	end

	--animate particles
	function bubbles:updateParticles(event)
        --- do stuff in here

        local numParticlesOut = 0;

        for i=1,#bubbles.particles do
			local particle = bubbles.particles[i];

			if(particle~=nil) then 
				--print("updating particle: "..particle.index);
				-- apply gravity

				-- apply gravity
				particle.speed.x = particle.speed.x;
				particle.speed.y = particle.speed.y;

				-- update position
				particle.image.x =particle.image.x + particle.speed.x;
				particle.image.y = particle.image.y + 0.1 + particle.speed.y;
				particle.image.rotation = particle.image.rotation + particle.speed.rotation;

				if particle.image.y > display.contentHeight+particle.image.height or particle.image.x > display.contentWidth+particle.image.width then
					--print("removed bubble - count "..#bubbles.particles);
					if(particle~=nil) then
						particle.image:removeSelf();
					end
					table.remove(bubbles.particles,i);
				end
			end
		end
	end

	function bubbles:endParticleSystem()
		print("particle_bubbles : endParticleSystem");

		bubbles:stopAnimating();

		-- remove all particles
		for i=1,#bubbles.particles do
			local particle = bubbles.particles[i];
			particle.image:removeSelf();
		end

		bubbles.group:removeSelf();
		timer.cancel(bubbles.timer);

		bubbles.particles = null;
	end

	function bubbles:startAnimating()
		print("particle_bubbles : startAnimating");
		Runtime:addEventListener("enterFrame",bubbles.updateParticles);
	end

	function bubbles:stopAnimating()
		print("particle_bubbles : stopAnimating");
		Runtime:removeEventListener("enterFrame",bubbles.updateParticles);
	end

	

	return bubbles;
end