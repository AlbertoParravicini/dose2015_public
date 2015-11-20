note
	description: "Summary description for {GAME_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MANAGER

create
	make

feature {NONE} -- Creation

	make (a_algorithm: STRING)
			-- Creates a game manager based on the options chosen by the user;
			-- the game mode is implied by the choice of the algorithm;
			-- The game manager contains the main game loop, and a reference to the rules set and the current state;
			-- Th rules set contains the "problem" and the "ai_engine", which are instantiated based on the chosen algorithm;
		require
			valid_algorthm: a_algorithm /= VOID and not a_algorithm.is_empty
			supported_algorithms:
				equal(a_algorithm, "minimax") or
				equal(a_algorithm, "minimax_ab") or
				equal(a_algorithm, "negascout") or
				equal(a_algorithm, "two_players") or
				equal(a_algorithm, "df") or
				equal(a_algorithm, "bf") or
				equal(a_algorithm, "df_cycle_checking") or
				equal(a_algorithm, "a_star")
		do

			if false then

			end

		end

end
