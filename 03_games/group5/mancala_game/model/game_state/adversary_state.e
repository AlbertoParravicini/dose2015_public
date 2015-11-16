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
		do
		end


	next_player: PLAYER
			-- Return the player who will play in the next turn;
		do
		end


feature -- Status report

	parent: detachable like Current
			-- Parent of current state
		do
		end

	rule_applied: detachable ACTION_SELECT
			-- Rule applied to reach current state.
			-- If the state is an initial state, rule_applied
			-- is Void.
		do
		end

	is_max: BOOLEAN
			-- Indicates whether current state is a max state
		do
		end

	is_min: BOOLEAN
			-- Indicates whether current state is a min state
		do
		end

feature -- Status setting

	set_parent (new_parent: detachable like Current)
			-- Sets the parent for current state
		do
		end

	set_rule_applied (rule: detachable ACTION_SELECT)
			-- Sets the rule_applied for current state
		do
		end

feature -- Inherited

	out: STRING
		do
			Result := "Selected hole: " + selected_hole.out + "%N%N Map: " + map.out + "%N"
		end

end
