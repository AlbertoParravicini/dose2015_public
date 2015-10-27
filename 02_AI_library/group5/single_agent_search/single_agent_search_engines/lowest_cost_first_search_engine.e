note
	description: "[
				Lowest cost first search engine. 
				This is a generic implementation of lowest cost first search
				algorithm, to be applied to search problems. To use this engine, instantiate the class 
				providing search states, rules for search states, and a search problem involving the
				search states and rules.
				Lowest cost first search performs an uninformed, exhaustive search, where
				successor states are prioritized according to the cost of the path leading to them.
				]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"


class
	LOWEST_COST_FIRST_SEARCH_ENGINE [RULE -> ANY, S -> SEARCH_STATE [RULE], P -> STATE_COST_SEARCH_PROBLEM [RULE, S]]

inherit

	SEARCH_ENGINE [RULE, S, P]

create
	make

feature -- Creation

	make (other_problem: P)
			-- Constructor of the class. It initialises a
			-- LOWEST_COST_FIRST_SEARCH_ENGINE with a problem
		require
			other_problem /= Void
		do
			set_problem(other_problem)
			reset_engine
		ensure
			problem = other_problem
			not search_performed
		end


feature -- Search Execution

	perform_search
			-- Starts the search using a lowest-cost first search
			-- strategy. This search strategy prioritizes states according to the cost
			-- of the path leading to them, attempting to produce minimum-cost solutions.
			-- The result of the search is indicated in
			-- is_search_successful.
		local
			frontier_state : FERRED_STATE[RULE,S]
			aux: FERRED_STATE[RULE,S]
			current_state : S
			current_successors:LIST[S]

		do

			if problem.is_successful (problem.initial_state) then
				is_search_successful := true
				successful_state := problem.initial_state
			else
				create aux.make
				create frontier_state.make_with_params(problem.initial_state,problem.cost(problem.initial_state))
				frontier.put (frontier_state)
				from
				until
					is_search_successful or frontier.is_empty
				loop
					frontier_state := frontier.item
					current_state := frontier_state.state
					frontier.remove
					if(problem.is_successful (current_state)) then
						successful_state := current_state
						is_search_successful:= true
						explored.extend(current_state)
						nr_of_visited_states := nr_of_visited_states + 1
					else
						if (not is_search_successful) then
							current_successors:=problem.get_successors (current_state)
							explored.extend(current_state)
							nr_of_visited_states:=nr_of_visited_states + 1
							from
								current_successors.start
							until
								current_successors.exhausted or is_search_successful
							loop
								--  n = current succesor
								--	if n is not in explored
		        				--		if n is not in frontier
		         				--		 frontier.add(n)
		        				--		else if n is in frontier with higher cost
		          				--		replace existing node with n

								successful_state := current_successors.item

								if(not explored.has(successful_state))then
									if(not stateInfrontier(successful_state)) then
										aux.set_state (successful_state)
										aux.set_cost(problem.cost(successful_state))
										frontier.put(aux)
									else
										if(stateInFrontier(successful_state) and (costStateInFrontier(successful_state) > problem.cost(successful_state))) then
											successful_state.set_parent (current_state)
											setCostInFrontier(successful_state,problem.cost (successful_state))
										end
									end
								end
								current_successors.forth
							end
						end
					end
					search_performed := True
				end
			end
		end

feature
	stateInFrontier(search_state : S): BOOLEAN
			--It contains the state frontier
	local
		res:BOOLEAN
		state_current : S
		frontier_current : FERRED_STATE[RULE,S]
		aux_frontier :LINKED_PRIORITY_QUEUE[FERRED_STATE[RULE,S]]
	do
		create aux_frontier.make
		create frontier_current.make
		res := false
		if (not frontier.is_empty) then
			from
			until
				res = true or frontier.is_empty
			loop
				frontier_current := frontier.item
				state_current := frontier_current.state
				if(state_current.is_equal(search_state)) then
					res:= true
				end
				aux_frontier.put (frontier.item)
				frontier.remove
			end
		end
		frontier:=aux_frontier
		Result:=res
	ensure
		result_false_if_void: search_state = void implies Result = false
	end


