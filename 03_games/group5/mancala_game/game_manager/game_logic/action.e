note
	description: "Represents a generic action performed by a human player."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ACTION
inherit
	ANY
		undefine
			out
		end
feature
	out : STRING
		deferred
		end
end
