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
			problem_a: ADVERSARY_PROBLEM
			engine_a: ADVERSARY_SEARCH_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]
			initial_state_a: ADVERSARY_STATE
			adversary_rule_set: ADVERSARY_RULE_SET
			players: ARRAYED_LIST [PLAYER]
			current_state_s: SOLITAIRE_STATE
			first_move_done: BOOLEAN
			i: INTEGER
			current_state_a: ADVERSARY_STATE
			solitaire_rule_set: SOLITAIRE_RULE_SET

			selected_algorithm_string: STRING
			mode_selected_string: STRING
			initial_state_s: SOLITAIRE_STATE
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
					mode_selected_string := "solitaire"
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
			if mode_selected_string.is_equal ("solitaire") then
				from
					algorithm_selected := false
					print ("%NSelect a single state search algorithm:%N 1.Cycle checking depth fist search%N 2. A*%N Other algorithms coming soon...%N")
				until
					algorithm_selected = true
				loop
					io.read_line
					io.last_string.to_lower
					if io.last_string.is_equal ("1") then
						selected_algorithm_string := "depth_first_with_cycle_checking"
						algorithm_selected := true
					elseif io.last_string.is_equal ("2") then
						selected_algorithm_string := "a_star"
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
			if mode_selected_string.is_equal ("solitaire") then
				print ("SOLITAIRE MANCALA%N")
				create initial_state_s.make
				create solitaire_rule_set.make_by_state (initial_state_s, selected_algorithm_string, -1)
				print (initial_state_s.out)


					-- First move
				from
					current_state_s := solitaire_rule_set.current_state
					first_move_done := false
				until
					first_move_done = true
				loop
					print ("Enter a move between 1 and " + {GAME_CONSTANTS}.num_of_holes.out + "%N")
					print ("If you are stuck, ask for a hint (H),%N%Tor let the computer solve the game for you (S)!%N")
					io.read_line
					io.last_string.to_lower
					if io.last_string.is_integer and then solitaire_rule_set.is_valid_action (1, create {ACTION_SELECT}.make (io.last_string.to_integer)) then
						current_state_s := solitaire_rule_set.current_state
						first_move_done := true
					elseif (io.last_string.is_equal ("h") or io.last_string.is_equal ("hint")) and then solitaire_rule_set.is_valid_action (1, create {ACTION_OTHER}.make ((create {ENUM_OTHER}).hint)) then
						print ("Searching for the best move...%N")
						if solitaire_rule_set.engine.is_search_successful then
							print ("The search was successful!%N")
							current_state_s := solitaire_rule_set.current_state
							first_move_done := true
						else
							print ("The search wasn't successful!%N")
						end
					elseif (io.last_string.is_equal ("s") or io.last_string.is_equal ("solve")) and then solitaire_rule_set.is_valid_action (1, create {ACTION_OTHER}.make ((create {ENUM_OTHER}).solve)) then
						print ("Trying to solve the game...%N")
						if solitaire_rule_set.engine.is_search_successful then
							print ("The search was successful!%N")
							from
								i := 1
							until
								i > solitaire_rule_set.engine.path_to_obtained_solution.count - 1
							loop
								print (solitaire_rule_set.engine.path_to_obtained_solution.i_th (i).out + "%N%N")
								solitaire_rule_set.engine.path_to_obtained_solution.forth
								i := i + 1
							end
							first_move_done := true
							current_state_s := solitaire_rule_set.engine.path_to_obtained_solution.last
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
					solitaire_rule_set.problem.is_successful (current_state_s) or current_state_s.is_game_over
				loop
					print ("Do you want to move clockwise (A) or counter-clockwise (D)?%N")
					print ("If you are stuck, ask for a hint (H),%N%Tor let the computer solve the game for you (S)!%N")
					io.read_line
					io.last_string.to_lower
					if io.last_string.is_equal ("a") and solitaire_rule_set.is_valid_action (1, create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).clockwise)) then
						current_state_s := solitaire_rule_set.current_state
						print ("%NRotation: Clockwise%N" + current_state_s.out + "%N%N")
					elseif io.last_string.is_equal ("d") and solitaire_rule_set.is_valid_action (1, create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).counter_clockwise)) then
						current_state_s := solitaire_rule_set.current_state
						print ("%NRotation: Counter-Clockwise%N" + current_state_s.out + "%N%N")
					elseif (io.last_string.is_equal ("h") or io.last_string.is_equal ("hint")) and then solitaire_rule_set.is_valid_action (1, create {ACTION_OTHER}.make ((create {ENUM_OTHER}).hint)) then
						print ("Searching for the best move...%N")

						if solitaire_rule_set.engine.is_search_successful  then
							print ("The search was successful!%N%N")
							current_state_s := solitaire_rule_set.engine.path_to_obtained_solution.at (2)
							print (current_state_s.rule_applied.out + "%N" + current_state_s.out + "%N%N")
						else
							print ("The search wasn't successful!%N")
						end
					elseif (io.last_string.is_equal ("s") or io.last_string.is_equal ("solve")) and then solitaire_rule_set.is_valid_action (1, create {ACTION_OTHER}.make ((create {ENUM_OTHER}).solve)) then
						print ("Trying to solve the game...%N")

						if solitaire_rule_set.engine.is_search_successful then
							print ("The search was successful!%N%N")
							from
								i := 2
								print ("solition depth:" + solitaire_rule_set.engine.path_to_obtained_solution.count.out + "%N")
							until
								i > solitaire_rule_set.engine.path_to_obtained_solution.count
							loop
								if solitaire_rule_set.engine.path_to_obtained_solution.i_th (i).rule_applied /= void then
									print (solitaire_rule_set.engine.path_to_obtained_solution.i_th (i).rule_applied.out + "%N")
								end
								print (solitaire_rule_set.engine.path_to_obtained_solution.i_th (i).out + "%N%N")
								solitaire_rule_set.engine.path_to_obtained_solution.forth
								i := i + 1
							end
							current_state_s := solitaire_rule_set.engine.path_to_obtained_solution.last
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
				create adversary_rule_set.make_by_state (initial_state_a, "negascout", 5)
				from
					current_state_a := initial_state_a
				until
					problem_a.is_end (current_state_a)
				loop
					if current_state_a.index_of_current_player = 1 then
						print ("It's your turn: insert which hole you want to empty, from 1 to " + ({GAME_CONSTANTS}.num_of_holes // 2).out + "%N%N")
						io.read_line
						io.last_string.to_lower

							-- TODO: 1 => player_id
						if io.last_string.is_integer and then adversary_rule_set.is_valid_action (1, create {ACTION_SELECT}.make (io.last_string.to_integer)) then
							current_state_a := adversary_rule_set.current_state
							print (current_state_a.out + "%N")
							end
					end
				end
			end
		end

--	view_mode: MAIN_WINDOW_CLI


--	make
--		do
--			create view_mode.make_and_launch
--		end


feature {NONE} -- Implementation


		--first_window: MAIN_WINDOW
		-- Main window.

end -- class APPLICATION
