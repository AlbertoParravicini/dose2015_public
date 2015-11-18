note
	description: "State representing a Human vs AI game."
	author: "Simone"
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_STATE
inherit
	GAME_STATE
		undefine
			out
		end

	ADVERSARY_SEARCH_STATE[ACTION_SELECT]
		undefine
			out
		end

	ANY
		redefine
			out
		end


create
	make, make_from_parent_and_rule


feature {NONE} -- Creation

	make (a_players: ARRAYED_LIST[PLAYER])
		require
			num_of_stones_multiple_of_num_of_holes: {GAME_CONSTANTS}.num_of_stones \\ {GAME_CONSTANTS}.num_of_holes = 0
		local
			current_stones: INTEGER
		do
			create map.make

			players := a_players
			index_of_current_player := 1
			current_player := players.i_th (index_of_current_player)

				-- Set unique name for each player adding index of its position in array_list.
			from
				players.start
			until
				players.exhausted
			loop
				players.item.set_name (players.item.name + "_" + players.index.out)
				players.forth
			end

				-- Every hole has to contain the same number of stones;
			from
				current_stones := {GAME_CONSTANTS}.num_of_stones
			until
				current_stones = 0
			loop
				map.add_stone_to_hole ((({GAME_CONSTANTS}.num_of_stones - current_stones) \\ {GAME_CONSTANTS}.num_of_holes) + 1)
				current_stones := current_stones - 1

			end

		ensure
			no_rule_applied: rule_applied = void
			no_parent: parent = void
			setting_done: players = a_players and current_player = players.i_th (1)
			stones_placed: map.num_of_stones = {GAME_CONSTANTS}.num_of_stones
			score_is_zero: players.i_th (1).score = 0 and players.i_th (2).score = 0
		end



	make_from_parent_and_rule (a_parent: ADVERSARY_STATE; a_rule: ACTION_SELECT)
		do

			set_parent (a_parent)

			create players.make (a_parent.players.count)
			players.deep_copy (a_parent.players)

			index_of_current_player := a_parent.index_of_current_player

			current_player := next_player

			set_rule_applied (a_rule)
			set_map (create {GAME_MAP}.make_from_map(a_parent.map))

				-- Perform action:
			move (a_rule.get_selection)

		ensure
			rule_applied: rule_applied /= VOID
			parent_not_void: parent /= VOID
			stones_placed: map.num_of_stones = {GAME_CONSTANTS}.num_of_stones
			name_is_mantained: equal(players.i_th (1).name, a_parent.players.i_th (1).name) and equal(players.i_th (2).name, a_parent.players.i_th (2).name)
		end



feature -- Implementation Variables

	players: ARRAYED_LIST[PLAYER]
		-- List contains the players of the game.

	index_of_current_player: INTEGER
		-- Adjourned each round.