feature
	costStateInFrontier(search_state : S): REAL_32
			--Cost the state contain in a frontier
	local
		stop : BOOLEAN
		state_current : S
		cost_current : REAL_32
		frontier_current : FERRED_STATE[RULE,S]
		aux_frontier :LINKED_PRIORITY_QUEUE[FERRED_STATE[RULE,S]]
	do
		create aux_frontier.make
		create frontier_current.make
		from
		until
			stop or frontier.is_empty
		loop
			frontier_current := frontier.item
			state_current := frontier_current.state
			if(state_current.is_equal(search_state)) then
				stop:=true
				cost_current:= frontier_current.cost
			end
			aux_frontier.put (frontier.item)
			frontier.remove
		end
		frontier:=aux_frontier
		Result:= cost_current
	end



feature
	setCostInFrontier(search_state : S ; new_cost : REAL_32)
			-- Changes the cost of a state in frontier
	local
		stop : BOOLEAN
		state_current : S
		frontier_current : FERRED_STATE[RULE,S]
		aux_frontier : LINKED_PRIORITY_QUEUE[FERRED_STATE[RULE,S]]
	do
		create aux_frontier.make
		from
		until
			stop or frontier.is_empty
		loop

			create frontier_current.make
			frontier_current:= frontier.item
			state_current := frontier_current.state
			if(state_current.is_equal(search_state)) then
				frontier_current.set_cost(new_cost)
				frontier.replace (frontier_current)
				stop:=true
			end
			aux_frontier.put (frontier.item)
			frontier.remove
		end
		frontier:=aux_frontier
	end


feature
	reset_engine
			-- Resets engine, so that search can be restarted.
		do
			search_performed:=false
			create frontier.make
			create explored.make
			is_search_successful := false
			nr_of_visited_states := 0
			frontier.compare_objects
			explored.compare_objects
		ensure then
			successful_state_resetted: successful_state = void
			search_not_performed: search_performed = false
			search_not_successful: is_search_successful = false
			no_visited_states: nr_of_visited_states = 0
		end


feature -- Status Report

	path_to_obtained_solution: LIST [S]
			-- Returns the path to the solution obtained from performed search.
		local
			current_state: S
			list: LINKED_LIST [S]
		do
			if (is_search_successful) then
					-- Starting from the successful state, get the parent of each state
					--		by travelling backwards in the hierarchy, and add it to a list;
				from
					current_state := obtained_solution
					create list.make
					list.put_front (current_state)
				until
					current_state.parent = void
				loop
					list.put_front (current_state.parent)
					current_state := current_state.parent
				end
				Result := list
			end
		ensure then
			first_state_is_consistent: Result.is_empty or else equal (Result.first, problem.initial_state)
			last_state_is_consistent: Result.is_empty or else problem.is_successful (Result.last)
			empty_list_is_consistent: (Result.is_empty implies (not is_search_successful)) and ((not is_search_successful) implies Result.is_empty)
		end

	obtained_solution: detachable S
			-- Returns solution obtained from last performed search.
		do
			if is_search_successful and search_performed then
				Result := successful_state
			end
		ensure then
			if_result_exists_not_void: (is_search_successful and search_performed) implies Result = successful_state
			successful_search: is_search_successful implies problem.is_successful (Result)
			unsuccessful_search: (not is_search_successful) implies Result = void

		end

	is_search_successful: BOOLEAN
			-- Was last search successful?

	nr_of_visited_states: INTEGER
			-- Number of states visited in the performed search.
feature{NONE}
	frontier :LINKED_PRIORITY_QUEUE[FERRED_STATE[RULE,S]]
			-- Priority queue contatining states

	explored: LINKED_LIST[S]
			-- States visited

	successful_state: S
			-- Successful state

invariant
	nr_of_visited_states_is_negative: nr_of_visited_states >= 0
	is_search_successful implies search_performed
	successful_state_is_inconsistent: search_performed implies (is_search_successful implies problem.is_successful (successful_state))
	successful_state_is_inconsistent: search_performed implies ((successful_state /= void and then problem.is_successful (successful_state)) implies is_search_successful)
end
