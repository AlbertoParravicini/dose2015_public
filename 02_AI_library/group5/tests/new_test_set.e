note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	WATER_JAR_TEST_CLASS

inherit
	EQA_TEST_SET

feature -- Test routines

	test_a_star_1
		note
			testing: "single-agent.search-examples/{WATER_JAR_PUZZLE_SOLVER}"
		local
			engine: A_STAR_SEARCH_ENGINE [STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			solver: WATER_JAR_PUZZLE_SOLVER
			jar_puzzle : WATER_JAR_PUZZLE
		do
			create jar_puzzle.make_with_initial_state (0, 13, 7)
			create engine.make (jar_puzzle)
			create solver.make_with_parameters (engine, -1, jar_puzzle)
		end
end


