note
	description: "[
		Steepest ascent Hill climbing engine. This is a generic implementation of steepest ascent
		hill climbing, that can be applied to any heuristic search problem. The engine is parameterized
		with a heuristic search problem, the search state corresponding to the problem, and the rules 
		associated with state change.
		]"
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-22 03:18:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	STEEPEST_HILL_CLIMBING_ENGINE[RULE -> ANY, S -> SEARCH_STATE[RULE], P -> HEURISTIC_SEARCH_PROBLEM [RULE, S]]


-- To avoid duplication of many lines of code has been inherited class HILL_CLIMBING_ENGINE.
-- The advantage is a code that is easy to update, clean and legible.
-- The disadvantage is that the class that is inherited is to be included in the project, but this
-- is not a real disadvantage because when you import an entire library will import all its classes.
inherit
	HILL_CLIMBING_ENGINE [RULE, S, P]
        redefine
            update_current_maximum_state_from_neighbors
        end

create
	make


feature {NONE} -- Implementation


	update_current_maximum_state_from_neighbors (a_current_best_heuristic_value: REAL; neighbors_list: LIST [S]): BOOLEAN
		-- For each successor compare the heuristic values to find the one with the best value.
		-- Return true if current_maximum_state was updated.

		local

			is_current_maximum_state_updated: BOOLEAN
				-- True if current_maximum_state was updated.

			l_current_best_heuristic_value: REAL
				-- Saves the best heuristic value reached in each iteration.

		do

			is_current_maximum_state_updated := false
			l_current_best_heuristic_value := a_current_best_heuristic_value
				-- Initializes local variable.


			from -- Neighbors loop.
				neighbors_list.start
			until
				neighbors_list.exhausted
					-- Exits the loop when there aren't more neighbors.
			loop

				if problem.heuristic_value (neighbors_list.item) < l_current_best_heuristic_value then
					-- If a successor has heuristic value better than the current maximum state then update current maximum state.

					current_maximum_state := neighbors_list.item

					is_current_maximum_state_updated := true

					l_current_best_heuristic_value := problem.heuristic_value (current_maximum_state)
						-- Updates local current best heuristic value

				end

				nr_of_visited_states := nr_of_visited_states + 1
				neighbors_list.forth

			end -- End neighbors loop.

			Result := is_current_maximum_state_updated

		end



end
