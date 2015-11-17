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
		do
			create p.make (2)
			p.extend (create {HUMAN_PLAYER}.make)
			p.extend (create {AI_PLAYER}.make)

			create state.make(p)
			print(state.out)

				-- Sequence of game moves:
			--create moves_array.make_from_array (<<3,4,7,5,7,1>>)
			--create moves_array.make_from_array (<<1,10>>)
			create moves_array.make_from_array (<<3,4,8,12,4,7,3,10,2,8,1,7,3,12>>)

			from
				moves_array.start
			until
				moves_array.exhausted
			loop
				state := create {ADVERSARY_STATE}.make_from_parent_and_rule (state, create {ACTION_SELECT}.make(moves_array.item))
				print(state.out)
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
