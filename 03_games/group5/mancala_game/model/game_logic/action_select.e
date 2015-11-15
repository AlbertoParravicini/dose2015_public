note
	description: "Action that represents the selection of an hole by the user"
	author: "Simone Ripamonti"
	date: "$Date$"
	revision: "$Revision$"

class
	ACTION_SELECT

inherit

	ACTION

create
	make

feature
	-- Creation

	make (bucket: INTEGER)
		require
			bucket_not_valid: bucket > 0 and bucket <= {GAME_CONSTANTS}.num_of_buckets
		do
			selection := bucket
		ensure
			selection = bucket
		end

feature
	-- Getter

	get_selection: INTEGER
		do
			Result := selection
		ensure
			Result > 0 and Result < {GAME_CONSTANTS}.num_of_buckets
		end

feature {NONE}
	-- variables

	selection: INTEGER
			-- selected hole

end
