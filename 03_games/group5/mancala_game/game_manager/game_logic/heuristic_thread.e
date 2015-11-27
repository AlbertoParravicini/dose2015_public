note
	description: "Summary description for {HEURISTIC_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HEURISTIC_THREAD

inherit
	THREAD
		rename
			make as thread_make
		end

create
	make_with_weights

feature -- Attributes
	problem: ADVERSARY_PROBLEM
	engine: MINIMAX_AB_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]

	current_state: ADVERSARY_STATE
	initial_state: ADVERSARY_STATE

	players: ARRAYED_LIST [PLAYER]

	engine_depth: INTEGER = 1
		-- Depth of the engine;

	weights_1, weights_2: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]

	winner: INTEGER



feature -- Initialization
	make_with_weights (a_weights_1: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]]; a_weights_2: ARRAYED_LIST[TUPLE[weight: REAL_64; variance: REAL_64]])
		do
			thread_make
			create problem.make
			create players.make (2)
			players.extend (create {HUMAN_PLAYER}.make_with_initial_values ("PLAYER", 0))
			players.extend (create {HUMAN_PLAYER}.make_with_initial_values ("PLAYER", 0))
			create initial_state.make (players)
			create engine.make_with_depth (problem, engine_depth)

			create weights_1.make ({HEURISTIC_FUNCTIONS_SUPPORT}.num_of_weights)
			create weights_2.make ({HEURISTIC_FUNCTIONS_SUPPORT}.num_of_weights)

			weights_1.deep_copy(a_weights_1)
			weights_2.deep_copy(a_weights_2)

			winner := -1
		end


feature -- Execution
	execute
		do
			from
				problem.set_weights (weights_1)
				current_state := initial_state
			until
				problem.is_end (current_state)
			loop
				print(current_state.index_of_current_player.out + ": ")
				from
					problem.weights.start
				until
					problem.weights.exhausted
				loop
					print(	problem.weights.item.truncated_to_real.out + ", ")
					problem.weights.forth
				end
				print("%N")



				engine.perform_search (current_state)

				if engine.obtained_successor /= void then
					current_state := engine.obtained_successor
					engine.reset_engine
				end
				if current_state.index_of_current_player = 2 then
					problem.set_weights (weights_2)
				elseif current_state.index_of_current_player = 1 then
					problem.set_weights (weights_1)
				else
					print("asda")
				end
			end

			winner := evaluate_result
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
end
