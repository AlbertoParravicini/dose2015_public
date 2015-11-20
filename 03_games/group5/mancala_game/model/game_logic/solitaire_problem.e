note
	description: "Summary description for {SOLITAIRE_PROBLEM}."
	author: "Alberto"
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_PROBLEM

inherit

	HEURISTIC_SEARCH_PROBLEM [ACTION, SOLITAIRE_STATE]

	STATE_COST_SEARCH_PROBLEM [ACTION, SOLITAIRE_STATE]

	HEURISTIC_STATE_COST_SEARCH_PROBLEM [ACTION, SOLITAIRE_STATE]

create
	make, make_with_initial_state

feature
	-- Initialization

	make
			-- Default constructor, it generates a initial state;
		do
			create initial_state.make
		ensure
			initial_state_not_void: initial_state /= void
		end

	make_with_initial_state (new_state: SOLITAIRE_STATE)
			-- Initializes the problem with the provided initial state;
		do
			initial_state := new_state
		ensure
			initial_state_not_void: initial_state /= void
		end

feature

	initial_state: SOLITAIRE_STATE
			-- The initial state of the problem;

	get_successors (a_state: SOLITAIRE_STATE): LIST [SOLITAIRE_STATE]
		local
			successors: LINKED_LIST [SOLITAIRE_STATE]
			successor_1: SOLITAIRE_STATE
			successor_2: SOLITAIRE_STATE
			current_selection: INTEGER
		do
			create successors.make
			if a_state.is_game_over then -- Do nothing

			elseif (a_state.selected_hole = -1 and a_state.parent = void) then
					-- In the first state no first hole has been selected and the parent is void;

				from
					current_selection := 1
				until
					current_selection > {GAME_CONSTANTS}.num_of_holes
				loop
					successors.extend (create {SOLITAIRE_STATE}.make_from_parent_and_rule (a_state, create {ACTION_SELECT}.make (current_selection)))
					current_selection := current_selection + 1
				end -- End Loop

			else -- This is not the first state, i.e the first hole was already selected;

					-- Two successors must be created: one for the clockwise move, another for the counter-clockwise movement;
				if (not game_over_a_priori (a_state, (create {ENUM_ROTATE}).clockwise)) then

						-- Rotate clockwise;
						-- Create a new state whose map is equal to the one of the current state;
					create successor_1.make_from_parent_and_rule (a_state, create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).clockwise))

						-- Clockwise movement;
						-- Empties the current_hole, distributes the stones clockwise, updates the score, updates the current_hole;
					successor_1.move_clockwise
					successors.extend (successor_1)
				end
				if (not game_over_a_priori (a_state, (create {ENUM_ROTATE}).counter_clockwise)) then


						-- Rotate counter-clockwise;
						-- Create a new state whose map is equal to the one of the current state;
					create successor_2.make_from_parent_and_rule (a_state, create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).counter_clockwise))

						-- Counter-clockwise movement;
						-- Empties the current_hole, distributes the stones counter-clockwise, updates the score, updates the current_hole;
					successor_2.move_counter_clockwise
					successors.extend (successor_2)
				end
			end -- End external if

			Result := successors
		ensure then
			at_most_tot_successors: Result.count <= {GAME_CONSTANTS}.num_of_holes
		end

	is_successful (state: SOLITAIRE_STATE): BOOLEAN
			-- Is the state successful, i.e. is the player score equal to the number of stones in the game?
		do
			Result := state.player.score = {GAME_CONSTANTS}.num_of_stones
		ensure then
			result_is_consistent: (Result = true implies (state.player.score = {GAME_CONSTANTS}.num_of_stones)) and ((state.player.score = {GAME_CONSTANTS}.num_of_stones) implies Result = true)
		end

