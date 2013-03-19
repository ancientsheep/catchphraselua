module(...,package.seeall);

-- score keeper, game settings, state, etc

function new()
	local score_keeper = {};

	score_keeper.team1_score = 0;
	score_keeper.team2_score = 0;
	score_keeper.team1_name = "Team 1";
	score_keeper.team2_name = "Team 2";
	score_keeper.clock = 60;
	score_keeper.currRound = 1;
	score_keeper.playToText = "Points";
	score_keeper.wordSkips = -1;
	score_keeper.wordSkipsPenalty = 0;
	score_keeper.playTo = "1";
	score_keeper.current_word = "--";
	score_keeper.wordSkipsCurr = 0;
	--never resets
	score_keeper.gameMode = "";

	

	-- resets the score - do this for new game
	function score_keeper:reset()
		print("score_keeper : reset");
		score_keeper.team1_score = 0;
		score_keeper.team2_score = 0;
		score_keeper.currRound = 1;
		score_keeper.wordSkipsCurr = 0;
		score_keeper.playTo = "1";
		score_keeper.current_word = "--";
	end

	function score_keeper:incrementScore(team)
		print("scoreKeeper : incrementScore");

		if string.upper(team)=="TEAM1" then score_keeper.team1_score = score_keeper.team1_score+1;
		elseif string.upper(team)=="TEAM2" then score_keeper.team2_score = score_keeper.team2_score+1;
		end

		print("scoreKeeper : incrementScore team1: "..score_keeper.team1_score.." team2: "..score_keeper.team2_score);

		score_keeper:checkMinMax();
	end

	function score_keeper:decrementScore(team)
		print("scoreKeeper : decrementScore");

		if string.upper(team)=="TEAM1" then score_keeper.team1_score = score_keeper.team1_score-1;
		elseif string.upper(team)=="TEAM2" then score_keeper.team2_score = score_keeper.team2_score-1;
		end

		score_keeper:checkMinMax();
	end

	function score_keeper:checkMinMax()
		print("scoreKeeper : checkMinMax");

		-- set min score to 0
		if score_keeper.team1_score < 0 then score_keeper.team1_score = 0; end
		if score_keeper.team2_score < 0 then score_keeper.team2_score = 0; end
	end
	

	return score_keeper;
end