note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	BOUNDED_BREADTH_FIRST_SEARCH_TEST

inherit

	EQA_TEST_SET
	redefine
		on_prepare

	end

feature -- Test routines

	on_prepare
		do
			search_result := false
			num_visited_states := 0
		end

	search_result: BOOLEAN

	num_visited_states: INTEGER

	test_bfs_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do



			create jar_puzzle.make_with_initial_state (0, 13, 7)
			create engine.make (jar_puzzle)
			engine.set_max_depth (20)
			engine.set_check_queue (true)
			engine.set_mark_visited_states (true)

			engine.perform_search
			search_result := engine.is_search_successful
			num_visited_states := engine.nr_of_visited_states
		ensure
			search_result = true
		end

--	test_bfs_trivial_solution_1
--		note
--			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
--		local
--			engine: BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
--			solver: WATER_JAR_PUZZLE_SOLVER
--			jar_puzzle: WATER_JAR_PUZZLE
--		do
--			search_result := false
--			num_visited_states := 0
--			create jar_puzzle.make_with_initial_state (10, 10, 0)
--			create engine.make (jar_puzzle)
--			engine.set_max_depth (20)
--			engine.set_check_queue (true)
--			engine.set_mark_visited_states (true)
--			create solver.make_with_parameters (engine, jar_puzzle)
--			search_result := engine.is_search_successful
--			num_visited_states := engine.nr_of_visited_states
--		ensure
--			search_result = true
--			num_visited_states = 1
--		end

--	test_bfs_trivial_solution_2
--		note
--			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
--		local
--			engine: BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
--			solver: WATER_JAR_PUZZLE_SOLVER
--			jar_puzzle: WATER_JAR_PUZZLE
--		do
--			search_result := false
--			num_visited_states := 0
--			create jar_puzzle.make_with_initial_state (0, 0, 0)
--			create engine.make (jar_puzzle)
--			engine.set_max_depth (20)
--			engine.set_check_queue (true)
--			engine.set_mark_visited_states (true)
--			create solver.make_with_parameters (engine, jar_puzzle)
--			search_result := engine.is_search_successful
--			num_visited_states := engine.nr_of_visited_states
--		ensure
--			search_result = false
--			num_visited_states = 1
--		end

--	test_bfs_no_solution_1
--		note
--			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
--		local
--			engine: BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
--			solver: WATER_JAR_PUZZLE_SOLVER
--			jar_puzzle: WATER_JAR_PUZZLE
--		do
--			search_result := false
--			num_visited_states := 0
--			create jar_puzzle.make_with_initial_state (0, 2, 7)
--			create engine.make (jar_puzzle)
--			engine.set_max_depth (20)
--			engine.set_check_queue (true)
--			engine.set_mark_visited_states (true)
--			create solver.make_with_parameters (engine, jar_puzzle)
--			search_result := engine.is_search_successful
--			num_visited_states := engine.nr_of_visited_states
--		ensure
--			search_result = false
--		end

--	test_bfs_no_solution_2
--		note
--			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
--		local
--			engine: BOUNDED_BREADTH_FIRST_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
--			solver: WATER_JAR_PUZZLE_SOLVER
--			jar_puzzle: WATER_JAR_PUZZLE
--		do
--			search_result := false
--			num_visited_states := 0
--			create jar_puzzle.make_with_initial_state (10, 13, 7)
--			create engine.make (jar_puzzle)
--			engine.set_max_depth (20)
--			engine.set_check_queue (true)
--			engine.set_mark_visited_states (true)
--			create solver.make_with_parameters (engine, jar_puzzle)
--			search_result := engine.is_search_successful
--			num_visited_states := engine.nr_of_visited_states
--		ensure
--			search_result = false
--		end

end
