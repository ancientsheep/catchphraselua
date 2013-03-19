module(...,package.seeall);

function new()
	print("audio_manager :: new");

	audioman = {};
	audioman.musicChannel = nil;
	audioman.sfxChannel = nil;
	audioman.clockChannel = nil;
	audioman.sfx_disabled = false;
	audioman.music_disabled = false;

	--sound effects
	audioman.piece_selected = nil;

	--load the audio preferences
	function audioman:loadAudioPreferences()
		print("audioman : oadAudioPreferences");
		preference.printAll();	-- print all preferences DELETE ME

		-- get value from preferences
		audioman.music_disabled = preference.getValue("music_disabled");
		audioman.sfx_disabled = preference.getValue("sfx_disabled");

		-- set default value in case no value is set
		if audioman.music_disabled==nil then audioman.music_disabled=false; end
		if audioman.sfx_disabled==nil then audioman.sfx_disabled=false; end

		audioman.music_disabled=true;

		--print("music : "..audioman.music_disabled.." sfx: "..audioman.sfx_disabled);
	end

	-- load preferences on startup
	audioman:loadAudioPreferences();

	--saves audio preferences
	function audioman:saveAudioPreferences()
		print("audioman : saveAudioPreferences");
		preference.printAll();	-- print all preferences DELETE ME

		preference.save({music_disabled=audioman.music_disabled,
						 sfx_disabled=audioman.sfx_disabled
						 });
	end

	function audioman:setMusicEnabled(enabled)
		-- save settings to disc
		preference.save({music_disabled=enabled});
		preference:printAll();
	end

	-- pause the music
	function audioman:stopMusicChannel()
		print("stopMusicChannel");

		audio.pause(audioman.musicChannel);
		audioman.setMusicEnabled(false);
		--audioman.music_disabled = true;
	end

	-- resume the music channel
	function audioman:resumeMusicChannel()
		print("resumeMusicChannel");
		audio.resume(audioman.musicChannel);
		audioman.setMusicEnabled(true);
		--audioman.music_disabled = false;
	end

	--load audio preferences
	audioman:loadAudioPreferences();

	--preload small sound effects
	function audioman:preloadSounds()
		print("audioman : preloadSounds");
		audioman.next_word = audio.loadSound("assets/audio/next_word.mp3");
		audioman.score_inc = audio.loadSound("assets/audio/score_inc.mp3");
		audioman.pass = audio.loadSound("assets/audio/pass.mp3");
		audioman.clock_1 = audio.loadSound("assets/audio/ping.wav");
		audioman.round_over = audio.loadSound("assets/audio/round_over.mp3");
		audioman.firework1 = audio.loadSound("assets/audio/firework_1.mp3");
		audioman.firework2 = audio.loadSound("assets/audio/firework_2.mp3");
		audioman.firework3 = audio.loadSound("assets/audio/firework_3.mp3");
		audioman.firework4 = audio.loadSound("assets/audio/firework_4.wav");
		audioman.firework5 = audio.loadSound("assets/audio/firework_5.wav");
		audioman.alert1 = audio.loadSound("assets/audio/alert_1.mp3");
		audioman.alert2 = audio.loadSound("assets/audio/alert_2.mp3");
	end

	function audioman:playMusic(file,loops)
		print("audio_manager:playMusic - "..file);
		print("audioman.music_disabled = "..tostring(audioman.music_disabled));

		--if audioman.music_disabled==false then
			--bgMusic = audio.loadStream("assets/audio/"..file);
			--audioman.musicChannel = audio.play(bgMusic,{
													--loops=loops,
													--fadein=0});
		--end
	end

	function audioman:playClock(loops)
		print("audio_manager:playClock");

		audioman.clockChannel = audio.play(audioman.clock_1, {loops = -1});
	end

	function audioman:stopClock()
		print("audio_manager:stopClock");

		audio.stop(audioman.clockChannel);
	end

	function audioman:playSound(snd)
		--print("audio_manager:playSound - "..snd);


		if snd=="next_word" then
			print("playing next_word.mp3");
			audioman.sfxChannel = audio.play(audioman.next_word);

		elseif snd=="score_inc" then
			print("playing score_inc.mp3");
			audioman.sfxChannel = audio.play(audioman.score_inc);

		elseif snd=="pass" then
			print("playing pass.mp3");
			audioman.sfxChannel = audio.play(audioman.pass);

		elseif snd=="clock_tick" then audio.play(audioman.clock_1);

		elseif snd=="round_over" then
			print("playing round_over.wav");
			audioman.sfxChannel = audio.play(audioman.round_over);

		elseif snd=="firework1" then
			--print("playing firework_1.mp3");
			audioman.sfxChannel = audio.play(audioman.firework1);

		elseif snd=="firework2" then
			--print("playing firework_2.mp3");
			audioman.sfxChannel = audio.play(audioman.firework2);

		elseif snd=="firework3" then
			--print("playing firework_3.mp3");
			audioman.sfxChannel = audio.play(audioman.firework3);

		elseif snd=="firework4" then
			--print("playing firework_4.wav");
			audioman.sfxChannel = audio.play(audioman.firework4);

		elseif snd=="firework5" then
			--print("playing firework_5.wav");
			audioman.sfxChannel = audio.play(audioman.firework5);

		elseif snd=="alert1" then
			--print("playing firework_5.wav");
			audioman.sfxChannel = audio.play(audioman.alert1);

		elseif snd=="alert2" then
			--print("playing firework_5.wav");
			audioman.sfxChannel = audio.play(audioman.alert2);
		end
	end

	return audioman;

end
