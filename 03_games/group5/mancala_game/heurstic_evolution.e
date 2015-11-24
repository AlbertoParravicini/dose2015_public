note
	description: "Class which allows the heuristic of the game to evolve itself through a tournament-based genetic algorithm."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HEURISTIC_EVOLUTION


create
	make

feature -- Attributes
	problem: ADVERSARY_PROBLEM
	math: HEURISTIC_FUNCTIONS_SUPPORT
	engine: MINIMAX_AB_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]

	current_state: ADVERSARY_STATE
	initial_state: ADVERSARY_STATE

	i: INTEGER

	players: ARRAYED_LIST [PLAYER]

	weights_1: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]
	weights_2: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]

	epoch: INTEGER
		-- Current epoch of the breeding process;

	max_num_of_epochs: INTEGER = 100
		-- Number of iterations of the breeding process;

	engine_depth: INTEGER = 4
		-- Depth of the engine;

feature
	make
		local
			winner_player_game_1: INTEGER
			winner_player_game_2: INTEGER
			overall_winner: INTEGER

			random_winner: INTEGER
			sum: REAL_64
		do
			create problem.make
			create players.make (2)
			players.extend (create {HUMAN_PLAYER}.make_with_initial_values ("PLAYER", 0))
			players.extend (create {HUMAN_PLAYER}.make_with_initial_values ("PLAYER", 0))
			create initial_state.make (players)
			create engine.make_with_depth (problem, engine_depth)

			create math.make

				-- Initialize the first weights list as default;
			weights_1 := math.initialize_weights
			weights_2 := math.initialize_weights

			print ("v1: ")
			print_weights (weights_1)

				-- Initialize the second weights list based on the first one;
			--create	weights_2.make_from_array (<<[0.11, 0.1], [0.1, 0.1], [0.086, 0.1], [0.3, 0.1], [0.15, 0.1], [0.24, 0.1]>>)
			weights_2 := math.generate_gaussian_weights (weights_2)
			weights_2 := math.log_normal_weights (weights_2)
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
				winner_player_game_1 := play_game (weights_1, weights_2)

				winner_player_game_2 := play_game (weights_2, weights_1)

					-- Get the best weights list among the two;
				overall_winner := evaluate_overall_winner (winner_player_game_1, winner_player_game_2)


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
					print_results (weights_1, weights_2)
				when 2 then
					weights_1 := math.breed_weights (weights_2, weights_1)
					print_results (weights_2, weights_1)
				when 0 then


					if random_winner = 1 then
						weights_2 := math.breed_weights (weights_1, weights_2)
						print_results (weights_1, weights_2)
					else
						weights_1 := math.breed_weights (weights_2, weights_1)
						print_results (weights_2, weights_1)
					end

				else
					print ("%N%NERROR: CAN'T BREED!%N%N")
				end

				epoch := epoch + 1
			end
		end

	play_game (player_1_weights: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]; player_2_weights:  ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]): INTEGER
			-- Automatic fight between two players with weigths equal to weights_1 and weights_2, respectively;
		do

			from
				engine.reset_engine
				problem.set_weights (player_1_weights)

				engine.perform_search (initial_state)
				current_state := engine.obtained_successor
				until
				problem.is_end (current_state)
			loop
				if current_state.index_of_current_player = 2 then
					problem.set_weights (player_2_weights)
				elseif current_state.index_of_current_player = 1 then
					problem.set_weights (player_1_weights)
				end
				engine.reset_engine
				engine.perform_search (current_state)
				current_state := engine.obtained_successor
			end

			Result := evaluate_result
		end

	evaluate_result: INTEGER
			-- Given an end-game state, return the index of the winning player, 0 if the state is a tie or -1 if it isn't a final state;
		do
			if problem.is_end (current_state) then
				if current_state.players.i_th (1).score > current_state.players.i_th (2).score then
					Result := 1
				elseif
					current_state.players.i_th (1).score < current_state.players.i_th (2).score
				then
					Result := 2
				else
					Result := 0
				end
			else
				Result := -1
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
		do
			from
				a_weights.start
				print ("[ ")
			until
				a_weights.exhausted
			loop
				print (a_weights.item.weight.truncated_to_real.out + ", ")
				a_weights.forth
			end
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
