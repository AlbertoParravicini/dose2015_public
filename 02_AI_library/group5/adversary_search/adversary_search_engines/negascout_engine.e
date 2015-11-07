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
			set_max_depth (default_depth)
			obtained_value := 0
			obtained_successor := void
			start_from_best := true
			order_moves := false
			reset_engine
		ensure
			problem_set: problem /= void and then equal (problem, new_problem)
			default_depth_set: max_depth = default_depth
			search_not_performed: search_performed = false
			move_score_not_obtained: obtained_value = 0
			move_not_obtained: obtained_successor = void
			start_from_best_true: start_from_best = true
			order_moves_false: order_moves = false
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
			start_from_best := true
			order_moves := false
			reset_engine
		ensure
			problem_set: problem /= void and then equal (problem, new_problem)
			new_depth_set: max_depth = new_max_depth
			search_not_performed: search_performed = false
			move_score_not_obtained: obtained_value = 0
			move_not_obtained: obtained_successor = void
			start_from_best_true: start_from_best = true
			order_moves_false: order_moves = false
		end

feature {NONE} -- Implementation function/routines

	negascout (a_state: S; current_max_depth: INTEGER; a_alfa: INTEGER; a_beta: INTEGER): TUPLE [state: S; value: INTEGER]
		local
			negascout_result: TUPLE [state: S; value: INTEGER]
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
					Result := [a_state, - problem.value (a_state)]
				end
			else
				cut_done := false

					-- Go through the successors of the current state;
				from
					current_successors := problem.get_successors (a_state)

						-- Optionally, pick the best state as the presumed principal variation or
						-- order the successors based on their heuristic value;
					if start_from_best = true then
						pick_best (current_successors)
					elseif order_moves = true then
						current_successors := merge_sort (current_successors)
					end
					current_successors.start
				until
						-- End the search if the list is over or if the branch has been pruned;
					current_successors.exhausted or cut_done = true
				loop
						-- If the current successor is not the first successor in the list:
					if current_successors.item /= current_successors.first then
							-- Search with a null window, as the first node is assumed to be the principal variation;
						negascout_result := negascout (current_successors.item, current_max_depth - 1, - alfa - 1, - alfa)
						negascout_score := - negascout_result.value

							-- if alfa < score < beta, it means that the proof failed (i.e. the first successor isn't the principal variation).
							-- Continue the search as a normal minimax with alfa-beta pruning;
						if alfa < negascout_score and negascout_score < beta then
							negascout_result := negascout (current_successors.item, current_max_depth - 1, - beta, - negascout_score)
							negascout_score := - negascout_result.value
						end

							-- If the current successor is the first successor in the list, evaluate it as a normal
							-- minimax with alfa-beta pruning. The algorithm will assume that this is the principal variation;
					else
						negascout_result := negascout (current_successors.item, current_max_depth - 1, - beta, - alfa)
						negascout_score := - negascout_result.value
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
		ensure then
			routine_invariant: max_depth = old max_depth and equal (problem, old problem) and old order_moves = order_moves and old start_from_best = start_from_best
		end

	find_next_move (a_state: S; initial_state: S): S
			-- Return the next move to perform by backtracking from
			-- the best state found by the algorithm;
		require
			last_state_not_void: a_state /= void
			initial_state_not_void: initial_state /= void
		local
			current_state: S
		do
				-- What if the initial state of the game is already an ending state?
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
		ensure
			routine_invariant: max_depth = old max_depth and equal (problem, old problem) and old order_moves = order_moves and old start_from_best = start_from_best
			result_is_consistent: not equal (a_state, initial_state) implies equal (initial_state, Result.parent)
		end

	default_depth: INTEGER
			-- Set the default depth of the algorithm;
		once
			Result := 6
		end

	pick_best (a_list: LIST [S])
		-- Put the best item contained in the list (i.e. the one with highest heuristic value)
		-- as the first element of the list; this approach is faster than ordering the entire list,
		-- and in some cases provides even better results in terms of number of visited states;
		require
			a_list /= void
		local
			best_value: INTEGER
			best_state: S
			best_state_pos: INTEGER
		do
			from
				a_list.start
				if not a_list.is_empty then
					best_value := problem.value (a_list.first)
					best_state := a_list.first
					best_state_pos := 1
					a_list.forth
				end
			until
				a_list.exhausted
			loop
				if problem.value (a_list.item) > best_value then
					best_value := problem.value (a_list.item)
					best_state := a_list.item
					best_state_pos := a_list.index
				end
				a_list.forth
			end
			if not a_list.is_empty then
				a_list.go_i_th (best_state_pos)
				a_list.swap (1)
			end
		ensure
			size_not_changed: old a_list.count = a_list.count
			routine_invariant: max_depth = old max_depth and equal (problem, old problem) and old order_moves = order_moves and old start_from_best = start_from_best
		end

	merge_sort (a_list: LIST [S]): LIST [S]
			-- Order the successors based on their heuristic value, in descending order:
			-- the first element has the highest value, meaning that it is a better state for the
			-- maximizing player; with a complexity of theta(b*logb), the merge sort
			-- might be sightly slower than other algorithms (e.g the insertion sort)
			-- under specific circumstances (e.g a partially ordered list);
			-- against a problem with an high branching factor "b", the merge sort
			-- generally yelds better results, though;
		require
			a_list_not_void: a_list /= void
		local
			left: LIST [S]
			right: LIST [S]
			middle: INTEGER
		do
			if a_list.count <= 1 then
				Result := a_list
			else
				middle := a_list.count // 2
				a_list.start
				left := a_list.duplicate (middle)
				a_list.go_i_th (middle + 1)
				right := a_list.duplicate (a_list.count - middle)
				left := merge_sort (left)
				right := merge_sort (right)
				Result := merge (left, right)
			end
		ensure
			result_not_void: Result /= void
			result_size_consistent: Result.count = a_list.count
			list_item_not_modified: across Result as curr_state all a_list.has (curr_state.item) end
			routine_invariant: max_depth = old max_depth and equal (problem, old problem) and old order_moves = order_moves and old start_from_best = start_from_best
		end

	merge (left: LIST [S]; right: LIST [S]): LIST [S]
			-- Routine used as part of the merge sort algorithm:
			-- the two lists passed as parameter are merged in a way
			-- that the resulting list is in descending order;
		require
			left_not_void: left /= void
			right_not_void: right /= void
		local
			ordered_list: LINKED_LIST [S]
			left_curr_value: INTEGER
			right_curr_value: INTEGER
		do
			from
				create ordered_list.make
				left.start
				right.start
					-- Saving the current values leads to a small but not negligible optimization,
					-- at the expense of lower code readability;
				left_curr_value := problem.value (left.first)
				right_curr_value := problem.value (right.first)
			until
				left.is_empty or right.is_empty
			loop
				if left_curr_value >= right_curr_value then
					ordered_list.extend (left.first)
					left.remove
					if not left.is_empty then
						left_curr_value := problem.value (left.first)
					end
				else
					ordered_list.extend (right.first)
					right.remove
					if not right.is_empty then
						right_curr_value := problem.value (right.first)
					end
				end
			end

				-- Either left or right may have elements left;
			from
				left.start
			until
				left.is_empty
			loop
				ordered_list.extend (left.first)
				left.remove
			end
			from
				right.start
			until
				right.is_empty
			loop
				ordered_list.extend (right.first)
				right.remove
			end
			Result := ordered_list
		ensure
			result_size_is_consistent: Result /= void and then Result.count = old (left.count) + old (right.count)
			routine_invariant: max_depth = old max_depth and equal (problem, old problem) and old order_moves = order_moves and old start_from_best = start_from_best
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
			routine_invariant: max_depth = old max_depth and equal (problem, old problem) and old order_moves = order_moves and old start_from_best = start_from_best
		end

	perform_search (initial_state: S)
			-- Perform the search of the next best available move by using a negascout
			-- (a.k.a. principal variation search) algorithm.
			-- It supposes the first node is in the principal variation (i.e. the most advantageous move),
			-- then, it checks whether that is true by searching the remaining nodes with a null window (alfa = beta).
			-- If the proof fails, then the first node was not in the principal variation, and the search continues as normal alpha-beta.
		local
			negascout_solution: TUPLE [state: S; value: INTEGER]
			current_successors: LIST [S]
			random_number_generator: RANDOM
				-- Random numbers generator to have a stochastic move choice, if the maximum depth is set to 0;
			time_seed_for_random_generator: TIME
			-- Time variable in order to get new random numbers from random numbers generator every time the program runs.

		do
			if max_depth = 0 then
				create time_seed_for_random_generator.make_now
					-- Initializes random generator using current time seed.
				create random_number_generator.set_seed (((time_seed_for_random_generator.hour * 60 + time_seed_for_random_generator.minute) * 60 + time_seed_for_random_generator.second) * 1000 + time_seed_for_random_generator.milli_second)
				random_number_generator.start

					-- Select a random move from the successors of the current state;
				current_successors := problem.get_successors (initial_state)
				obtained_successor := current_successors.at ((random_number_generator.item \\ current_successors.count) + 1)
				obtained_value := problem.value (obtained_successor)
			else
					-- If max_depth > 0, perform a real negascout search;
				negascout_solution := negascout (initial_state, max_depth, problem.min_value, problem.max_value)
				obtained_successor := find_next_move (negascout_solution.state, initial_state)
				obtained_value := negascout_solution.value
			end
			search_performed := true
		ensure then
			search_performed implies obtained_successor /= void
			obtained_value_is_consistent: problem.min_value <= obtained_value and obtained_value <= problem.max_value
			routine_invariant: max_depth = old max_depth and equal (problem, old problem) and old order_moves = order_moves and old start_from_best = start_from_best
		end

feature -- Status setting

	set_max_depth (new_max_depth: INTEGER)
			-- Set the maximum depth of the algorithm,
			-- which is the sum of the number of moves performed
			-- by the two agents;
		do
			max_depth := new_max_depth
		ensure then
			max_depth_set: max_depth = new_max_depth
			routine_invariant: equal (problem, old problem) and old order_moves = order_moves and old start_from_best = start_from_best
		end

	set_order_moves (choice: BOOLEAN)
			-- Set whether to order the successors or not;
		do
			order_moves := choice
		ensure
			order_moves_set: order_moves = choice
			routine_invariant: equal (problem, old problem) and old max_depth = max_depth and old start_from_best = start_from_best
		end

	set_start_from_best (choice: BOOLEAN)
			-- Set the value of the "start_from_best" parameter.
			-- When the successors of a state are calculated, pick the best state (in term of heuristic value)
			-- as the presumed principal variation; this on average can reduce the number of visited states
			-- and the overall computation time, especially with high search depth;
		do
			start_from_best := choice
		ensure
			order_moves_set: order_moves = choice
			routine_invariant: equal (problem, old problem) and old max_depth = max_depth and old order_moves = order_moves
		end

feature -- Status report

	obtained_value: INTEGER
			-- The value (or score) associated to the principal variation,
			-- i.e. the most advantageous sequence of actions for the current agent.
			-- This value is obtained after performing the search;

	obtained_successor: S
			-- The node which identifies the next move to perform.
			-- It is the first node (except the current node) found by exploring
			-- the principal variation.
			-- This value is obtained after performing the search;

	order_moves: BOOLEAN
			-- The value holds whether the successors of a given states are ordered
			-- or not before being expanded; ordering the successors leads on average to a lower number of
			-- visited states, as it is more probable that the real principal variation is
			-- among the first successors in the list;
			-- if both "start_from_best" and "order_moves" are set to true,
			-- "start_from_best" is the only one considered;

	start_from_best: BOOLEAN
			-- When the successors of a state are calculated, pick the best state (in term of heuristic value)
			-- as the presumed principal variation; this on average can reduce the number of visited states
			-- and the overall computation time, especially with high search depth;
			-- if both "start_from_best" and "order_moves" are set to true,
			-- "start_from_best" is the only one considered;

invariant
	consistent_result: search_performed implies obtained_successor /= void
	consistent_obtained_value: problem.min_value <= obtained_value and obtained_value <= problem.max_value
	consisten_max_depth: max_depth >= 0
end
