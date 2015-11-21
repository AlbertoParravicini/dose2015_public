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
			create player.make_with_initial_values ("pippo", 0)
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
			stones_placed: map.num_of_stones = {GAME_CONSTANTS}.num_of_stones
			score_is_zero: player.score = 0
		end

	make_from_parent_and_rule (a_parent: SOLITAIRE_STATE; a_rule: ACTION)
		do
			set_parent (a_parent)
			player := create {HUMAN_PLAYER}.make_with_initial_values (a_parent.player.name, a_parent.player.score)
			set_rule_applied (a_rule)
			set_map (create {GAME_MAP}.make_from_map (a_parent.map))

				-- Automatically update the selected_hole if the action is an ACTION_SELECT
			if attached {ACTION_SELECT} a_rule as rule_select then
				set_selected_hole (rule_select.get_selection)
			else
				set_selected_hole (a_parent.selected_hole)
			end
		ensure
			rule_applied: rule_applied /= void
			parent_not_void: parent /= void
			stones_placed: map.num_of_stones = {GAME_CONSTANTS}.num_of_stones
			map_is_copied: map.is_equal (a_parent.map)
			score_is_mantained: player.score = a_parent.player.score
			name_is_mantained: player.name = a_parent.player.name
		end

feature -- Status setting

	set_selected_hole (new_hole: INTEGER)
			-- Set the hole selected by the player, on which the next move will be performed;
		require
			new_hole_exists: new_hole >= 1 and new_hole <= {GAME_CONSTANTS}.num_of_holes
		do
			selected_hole := new_hole
		ensure
			hole_selscted: selected_hole = new_hole
		end

	move_clockwise
			-- Empties the current_hole, distributes the stones clockwise, updates the score, updates the current_hole;
		local
			stones_to_distribute: INTEGER
		do
			from
				stones_to_distribute := map.get_hole_value (selected_hole)
				map.clear_hole (selected_hole)
			until
				stones_to_distribute = 0
			loop
					-- Example: 8 <= selected_hole <= 12
				if ((selected_hole > (({GAME_CONSTANTS}.num_of_holes // 2) + 1)) and then (selected_hole <= {GAME_CONSTANTS}.num_of_holes)) then
					selected_hole := selected_hole - 1
					map.add_stone_to_hole (selected_hole)
					stones_to_distribute := stones_to_distribute - 1

						-- Example: selected_hole = 7
				elseif (selected_hole = (({GAME_CONSTANTS}.num_of_holes // 2) + 1)) then
					if (stones_to_distribute = 1) then
							-- Only 1 stone left
						map.add_stone_to_store (1)
						player.increment_score
						stones_to_distribute := stones_to_distribute - 1
					else
							-- More than 1 stone left
						selected_hole := {GAME_CONSTANTS}.num_of_holes // 2
						map.add_stone_to_hole (selected_hole)
						stones_to_distribute := stones_to_distribute - 1
					end -- End inner if

						-- Example: 2 <= selected_hole <= 6
				elseif ((selected_hole > 1) and (selected_hole <= ({GAME_CONSTANTS}.num_of_holes // 2))) then
					selected_hole := selected_hole - 1
					map.add_stone_to_hole (selected_hole)
					stones_to_distribute := stones_to_distribute - 1

						-- Example: selected_hole = 1
				elseif selected_hole = 1 then
					if (stones_to_distribute = 1) then
							-- Only 1 stone left
							--print(player.score.out)
						map.add_stone_to_store (2)
						player.increment_score
							--print(" " + player.score.out + "%N")
						stones_to_distribute := stones_to_distribute - 1
					else
							-- More than 1 stone left
						selected_hole := {GAME_CONSTANTS}.num_of_holes
						map.add_stone_to_hole (selected_hole)
						stones_to_distribute := stones_to_distribute - 1
					end -- End inner if
				end
			end
		end

	move_counter_clockwise
			-- Empties the current_hole, distributes the stones counter-clockwise, updates the score, updates the current_hole;
		local
			stones_to_distribute: INTEGER
		do
			from
				stones_to_distribute := map.get_hole_value (selected_hole)
				map.clear_hole (selected_hole)
			until
				stones_to_distribute = 0
			loop
					-- Example: 7 <= selected_hole <= 11
				if ((selected_hole >= (({GAME_CONSTANTS}.num_of_holes // 2) + 1)) and then (selected_hole < {GAME_CONSTANTS}.num_of_holes)) then
					selected_hole := selected_hole + 1
					map.add_stone_to_hole (selected_hole)
					stones_to_distribute := stones_to_distribute - 1

						-- Example: selected_hole = 12
				elseif selected_hole = ({GAME_CONSTANTS}.num_of_holes) then
					if (stones_to_distribute = 1) then
							-- Only 1 stone left
						map.add_stone_to_store (2)
						player.increment_score
						stones_to_distribute := stones_to_distribute - 1
					else
							-- More than 1 stone left
						selected_hole := 1
						map.add_stone_to_hole (selected_hole)
						stones_to_distribute := stones_to_distribute - 1
					end -- End inner if

						-- Example: 1 <= selected_hole <= 5
				elseif ((selected_hole >= 1) and (selected_hole <= ({GAME_CONSTANTS}.num_of_holes // 2) - 1)) then
					selected_hole := selected_hole + 1
					map.add_stone_to_hole (selected_hole)
					stones_to_distribute := stones_to_distribute - 1

						-- Example: selected_hole = 6
				elseif selected_hole = {GAME_CONSTANTS}.num_of_holes // 2 then
					if (stones_to_distribute = 1) then
							-- Only 1 stone left
						map.add_stone_to_store (1)
						player.increment_score
						stones_to_distribute := stones_to_distribute - 1
					else
							-- More than 1 stone left
						selected_hole := ({GAME_CONSTANTS}.num_of_holes // 2) + 1
						map.add_stone_to_hole (selected_hole)
						stones_to_distribute := stones_to_distribute - 1
					end -- End inner if
				end
			end
		end

feature -- Status report

	is_game_over: BOOLEAN
			-- When the last stone distributed in a round was
			-- placed in an empty hole and there was no increase in the score,
			-- the player loses and the game is over;
		local
			placed_in_empty_hole: BOOLEAN
			no_score_increase: BOOLEAN
		do
				-- The real evaluation is done only after the first movementa has been done;
				-- The initial state and the second state (where a hole is selected) are never final states;
			if (parent /= void and then not map.is_equal (parent.map)) then
				placed_in_empty_hole := (map.get_hole_value (selected_hole) <= 1)
				no_score_increase := player.score = parent.player.score
			end
			Result := (placed_in_empty_hole and no_score_increase) or (map.get_hole_value (selected_hole) = 0 and (map.num_of_stones - map.sum_of_stores_token > 0))
		end

	selected_hole: INTEGER
			-- Target of the next move, it's the ending position after having moved in the previous state;

	player: HUMAN_PLAYER
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

	index_of_current_player: INTEGER
			-- Return the player index who plays in the this turn;
		do
			Result := 1
		ensure then
			current_player_index_consistent: Result = 1
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
			Result := (selected_hole = other_state.selected_hole) and then player.is_equal (other_state.player) and then (map.is_equal (other_state.map))
		end

	out: STRING
		do
			Result := "%N---------------------------------------%NSelected hole: " + selected_hole.out + "%N%NMap: %N " + map.out + "%N"
		end

invariant
	score_consistent: map.sum_of_stores_token = player.score

end
