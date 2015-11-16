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

			free_turn := false

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
			setting_done: players = a_players and current_player = players.i_th (1) and not free_turn
		end

	make_from_parent_and_rule (a_parent: ADVERSARY_STATE; a_rule: ACTION_SELECT; new_map: GAME_MAP)
		do

			set_parent (a_parent)
			free_turn := false

			create players.make (a_parent.players.count)
			players.deep_copy (a_parent.players)

			index_of_current_player := a_parent.index_of_current_player
				-- Free turn check
			if a_parent.free_turn then
				current_player := players.i_th (index_of_current_player)
			else
				current_player := next_player
			end

			set_rule_applied (a_rule)
			set_map (new_map)
		end

feature -- Implementation Variables

	players: ARRAYED_LIST[PLAYER]
		-- List contains the players of the game.

	index_of_current_player: INTEGER
		-- Adjourned each round.

	free_turn: BOOLEAN
		-- Free turn allow the player to move twice.

feature -- Implementation Routines

	move(a_selected_hole: INTEGER)
		require
			minimal_valid_selection: 1 + ((parent.index_of_current_player - 1) * ({GAME_CONSTANTS}.num_of_holes / players.count)) <= a_selected_hole
			maximal_valid_selection: a_selected_hole <= ({GAME_CONSTANTS}.num_of_holes / players.count) * (1 + (parent.index_of_current_player - 1))
			non_empty_hole: map.get_hole_value (a_selected_hole) >= 1
		local
			l_number_of_stones: INTEGER
		do
			l_number_of_stones := map.get_hole_value (a_selected_hole)
			print (l_number_of_stones)
		ensure
		end


feature -- Status Report

	is_game_over: BOOLEAN
		-- Is the game over?
		do
		end


	next_player: PLAYER
			-- Return the player who will play in the next turn;
		do
			index_of_current_player := (index_of_current_player \\ players.count) + 1
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
			Result := "- Max: " + is_max.out + "%N- Current Player: " + current_player.out + "%N- Map: %N" + map.out + "%N%N"
		end

invariant
	index_of_current_player_domain: index_of_current_player >= 1 and index_of_current_player <= players.count

end
