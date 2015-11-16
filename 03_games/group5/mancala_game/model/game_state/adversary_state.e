note
	description: "State representing a Human vs AI game."
	author: "Simone"
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_STATE
inherit
	GAME_STATE

	ADVERSARY_SEARCH_STATE[STRING]
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

	make
		local
			current_stones: INTEGER
			player_1: HUMAN_PLAYER
			player_2: AI_PLAYER
		do
			create player_1.make
			create player_2.make
			create map.make


				-- Every hole has to contain the same number of stones;
			from
				current_stones := {GAME_CONSTANTS}.num_of_stones
			until
				current_stones = 0
			loop
				map.add_stone_to_hole ({GAME_CONSTANTS}.num_of_stones - current_stones + 1)
				current_stones := current_stones - 1
			end

			selected_hole := -1
		ensure
			no_rule_applied: rule_applied = void
			no_parent: parent = void
		end

	make_from_parent_and_rule (a_parent: SOLITAIRE_STATE; a_rule: ACTION; new_map: GAME_MAP; new_hole: INTEGER)
		do
			set_parent (a_parent)
			player := create {HUMAN_PLAYER}.make_with_initial_values (a_parent.player.name, a_parent.player.score)
			set_rule_applied (a_rule)
			set_map (new_map)
			set_selected_hole (new_hole)
		end

feature -- Status Report

	is_game_over: BOOLEAN
		-- Is the game over?
		deferred
		end

	map: GAME_MAP
			-- Map of the game

	current_player: PLAYER
			-- The player who has to make a move in the current turn;

	next_player: PLAYER
			-- Return the player who will play in the next turn;
		deferred
		end

feature -- Status Setting

	set_map (new_map: GAME_MAP)
			-- Set a new map for the state;
		require
			map_not_void: new_map /= void
		do
			map := new_map
		ensure
			map_set: map.is_equal (new_map)
		end

	set_current_player (new_current_player: PLAYER)
			-- Set a new current player for the state;
		do
			current_player := new_current_player
		end


end
