note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	HILL_CLIMBING_TEST_CASES

inherit
	EQA_TEST_SET

feature -- Test routines

	search_result: BOOLEAN

	nr_vis_states: INTEGER

	nr_actions_to_obtained_solution: INTEGER



	hill_climbing_test_trivial_solution_1
			-- test case: WATER JAR (0,0,0)
		local
			engine: HILL_CLIMBING_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false

			create jar_puzzle.make_with_initial_state (0, 0, 0)
			create engine.make (jar_puzzle)

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			nr_vis_states = 1
			search_result = false
		end




	hill_climbing_test_trivial_solution_2
			-- test case: WATER JAR (10,10,0)
		local
			engine: HILL_CLIMBING_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false

			create jar_puzzle.make_with_initial_state (10, 10, 0)
			create engine.make (jar_puzzle)

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			nr_vis_states = 1
			search_result = true
		end




	hill_climbing_test_one_step_solution_1
			-- test case: WATER JAR (9,10,1)
		local
			engine: HILL_CLIMBING_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			nr_actions_to_obtained_solution := 0

			create jar_puzzle.make_with_initial_state (9, 10, 1)
			create engine.make (jar_puzzle)

			engine.perform_search
			search_result := engine.is_search_successful
			nr_actions_to_obtained_solution := engine.path_to_obtained_solution.count - 1
		ensure
			search_result = true
			nr_actions_to_obtained_solution = 1
		end




	hill_climbing_test_best_heuristic_solution_1
			-- test case: WATER JAR (0,0,0)
		local
			engine: HILL_CLIMBING_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			nr_actions_to_obtained_solution := 0

			create jar_puzzle.make_with_initial_state (0, 0, 0)
			create engine.make (jar_puzzle)

			engine.set_best_heuristic_partial_solution_allowed (true)

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
			nr_actions_to_obtained_solution := engine.path_to_obtained_solution.count - 1
		ensure
			nr_vis_states = 1
			search_result = true
			nr_actions_to_obtained_solution = 0
		end




	hill_climbing_test_best_heuristic_solution_2
			-- test case: WATER JAR (0,13,7)
		local
			engine: HILL_CLIMBING_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			nr_actions_to_obtained_solution := 0

			create jar_puzzle.make_with_initial_state (0, 13, 7)
			create engine.make (jar_puzzle)

			engine.set_best_heuristic_partial_solution_allowed (true)

			engine.perform_search
			search_result := engine.is_search_successful
			nr_actions_to_obtained_solution := engine.path_to_obtained_solution.count - 1
		ensure
			search_result = true
			nr_actions_to_obtained_solution = 1
		end




	hill_climbing_test_best_heuristic_solution_3
			-- test case: WATER JAR (0,13,6)
		local
			engine: HILL_CLIMBING_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			nr_actions_to_obtained_solution := 0

			create jar_puzzle.make_with_initial_state (0, 13, 6)
			create engine.make (jar_puzzle)

			engine.set_best_heuristic_partial_solution_allowed (true)

			engine.perform_search
			search_result := engine.is_search_successful
			nr_actions_to_obtained_solution := engine.path_to_obtained_solution.count - 1
		ensure
			search_result = true
			nr_actions_to_obtained_solution = 2
		end




	hill_climbing_test_sideways_moves
			-- test case: WATER JAR (1,0,0)
		local
			engine: HILL_CLIMBING_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			nr_actions_to_obtained_solution := 0

			create jar_puzzle.make_with_initial_state (1, 0, 0)
			create engine.make (jar_puzzle)

			engine.set_best_heuristic_partial_solution_allowed (true)

			engine.perform_search
			search_result := engine.is_search_successful
			nr_actions_to_obtained_solution := engine.path_to_obtained_solution.count - 1
		ensure
			search_result = true
			nr_actions_to_obtained_solution = 10
		end




	hill_climbing_test_sideways_moves_disabled
			-- test case: WATER JAR (1,0,0)
		local
			engine: HILL_CLIMBING_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			nr_actions_to_obtained_solution := 0

			create jar_puzzle.make_with_initial_state (1, 0, 0)
			create engine.make (jar_puzzle)

			engine.set_best_heuristic_partial_solution_allowed (true)
			engine.set_max_number_of_sideways_moves (0)

			engine.perform_search
			search_result := engine.is_search_successful
			nr_actions_to_obtained_solution := engine.path_to_obtained_solution.count - 1
		ensure
			search_result = true
			nr_actions_to_obtained_solution = 0
		end

end


