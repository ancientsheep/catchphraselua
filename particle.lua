module(...,package.seeall);

local gravity = 0.1;

function new()
	print("particle : new");

	particle = {};

	particle.index = 0;
	particle.x = 0;
	particle.y = 0;
	particle.speed = 0;

	particle.image = display.newImage("assets/particles/particle2.png",20,20);
	particle.image:setReferencePoint(display.CenterReferencePoint);

	function particle:update()
		particle.x = particle.x + particle.speed;
		particle.y = particle.y + particle.speed + gravity;

		particle.image.x = particle.x;
		particle.image.y = particle.y;
	end

	return particle;
end