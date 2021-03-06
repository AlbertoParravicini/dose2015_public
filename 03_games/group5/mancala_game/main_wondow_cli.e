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

			view: VIEW
			game_manager: GAME_MANAGER

			l_algorithm_depth: INTEGER
			l_algorithms_with_depth: ARRAYED_LIST[STRING]

		do
			print ("----------------------------------%N")
			print ("WELCOME TO MANCALA - CLI INTERFACE%N")
			print ("----------------------------------%N%N")


				-- SUPPORTED ALGORITHMS
			l_adversary_algorithms := (create {GAME_CONSTANTS}.default_create).adversary_algorithms
			l_solitaire_algorithms :=  (create {GAME_CONSTANTS}.default_create).solitaire_algorithms
			l_algorithms_with_depth :=  (create {GAME_CONSTANTS}.default_create).algorithms_with_depth
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
				if io.last_string.is_integer and then io.last_string.to_integer >= 0 then
					l_algorithm_depth := io.last_string.to_integer
				else
					print (io.last_string + " isn't a valid depth!%N")
				end
			end


				-- INTERFACE CREATION
			if selected_mode.is_equal ("solitaire") then
				view := create {SOLITAIRE_VIEW_CLI}.make
			elseif selected_mode.is_equal ("adversary")	then
				view := create {ADVERSARY_VIEW_CLI}.make
			else
				print ("ERROR")
			end

			create game_manager.make (selected_algorithm, l_algorithm_depth, view)
			view.start_view (game_manager)

		end
end
