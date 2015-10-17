note
	description: "[
		Minimax adversary search engine. This is a generic implementation of minimax, that
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
	MINIMAX_ENGINE [RULE -> ANY, S -> ADVERSARY_SEARCH_STATE [RULE], P -> ADVERSARY_SEARCH_PROBLEM [RULE, S]]

inherit
	ADVERSARY_SEARCH_ENGINE [RULE, S, P]

create
	make, make_with_depth

feature

	make (new_problem: P)
		require
			new_problem /= Void
		do
			set_problem(new_problem)
			search_performed := False
		end

	make_with_depth (new_problem: P; new_max_depth: INTEGER)
		require
			new_problem /= Void
			new_max_depth >= 0
		do
			set_problem (new_problem)
			set_max_depth (new_max_depth)
		end

feature

	reset_engine
		do
			search_performed := False
		end

	perform_search (initial_state: S)
		local
			current_successors : LIST [S]
			value_to_compare : INTEGER
		do
			current_successors := problem.get_successors (initial_state)
			if not current_successors.is_empty then
				from
				    current_successors.start
					obtained_successor := current_successors.item
					obtained_value := compute_value (obtained_successor, 0)
				until
					current_successors.exhausted
				loop
					value_to_compare := compute_value (current_successors.item, 0)
					if (value_to_compare > obtained_value)  then
						obtained_successor := current_successors.item
						obtained_value := value_to_compare
					end
					current_successors.forth
				end
			end
			search_performed := True
		end

	compute_value (initial_state : S; current_depth : INTEGER) : INTEGER
		local
			max_value : INTEGER
			min_value : INTEGER
			current_successors : LIST [S]
		do
			if (problem.is_end (initial_state) or current_depth >= max_depth) then
				Result := problem.value (initial_state)
			else
				max_value := problem.min_value
				min_value := problem.max_value
				current_successors := problem.get_successors (initial_state)
				from
					current_successors.start
				until
					current_successors.exhausted
				loop
					if initial_state.is_max then
						max_value := max_value.max (compute_value (current_successors.item, current_depth+1))
					else
						min_value := min_value.min (compute_value (current_successors.item, current_depth+1))
					end
					current_successors.forth
				end
				if initial_state.is_max then
					Result := max_value
				else
					Result := min_value
				end
			end
		end


	set_max_depth (new_max_depth: INTEGER)
		do
			max_depth := new_max_depth
		end

	obtained_value: INTEGER

	obtained_successor: S


end
