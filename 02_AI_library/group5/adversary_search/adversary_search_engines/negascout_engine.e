note
	description: "[
		Negascout adversary search engine. This is a generic implementation of negascout, that
		can be applied to any adversary search problem. The engine is parameterized with an adversary
		search problem, the adversary search state for the problem, and the rules associated with
		state change.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	NEGASCOUT_ENGINE [RULE -> ANY, reference S -> ADVERSARY_SEARCH_STATE [RULE], P -> ADVERSARY_SEARCH_PROBLEM [RULE, S]]

inherit

	ADVERSARY_SEARCH_ENGINE [RULE, S, P]

create
	make, make_with_depth

feature

	make (new_problem: P)
	-- Initialize the engine with a default depth value, equal to 6;
		require
			new_problem /= Void
		do
			problem := new_problem
			set_max_depth(default_depth)
			obtained_value := 0
			obtained_successor := void
			reset_engine
		ensure
			problem_set: problem /= void and then equal(problem, new_problem)
			default_depth_set: max_depth = default_depth
			search_not_performed: search_performed = false
			move_score_not_obtained: obtained_value = 0
			move_not_obtained: obtained_successor = void
		end

	make_with_depth (new_problem: P; new_max_depth: INTEGER)
	-- Initialize the engine with the provided depth value;
		require
			new_problem /= Void
		do
			problem := new_problem
			set_max_depth (new_max_depth)
			obtained_value := 0
			obtained_successor := void
			reset_engine
		ensure
			problem_set: problem /= void and then equal(problem, new_problem)
			new_depth_set: max_depth = new_max_depth
			search_not_performed: search_performed = false
			move_score_not_obtained: obtained_value = 0
			move_not_obtained: obtained_successor = void
		end


feature {NONE} -- Implementation function/routines

	negascout (a_state: S; current_max_depth: INTEGER; a_alfa: INTEGER; a_beta: INTEGER): TUPLE[state: S; value: INTEGER]
		local
			negascout_result: TUPLE[state: S; value: INTEGER]
			current_successors: LIST [S]
			best_state: S
			cut_done: BOOLEAN
			alfa: INTEGER
			beta: INTEGER
			negascout_score: INTEGER
		do
			-- Assume that the best state is the input state (the one passed as parameter);
			best_state := a_state
			-- Initialize the search window;
			alfa := a_alfa
			beta := a_beta

			-- If the input state is a terminal state, or if the maximum depth is reached,
			-- evaluate the score of the state.
			-- As this is a negamax algorithm, the score has to be evaluated from
			-- the point of view of the current player, assuming that
			-- the score for player_1 is the opposite of the score of player_2;
			if problem.is_end (a_state) or current_max_depth = 0 then
				if a_state.is_max then
					Result := [a_state, problem.value (a_state)]
				else
					Result := [a_state, -problem.value (a_state)]
				end

			else
				cut_done := false

				-- Go through the successors of the current state;
				from
					current_successors := problem.get_successors (a_state)
					current_successors.start
				until
					-- End the search if the list is over or if the branch has been pruned;
					current_successors.exhausted or cut_done = true
				loop
					-- If the current successor is not the first successor in the list:
					if current_successors.item /= current_successors.first then
						-- Search with a null window, as the first node is assumed to be the principal variation;
						negascout_result := negascout (current_successors.item, current_max_depth - 1, -alfa - 1, -alfa)
						negascout_score := -negascout_result.value

						-- if alfa < score < beta, it means that the proof failed (i.e. the first successor isn't the principal variation).
						-- Continue the search as a normal minimax with alfa-beta pruning;
						if alfa < negascout_score and negascout_score < beta then
							negascout_result := negascout (current_successors.item, current_max_depth - 1, -beta, -negascout_score)
							negascout_score := -negascout_result.value
						end

					-- If the current successor is the first successor in the list, evaluate it as a normal
					-- minimax with alfa-beta pruning. The algorithm will assume that this is the principal variation;
					else
						negascout_result := negascout (current_successors.item, current_max_depth - 1, -beta, -alfa)
						negascout_score := -negascout_result.value
					end

					-- If a new best state is found, mark it as the best_state;
					if negascout_score > alfa then
						alfa := negascout_score
						best_state := negascout_result.state
					end

					-- If alfa >= beta, prune the branch;
					if alfa >= beta then
						cut_done := true
					end
					current_successors.forth
				end
				Result := [best_state, alfa]
			end
		end

	find_next_move (a_state: S; initial_state: S): S
		-- Return the next move to perform by backtracking from
		-- the best state found by the algorithm;
		local
			current_state: S
		do
			if equal (a_state, initial_state) then
				Result := a_state
			else
				from
					current_state := a_state
				until
					equal (current_state.parent, initial_state)
				loop
					current_state := current_state.parent
				end
				Result := current_state
			end
		end

	default_depth: INTEGER
		-- Set the default depth of the algorithm;
		once
            Result := 6
        end

feature

	reset_engine
	-- Reset the engine so that a new search can be performed; the maximum depth and
	-- the problem which is resolved by the algorithm are left unchanged;
		do
			search_performed := false
			obtained_value := 0
			obtained_successor := void
		ensure then
			search_not_performed: search_performed = false
			move_score_not_obtained: obtained_value = 0
			move_not_obtained: obtained_successor = void
			routine_invariant: max_depth = old max_depth and equal(problem, old problem)
		end

	perform_search (initial_state: S)
	-- Perform the search of the next best available move by using a negascout
	-- (a.k.a. principal variation search) algorithm.
	-- It supposes the first node is in the principal variation (i.e. the most advantageous move),
	-- then, it checks whether that is true by searching the remaining nodes with a null window (alfa = beta).
	-- If the proof fails, then the first node was not in the principal variation, and the search continues as normal alpha-beta.
		local
			negascout_solution: TUPLE[state: S; value: INTEGER]
		do
			negascout_solution := negascout (initial_state, max_depth, problem.min_value, problem.max_value)
			obtained_successor := find_next_move(negascout_solution.state, initial_state)
			obtained_value := negascout_solution.value
			search_performed := true
		ensure then
			search_performed implies obtained_successor /= void
			obtained_value_is_consistent: problem.min_value <= obtained_value and obtained_value <= problem.max_value
		end

	set_max_depth (new_max_depth: INTEGER)
	-- Set the maximum depth of the algorithm,
	-- which is the sum of the number of moves performed
	-- by the two agents.
		do
			max_depth := new_max_depth
		ensure then
			max_depth_set: max_depth = new_max_depth
		end

	obtained_value: INTEGER
	-- The value (or score) associated to the principal variation,
	-- i.e. the most advantageous sequence of actions for the current agent.
	-- This value is obtained after performing the search;

	obtained_successor: S
	-- The node which identifies the next move to perform.
	-- It is the first node (except the current node) found by exploring
	-- the principal variation.
	-- This value is obtained after performing the search;

invariant
	consistent_result: search_performed implies obtained_successor /= void
	consistent_obtained_value: problem.min_value <= obtained_value and obtained_value <= problem.max_value
	consisten_max_depth: max_depth >= 0
end
