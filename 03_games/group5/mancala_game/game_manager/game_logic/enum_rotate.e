note
	description: "Enumeration for the rotation: clockwise or counter_clockwise"
	author: "Simone Ripamonti"
	date: "$Date$"
	revision: "$Revision$"

class
	ENUM_ROTATE
feature
	-- Exploiting enumeration using unique object for each enumerable value
	clockwise : ENUM_ROTATE once create Result end
	counter_clockwise : ENUM_ROTATE once create Result end
end
