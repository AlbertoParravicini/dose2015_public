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
	BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [RULE -> ANY, S -> SEARCH_STATE [RULE], P -> SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature {NONE} -- Implementation

	queue: LINKED_QUEUE [TUPLE [depth: INTEGER; state: S]]
			-- Queue containing the states which haven't been fully explored, and their depth;

	marked_states: LINKED_QUEUE [S]
			-- List of the states which have been fully explored

	successful_state: S

feature {NONE} -- Implementation functions

	reverse_list (a_list: LIST[S]) : LIST[S]

		local
			m_list: LINKED_LIST[S]
		do
			create m_list.make
			across a_list as i loop
				m_list.put_front(i.item)
			end
			Result := m_list
		end



feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- BREADTH_FIRST_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
			-- TODO: more requires
		do
			set_problem (other_problem)
			create queue.make
			create marked_states.make
			search_performed := false
			is_search_successful := false
			nr_of_visited_states := 0
		    set_max_depth (0)

		ensure
			problem = other_problem
			not search_performed
				-- TODO: more ensures
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
		do

			create current_successors.make
			current_state := problem.initial_state
			--current_depth := 0
			queue.put ([current_depth, current_state])
				-- What if the first state is already successful?
			nr_of_visited_states := nr_of_visited_states + 1

			marked_states.put (current_state)

			if problem.is_successful (current_state) then
				is_search_successful := true
				successful_state := current_state
			end

				-- Main loop
			from

			until
				queue.is_empty or is_search_successful
			loop

				current_successors.wipe_out
				-- Remove the first state of the queue, add it to the marked states list			
				current_tuple := queue.item
				current_state := current_tuple.state
				current_depth := current_tuple.depth

				queue.remove

				-- Check if the removed state is successful
				if (problem.is_successful (current_state)) then
					is_search_successful := true
					successful_state := current_state

				-- Get the successors of the state, if the removed state isn't successful
				elseif (current_depth < maximum_depth) then
					current_successors.append (problem.get_successors (current_state))
					from
						current_successors.start
					until
						current_successors.exhausted or is_search_successful
					loop
					-- Check if the current successor is marked
						if (not marked_states.has (current_successors.item)) then
							marked_states.extend (current_successors.item)
							nr_of_visited_states := nr_of_visited_states + 1
							-- Check if the current successor is successful
							if problem.is_successful (current_successors.item) then
								is_search_successful := true
								successful_state := current_successors.item
							else
								-- Put it in the queue if it isn't successful
								queue.put ([current_depth + 1, current_successors.item])
							end
						end
						current_successors.forth
					end -- End of the loop
				end
			end -- End of the main loop
			search_performed := true
		end

	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			create queue.make
			create marked_states.make
			search_performed := false
			is_search_successful := false
			set_max_depth (0)
			nr_of_visited_states := 0
		end

feature -- Status setting

	set_max_depth (new_bound: INTEGER)
			-- Sets the max depth bound to new_bound
		require
			new_bound >= 0
		do
			maximum_depth := new_bound
				-- Could cause issue if not called appropriately (during the search?)
		ensure
			maximum_depth = new_bound
		end

feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
		local
			current_state: S
			list: LINKED_LIST[S]
		do
			from
				current_state := obtained_solution
				create list.make
				list.extend (current_state)
			until
				current_state.parent = void
			loop
				list.extend (current_state.parent)
				current_state := current_state.parent
			end

			-- The list should be reversed, so it goes:
			-- 		Starting State --> Successful State

			Result := reverse_list(list)
		end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			if is_search_successful and search_performed then
				Result := successful_state
			end
		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	maximum_depth: INTEGER
			-- Max depth employed for the bounded breadth first search.

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.

end
