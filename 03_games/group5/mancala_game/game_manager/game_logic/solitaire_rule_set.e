note
	description: "Summary description for {SOLITAIRE_RULE_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_RULE_SET

inherit

	RULE_SET [SOLITAIRE_STATE]

create
	make_by_state

feature -- Initialization

	make_by_state (a_initial_state: SOLITAIRE_STATE; selected_algorithm: STRING; selected_depth: INTEGER)
		do
			current_state := a_initial_state
			create problem.make_with_initial_state (a_initial_state)
			if selected_algorithm.is_equal ("bounded_breadth_first_search") then
				engine := create {BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
				if attached {BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]} engine as engine_bfs then
					engine_bfs.set_mark_visited_states (true)
					engine_bfs.set_check_queue (true)
					if selected_depth > 0 then
						engine_bfs.set_max_depth (selected_depth)
					else
						engine_bfs.set_max_depth (5)
					end
				end
			elseif selected_algorithm.is_equal ("bounded_depth_first_search") then
				engine := create {BOUNDED_DEPTH_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
				if attached {BOUNDED_DEPTH_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]} engine as engine_dfs then
					engine_dfs.enable_cycle_checking
					if selected_depth > 0 then
						engine_dfs.set_max_depth (selected_depth)
					else
						engine_dfs.set_max_depth (5)
					end
				end
			elseif selected_algorithm.is_equal ("depth_first_with_cycle_checking") then
				engine := create {CYCLE_CHECKING_DEPTH_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
			elseif selected_algorithm.is_equal ("iterative_deepening") then
				engine := create {ITERATIVE_DEEPENING_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
				if attached {ITERATIVE_DEEPENING_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]} engine as engine_idfs then
					engine_idfs.enable_cycle_checking
				end
			elseif selected_algorithm.is_equal ("heuristic_depth_first_search") then
				engine := create {HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
				if attached {HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]} engine as engine_hdfs then
					engine_hdfs.enable_cycle_checking
				end
			elseif selected_algorithm.is_equal ("hill_climbing") then
				engine := create {HILL_CLIMBING_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
				if attached {HILL_CLIMBING_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]} engine as engine_hc then
					engine_hc.set_best_heuristic_partial_solution_allowed (true)
					engine_hc.set_max_number_of_sideways_moves (10)
				end
			elseif selected_algorithm.is_equal ("steepest_ascent_hill_climbing") then
				engine := create {STEEPEST_HILL_CLIMBING_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
				if attached {STEEPEST_HILL_CLIMBING_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]} engine as engine_shc then
					engine_shc.set_best_heuristic_partial_solution_allowed (true)
					engine_shc.set_max_number_of_sideways_moves (10)
				end
			elseif selected_algorithm.is_equal ("lowest_cost_first_search") then
				engine := create {LOWEST_COST_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
				if attached {LOWEST_COST_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]} engine as engine_lcf then
					engine_lcf.set_mark_explored_states (true)
				end
			elseif selected_algorithm.is_equal ("best_first_search") then
				engine := create {BEST_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
			elseif selected_algorithm.is_equal ("a_star") then
				engine := create {A_STAR_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem)
				if attached {A_STAR_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]} engine as engine_a_star then
					engine_a_star.set_mark_closed_state (true)
					engine_a_star.set_check_open_state (true)
				end
			else
				print("ERROR, engine not selected%N")
			end
		end

feature -- Status report

	problem: SOLITAIRE_PROBLEM
			-- The problem which ought to be solved through the use of AI search;

	engine: SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]
			-- The engine used to solve the problem;

feature -- Implementation

	is_valid_action (a_player_id: INTEGER; a_action: ACTION): BOOLEAN
		local
			l_is_valid: BOOLEAN
			l_is_first_turn: BOOLEAN
		do
			l_is_valid := true

				-- Check if it is the first turn of the game;
			if (current_state.parent = Void and current_state.rule_applied = Void) then
				l_is_first_turn := true
			end

				-- INVALID PLAYER:
			if l_is_valid and then a_player_id /= current_state.index_of_current_player then
				l_is_valid := false
			end

				-- THE ACTION MUST BE AN ACTION_SELECT OR AN ACTION_ROTATE OR ANOTHER COMPATIBLE ACTION:
			if l_is_valid and then (not attached {ACTION_SELECT} a_action and not attached {ACTION_ROTATE} a_action and not attached {ACTION_OTHER} a_action) then
				l_is_valid := false
			end

				-- CHOSING THE HOLE IS ALLOWED ONLY IN THE FIRST TURN:
			if l_is_valid and then attached {ACTION_SELECT} a_action as select_action and then l_is_first_turn = false then
				l_is_valid := false
			end

				-- THE CHOSEN HOLE MUST EXIST:
			if l_is_valid and then attached {ACTION_SELECT} a_action as select_action and then (select_action.get_selection <= 0 or select_action.get_selection > {GAME_CONSTANTS}.num_of_holes) then
				l_is_valid := false
			end

				-- MOVE CLOCKWISE OR COUNTER-CLOCKWISE ONLY IF THE HOLE IS SELECTED:
			if l_is_valid and then attached {ACTION_ROTATE} a_action as action_rotate and (current_state.selected_hole <= 0 or current_state.selected_hole > {GAME_CONSTANTS}.num_of_holes) then
				l_is_valid := false
			end

				-- ACCEPT ONLY IF THE HOLE ISN'T EMPTY:
			if l_is_valid and then attached {ACTION_ROTATE} a_action as action_rotate and (current_state.map.get_hole_value (current_state.selected_hole) <= 0) then
				l_is_valid := false
			end

				-- THE ACTION IS A HINT OR A SOLVE REQUEST:
			if l_is_valid and then attached {ACTION_OTHER} a_action as action_other and then (action_other.action = (create {ENUM_OTHER}).hint or action_other.action = (create {ENUM_OTHER}).solve) then
				current_state.set_parent (Void)
				current_state.set_rule_applied (Void)
				problem.make_with_initial_state (current_state)
				engine.set_problem (problem)
				engine.reset_engine
				engine.perform_search

				if engine.is_search_successful then
					current_state := engine.path_to_obtained_solution.at (2)
				else
					print("asdasdasdasdasd")
				end
				l_is_valid := true
			end

			if l_is_valid and then attached {ACTION_SELECT} a_action as action_select then
				current_state := create {SOLITAIRE_STATE}.make_from_parent_and_rule (current_state, action_select)
			elseif l_is_valid and then attached {ACTION_ROTATE} a_action as action_rotate then
				current_state := create {SOLITAIRE_STATE}.make_from_parent_and_rule (current_state, action_rotate)
				if action_rotate.rotation = (create {ENUM_ROTATE}).clockwise then
					current_state.move_clockwise
				else
					current_state.move_counter_clockwise
				end
			end
			Result := l_is_valid
		end

end
