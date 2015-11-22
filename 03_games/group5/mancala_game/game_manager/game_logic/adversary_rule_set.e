note
	description: "Rule-set for the Adversarial game mode; %
				%it contains the validation of a move and its actual execution if it is positively evalutated."
	author: "Alberto Parravicini"
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARY_RULE_SET

inherit

	RULE_SET [ADVERSARY_STATE]

create
	make_by_state

feature -- Initialization
	make_by_state (a_initial_state: ADVERSARY_STATE; selected_algorithm: STRING; selected_depth: INTEGER)
		do
			current_state := a_initial_state

			create problem.make

			if selected_algorithm.is_equal ("minimax") then
				if selected_depth <= 0 then
					engine := create {MINIMAX_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make (problem)
				else
					engine := create {MINIMAX_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make_with_depth (problem, selected_depth)
				end
			elseif selected_algorithm.is_equal ("minimax_ab") then
				if selected_depth <= 0 then
					engine := create {MINIMAX_AB_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make (problem)
				else
					engine := create {MINIMAX_AB_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make_with_depth (problem, selected_depth)
				end
			elseif selected_algorithm.is_equal ("negascout") then
				if selected_depth <= 0 then
					engine := create {NEGASCOUT_ENGINE[ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make (problem)
				else
					engine := create {NEGASCOUT_ENGINE [ACTION_SELECT, ADVERSARY_STATE, ADVERSARY_PROBLEM]}.make_with_depth (problem, selected_depth)
				end
			end
		end


feature -- Status report

	problem: ADVERSARY_PROBLEM
		-- The problem which ought to be solved through the use of AI search;

	engine: ADVERSARY_SEARCH_ENGINE [ACTION, ADVERSARY_STATE, ADVERSARY_PROBLEM]
		-- The engine used to solve the problem;


feature -- Implementation

	is_valid_action (a_player_id: INTEGER; a_action: ACTION): BOOLEAN
		local
			l_is_valid: BOOLEAN
			l_hole_selected: INTEGER
		do
			l_is_valid := true

				-- INVALID PLAYER:
			if l_is_valid and then a_player_id /= current_state.index_of_current_player then
				l_is_valid := false
			end

			if l_is_valid and then attached {ACTION_SELECT} a_action as action_select then
				l_hole_selected := action_select.get_selection

					-- THE HOLE SELECTED EXISTS:
				if l_is_valid and then action_select.get_selection <= 0 or {GAME_CONSTANTS}.num_of_holes < action_select.get_selection then
					l_is_valid := false
				end

					-- HOLE OF ANOTHER PLAYER:
				if l_is_valid and then not current_state.valid_player_hole (current_state.index_of_current_player, l_hole_selected) then
					l_is_valid := false
				end

					-- HOLE WITH ZERO VALUE:
				if l_is_valid and then current_state.map.get_hole_value (l_hole_selected) = 0 then
					l_is_valid := false
				end
			elseif l_is_valid and then attached {ACTION_OTHER} a_action as action_other then
				if action_other.action = (create {ENUM_OTHER}).hint then
					current_state.set_parent (Void)
					current_state.set_rule_applied (Void)
					engine.reset_engine
					engine.perform_search (current_state)
					current_state := engine.obtained_successor
				elseif action_other.action = (create {ENUM_OTHER}).solve then
					l_is_valid := true
				else
					l_is_valid := false
				end
			end

			if attached {ACTION_SELECT} a_action as action_select and then l_is_valid then
				current_state := create {ADVERSARY_STATE}.make_from_parent_and_rule (current_state, action_select)
			end
			Result := l_is_valid
		ensure then
			invalid_player: a_player_id /= Old current_state.index_of_current_player implies Result = false
		end


	ai_move (a_state: ADVERSARY_STATE)
			-- The AI performs a move on the given state,
			-- and the current state of the rule-set is updated accordingly;
		require else
			non_void_engine: engine /= VOID
		do
			engine.reset_engine
			engine.perform_search (a_state)

			current_state := engine.obtained_successor
		ensure
			current_state = engine.obtained_successor
		end

end
