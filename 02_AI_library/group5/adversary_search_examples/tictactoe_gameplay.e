note
	description: "Summary description for {TICTACTOE_GAMEPLAY}."
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

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


end
