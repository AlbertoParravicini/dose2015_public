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
			v: INTEGER
			negascout_result: TUPLE[state: S; value: INTEGER]
			current_successors: LIST [S]
			best_state: S
			cut_done: BOOLEAN
			alfa: INTEGER
			beta: INTEGER
			negascout_score: INTEGER
		do
			best_state := a_state
			alfa := a_alfa
			beta := a_beta

			if problem.is_end (a_state) or current_max_depth = 0 then
				if a_state.is_max then
					Result := [a_state, problem.value (a_state)]
				else
					Result := [a_state, -problem.value (a_state)]
				end

			else
				v := problem.min_value
				cut_done := false

				from
					current_successors := problem.get_successors (a_state)
					current_successors.start
				until
					current_successors.exhausted or cut_done = true
				loop
					if current_successors.item /= current_successors.first then
						negascout_result := negascout (current_successors.item, current_max_depth - 1, -alfa - 1, -alfa)
						negascout_score := -negascout_result.value

						-- if alfa < score < beta
						if alfa < negascout_score and negascout_score < beta then
							negascout_result := negascout (current_successors.item, current_max_depth - 1, -beta, -negascout_score)
							negascout_score := -negascout_result.value
						end

					--else score := -pvs(child, depth-1, -beta, -alfa, -color)
					else
						negascout_result := negascout (current_successors.item, current_max_depth - 1, -beta, -alfa)
						negascout_score := -negascout_result.value
					end

					if negascout_score > alfa then
						alfa := negascout_score
						best_state := negascout_result.state
					end

					-- If alfa >= beta, cut the branch;
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
		ensure
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

end
