note
	description: "Summary description for {ACTION}."
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