feature {NONE} -- Implementation Routines

	first_valid_player_hole (l_player_index: INTEGER): INTEGER
	do
		Result := 1 + ((l_player_index - 1) * ({GAME_CONSTANTS}.num_of_holes / players.count)).truncated_to_integer
	end

	last_valid_player_hole (l_player_index: INTEGER): INTEGER
	do
		Result := ({GAME_CONSTANTS}.num_of_holes / players.count).truncated_to_integer * (1 + (l_player_index - 1))
	end

	valid_player_hole (l_hole: INTEGER): BOOLEAN
		do
			if first_valid_player_hole (parent.index_of_current_player) <= l_hole and l_hole <= last_valid_player_hole (parent.index_of_current_player) then
				Result := true
			else
				Result := false
			end
		end

	opposite_hole_value (l_hole: INTEGER): INTEGER
		do
			Result := map.get_hole_value ({GAME_CONSTANTS}.num_of_holes + 1 - l_hole)
		end


	move(a_selected_hole: INTEGER)

		require

			valid_selection: valid_player_hole (a_selected_hole)
			non_empty_hole: map.get_hole_value (a_selected_hole) >= 1
			non_void_parent: parent /= VOID

		local

			l_number_of_stones: INTEGER
			l_current_hole: INTEGER

			l_sum_of_player_stones: INTEGER
			end_condition: BOOLEAN

		do

		--	print("--------------------------%N" + parent.current_player.name + " moved: " + a_selected_hole.out + "%N--------------------------%N%N")


			-- Perform move.
			from

				l_number_of_stones := map.get_hole_value (a_selected_hole)
				l_current_hole := a_selected_hole
				map.clear_hole (l_current_hole)

			until

				l_number_of_stones = 0

			loop

				-- STORE:
					-- Add one stone to store if current hole is the last player's hole
					-- and there is at least one other stone.
					-- If you run into your opponent's store, skip it.
				if l_current_hole = last_valid_player_hole (parent.index_of_current_player) and l_number_of_stones >= 1 then

					map.add_stone_to_store (parent.index_of_current_player)
					players.i_th (parent.index_of_current_player).increment_score
					l_number_of_stones := l_number_of_stones - 1

				end


				-- FREE TURN:
					-- Allow the player to move twice.
				if l_number_of_stones = 0 then

					current_player := prev_player
	--				print("!!! FREE TURN%N%N")

				else

					-- NORMAL BEHAVIOR:
						-- The game now deposits one of the stones in each hole until the stones run out.
					l_current_hole := l_current_hole + 1

						-- If l_current_hole exceeds last hole then go to the first one.
					if l_current_hole > {GAME_CONSTANTS}.num_of_holes then
						l_current_hole := 1
					end

					map.add_stone_to_hole (l_current_hole)
					l_number_of_stones := l_number_of_stones - 1

					-- CAPTURE:
						-- If the last piece you drop is in an empty hole on your side,
						-- you capture that piece and any pieces in the hole directly opposite.
					if l_number_of_stones = 0 and map.get_hole_value (l_current_hole) = 1 and valid_player_hole (l_current_hole) and opposite_hole_value (l_current_hole) /= 0 then

						players.i_th (parent.index_of_current_player).sum_to_score (opposite_hole_value (l_current_hole) + 1)
						map.add_stones_to_store (opposite_hole_value (l_current_hole) + 1, parent.index_of_current_player)
						map.clear_hole ({GAME_CONSTANTS}.num_of_holes + 1 - l_current_hole)
						map.clear_hole (l_current_hole)
	--					print("!!! CAPTURE%N%N")

					end
				end

			end -- End perform move.


			-- END
				-- The game ends when all six spaces on one side of the Mancala board are empty.
				-- The player who still has pieces on his side of the board when the game ends
				-- captures all of those pieces.
			from
				players.start
				end_condition := false
			until
				players.exhausted or end_condition
			loop

				from
					l_sum_of_player_stones := 0
					l_current_hole := first_valid_player_hole (players.index)
				until
					l_current_hole > last_valid_player_hole (players.index)
				loop
					l_sum_of_player_stones := l_sum_of_player_stones + map.get_hole_value (l_current_hole)
					l_current_hole := l_current_hole + 1
				end

				if l_sum_of_player_stones = 0 then
					end_condition := true
				end

				players.forth
			end

			if end_condition then

				from
					players.start
				until
					players.exhausted
				loop

					from
						l_sum_of_player_stones := 0
						l_current_hole := first_valid_player_hole (players.index)
					until
						l_current_hole > last_valid_player_hole (players.index)
					loop
						l_sum_of_player_stones := l_sum_of_player_stones + map.get_hole_value (l_current_hole)
						map.clear_hole (l_current_hole)
						l_current_hole := l_current_hole + 1
					end

					map.add_stones_to_store (l_sum_of_player_stones, players.index)
					players.i_th (players.index).sum_to_score (l_sum_of_player_stones)

					players.forth
				end

	--				print("!!! END%N%N")
			end

		ensure
		end



feature -- Status Report

	is_game_over: BOOLEAN
		-- Is the game over?
		do
			if (map.sum_of_stores_token = {GAME_CONSTANTS}.num_of_stones) or (players.at (1).score > {GAME_CONSTANTS}.num_of_stones // 2)
				or (players.at (2).score > {GAME_CONSTANTS}.num_of_stones // 2)  then
					Result := true
			else Result := false
			end
		end


	next_player: PLAYER
			-- Return the player who will play in the next turn;
		do
			index_of_current_player := (index_of_current_player \\ players.count) + 1
			Result := players.i_th (index_of_current_player)
		end


	prev_player: PLAYER
			-- Return the player who played in the last turn;
		do
			index_of_current_player := index_of_current_player - 1
			if index_of_current_player = 0 then
				index_of_current_player := players.count
			end

			Result := players.i_th (index_of_current_player)
		end



feature -- Status report

	parent: detachable like Current
			-- Parent of current state

	rule_applied: detachable ACTION_SELECT
			-- Rule applied to reach current state.
			-- If the state is an initial state, rule_applied
			-- is Void.


	is_max: BOOLEAN
			-- Indicates whether current state is a max state
		do
			if index_of_current_player \\ 2 = 0 then
				Result := false
			else
				Result := true
			end
		ensure then
			odd_player_max: Result = true implies index_of_current_player \\ 2 = 1
			max_odd_player: index_of_current_player \\ 2 = 1 implies Result = true
			mutual_exclusion: (is_max implies not is_min) and (not is_min implies is_max)
		end

	is_min: BOOLEAN
			-- Indicates whether current state is a min state
		do
			if is_max then
				Result := false
			else
				Result := true
			end
		ensure then
			even_player_min: Result = true implies index_of_current_player \\ 2 = 0
			min_even_player: index_of_current_player \\ 2 = 1 implies Result = true
			mutual_exclusion: (is_max implies not is_min) and (not is_min implies is_max)
		end



feature -- Status setting

	set_parent (new_parent: detachable like Current)
			-- Sets the parent for current state
		do
			parent := new_parent
		end

	set_rule_applied (new_rule: detachable ACTION_SELECT)
			-- Sets the rule_applied for current state
		do
			rule_applied := new_rule
		end



feature -- Inherited

	out: STRING
		do
			Result := "- Turn of: " + current_player.out + "%N- MAP: %N" + map.out + "%N%N"
		end

invariant
	score_is_consistent: players.i_th (1).score + players.i_th (2).score = map.sum_of_stores_token
	index_of_current_player_domain: index_of_current_player >= 1 and index_of_current_player <= players.count
end
