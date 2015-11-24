note
	description: "Class which allows the heuristic of the game to evolve itself through a tournament-based genetic algorithm."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HEURISTIC_EVOLUTION


create
	make

feature -- Attributes
	problem: ADVERSARY_PROBLEM
	math: HEURISTIC_FUNCTIONS_SUPPORT
	engine: MINIMAX_AB_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]
	engine_depth: INTEGER
	current_state: ADVERSARY_STATE
	initial_state: ADVERSARY_STATE

	i: INTEGER

	players: ARRAYED_LIST [PLAYER]

	weights_1: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]
	weights_2: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]

feature
	make
		do
			engine_depth := 3
			create problem.make
			create players.make (2)
			players.extend (create {HUMAN_PLAYER}.make_with_initial_values ("PLAYER", 0))
			players.extend (create {HUMAN_PLAYER}.make_with_initial_values ("PLAYER", 0))
			create initial_state.make (players)
			create engine.make_with_depth (problem, engine_depth)

			create math.make

				-- Initialize the first weights list as default;
			weights_1 := math.initialize_weights

				-- Initialize the second weights list based on the first one;
				


		end
end
