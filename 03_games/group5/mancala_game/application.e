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
			state, state2, state3, state4, state5, state6, state7: ADVERSARY_STATE
		do
			create p.make (2)
			p.extend (create {HUMAN_PLAYER}.make)
			p.extend (create {AI_PLAYER}.make)

			create state.make(p)
			print(state.out)

			create state2.make_from_parent_and_rule (state, VOID)
			state2.move(3)
			print(state2.out)

			create state3.make_from_parent_and_rule (state2, VOID)
			state3.move(4)
			print(state3.out)

			create state4.make_from_parent_and_rule (state3, VOID)
			state4.move(7)
			print(state4.out)

			create state5.make_from_parent_and_rule (state4, VOID)
			state5.move(5)
			print(state5.out)

			create state6.make_from_parent_and_rule (state5, VOID)
			state6.move(7)
			print(state6.out)

			create state7.make_from_parent_and_rule (state6, VOID)
			state7.move(1)
			print(state7.out)
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
