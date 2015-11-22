note
	description: "Summary description for {GAME_MANAGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MANAGER

create
	make

feature {NONE} -- Creation


	make (a_algorithm: STRING; a_algorithm_depth: INTEGER; a_view: VIEW)
			-- Creates a game manager based on the options chosen by the user;
			-- the game mode is implied by the choice of the algorithm;
			-- The game manager contains the main game loop, and a reference to the rules set and the current state;
			-- Th rules set contains the "problem" and the "ai_engine", which are instantiated based on the chosen algorithm;
		require
			valid_algorthm: a_algorithm /= VOID and not a_algorithm.is_empty
			non_void_view: a_view /= VOID
			supported_algorithms: is_valid_solitaire_algorithm(a_algorithm) or is_valid_adversary_algorithm(a_algorithm)
			a_algorithm_depth >= 0
		local
			l_players: ARRAYED_LIST [PLAYER]
		do

			view := a_view
			algorithm_selected := a_algorithm

				-- SOLITAIRE
			if is_valid_solitaire_algorithm(a_algorithm) then
				rules_set := create {SOLITAIRE_RULE_SET}.make_by_state (create {SOLITAIRE_STATE}.make, a_algorithm, a_algorithm_depth)
			end

				-- ADVERSARY
			if is_valid_adversary_algorithm (a_algorithm) then

				create l_players.make (2)
				l_players.extend (create {HUMAN_PLAYER}.make)

				if equal(a_algorithm,"two_players") then
					l_players.extend (create {HUMAN_PLAYER}.make)
				else
					l_players.extend (create {AI_PLAYER}.make)
				end

				rules_set := create {ADVERSARY_RULE_SET}.make_by_state (create {ADVERSARY_STATE}.make(l_players), a_algorithm, a_algorithm_depth)
			end

		ensure
			setting_done: rules_set /= VOID and view = a_view and algorithm_selected = a_algorithm
		end

feature {NONE} -- Implementation

	is_valid_solitaire_algorithm (a_algorithm: STRING): BOOLEAN
		require
			valid_algorthm: a_algorithm /= VOID and not a_algorithm.is_empty
		local
			l_valid_algorithms: ARRAYED_LIST[STRING]
			l_result: BOOLEAN
		do
			create l_valid_algorithms.make_from_array (<<"bounded_breadth_first_search",
			"bounded_depth_first_search","depth_first_with_cycle_checking","heuristic_depth_first_search","iterative_deepening",
			"hill_climbing","steepest_ascent_hill_climbing","lowest_cost_first_search","best_first_search","a_star">>)

			from
				l_valid_algorithms.start
				l_result := false
			until
				l_result or l_valid_algorithms.exhausted
			loop
				if equal(l_valid_algorithms.item, a_algorithm) then
					l_result := true
				end
				l_valid_algorithms.forth
			end

			Result := l_result
		end

	is_valid_adversary_algorithm (a_algorithm: STRING): BOOLEAN
		require
			valid_algorthm: a_algorithm /= VOID and not a_algorithm.is_empty
		local
			l_valid_algorithms: ARRAYED_LIST[STRING]
			l_result: BOOLEAN
		do
			create l_valid_algorithms.make_from_array (<<"minimax","minimax_ab","negascout","two_players">>)

			from
				l_valid_algorithms.start
				l_result := false
			until
				l_result or l_valid_algorithms.exhausted
			loop
				if equal(l_valid_algorithms.item, a_algorithm) then
					l_result := true
				end
				l_valid_algorithms.forth
			end

			Result := l_result
		end

feature -- Status report

	rules_set: RULE_SET[GAME_STATE]
		-- Reference to the rules-set of the game; it holds a reference to most of the game logic and the AI;

	algorithm_selected: STRING
		-- The current view of the game;

	view: VIEW
		-- The current view of the game;

feature -- Status setting

	parse_action_string (a_action: ACTION)
		do

				-- SOLITAIRE
			if is_valid_solitaire_algorithm (algorithm_selected) then

					-- ACTION_START_GAME
				if equal(a_action.generator, "ACTION_START_GAME") then
					view.show_message ("%N%N")
					view.show_state (rules_set.current_state)
					view.show_message ("TODO: write 'exit'%N")
				end

				-- TODO

			end


				-- ADVERSARY
			if is_valid_adversary_algorithm (algorithm_selected) then


					-- ACTION_START_GAME
				if equal(a_action.generator, "ACTION_START_GAME") then
					send_it_is_your_turn
				end

					-- ACTION_SELECT
				if equal(a_action.generator, "ACTION_SELECT") then
					if human_player_turn and rules_set.is_valid_action (rules_set.current_state.index_of_current_player, a_action) then
						send_it_is_your_turn
					else
						view.show_message ("ERROR: it isn't a valid hole or it isn't your turn!%N")
					end
				end
			end

		end

	human_player_turn: BOOLEAN
		require
			rules_set /= VOID
		do
			Result := equal(rules_set.current_state.current_player.generator, "HUMAN_PLAYER")
		end

	send_it_is_your_turn
		require
			non_void_view: view /= VOID
		do
			view.show_message ("%N%N")
			view.show_state (rules_set.current_state)
			view.show_message ("It's turn of " + rules_set.current_state.current_player.name + " insert which hole you want to select, from " + (1 + ((rules_set.current_state.index_of_current_player - 1) * {GAME_CONSTANTS}.num_of_holes // 2 )).out + " to " + ({GAME_CONSTANTS}.num_of_holes * rules_set.current_state.index_of_current_player // 2).out + "%N")
		end

end
