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
			engine_s: SEARCH_ENGINE [ACTION, SOLITAIRE_STATE, SOLITAIRE_PROBLEM]
			engine_a: ADVERSARY_SEARCH_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]
			initial_state_a: ADVERSARY_STATE
			adversary_rule_set: ADVERSARY_RULE_SET
			players: ARRAYED_LIST [PLAYER]
			current_state_s: SOLITAIRE_STATE
			first_move_done: BOOLEAN
			i: INTEGER
			current_state_a: ADVERSARY_STATE
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

				---------------SOLITAIRE--------------------------------------------------------------------------------
			if problem_s /= void then
				print ("SOLITAIRE MANCALA%N")
				print (problem_s.initial_state.out)

					-- First move
				from
					current_state_s := problem_s.initial_state
					first_move_done := false
				until
					first_move_done = true
				loop
					print ("Enter a move between 1 and " + {GAME_CONSTANTS}.num_of_holes.out + "%N")
					print ("If you are stuck, ask for a hint (H),%N%Tor let the computer solve the game for you (S)!%N")
					io.read_line
					io.last_string.to_lower
					if io.last_string.is_integer and then (io.last_string.to_integer >= 1 and io.last_string.to_integer <= {GAME_CONSTANTS}.num_of_holes) then
						current_state_s := create {SOLITAIRE_STATE}.make_from_parent_and_rule (current_state_s, create {ACTION_SELECT}.make (io.last_string.to_integer))
						first_move_done := true
					elseif io.last_string.is_equal ("h") or io.last_string.is_equal ("hint") then
						print ("Searching for the best move...%N")
						engine_s.reset_engine
						engine_s.perform_search
						if engine_s.is_search_successful then
							print ("The search was successful!%N")
							current_state_s := engine_s.path_to_obtained_solution.at (2)
							first_move_done := true
						else
							print ("The search wasn't successful!%N")
						end
					elseif io.last_string.is_equal ("s") or io.last_string.is_equal ("solve") then
						print ("Trying to solve the game...%N")
						engine_s.reset_engine
						engine_s.perform_search
						if engine_s.is_search_successful then
							print ("The search was successful!%N")
							from
								i := 1
							until
								i > engine_s.path_to_obtained_solution.count - 1
							loop
								print (engine_s.path_to_obtained_solution.i_th (i).out + "%N%N")
								engine_s.path_to_obtained_solution.forth
								i := i + 1
							end
							first_move_done := true
							current_state_s := engine_s.path_to_obtained_solution.last
						else
							print ("The search wasn't successful!%N")
						end
					else
						print ("ERROR: " + io.last_string + " isn't a valid move!%N")
					end
				end
				print (current_state_s.out + "%N%N")

					-- Other moves
				from
				until
					problem_s.is_successful (current_state_s) or current_state_s.is_game_over
				loop
					print ("Do you want to move clockwise (A) or counter-clockwise (D)?%N")
					print ("If you are stuck, ask for a hint (H),%N%Tor let the computer solve the game for you (S)!%N")
					io.read_line
					io.last_string.to_lower
					if io.last_string.is_equal ("a") then
						current_state_s := create {SOLITAIRE_STATE}.make_from_parent_and_rule (current_state_s, create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).clockwise))
						current_state_s.move_clockwise
						print ("%NRotation: Clockwise%N" + current_state_s.out + "%N%N")
					elseif io.last_string.is_equal ("d") then
						current_state_s := create {SOLITAIRE_STATE}.make_from_parent_and_rule (current_state_s, create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).counter_clockwise))
						current_state_s.move_counter_clockwise
						print ("%NRotation: Counter-Clockwise%N" + current_state_s.out + "%N%N")
					elseif io.last_string.is_equal ("h") or io.last_string.is_equal ("hint") then
						print ("Searching for the best move...%N")
						current_state_s.set_parent (void)
						current_state_s.set_rule_applied (void)
						problem_s.make_with_initial_state (current_state_s)
						engine_s.set_problem (problem_s)
						engine_s.reset_engine
						engine_s.perform_search
						if engine_s.is_search_successful then
							print ("The search was successful!%N%N")
							current_state_s := engine_s.path_to_obtained_solution.at (2)
							print (current_state_s.rule_applied.out + "%N" + current_state_s.out + "%N%N")
						else
							print ("The search wasn't successful!%N")
						end
					elseif io.last_string.is_equal ("s") or io.last_string.is_equal ("solve") then
						print ("Trying to solve the game...%N")
						current_state_s.set_parent (void)
						current_state_s.set_rule_applied (void)
						problem_s.make_with_initial_state (current_state_s)
						engine_s.set_problem (problem_s)
						engine_s.reset_engine
						engine_s.perform_search
						if engine_s.is_search_successful then
							print ("The search was successful!%N%N")
							from
								i := 2
								print ("solition depth:" + engine_s.path_to_obtained_solution.count.out + "%N")
							until
								i > engine_s.path_to_obtained_solution.count
							loop
								if engine_s.path_to_obtained_solution.i_th (i).rule_applied /= void then
									print (engine_s.path_to_obtained_solution.i_th (i).rule_applied.out + "%N")
								end
								print (engine_s.path_to_obtained_solution.i_th (i).out + "%N%N")
								engine_s.path_to_obtained_solution.forth
								i := i + 1
							end
							current_state_s := engine_s.path_to_obtained_solution.last
						else
							print ("The search wasn't successful!%N")
						end
					else
						print ("ERROR: " + io.last_string + " isn't a valid move!%N")
					end
				end
				if current_state_s.is_game_over then
					print ("GAME OVER!%N")
				else
					print ("YOU WON!%N")
				end

					--------------------------------------------------------------------------------------------------------

					---------------ADVERSARY GAME---------------------------------------------------------------------------

			elseif problem_a /= void then
				print ("ADVERSARY MANCALA%N")
				print (initial_state_a.out)
				create adversary_rule_set.make_by_state (initial_state_a)
				from
					current_state_a := initial_state_a
				until
					problem_a.is_end (current_state_a)
				loop
					if current_state_a.index_of_current_player = 1 then
						print ("It's your turn: insert which hole you want to empty, from 1 to " + ({GAME_CONSTANTS}.num_of_holes // 2).out + "%N%N")
						io.read_line
						io.last_string.to_lower

						if valid_range_input(io.last_string) and adversary_rule_set.is_valid_action (current_state_a.current_player.name, create {ACTION_SELECT}.make (io.last_string.to_integer)) then
							current_state_a := adversary_rule_set.get_current_state
							print (current_state_a.out + "%N")

						elseif io.last_string.is_equal ("h") or io.last_string.is_equal ("hint") then

							print ("Searching for the best move...%N")
							current_state_a.set_parent (void)
							current_state_a.set_rule_applied (void)
							engine_a.reset_engine
							engine_a.perform_search (current_state_a)
							print ("Solution found!%N")
							current_state_a := engine_a.obtained_successor
							print (current_state_a.out + "%N")

						elseif io.last_string.is_equal ("s") or io.last_string.is_equal ("solve") then

							from
							until
								problem_a.is_end (current_state_a)
							loop
								engine_a.reset_engine
								engine_a.perform_search (current_state_a)
								print ("Solution found!%N")
								current_state_a := engine_a.obtained_successor
								print (current_state_a.out + "%N")
							end
						else
							print ("ERROR: " + io.last_string + " isn't a valid move!%N")
						end
					else
						engine_a.reset_engine
						engine_a.perform_search (current_state_a)
						print (engine_a.obtained_successor.out + "%N")
						current_state_a := engine_a.obtained_successor
					end
				end
				print ("%N%NGG%N")
				if current_state_a.players.at (1).score > current_state_a.players.at (2).score then
					print (current_state_a.players.at (1).name + " WON!%N")
				elseif current_state_a.players.at (1).score < current_state_a.players.at (2).score then
					print (current_state_a.players.at (2).name + " WON!%N")
				else
					print ("IT'S A DRAW!%N")
				end
			else
				print ("ERROR: WHAT THE FUCK IS GOING ON?%N")
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

		valid_range_input (a_hole_selected: STRING): BOOLEAN
			do
				if not a_hole_selected.is_integer then
					Result := false
				else
					if 0 < a_hole_selected.to_integer and a_hole_selected.to_integer <= {GAME_CONSTANTS}.num_of_holes then
						Result := true
					else
						Result := false
					end
				end
			end

		--first_window: MAIN_WINDOW
		-- Main window.

end -- class APPLICATION
