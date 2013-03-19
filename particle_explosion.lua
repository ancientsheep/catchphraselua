module(...,package.seeall);

function new()
	local explosion = {};

	-- particle settinigs
	explosion.numParticles = 40;
	explosion.gravity = 0.50;
	explosion.force = 10;
	explosion.rotationForce = 60;
	explosion.friction = 0.99;
	explosion.doFlash = true;

	explosion.group = display.newGroup(0,0);
	explosion.group:setReferencePoint(display.CenterReferencePoint);

	explosion.origin = {};
	explosion.origin.x = display.contentWidth/2;
	explosion.origin.y = display.contentHeight/2;

	--create particles
	explosion.particles = {};

	function explosion:startExplosion()
		--flash screen
		if explosion.doFlash==true then
			local white_out = require("white_out").new();
			white_out.startAlpha = 0.5;
			white_out:flash(150);
		end


		for i=1,explosion.numParticles do
			local particle = {};
			particle.index = i;

			-- load random image
			local rndImage = math.random(1,3);

			particle.image = display.newImage("assets/particles/particle"..rndImage..".png");
		
			particle.image.x = explosion.origin.x;
			particle.image.y = explosion.origin.y;

			local scaler = math.random(0,100)/100*10+5;

			particle.image.width = scaler;
			particle.image.height = scaler;
			particle.image:setReferencePoint(display.CenterReferencePoint);
			--particle.image.blendMode = "add";
			--randomize speed
			particle.speed = {};
			particle.speed.x = math.random(-100,100)/100*explosion.force;
			particle.speed.y = math.random(-100,100)/100*explosion.force;


			particle.speed.rotation = math.random(-100,100)/100*explosion.rotationForce;
			explosion.particles[#explosion.particles+1]=particle;

			explosion.group:insert(explosion.particles[#explosion.particles].image);
		end

		explosion:startAnimating();

		-- play explosion sound
		local rndSnd = math.random(1,5);
		audioManager:playSound("firework"..rndSnd);
	end

	--animate particles
	function explosion:updateParticles(event)
        --- do stuff in here

        local numParticlesOut = 0;

        for i=1,#explosion.particles do
			local particle = explosion.particles[i];
			--print("updating particle: "..particle.index);
			-- apply gravity

			-- apply gravity
			particle.speed.x = particle.speed.x * explosion.friction;
			particle.speed.y = particle.speed.y + explosion.gravity;

			-- update position
			particle.image.x =particle.image.x + particle.speed.x;
			particle.image.y = particle.image.y + 0.1 + particle.speed.y;
			particle.image.rotation = particle.image.rotation + particle.speed.rotation;

			if(particle.image.y > display.contentHeight) then
				numParticlesOut = numParticlesOut + 1;
			end
		end

		-- end this particle system
		if(numParticlesOut == #explosion.particles) then
			explosion:endParticleSystem();
		end
	end

	function explosion:endParticleSystem()
		--print("particle_explosion : endParticleSystem");

		explosion:stopAnimating();

		-- remove all particles

		for i=1,#explosion.particles do
			local particle = explosion.particles[i];
			if(particle) then
				if(particle.image) then
					particle.image:removeSelf(); -- removeSelf is nil sometimes... why?
				end
			end
		end

		explosion.group:removeSelf();
	end

	function explosion:startAnimating()
		Runtime:addEventListener("enterFrame",explosion.updateParticles);
	end

	function explosion:stopAnimating()
		Runtime:removeEventListener("enterFrame",explosion.updateParticles);
	end

	

	return explosion;
end