feature
	-- Heuristic search related routines

	heuristic_value (state: SOLITAIRE_STATE): REAL
			-- Return the remaining number of stones in the game;
			-- even though the heuristic is both admissible and consistent,
			-- it doesn't really provide a fast convergence to the solution :(
		do
			Result := {GAME_CONSTANTS}.num_of_stones - state.player.score
		ensure then
			result_is_non_negative: Result >= 0
			result_is_zero_in_successful_state: (Result = 0 implies is_successful (state)) and then (is_successful (state) implies Result = 0)
		end

feature
	-- State cost realted routines

	cost (state: SOLITAIRE_STATE): REAL
			-- Cost of rule leading to current state
		do
			if state.parent = void then
				Result := 0
			else
				Result := 1
			end
		ensure then
			result_is_consistent: (Result = 0 implies state.parent = void) and (state.parent = void implies Result = 0)
		end

feature
	-- Auxiliary functions

	game_over_a_priori (state: SOLITAIRE_STATE; rotation: ENUM_ROTATE): BOOLEAN
			-- This function tells if the state that is going to be generated is a gameover state before generating it
		local
			l_starting_hole, l_value, l_target_hole, l_counter: INTEGER
			l_game_over: BOOLEAN
		do
			l_game_over := false
			l_starting_hole := state.selected_hole
			l_value := state.map.get_hole_value (l_starting_hole)
			if (rotation = (create {ENUM_ROTATE}).clockwise) then

				-- Calculate target hole
				from
					l_counter := l_value
					l_target_hole := l_starting_hole
				until
					l_counter = 0
				loop
					-- clockwise -> subtract
					if (l_target_hole = 1) then
						l_target_hole := {GAME_CONSTANTS}.num_of_holes
						l_counter := l_counter - 1
					else
						l_target_hole := l_target_hole - 1
						l_counter := l_counter - 1
					end
				end




				if ((l_value = {GAME_CONSTANTS}.num_of_holes) and then (not (l_target_hole = (({GAME_CONSTANTS}.num_of_holes / 2)+1)) and not (l_target_hole = 1))) then
						-- Moved back to starting position, not after a store, the hole is empty
					l_game_over := true
				elseif ((l_value < {GAME_CONSTANTS}.num_of_holes) and then ((l_target_hole = (({GAME_CONSTANTS}.num_of_holes / 2)+1) and state.map.is_hole_empty (({GAME_CONSTANTS}.num_of_holes / 2).floor)) or ((l_target_hole = 1 and state.map.is_hole_empty ({GAME_CONSTANTS}.num_of_holes)))) and state.map.sum_of_stores_token=({GAME_CONSTANTS}.num_of_stones-1)) then
						-- Moved to a hole after the store, i need to check if the hole before the store is empty
					l_game_over := true
				end
			else
				-- Calculate target hole
				from
					l_counter := l_value
					l_target_hole := l_starting_hole
				until
					l_counter = 0
				loop
					-- counterclockwise -> add
					if (l_target_hole = {GAME_CONSTANTS}.num_of_holes) then
						l_target_hole := 1
						l_counter := l_counter - 1
					else
						l_target_hole := l_target_hole + 1
						l_counter := l_counter - 1
					end
				end
				if ((l_value = {GAME_CONSTANTS}.num_of_holes) and then (not (l_target_hole = ({GAME_CONSTANTS}.num_of_holes / 2) ) and not (l_target_hole = {GAME_CONSTANTS}.num_of_holes))) then
						-- Moved back to starting position, not after a store, the hole is empty
					l_game_over := true
				elseif ((l_value < {GAME_CONSTANTS}.num_of_holes) and then ((l_target_hole = ({GAME_CONSTANTS}.num_of_holes / 2)  and state.map.is_hole_empty (({GAME_CONSTANTS}.num_of_holes / 2).floor +1)) or ((l_target_hole = {GAME_CONSTANTS}.num_of_holes) and state.map.is_hole_empty (1)))  and state.map.sum_of_stores_token=({GAME_CONSTANTS}.num_of_stones-1)) then
						-- Moved to a hole after a store, i need to check if the hole before the store is empty
					l_game_over := true
				end
			end
			Result := l_game_over
		end

end
