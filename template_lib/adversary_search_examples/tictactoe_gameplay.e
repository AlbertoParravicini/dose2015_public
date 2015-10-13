note
	description: "Summary description for {TICTACTOE_GAMEPLAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TICTACTOE_GAMEPLAY

create
	make

feature -- Initialisation

	make
		local
			engine: MINIMAX_ENGINE[STRING, TICTACTOE_STATE, TICTACTOE]
			problem: TICTACTOE
			initial_state: TICTACTOE_STATE
			current_state: TICTACTOE_STATE
		do
			create initial_state.make
			create problem.make
			create engine.make_with_depth (problem, 6)
			engine.perform_search (initial_state)
			print ("Obtained value: " + engine.obtained_value.out + "%N")
			print ("Obtained state: %N" + engine.obtained_successor.out + "%N")
			from
				current_state := engine.obtained_successor
			until
				problem.is_end (current_state)
			loop
				engine.reset_engine
				engine.perform_search (current_state)
			    print ("Obtained value: " + engine.obtained_value.out + "%N")
			    print ("Obtained state: %N" + engine.obtained_successor.out + "%N")
				current_state := engine.obtained_successor
			end
		end

note
	copyright: "Copyright (c) 2015, UNRC"
	license: "MIT License (see http://...)"
	source: "[
		Dpto. de Computacion, FCEFQyN
		Universidad Nacional de Rio Cuarto
		Ruta Nacional No. 36 Km 601
		Rio Cuarto (5800), Cordoba, Argentina
		Telephone +54 358 4676235
	]"

end
