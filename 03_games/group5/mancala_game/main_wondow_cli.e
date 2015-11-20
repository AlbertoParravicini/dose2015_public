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

		do

			print ("WELCOME TO MANCALA CLI%N%N")


				-- SUPPORTED ALGORITHMS
			create l_adversary_algorithms.make_from_array (<<"minimax","minimax_ab","negascout","two_players">>)
			create l_solitaire_algorithms.make_from_array (<<"cycle_checking_df","A_star">>)



				-- MODE SELECTION
			from
				print ("Select a game mode:%N 1: Solitaire%N 2: Adversary%N")
				exit_from_loop := false
			until
				exit_from_loop
			loop
				io.read_line
				io.last_string.to_lower
				if io.last_string.is_equal ("1") then
					l_algorithms := l_solitaire_algorithms
					exit_from_loop := true
				elseif io.last_string.is_equal ("2") then
					l_algorithms := l_adversary_algorithms
					exit_from_loop := true
				else
					print ("ERROR: " + io.last_string + " is not a valid game mode!%N")
				end
			end

			print ("%N")



				-- ALGHORITHM SELECTION
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
				if 1 <= io.last_string.to_integer and io.last_string.to_integer <= l_algorithms.count then
					print(l_algorithms.i_th (io.last_string.to_integer) + " SELECTED")
					exit_from_loop := true
				else
					print ("ERROR: " + io.last_string + " is not a valid alghorithm!%N")
				end
			end
		end

end
