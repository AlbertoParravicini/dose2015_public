note
	description: "Summary description for {MAIN_WONDOW_CLI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAIN_WINDOW_CLI

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
		do
			print("CLI: %N")
		end

end
