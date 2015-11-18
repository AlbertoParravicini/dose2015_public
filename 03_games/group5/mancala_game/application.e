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
			mode_selected: BOOLEAN
			algorithm_selected: BOOLEAN
			problem_s: SOLITAIRE_PROBLEM
			problem_a: ADVERSARY_PROBLEM
			engine_s: SEARCH_ENGINE[ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]
			engine_a: ADVERSARY_SEARCH_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]
			initial_state_a: ADVERSARY_STATE
			players: ARRAYED_LIST [PLAYER]
		do
--------------------------------------------------------------------------------------------------------
			print ("WELCOME TO MANCALA%N%N")
			from
				mode_selected := false
				print ("Select a game mode:%N 1: Solitaire%N 2: Adversary%N")
			until
				mode_selected = true
			loop
				io.read_line
				io.last_string.to_lower
				if io.last_string.is_equal ("1") or io.last_string.is_equal ("solitaire") then
					create problem_s.make
					mode_selected := true
				elseif io.last_string.is_equal ("2") or io.last_string.is_equal ("adversary") then
					create problem_a.make
					create players.make (2)
					players.extend (create {HUMAN_PLAYER}.make_with_initial_values ("pippo", 0))
					players.extend (create {HUMAN_PLAYER}.make_with_initial_values ("pluto", 0))
					create initial_state_a.make (players)
					mode_selected := true
				else
					print ("ERROR: " + io.last_string + " is not a valid game mode!%N")
				end
			end

--------------------------------------------------------------------------------------------------------
			if problem_s /= void then
				from
					algorithm_selected := false
					print ("%NSelect a single state search algorithm:%N 1.Cycle checking depth fist search%N 2. A*%N Other algorithms coming soon...%N")
				until
					algorithm_selected = true
				loop
					io.read_line
					io.last_string.to_lower
					if io.last_string.is_equal ("1") then
						engine_s := create {CYCLE_CHECKING_DEPTH_FIRST_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem_s)
						algorithm_selected := true
					elseif io.last_string.is_equal ("2") then
						engine_s := create {A_STAR_SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]}.make (problem_s)
						algorithm_selected := true
					else
						print ("ERROR: " + io.last_string + " is not a valid algorithm!%N")
					end
				end
			elseif problem_a /= void then
				from
					algorithm_selected := false
					print ("%NSelect an adversary search algorithm:%N 1. Minimax%N 2. Minimax with Alfa-Beta pruning%N 3. Negascout%N")
				until
					algorithm_selected = true
				loop
					io.read_line
					io.last_string.to_lower
					if io.last_string.is_equal ("1") then
						engine_a := create {MINIMAX_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make (problem_a)
						algorithm_selected := true
					elseif io.last_string.is_equal ("2") then
						engine_a := create {MINIMAX_AB_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make (problem_a)
						algorithm_selected := true
					elseif io.last_string.is_equal ("3") then
						engine_a := create {NEGASCOUT_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make (problem_a)
						algorithm_selected := true
					else
						print ("ERROR: " + io.last_string + " is not a valid algorithm!%N")
					end
				end
			else
				print ("ERROR: WHAT THE FUCK IS GOING ON?%N")
			end
--------------------------------------------------------------------------------------------------------


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
