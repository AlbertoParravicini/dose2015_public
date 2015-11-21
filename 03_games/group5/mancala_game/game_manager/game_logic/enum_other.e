note
	description: "Summary description for {ENUM_OTHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENUM_OTHER
feature
	-- Exploiting enumeration using unique object for each enumerable value
	hint : ENUM_OTHER once create Result end
	solve : ENUM_OTHER once create Result end
end
