note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	HEURISTIC_DEPTH_FIRST_SEARCH_TEST

inherit
	EQA_TEST_SET

feature -- Test routines



	search_result: BOOLEAN
	nr_vis_states: INTEGER

	test_hdfs_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			create jar_puzzle.make_with_initial_state (0, 13, 7)
			create engine.make (jar_puzzle)
			engine.enable_cycle_checking

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			search_result = true
		end

	test_hdfs_2
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			create jar_puzzle.make_with_initial_state (6, 9, 5)
			create engine.make (jar_puzzle)
			engine.enable_cycle_checking

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			search_result = true
		end

	test_hdfs_trivial_solution_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			create jar_puzzle.make_with_initial_state (10, 10, 0)
			create engine.make (jar_puzzle)
			engine.enable_cycle_checking

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			search_result = true
			nr_vis_states = 1
		end

	test_hdfs_trivial_solution_2
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			create jar_puzzle.make_with_initial_state (0, 0, 0)
			create engine.make (jar_puzzle)
			engine.enable_cycle_checking

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			search_result = false
			nr_vis_states = 1
		end

	test_hdfs_no_solution_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			create jar_puzzle.make_with_initial_state (0, 10, 7)
			create engine.make (jar_puzzle)
			engine.enable_cycle_checking

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			search_result = false
		end

	test_hdfs_no_solution_2
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: HEURISTIC_DEPTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			create jar_puzzle.make_with_initial_state (7, 3, 0)
			create engine.make (jar_puzzle)
			engine.enable_cycle_checking

			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			search_result = false
		end

end


