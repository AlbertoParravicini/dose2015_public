note
	description: "[
		Bounded breadth first search engine. This is a generic implementation of breadth first search
		algorithm, to be applied to search problems. To use this engine, instantiate the class 
		providing search states, rules for search states, and a search problem involving the
		search states and rules.
		Bounded breadth first search performs an uninformed, exhaustive breadth-first search up to depth 
		maximum_depth.
	]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [RULE -> ANY, reference S -> SEARCH_STATE [RULE], P -> SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature {NONE} -- Implementation

	queue: LINKED_QUEUE [TUPLE [depth: INTEGER; state: S]]
			-- Queue containing the states which haven't been fully explored, and their depth;

	marked_states: LINKED_QUEUE [S]
			-- List of the states which have been fully explored;

	successful_state: S
			-- The successful state, the result of a successful search;

	redundant_parents (a_state: S): BOOLEAN
			-- Explore the parents of a_state and check if any of them is equal to it;
		local
			current_state: S
			redunant_state: BOOLEAN
		do
			if a_state = void then
				Result := false
			else
				from
					current_state := a_state.parent
					redunant_state := false
				until
					current_state.parent = void or redunant_state = true
				loop
					if equal (current_state, a_state) then
						redunant_state := true
					end
					current_state := current_state.parent
				end
			end
			Result := redunant_state
		ensure
			result_false_if_void: a_state = void implies Result = false
		end

	scan_queue_for_redundant_state (a_depth: INTEGER; a_state: S;): BOOLEAN
			-- Check if in the queue the state "a_state" is already present with a lower cost;
		require
			a_state /= void
		do
			across
				queue as curr_tuple
			loop
				if equal (curr_tuple.item.state, a_state) and a_depth > curr_tuple.item.depth then
					Result := true
				end
			end
		ensure
			result_consistent: Result = true implies across queue as tuple some equal (tuple.item.state, a_state) and a_depth > tuple.item.depth end
		end

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- BREADTH_FIRST_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
			other_problem.initial_state /= void
		do
			set_problem (other_problem)
			mark_previous_states := false
			check_parents := false
			check_queue := true
			reset_engine
		ensure
				-- Also ensures the post-conditions of reset_engine
			problem_set: problem /= void and then equal(problem, other_problem)
			previous_states_not_marked: mark_previous_states = false
			check_parents = false
			check_queue = true
			not search_performed
		end

feature -- Search Execution

	perform_search
			-- Starts the search using a breadth first search
			-- strategy. This search strategy is bounded.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
			current_state: S
			current_depth: INTEGER
			current_successors: LINKED_LIST [S]
			current_tuple: TUPLE [depth: INTEGER; state: S]
			redundant_state: BOOLEAN
		do
			create current_successors.make
			current_state := problem.initial_state
			current_depth := 0
			queue.put ([current_depth, current_state])
			if (mark_previous_states = true) then
				marked_states.extend (current_state)
			end


				-- What if the first state is already successful?
			if problem.is_successful (current_state) then
				is_search_successful := true
				successful_state := current_state
				nr_of_visited_states := nr_of_visited_states + 1
			end

				-- Main loop;
			from
			invariant
				nr_of_visited_states_is_negative: nr_of_visited_states >= 0
				depth_positive: current_depth >= 0
				depth_not_exceeded: current_depth <= maximum_depth
			until
				queue.is_empty or is_search_successful
			loop
				redundant_state := false
				current_successors.wipe_out
					-- Remove the first state of the queue, add it to the marked states list;
				current_tuple := queue.item
				current_state := current_tuple.state
				current_depth := current_tuple.depth
				queue.remove
				nr_of_visited_states := nr_of_visited_states + 1
					-- Check if the removed state is successful, if so don't start the main loop;
				if (problem.is_successful (current_state)) then
					is_search_successful := true
					successful_state := current_state

						-- Get the successors of the state, if the removed state isn't successful;
				elseif (current_depth < maximum_depth) then

					current_successors.append (problem.get_successors (current_state))

					from
						current_successors.start
					invariant
						nr_of_visited_states_is_negative: nr_of_visited_states >= 0
					until
						current_successors.exhausted or is_search_successful
					loop
							-- If the visited states are memorized, check if the current successor is marked:
							-- if so just go to the next iteration of the loop.
							-- If visited states aren't visited, add it to the queue;
						if (mark_previous_states = false or not marked_states.has (current_successors.item)) then
							if (mark_previous_states = true) then
								marked_states.extend (current_successors.item)
							end

								-- Check if the current successor is successful;
							if problem.is_successful (current_successors.item) then
								is_search_successful := true
								successful_state := current_successors.item
							else
									-- If "check_parent" is active, check if the state is redundant;
								if check_parents = true then
									redundant_state := redundant_parents (current_successors.item)
								end

									-- Put it in the queue if the state isn't successful or it isn't redundant;
								if check_queue = true then
									redundant_state := scan_queue_for_redundant_state (current_depth + 1, current_successors.item)
								end
								if (check_parents = false or redundant_state = false) and (check_queue = false or redundant_state = false) then
									queue.put ([current_depth + 1, current_successors.item])
								end
							end
						end
						current_successors.forth
					end -- End of the loop;
				end
			end -- End of the main loop;
			search_performed := true
		ensure then
			unsuccessful_state_with_non_empty_queue: (not is_search_successful) implies queue.is_empty
			no_visited_states: nr_of_visited_states > old nr_of_visited_states
			at_least_one_state_visited: mark_previous_states implies (marked_states.count > old marked_states.count)
			search_successful_nec: is_search_successful implies problem.is_successful (successful_state)
			search_successful_suc: (search_performed and successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful
			routine_invariant: old mark_previous_states = mark_previous_states and old maximum_depth = maximum_depth and old check_parents = check_parents and old check_queue = check_queue and equal(problem, old problem)
		end

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			create queue.make
			create marked_states.make
			search_performed := false
			is_search_successful := false
			successful_state := void
			nr_of_visited_states := 0
			queue.compare_objects
			marked_states.compare_objects
		ensure then
			queue_emptied: queue /= void and then queue.count = 0
			marked_states_emptied: marked_states /= void and then marked_states.count = 0
			successful_state_resetted: successful_state = void
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
			no_visited_states: nr_of_visited_states = 0
			routine_invariant: old maximum_depth = maximum_depth and old mark_previous_states = mark_previous_states and old check_parents = check_parents and old check_queue = check_queue and equal(problem, old problem)
		end

feature -- Status setting

	set_max_depth (new_bound: INTEGER)
			-- Sets the max depth bound to new_bound;
		require
			positive_depth: new_bound >= 0
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
		do
			maximum_depth := new_bound
		ensure
			new_depth_set: maximum_depth = new_bound
			routine_invariant: old mark_previous_states = mark_previous_states and old search_performed = search_performed and old is_search_successful = is_search_successful and old check_parents = check_parents and old check_queue = check_queue and equal(problem, old problem) and equal(successful_state, old successful_state) and equal(queue, old queue) and equal(marked_states, old marked_states)
		end

	set_mark_visited_states (a_choice: BOOLEAN)
			-- Set whether to memorize the visited states or not; it is NOT RECOMMENDED to have both
			-- "check_parents" and "mark_visited_states" active at the same time,
			-- as the parents of a state are already included among the visited states;
		require
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
		do
			mark_previous_states := a_choice
			if (marked_states /= void) then
				marked_states.wipe_out
			end
		ensure
			mark_states_set: mark_previous_states = a_choice
			empty_marked_states: marked_states.count = 0
			routine_invariant: old maximum_depth = maximum_depth and old search_performed = search_performed and old is_search_successful = is_search_successful and old check_parents = check_parents and old check_queue = check_queue and equal(problem, old problem) and equal(successful_state, old successful_state) and equal(queue, old queue)
		end

	set_check_parents (a_choice: BOOLEAN)
			-- Set whether to check the parents of a state before adding it
			-- to the queue or not; it is NOT RECOMMENDED to have both
			-- "check_parents" and "mark_visited_states" active at the same time,
			-- as the parents of a state are already included among the visited states;
		require
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
		do
			check_parents := a_choice
		ensure
			check_parents_set: check_parents = a_choice
			routine_invariant: old maximum_depth = maximum_depth and old search_performed = search_performed and old is_search_successful = is_search_successful and old mark_previous_states = mark_previous_states and old check_queue = check_queue and equal(problem, old problem) and equal(successful_state, old successful_state) and equal(queue, old queue) and equal(marked_states, old marked_states)
		end

	set_check_queue (a_choice: BOOLEAN)
			-- Set whether or not to scan the queue every time a new successor is generated,
			-- to see if the successor is already in the queue with a lower cost
		require
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
		do
			check_queue := a_choice
		ensure
			check_queue_set: check_queue = a_choice
			routine_invariant: old maximum_depth = maximum_depth and old search_performed = search_performed and old is_search_successful = is_search_successful and old mark_previous_states = mark_previous_states and old check_parents = check_parents and equal(problem, old problem) and equal(successful_state, old successful_state) and equal(queue, old queue) and equal(marked_states, old marked_states)
		end

feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search;
		local
			current_state: S
			list: LINKED_LIST [S]
		do
			create list.make
			if (is_search_successful) then
					-- Starting from the successful state, get the parent of each state
					-- by travelling backwards in the hierarchy, and add as first item of a list;
				from
					current_state := obtained_solution
					list.put_front (current_state)
				until
					current_state.parent = void
				loop
					list.put_front (current_state.parent)
					current_state := current_state.parent
				end
			end
			Result := list
		ensure then
				--First member of the list is the starting state, ending position of the list is the searched state;
			first_state_is_consistent: Result.is_empty or else equal (Result.first, problem.initial_state)
			last_state_is_consistent: Result.is_empty or else problem.is_successful (Result.last)
			empty_list_is_consistent: (Result.is_empty implies (not is_search_successful)) and ((not is_search_successful) implies Result.is_empty)
			routine_invariant: old mark_previous_states = mark_previous_states and old search_performed = search_performed and old is_search_successful = is_search_successful and old maximum_depth = maximum_depth and old check_parents = check_parents and old check_queue = check_queue and equal(problem, old problem) and equal(successful_state, old successful_state) and equal(queue, old queue) and equal(marked_states, old marked_states)
		end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search;
		do
			if is_search_successful and search_performed then
				Result := successful_state
			end
		ensure then
			if_result_exists_not_void: (is_search_successful and search_performed) implies Result = successful_state
			successful_search: is_search_successful implies problem.is_successful (Result)
			unsuccessful_search: (not is_search_successful) implies Result = void
			routine_invariant: old mark_previous_states = mark_previous_states and old search_performed = search_performed and old is_search_successful = is_search_successful and old maximum_depth = maximum_depth and old check_parents = check_parents and old check_queue = check_queue and equal(problem, old problem) and equal(successful_state, old successful_state) and equal(queue, old queue) and equal(marked_states, old marked_states)
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	maximum_depth: INTEGER
			-- Max depth employed for the bounded breadth first search.

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

	mark_previous_states: BOOLEAN
			-- If set to true the algorithm stores the previously visited states in a list,
			-- so that those states can't be visited again in the future.
			-- Improves drastically the time complexity at the cost of higher spatial complexity;

	check_parents: BOOLEAN
			-- If set to true the current state is examinated before being added to the queue:
			-- if one of its parents is equal to the state, the state is discarded; it is NOT RECOMMENDED to have both
			-- "check_parents" and "mark_visited_states" active at the same time,
			-- as the parents of a state are already included among the visited states;

	check_queue: BOOLEAN
			-- If set to true, every time a new successor state is generated
			-- the queue is scanned to see whether or not the state is already present with a lower cost:
			-- if so, the state is skipped;
			-- it is NOT RECOMMENDED to have both "mark_previous_states" and "check_queue" active at the same time,
			-- as the time complexity woul increase without providing any real benefit;

invariant
	queue_is_void: queue /= void
	marked_states_is_void: marked_states /= void
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	maximum_depth >= 0
	is_search_successful implies search_performed
	consistent_marked_states_size: mark_previous_states = false implies marked_states.count = 0
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)
	successful_state_not_belonging_to_marked_states: (is_search_successful and mark_previous_states) implies marked_states.has (successful_state)

end
