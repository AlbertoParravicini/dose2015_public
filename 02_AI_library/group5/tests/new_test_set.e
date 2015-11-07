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

	test_a_star_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			solver: WATER_JAR_PUZZLE_SOLVER
			jar_puzzle : WATER_JAR_PUZZLE
		do
			search_result := false
			create jar_puzzle.make_with_initial_state (10, 10, 0)
			create engine.make (jar_puzzle)
			engine.set_check_open_state (true)
			engine.set_mark_closed_state (true)
			create solver.make_with_parameters (engine, jar_puzzle)


			search_result := engine.is_search_successful
		ensure
			search_result = true
		end
end


