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

			engine_s: CYCLE_CHECKING_DEPTH_FIRST_SEARCH_ENGINE[ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]
			problem_s: SOLITAIRE_PROBLEM
			initial_state_s: SOLITAIRE_STATE
			path: LIST [SOLITAIRE_STATE]
			i: INTEGER
		do
			create players.make (2)
			players.extend (create {HUMAN_PLAYER}.make)
			players.extend (create {AI_PLAYER}.make)

-- 					AI VS AI GAME:
---------------------------------------------------------------
--			create players.make (2)
--			players.extend (create {HUMAN_PLAYER}.make_with_initial_values("pippo", 0))
--			players.extend (create {HUMAN_PLAYER}.make_with_initial_values("pluto", 0))
--			create initial_state.make (players)
--			create problem.make
--			create engine.make (problem)

--			engine.set_max_depth (3)

--			print(initial_state.out + "%N")

--			engine.perform_search (initial_state)
--			print ("Obtained value: " + engine.obtained_value.out + "%N")
--			print ("Obtained state: %N" + engine.obtained_successor.out + "%N")
--			from
--				current_state := engine.obtained_successor
--			until
--				problem.is_end (current_state)
--			loop
--				engine.reset_engine
--				engine.perform_search (current_state)
--				print ("Obtained value: " + engine.obtained_value.out + "%N")
--				print ("Obtained state: %N" + engine.obtained_successor.out + "%N")
--				current_state := engine.obtained_successor
--			end


--					SOLITAIRE:
---------------------------------------------------------------

		create problem_s.make
			create engine_s.make (problem_s)

			print (problem_s.initial_state.out + "%N%N")

			engine_s.perform_search



				if (engine_s.is_search_successful) then
					print ("solution found: " + engine_s.obtained_solution.out + " sat depth " + engine_s.path_to_obtained_solution.count.out + ".%N")
					print ("visited states: " + engine_s.nr_of_visited_states.out + "%N")
					print ("path to solution: %N")
					from
						i := 1
						path := engine_s.path_to_obtained_solution
					until
						i > path.count
					loop
						if path.i_th (i).rule_applied /= Void then
								-- skips the first state that has void rule
							print ("    " + path.i_th (i).rule_applied.out + "%N")
						end
						print (path.i_th (i).out + "%N")
						i := i + 1
					end

				else
					print ("no solution found%N")
					print ("visited states: " + engine_s.nr_of_visited_states.out + "%N")
				--	curr_depth := curr_depth + 1
					engine_s.reset_engine



					-- engine.set_max_depth (curr_depth)
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
