note
	description: "Summary description for {MAIN_WONDOW_CLI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAIN_WINDOW_CLI

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch

		local

			l_adversary_algorithms: ARRAYED_LIST[STRING]
			l_solitaire_algorithms: ARRAYED_LIST[STRING]
			l_algorithms: ARRAYED_LIST[STRING]
			l_algorithm: STRING

			exit_from_loop: BOOLEAN
			selected_mode: STRING
			selected_algorithm: STRING

			solitaire_view: SOLITAIRE_VIEW_CLI
			adversary_view: ADVERSARY_VIEW_CLI

			l_algorithm_depth: INTEGER
			l_algorithms_with_depth: ARRAYED_LIST[STRING]

		do
			print ("----------------------------------%N")
			print ("WELCOME TO MANCALA - CLI INTERFACE%N")
			print ("----------------------------------%N%N")


				-- SUPPORTED ALGORITHMS
			create l_adversary_algorithms.make_from_array (<<"minimax","minimax_ab","negascout">>)
			create l_solitaire_algorithms.make_from_array (<<"bounded_breadth_first_search","bounded_depth_first_search",
				"depth_first_with_cycle_checking","iterative_deepening","heuristic_depth_first_search","hill_climbing","steepest_ascent_hill_climbing",
				"lowest_cost_first_search", "best_first_search","a_star">>)

			create l_algorithms_with_depth.make_from_array (<<"minimax", "minimax_ab", "negascout", "bounded_breadth_first_search", "bounded_depth_first_search">>)
			l_algorithms_with_depth.compare_objects


				-- MODE SELECTION
			from
				print ("Select a game mode:%N 1: Solitaire%N 2: Adversary%N")
				exit_from_loop := false
			until
				exit_from_loop
			loop
				io.read_line
				io.last_string.to_lower
				if io.last_string.is_equal ("1") or io.last_string.is_equal ("solitaire") or io.last_string.is_equal ("s") then
					l_algorithms := l_solitaire_algorithms
					selected_mode := "solitaire"
					exit_from_loop := true
				elseif io.last_string.is_equal ("2") or io.last_string.is_equal ("adversary") or io.last_string.is_equal ("a") then
					l_algorithms := l_adversary_algorithms
					selected_mode := "adversary"
					exit_from_loop := true
				else
					print ("ERROR: " + io.last_string + " is not a valid game mode!%N")
				end
			end

			print ("%N")



				-- ALGORITHM SELECTION
			from
				print ("Select an alghorithm:%N")
				exit_from_loop := false
			until
				exit_from_loop
			loop

				from
					l_algorithms.start
				until
					l_algorithms.exhausted
				loop
					print(" " + l_algorithms.index.out + ": " + l_algorithms.item + "%N")
					l_algorithms.forth
				end

				io.read_line
				if io.last_string.is_integer and then (1 <= io.last_string.to_integer and io.last_string.to_integer <= l_algorithms.count) then
					selected_algorithm := l_algorithms.i_th (io.last_string.to_integer)
					print(selected_algorithm.out + " SELECTED%N")
					exit_from_loop := true
				else
					print ("ERROR: " + io.last_string + " is not a valid alghorithm!%N")
				end
			end

				-- POSSIBLE DEPTH SELECTION
			if l_algorithms_with_depth.has (selected_algorithm) then
				print ("%NSet the depth of the algorithm:%N")
				io.read_line
				io.last_string.to_lower
				if io.last_string.is_integer and then io.last_string.to_integer > 0 then
					l_algorithm_depth := io.last_string.to_integer
					print ("Depth chosen: " + l_algorithm_depth.out + "%N")
				else
					print (io.last_string + " isn't a valid depth!%N")
				end
			end


				-- INTERFACE CREATION
			if selected_mode.is_equal ("solitaire") then
				solitaire_view := create {SOLITAIRE_VIEW_CLI}.make_and_launch
			elseif selected_mode.is_equal ("adversary")	then
				adversary_view := create {ADVERSARY_VIEW_CLI}.make_and_launch
			else
				print ("ERROR")
			end
		end


--	if mode_selected_string.is_equal ("solitaire") then
--				from
--					algorithm_selected := false
--					print ("%NSelect a single state search algorithm:%N 1.Cycle checking depth fist search%N 2. A*%N Other algorithms coming soon...%N")
--				until
--					algorithm_selected = true
--				loop
--					io.read_line
--					io.last_string.to_lower
--					if io.last_string.is_equal ("1") then
--						selected_algorithm_string := "depth_first_with_cycle_checking"
--						algorithm_selected := true
--					elseif io.last_string.is_equal ("2") then
--						selected_algorithm_string := "a_star"
--						algorithm_selected := true
--					else
--						print ("ERROR: " + io.last_string + " is not a valid algorithm!%N")
--					end
--				end
--			elseif mode_selected_string.is_equal ("adversary") then
--				from
--					algorithm_selected := false
--					print ("%NSelect an adversary search algorithm:%N 1. Minimax%N 2. Minimax with Alfa-Beta pruning%N 3. Negascout%N")
--				until
--					algorithm_selected = true
--				loop
--					io.read_line
--					io.last_string.to_lower
--					if io.last_string.is_equal ("1") then
--						selected_algorithm_string := "minimax"
--						algorithm_selected := true
--					elseif io.last_string.is_equal ("2") then
--						selected_algorithm_string := "minimax_ab"
--						algorithm_selected := true
--					elseif io.last_string.is_equal ("3") then
--						selected_algorithm_string := "negascout"
--						algorithm_selected := true
--					else
--						print ("ERROR: " + io.last_string + " is not a valid algorithm!%N")
--					end
--				end
--			else
--				print ("ERROR: WHAT THE FUCK IS GOING ON?%N")
--			end

end
