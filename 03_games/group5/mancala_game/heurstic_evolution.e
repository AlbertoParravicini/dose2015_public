note
	description: "Class which allows the heuristic of the game to evolve itself through a tournament-based genetic algorithm."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HEURISTIC_EVOLUTION

inherit
	THREAD_CONTROL

create
	make

feature -- Attributes

	math: HEURISTIC_FUNCTIONS_SUPPORT




	i: INTEGER



	weights_1: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]
	weights_2: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]

	epoch: INTEGER
		-- Current epoch of the breeding process;

	max_num_of_epochs: INTEGER = 100
		-- Number of iterations of the breeding process;

	thread_1: HEURISTIC_THREAD
	thread_2: HEURISTIC_THREAD



feature
	make
		local
			winner_player_game_1: INTEGER
			winner_player_game_2: INTEGER
			overall_winner: INTEGER

			random_winner: INTEGER
			sum: REAL_64
		do

			create math.make

				-- Initialize the first weights list as default;
			weights_1 := math.initialize_weights
			weights_2 := math.initialize_weights

			create thread_1.make_with_weights (weights_1, weights_2)
			create thread_2.make_with_weights (weights_2, weights_1)

			print ("v1: ")
			print_weights (weights_1)

				-- Initialize the second weights list based on the first one;
			--create weights_2.make_from_array (<<[0.173409, 2.0], [0.551606, 2.0], [0.209192, 2.0], [0.0, 2.0], [0.0, 2.0], [0.0657929, 2.0]>>)

			--weights_2 := math.generate_gaussian_weights (weights_2)
			--weights_2 := math.log_normal_weights (weights_2)

			weights_2 := math.generate_uniform_weights (weights_2)
			weights_2 := math.normalize_weights (weights_2)

			print ("v2: ")
			print_weights (weights_2)


			from
				epoch := 0
			until
				epoch = max_num_of_epochs
			loop
				print ("%N--------------------------------------------%N")
				print ("EPOCH NUMBER: " + epoch.out + "%N")
					-- Play two games: each game has a different starting player;

				thread_1.execute
				thread_2.execute
				print("waiting")
				join_all

				winner_player_game_1 := thread_1.winner

				winner_player_game_2 := thread_2.winner

					-- Get the best weights list among the two;
				overall_winner := evaluate_overall_winner (winner_player_game_1, winner_player_game_2)

				print ("SCORE: " + winner_player_game_1.out + ", " + winner_player_game_2.out + "%N")
				if overall_winner = 1 or overall_winner = 2 then
					print ("%N%NOVERALL WINNER: " + overall_winner.out + "%N%N")
					print ("%N%NOVERALL WINNER: " + overall_winner.out + "%N%N")
				else
					random_winner := (math.random_number_generator.item \\ 2) + 1
					math.random_number_generator.forth
					print ("%N%NRANDOM WINNER: " + random_winner.out + "%N%N")
				end



					-- Breed the new weights;
				inspect overall_winner
				when 1 then
					-- Weights_1 is the winner
					--weights_2 := math.breed_weights (weights_1, weights_2)
					weights_2 := math.breed_uniform_weights (weights_1, weights_2)
					print_results (weights_1, weights_2)


				when 2 then
					--weights_1 := math.breed_weights (weights_2, weights_1)
					weights_1 := math.breed_uniform_weights (weights_2, weights_1)
					print_results (weights_2, weights_1)
				when 0 then


					if random_winner = 1 then
						--weights_2 := math.breed_weights (weights_1, weights_2)
						weights_2 := math.breed_uniform_weights (weights_1, weights_2)
						print_results (weights_1, weights_2)
					else
						--weights_1 := math.breed_weights (weights_2, weights_1)
						weights_1 := math.breed_uniform_weights (weights_2, weights_1)
						print_results (weights_2, weights_1)
					end

				else
					print ("%N%NERROR: CAN'T BREED!%N%N")
				end

				epoch := epoch + 1
			end
		end



	evaluate_overall_winner (game_1_winner: INTEGER; game_2_winner: INTEGER): INTEGER
			-- Calculate the overall winner, if any, of the two games that were played.
			-- The winner is given not in terms of winning player, but in term of winning weights;
		do
			if not ((game_1_winner = 0 or game_1_winner = 1 or game_1_winner = 2) and (game_2_winner = 0 or game_2_winner = 1 or game_2_winner = 2))  then
				Result := -1
			elseif game_1_winner = game_2_winner then
				Result := 0
			else
				inspect game_1_winner
				when 1 then
					Result := 1
				when 2 then
					Result := 2
				when 0 then
					Result := (game_2_winner \\ 2) + 1
				else
					Result := -1
				end
			end
		end

	print_weights (a_weights: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]])
			-- Print the given weights;
		local
			output : PLAIN_TEXT_FILE
		do
			from
				a_weights.start
				create output.make_open_append ("out.txt")

				print ("[ ")
			until
				a_weights.islast
			loop
				print (a_weights.item.weight.truncated_to_real.out + ", ")
				output.put_string (a_weights.item.weight.truncated_to_real.out + ", ")
				a_weights.forth
			end
				output.put_string (a_weights.item.weight.truncated_to_real.out + "%N")
				print (a_weights.item.weight.truncated_to_real.out + "%N")
				print ("]%N%N")
		end

	print_results (current_winner: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]; bred_weights: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]])
			-- Print the current best weights and the newly bred weights;
		do
			print ("CURRENT WINNER: ")
			print_weights (current_winner)
			print ("%TBRED_VECTOR: %N")
			math.print_weights (bred_weights)
		end

invariant
	not weights_1.is_equal (weights_2)
end
