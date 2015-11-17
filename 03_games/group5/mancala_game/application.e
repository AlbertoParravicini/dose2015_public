note
	description: "Root class for Mancala Game."
	author: "DOSE 2015 Group 5"
	date: "$Date: 2015/11/11 8:39:15 $"
	revision: "1.0.0"

class
	APPLICATION

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
		local
			players: ARRAYED_LIST [PLAYER]
			state: ADVERSARY_STATE
			moves_array: ARRAYED_LIST[INTEGER]
			engine: NEGASCOUT_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]
			problem: ADVERSARY_PROBLEM
			current_state: ADVERSARY_STATE
			initial_state: ADVERSARY_STATE
		do
			create players.make (2)
			players.extend (create {HUMAN_PLAYER}.make)
			players.extend (create {AI_PLAYER}.make)

		-- 			AI VS AI GAME:
			create players.make (2)
			players.extend (create {HUMAN_PLAYER}.make_with_initial_values("pippo", 0))
			players.extend (create {HUMAN_PLAYER}.make_with_initial_values("pluto", 0))
			create initial_state.make (players)
			create problem.make
			create engine.make (problem)

			engine.set_start_from_best (true)

			print(initial_state.out + "%N")

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

	prepare
			-- Prepare the first window to be displayed.
			-- Perform one call to first window in order to
			-- avoid to violate the invariant of class EV_APPLICATION.
		do
				-- create and initialize the first window.
			--create first_window

				-- Show the first window.
				--| TODO: Remove this line if you don't want the first
				--|       window to be shown at the start of the program.
			--first_window.show
		end

feature {NONE} -- Implementation

	--first_window: MAIN_WINDOW
			-- Main window.

end -- class APPLICATION
