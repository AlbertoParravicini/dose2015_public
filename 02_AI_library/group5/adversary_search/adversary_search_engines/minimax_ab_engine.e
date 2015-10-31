note
	description: "[
		Minimax adversary search engine, with alpha-beta pruning. This is a generic implementation of
		minimax alpha-beta, that can be applied to any adversary search problem. The engine is 
		parameterized with an adversary search problem, the adversary search state for the problem, 
		and the rules associated with state change.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	MINIMAX_AB_ENGINE [RULE -> ANY, reference S -> ADVERSARY_SEARCH_STATE [RULE], P -> ADVERSARY_SEARCH_PROBLEM [RULE, S]]

inherit

	ADVERSARY_SEARCH_ENGINE [RULE, S, P]

create
	make, make_with_depth

feature

	make (new_problem: P)
			-- Constructor of the class. It initialises a
			-- MINIMAX_AB_ENGINE with a problem
		require
			new_problem /= Void
		do
			set_problem (new_problem)
			set_max_depth (default_max_depth)
			search_performed := False
			obtained_successor := void
		ensure
			problem_set: problem /= void and then equal (problem, new_problem)
			default_depth_set: max_depth = default_max_depth
			search_not_performed: search_performed = false
		end

	make_with_depth (new_problem: P; new_max_depth: INTEGER)
			-- Constructor of the class. It initialises a
			-- MINIMAX_AB_ENGINE with a problem and maximum depth
		require
			new_problem /= Void
			new_max_depth >= 0
		do
			set_problem (new_problem)
			set_max_depth (new_max_depth)
			search_performed := False
			obtained_successor := void
		ensure
			problem_set: problem /= void and then equal (problem, new_problem)
			default_depth_set: max_depth = new_max_depth
			search_not_performed: search_performed = false
		end

feature -- Search execution

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			search_performed := False
			obtained_successor := void
			obtained_value := 0
		ensure then
			search_not_performed: search_performed = false
			move_score_not_obtained: obtained_value = 0
			move_not_obtained: obtained_successor = void
			routine_invariant: max_depth = old max_depth and equal (problem, old problem)
		end

	perform_search (initial_state: S)
			-- Starts the search using a min-max search strategy
			-- If initial_state is max, result is succesor with max value
			-- If initial_state is min, result is succesor with min value
			-- The state result of the search is returned in obtained_successor
		local
			current_successors: LIST [S]
			value_to_compare: INTEGER
			random_number_generator: RANDOM
				-- Random numbers generator to have a stochastic move choice;
			time_seed_for_random_generator: TIME
			-- Time variable in order to get new random numbers from random
			-- numbers generator every time the program runs.
		do
			current_successors := problem.get_successors (initial_state)
			create time_seed_for_random_generator.make_now
				-- Initializes random generator using current time seed.
			create random_number_generator.set_seed (((time_seed_for_random_generator.hour * 60 + time_seed_for_random_generator.minute) * 60 + time_seed_for_random_generator.second) * 1000 + time_seed_for_random_generator.milli_second)
			random_number_generator.start
			if max_depth = 0 then
					-- Select a random move from the successors of the current state;
				obtained_successor := current_successors.at ((random_number_generator.item \\ current_successors.count) + 1)
				obtained_value := problem.value (obtained_successor)
			else
				if not current_successors.is_empty then
					from
						current_successors.start
						obtained_successor := current_successors.item
						obtained_value := compute_value (obtained_successor, 1, problem.min_value, problem.max_value)
						current_successors.forth
					until
						current_successors.exhausted
					loop
						value_to_compare := compute_value (current_successors.item, 1, problem.min_value, problem.max_value)
						if initial_state.is_max then
							if (value_to_compare > obtained_value) then
								obtained_successor := current_successors.item
								obtained_value := value_to_compare
							end
						else
							if (value_to_compare < obtained_value) then
								obtained_successor := current_successors.item
								obtained_value := value_to_compare
							end
						end
						if value_to_compare = obtained_value and (random_number_generator.item \\ 2) = 1 then
								-- If the values are equal, the same successor is maintained with a 50% chance
							obtained_successor := current_successors.item
							obtained_value := value_to_compare
						end
						current_successors.forth
					end
				end
			end
			search_performed := True
		ensure then
			search_performed implies obtained_successor /= void
			obtained_value_is_consistent: problem.min_value <= obtained_value and obtained_value <= problem.max_value
			routine_invariant: max_depth = old max_depth and equal (problem, old problem)
		end

feature {NONE} -- Implementative routines

	compute_value (initial_state: S; current_depth: INTEGER; a: INTEGER; b: INTEGER): INTEGER
			-- Return the value of the state applying the algorithm min-max alpha beta pruning
		require
			valid_parameter_state: initial_state /= Void
			valid_parameter_depth: current_depth >= 0 and current_depth <= max_depth
		local
			alpha_value: INTEGER
			beta_value: INTEGER
			computed_value: INTEGER
			current_successors: LIST [S]
		do
			if (problem.is_end (initial_state) or current_depth >= max_depth) then
				Result := problem.value (initial_state)
			else
				alpha_value := a
				beta_value := b
				current_successors := problem.get_successors (initial_state)
				if initial_state.is_max then
					from
						current_successors.start
					until
						current_successors.exhausted or beta_value <= alpha_value
					loop
						computed_value := (compute_value (current_successors.item, current_depth + 1, alpha_value, beta_value))
						alpha_value := alpha_value.max (computed_value)
						current_successors.forth
					end
					Result := alpha_value
				else
					from
						current_successors.start
					until
						current_successors.exhausted or beta_value <= alpha_value
					loop
						computed_value := (compute_value (current_successors.item, current_depth + 1, alpha_value, beta_value))
						beta_value := beta_value.min (computed_value)
						current_successors.forth
					end
					Result := beta_value
				end
			end
		ensure
			valid_obtained_value: (Result <= problem.max_value) and (Result >= problem.min_value)
		end

feature -- Status setting

	set_max_depth (new_max_depth: INTEGER)
			-- Sets the maximum depth to be used for search.
		do
			max_depth := new_max_depth
		ensure then
			max_depth_set: max_depth = new_max_depth
			routine_invariant: equal (problem, old problem)
		end

feature -- Status report

	obtained_value: INTEGER

	obtained_successor: S

	default_max_depth: INTEGER
			-- Integer Constant default_max_depth used in make.
		once
			Result := 5
		end

invariant
		-- List of all class invariants
	consistent_result: search_performed implies obtained_successor /= void
	consistent_obtained_value: problem.min_value <= obtained_value and obtained_value <= problem.max_value
	consisten_max_depth: max_depth >= 0

end
