note
	description: "Game state for a Solitaire Mancala game."
	author: "Simone"
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_STATE

inherit

	GAME_STATE
		undefine
			is_equal,
			out
		end

	SEARCH_STATE [ACTION]
			-- Rules are represented as strings in this case.
			-- TODO: change to object event
		redefine
			is_equal,
			out
		end

create
	make, make_from_parent_and_rule

feature
	-- Creator

	make
		local
			current_stones: INTEGER
			random_number_generator: RANDOM
				-- Random numbers generator to have a random hole to which a stone will be added;
			time_seed_for_random_generator: TIME
			-- Time variable in order to get new random numbers from random numbers generator every time the program runs.

		do
			create map.make

				-- Every hole has to contain at least one stone;
			from
				current_stones := {GAME_CONSTANTS}.num_of_stones
			until
				current_stones = {GAME_CONSTANTS}.num_of_stones - {GAME_CONSTANTS}.num_of_holes
			loop
				map.add_stone_to_hole ({GAME_CONSTANTS}.num_of_stones - current_stones + 1)
				current_stones := current_stones - 1
			end
			create time_seed_for_random_generator.make_now
				-- Initializes random generator using current time seed.
			create random_number_generator.set_seed (((time_seed_for_random_generator.hour * 60 + time_seed_for_random_generator.minute) * 60 + time_seed_for_random_generator.second) * 1000 + time_seed_for_random_generator.milli_second)
			random_number_generator.start
			from
			until
				current_stones = 0
			loop
				map.add_stone_to_hole ((random_number_generator.item \\ ({GAME_CONSTANTS}.num_of_holes) + 1))
				random_number_generator.forth
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
			set_rule_applied (a_rule)
			set_map (new_map)
			set_selected_hole (new_hole)
			game_over := is_game_over
		end

feature -- Status setting

	set_selected_hole (new_hole: INTEGER)
			-- Set the hole selected by the player, on which the next move will be performed;
		do
			selected_hole := new_hole
		end

feature -- Status report

	is_game_over: BOOLEAN
			-- When the last stone distributed in a round was
			-- placed in an empty hole and there was no increase in the score,
			-- the player loses and the game is over;
		local
			placed_in_empty_hole: BOOLEAN
			no_store_increase: BOOLEAN
		do
			if parent /= void then
				placed_in_empty_hole := (state.map.get_hole_value (state.selected_hole) = 1)
				no_store_increase := (state.map.get_store_value (1) = state.parent.map.get_store_value (1)) and (state.map.get_store_value (2) = state.parent.map.get_store_value (2))
			end
			Result := placed_in_empty_hole and no_store_increase
		end

	selected_hole: INTEGER
			-- Target of the next move, it's the ending position after having moved in the previous state;

	player: PLAYER
			-- Reference to the player of the game;

	parent: detachable SOLITAIRE_STATE
			-- The parent of this state; it is void if this is the first state;

	rule_applied: detachable ACTION
			-- Rule applied to reach current state.
			-- If the state is an initial state, rule_applied
			-- is Void;

	next_player: PLAYER
			-- Return the player who will play in the next turn;
		do
			Result := player
		ensure then
			next_player_consistent: equal (player, Result)
		end

feature -- Inherited

	set_parent (new_parent: SOLITAIRE_STATE)
			-- Sets the parent for current state
		do
			parent := new_parent
		end

	set_rule_applied (new_rule: ACTION)
			-- Sets the rule_applied for current state
		do
			rule_applied := new_rule
		end

	is_equal (other_state: like Current): BOOLEAN
			-- Compares current state with another state other.
			-- Considered equal iff same map and same selected state.
		do
			Result := (selected_hole = other_state.selected_hole) and then (map.is_equal (other_state.map))
		end

	out: STRING
		do
			Result := "Selected hole: " + selected_hole.out + "%N%N Map: " + map.out + "/n"
		end

end
