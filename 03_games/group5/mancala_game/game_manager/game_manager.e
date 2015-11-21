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
			supported_algorithms: is_valid_algorithm(a_algorithm)

		do

			if false then

			end

		end

feature {NONE} -- Implementation

	is_valid_algorithm (a_algorithm: STRING): BOOLEAN
		require
			valid_algorthm: a_algorithm /= VOID and not a_algorithm.is_empty
		local
			l_valid_algorithms: ARRAYED_LIST[STRING]
			l_result: BOOLEAN
		do
			create l_valid_algorithms.make_from_array (<<"minimax","minimax_ab","negascout","two_players","bounded_breadth_first_search",
			"bounded_depth_first_search","depth_first_with_cycle_checking","heuristic_depth_first_search","iterative_deepening",
			"hill_climbing","steepest_ascent_hill_climbing","lowest_cost_first_search","best_first_search","a_star">>)

			from
				l_valid_algorithms.start
				l_result := false
			until
				l_result or l_valid_algorithms.exhausted
			loop
				if equal(l_valid_algorithms.item, a_algorithm) then
					l_result := true
				end
			end

			Result := l_result
		end

end
