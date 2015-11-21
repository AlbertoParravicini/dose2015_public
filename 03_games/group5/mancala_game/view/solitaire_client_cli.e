note
	description: "Summary description for {SOLITAIRE_CLIENT_CLI}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLITAIRE_VIEW_CLI

inherit
	VIEW

create
	make_and_launch

feature
	make_and_launch
		do
			-- crea game manager:
					-- crea e contiene il ruleset
					-- contiene il loop principale				
		end
end
