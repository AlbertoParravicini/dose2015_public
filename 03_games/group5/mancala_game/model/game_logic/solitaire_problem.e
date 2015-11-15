note
	description: "Summary description for {SOLITAIRE_PROBLEM}."
	author: ""
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
		end

	make_with_initial_state (new_state: SOLITAIRE_STATE)
			-- Initializes the problem with the provided initial state;
		do
			initial_state := new_state
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
					successors.extend (create {SOLITAIRE_STATE}.make_from_parent_and_rule (a_state, create {ACTION_SELECT}.make (current_selection),
						create {GAME_MAP}.make_from_map(a_state.map), current_selection))
					current_selection := current_selection + 1
				end -- End Loop

			else -- This is not the first state, i.e the first hole was already selected;

                -- Two successors must be created: one for the clockwise move, another for the counter-clockwise movement;

                -- Rotate clockwise;
                -- Create a new state whose map is equal to the one of the current state;
                create successor_1.make_from_parent_and_rule(a_state, create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).clockwise),
                	create {GAME_MAP}.make_from_map(a_state.map), a_state.selected_hole)

                -- Clockwise movement;
                -- Empties the current_hole, distributes the stones clockwise, updates the score, updates the current_hole;
                successor_1.move_clockwise


                -- Rotate counter-clockwise;
                -- Create a new state whose map is equal to the one of the current state;
                create successor_2.make_from_parent_and_rule(a_state, create {ACTION_ROTATE}.make ((create {ENUM_ROTATE}).counter_clockwise),
                	create {GAME_MAP}.make_from_map(a_state.map), a_state.selected_hole)

                -- Counter-clockwise movement;
                -- Empties the current_hole, distributes the stones counter-clockwise, updates the score, updates the current_hole;
                successor_2.move_counter_clockwise

			    successors.extend (successor_1)
                successors.extend (successor_2)

			end -- End external if

			Result := successors
		end

	is_successful (state: SOLITAIRE_STATE): BOOLEAN
			-- Is the state successful, i.e. is the player score equal to the number of stones in the game?
		do
			Result := state.player.score = {GAME_CONSTANTS}.num_of_stones
			if (result = true) then
				print ("score " + state.player.score.out + " stones: " +  {GAME_CONSTANTS}.num_of_stones.out + "%N" )
			end
		end

feature
	-- Heuristic search related routines

	heuristic_value (state: SOLITAIRE_STATE): REAL
			-- Return the remaining number of stones in the game;
		do
			Result := {GAME_CONSTANTS}.num_of_stones - state.player.score
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
		end

feature {NONE}
	-- Auxiliary functions

	is_game_over (state: SOLITAIRE_STATE): BOOLEAN
		local
			placed_in_empty_hole: BOOLEAN
			no_store_increase: BOOLEAN
		do
			placed_in_empty_hole := (state.map.get_hole_value (state.selected_hole) = 1)
			no_store_increase := (state.map.get_store_value (1) = state.parent.map.get_store_value (1)) and (state.map.get_store_value (2) = state.parent.map.get_store_value (2))
			Result := placed_in_empty_hole and no_store_increase
		end

end
