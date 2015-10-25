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
		require
			new_problem /= Void
		do
			set_max_depth(5)
			problem := new_problem
			reset_engine
		end

	make_with_depth (new_problem: P; new_max_depth: INTEGER)
		require
			new_problem /= Void
			new_max_depth > 0
		do
			problem := new_problem
			set_max_depth (new_max_depth)
			reset_engine
		end


feature {NONE} -- Implementation function/routines

	minimax (a_state: S; current_max_depth: INTEGER): TUPLE[state: S; value: INTEGER]
		local
			alfa: INTEGER
			minimax_result: TUPLE[state: S; value: INTEGER]
			current_successors: LIST [S]
			best_state: S
		do
			best_state := a_state
			if problem.is_end (a_state) or current_max_depth = 0 then
				Result := [a_state, problem.value (a_state)]
			elseif a_state.is_min then
				alfa := problem.max_value
				current_successors := problem.get_successors (a_state)
				across
					current_successors as curr_succ
				loop
					-- Keep the minimum value;
					minimax_result := minimax (curr_succ.item, current_max_depth - 1)
					if alfa > minimax_result.value then
						alfa := minimax_result.value
						best_state := minimax_result.state
					end
				end
				Result := [best_state, alfa]
			else
				alfa := problem.min_value
				current_successors := problem.get_successors (a_state)
				across
					current_successors as curr_succ
				loop
					-- Keep the maximum value;
					minimax_result := minimax (curr_succ.item, current_max_depth - 1)
					if alfa < minimax_result.value then
						alfa := minimax_result.value
						best_state := minimax_result.state
					end
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

feature

	reset_engine
		do
			search_performed := false
			obtained_successor := void
			obtained_value := 0
		end

	perform_search (initial_state: S)
		local
			current_successors: LIST [S]
			minimax_solution: TUPLE[state: S; value: INTEGER]
		do
			minimax_solution := minimax (initial_state, max_depth)
			obtained_successor := find_next_move(minimax_solution.state, initial_state)
			obtained_value := minimax_solution.value
			search_performed := true
		end

	set_max_depth (new_max_depth: INTEGER)
		do
			max_depth := new_max_depth
		end

	obtained_value: INTEGER

	obtained_successor: S

end
