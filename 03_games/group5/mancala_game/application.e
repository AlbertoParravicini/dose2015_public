note
	description	: "Root class for Mancala Game."
	author		: "DOSE 2015 Group 5"
	date		: "$Date: 2015/11/11 8:39:15 $"
	revision	: "1.0.0"

class
	APPLICATION

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
		local
			l_app: EV_APPLICATION
			map: GAME_MAP
		do
			create map.make
			create l_app
			prepare
			l_app.launch
		end

	prepare
			-- Prepare the first window to be displayed.
			-- Perform one call to first window in order to
			-- avoid to violate the invariant of class EV_APPLICATION.
		do
				-- create and initialize the first window.
			create first_window

				-- Show the first window.
				--| TODO: Remove this line if you don't want the first
				--|       window to be shown at the start of the program.
			first_window.show
		end

feature {NONE} -- Implementation

	first_window: MAIN_WINDOW
			-- Main window.

end -- class APPLICATION
