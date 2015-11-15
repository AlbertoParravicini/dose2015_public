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
			l_app: EV_APPLICATION


			problem: SOLITAIRE_PROBLEM
			engine: A_STAR_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]
			curr_depth: INTEGER
			found: BOOLEAN
			i: INTEGER
			path: LIST [SOLITAIRE_STATE]

		do


			create problem.make
			create engine.make (problem)
			engine.set_check_open_state (true)
			engine.set_mark_closed_state (true)

			print (problem.initial_state.out + "%N%N%N")
			engine.perform_search

			if (engine.is_search_successful) then
					print ("solution found: " + engine.obtained_solution.out + " sat depth " + engine.path_to_obtained_solution.count.out + ".%N")
					print ("visited states: " + engine.nr_of_visited_states.out + "%N")
					print ("path to solution: %N")
					from
						i := 1
						path := engine.path_to_obtained_solution
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
					found := True
				else
					print ("no solution found with depth " + curr_depth.out + ".%N")
					print ("visited states: " + engine.nr_of_visited_states.out + "%N")
					curr_depth := curr_depth + 1
					engine.reset_engine


					-- engine.set_max_depth (curr_depth)
				end


			create l_app
			prepare
			l_app.launch
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
