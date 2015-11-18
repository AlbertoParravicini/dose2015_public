note
	description: "Root class for Mancala Game."
	author: "DOSE 2015 Group 5"
	date: "$Date: 2015/11/11 8:39:15 $"
	revision: "1.0.0"

class
	APPLICATION

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
		local
			p: ARRAYED_LIST [PLAYER]
			state: ADVERSARY_STATE
			moves_array: ARRAYED_LIST[INTEGER]
			--set_of_rule: ADVERSARY_RULE_SET
		do
			--create set_of_rule.default_create
			create p.make (2)
			p.extend (create {HUMAN_PLAYER}.make)
			p.extend (create {AI_PLAYER}.make)

			create state.make(p)
			print(state.out)

				-- Sequence of game moves:
			create moves_array.make_from_array (<<3,5,9,6,10,2,1,5,6,7,4,11,5,4,10,2,11,3,7,6,7,1,9,5,8,6>>)

				-- Play game:
			from
				moves_array.start
			until
				moves_array.exhausted
			loop
				--if set_of_rule.is_valid_action(state, create {ACTION_SELECT}.make(moves_array.item)) then
					state := create {ADVERSARY_STATE}.make_from_parent_and_rule (state, create {ACTION_SELECT}.make(moves_array.item))
					print(state.out)
				--end
				moves_array.forth
			end

		end

	prepare
			-- Prepare the first window to be displayed.
			-- Perform one call to first window in order to
			-- avoid to violate the invariant of class EV_APPLICATION.
		do
				-- create and initialize the first window.
			--create first_window

				-- Show the first window.
				--| TODO: Remove this line if you don't want the first
				--|       window to be shown at the start of the program.
			--first_window.show
		end

feature {NONE} -- Implementation

	--first_window: MAIN_WINDOW
			-- Main window.

end -- class APPLICATION
