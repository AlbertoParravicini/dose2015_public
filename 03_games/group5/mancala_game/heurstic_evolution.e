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

	max_num_of_epochs: INTEGER = 300
		-- Number of iterations of the breeding process;

	thread_1: HEURISTIC_THREAD
	thread_2: HEURISTIC_THREAD



feature
	make
		local
			winner_player_game_1: INTEGER
			winner_player_game_2: INTEGER
			overall_winner: INTEGER

			winner_list: LINKED_LIST[INTEGER]

			random_winner: INTEGER
			sum: REAL_64
			n: INTEGER
		do

			create math.make
			create winner_list.make

				-- Initialize the first weights list as default;
			print ("v1: ")
			weights_1 := math.initialize_weights
			weights_1 := math.log_normal_weights (weights_1)
			weights_1 := math.normalize_weights (weights_1)


			--create weights_1.make_from_array (<<[0.19, 0.02], [0.0, 0.02], [0.22, 0.02], [0.47, 0.02], [0.10, 0.02], [0.0, 0.02]>>)

			math.print_weights (weights_1)

				-- Initialize the second weights list based on the first one;

			--create weights_2.make_from_array (<<[0.19, 0.02], [0.0, 0.02], [0.22, 0.02], [0.47, 0.02], [0.10, 0.02], [0.0, 0.02]>>)
			print ("v2: ")
			weights_2 := math.initialize_weights
			weights_2 := math.log_normal_weights (weights_2)
			weights_2 := math.generate_gaussian_weights (weights_2)
			weights_2 := math.log_normal_weights (weights_2)

			--weights_2 := math.generate_uniform_weights (weights_2)
			weights_2 := math.normalize_weights (weights_2)


			math.print_weights (weights_2)


			round_robin
			print ("%N--------------------------------------------%N")
			print ("%N--------------------------------------------%N")
			print ("%N--------------------------------------------%N")

			from
				epoch := 0
			until
				epoch = max_num_of_epochs
			loop
				create thread_1.make_with_weights (weights_1, weights_2)
				create thread_2.make_with_weights (weights_2, weights_1)

				print ("%N--------------------------------------------%N")
				print ("EPOCH NUMBER: " + epoch.out + "%N")
					-- Play two games: each game has a different starting player;


					-- Use "execute" to start the threads as normal classes, without multi-threading:
					-- this is necessary to avoid conflicts in I/O operations.
					-- Use "launch" otherwise;
				create thread_1.make_with_weights (weights_1, weights_2)
				create thread_2.make_with_weights (weights_2, weights_1)

				thread_1.execute
				thread_2.execute
				join_all

				winner_player_game_1 := thread_1.winner
				winner_player_game_2 := thread_2.winner

						-- Get the best weights list among the two;
				overall_winner := evaluate_overall_winner (winner_player_game_1, winner_player_game_2)


				--print ("SCORE: " + winner_player_game_1.out + ", " + winner_player_game_2.out + "%N")
				if overall_winner = 1 or overall_winner = 2 then
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
					weights_2 := math.breed_weights (weights_1, weights_2)
					--weights_2 := math.breed_uniform_weights (weights_1, weights_2)
					print_results (weights_1, weights_2)


				when 2 then
					weights_1 := math.breed_weights (weights_2, weights_1)
					--weights_1 := math.breed_uniform_weights (weights_2, weights_1)
					print_results (weights_2, weights_1)
				when 0 then


					if random_winner = 1 then
						weights_2 := math.breed_weights (weights_1, weights_2)
						--weights_2 := math.breed_uniform_weights (weights_1, weights_2)
						print_results (weights_1, weights_2)
					else
						weights_1 := math.breed_weights (weights_2, weights_1)
						--weights_1 := math.breed_uniform_weights (weights_2, weights_1)
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

	round_robin
			-- Execute a round-robin tournament between a certain number of weights, specified below;
		local
			k: INTEGER
			j: INTEGER
			victories: LINKED_LIST[INTEGER]
			curr_winner: INTEGER
			weights_list: LINKED_LIST[ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]]
		do
			create weights_list.make
			weights_list.extend (math.initialize_weights)

			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.41, 2.0], [0.0, 2.0], [0.22, 2.0], [0.11, 2.0], [0.0, 2.0], [0.25, 2.0]>>))
			--weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.53, 2.0], [0.21, 2.0], [0.24, 2.0], [0.0, 2.0], [0.0, 2.0], [0.0, 2.0]>>))
			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.19, 2.0], [0.0, 2.0], [0.22, 2.0], [0.47, 2.0], [0.10, 2.0], [0.0, 2.0]>>))
--			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.36, 2.0], [0.17, 2.0], [0.12, 2.0], [0.05, 2.0], [0.14, 2.0], [0.13, 2.0]>>))
--			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.17, 2.0], [0.04, 2.0], [0.29, 2.0], [0.30, 2.0], [0.04, 2.0], [0.12, 2.0]>>))
--			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.4, 2.0], [0.23, 2.0], [0.21, 2.0], [0.14, 2.0], [0.001, 2.0], [0.0, 2.0]>>))
			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.24, 2.0], [0.23, 2.0], [0.20, 2.0], [0.16, 2.0], [0.07, 2.0], [0.07, 2.0]>>))
--			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.25, 2.0], [0.1, 2.0], [0.1, 2.0], [0.06, 2.0], [0.16, 2.0], [0.29, 2.0]>>))
--			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[0.15, 2.0], [0.12, 2.0], [0.14, 2.0], [0.12, 2.0], [0.14, 2.0], [0.29, 2.0]>>))


			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[1.0, 2.0], [0.0, 2.0], [1.0, 2.0], [0.0, 2.0], [0.0, 2.0], [0.0, 2.0]>>))
			weights_list.extend (create {ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]}.make_from_array (<<[1.0, 2.0], [1.0, 2.0], [1.0, 2.0], [1.0, 2.0], [0.0, 2.0], [1.0, 2.0]>>))


			from
				create victories.make
				weights_list.start
			until
				weights_list.exhausted
			loop
				victories.extend (0)
				weights_list.forth
			end

			from
				k := 1
			until
				k > weights_list.count
			loop
				from
					j := k
				until
					j > weights_list.count
				loop
					if k /= j then
						create thread_1.make_with_weights (weights_list.i_th (k), weights_list.i_th (j))
						create thread_2.make_with_weights (weights_list.i_th (j), weights_list.i_th (k))
						print_weights (weights_list.i_th (k))
						print (" VS ")
						print_weights (weights_list.i_th (j))
						thread_1.launch
						thread_2.launch

						join_all

							-- Get the best weights list among the two;
						curr_winner := evaluate_overall_winner (thread_1.winner, thread_2.winner)
						print ("OVERALL WINNER: " + curr_winner.out + "%N%N")

						if curr_winner = 1 then
							victories.i_th (k) := victories.i_th (k) + 1
						elseif curr_winner = 2 then
							victories.i_th (j) := victories.i_th (j) + 1
						end
					end
					j := j + 1
				end
				k := k + 1
			end


			from
				weights_list.start
			until
				weights_list.exhausted
			loop
				print ("victories: " + victories.item.out + "%N")
				print_weights (weights_list.item)
				weights_list.forth
				victories.forth
			end
		end
end
