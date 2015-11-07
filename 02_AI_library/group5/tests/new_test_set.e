note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	A_STAR_TEST

inherit

	EQA_TEST_SET

feature -- Test routines

	search_result: BOOLEAN

	nr_vis_states: INTEGER

	test_a_star_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			create jar_puzzle.make_with_initial_state (0, 13, 7)
			create engine.make (jar_puzzle)
			engine.set_check_open_state (true)
			engine.set_mark_closed_state (true)
			engine.perform_search
			search_result := engine.is_search_successful
		ensure
			search_result = true
		end

	test_a_star_2
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			create jar_puzzle.make_with_initial_state (6, 9, 5)
			create engine.make (jar_puzzle)
			engine.set_check_open_state (false)
			engine.set_mark_closed_state (true)
			engine.perform_search
			search_result := engine.is_search_successful
		ensure
			search_result = true
		end

	test_a_star_3
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			create jar_puzzle.make_with_initial_state (3, 13, 4)
			create engine.make (jar_puzzle)
			engine.set_check_open_state (false)
			engine.set_mark_closed_state (false)
			engine.perform_search
			search_result := engine.is_search_successful
		ensure
			search_result = true
		end

	test_a_star_trivial_solution_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			create jar_puzzle.make_with_initial_state (10, 10, 0)
			create engine.make (jar_puzzle)
			engine.set_check_open_state (true)
			engine.set_mark_closed_state (true)
			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			search_result = true
			nr_vis_states = 1
		end

	test_a_star_trivial_solution_2
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			nr_vis_states := 0
			search_result := false
			create jar_puzzle.make_with_initial_state (0, 0, 0)
			create engine.make (jar_puzzle)
			engine.set_check_open_state (true)
			engine.set_mark_closed_state (true)
			engine.perform_search
			search_result := engine.is_search_successful
			nr_vis_states := engine.nr_of_visited_states
		ensure
			search_result = false
			nr_vis_states = 1
		end

	test_a_star_no_solution_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			search_result := false
			create jar_puzzle.make_with_initial_state (0, 4, 7)
			create engine.make (jar_puzzle)
			engine.set_check_open_state (true)
			engine.set_mark_closed_state (true)
			engine.perform_search
			search_result := engine.is_search_successful
		ensure
			search_result = false
		end

	test_a_star_no_solution_2
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			jar_puzzle: WATER_JAR_PUZZLE
		do
			search_result := false
			create jar_puzzle.make_with_initial_state (10, 4, 7)
			create engine.make (jar_puzzle)
			engine.set_check_open_state (true)
			engine.set_mark_closed_state (true)
			engine.perform_search
			search_result := engine.is_search_successful
		ensure
			search_result = false
		end

end
