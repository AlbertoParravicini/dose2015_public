note
	description: "Root class for Mancala Game."
	author: "DOSE 2015 Group 5"
	date: "$Date: 2015/11/11 8:39:15 $"
	revision: "1.0.0"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	view_mode: MAIN_WINDOW_CLI
	gui: START_GUI

	make
		do
			--create view_mode.make_and_launch
			create gui.make_and_launch
		end

end
