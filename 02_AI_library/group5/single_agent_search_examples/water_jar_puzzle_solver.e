note
	description: "Dummy class holding dummy main routine."
	library: "Eiffel AI Search Library"
	copyright: "Copyright (c) 2015"
	license: "MIT License (see https://opensource.org/licenses/MIT)"
	author: "DOSE 2015 Teams"
	date: "$Date: 2015-08-30 19:20:00 -0300$"
	revision: "$Revision: 0.1 $"

class
	WATER_JAR_PUZZLE_SOLVER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			jar_puzzle: WATER_JAR_PUZZLE
			engine: BOUNDED_DEPTH_FIRST_SEARCH_ENGINE[STRING, WATER_JAR_PUZZLE_STATE, WATER_JAR_PUZZLE]
			curr_depth: INTEGER
			found: BOOLEAN
			i: INTEGER
			path: LIST[WATER_JAR_PUZZLE_STATE]
		do
			from
				curr_depth := 12
				create jar_puzzle.make
				create engine.make (jar_puzzle)
				engine.set_max_depth (curr_depth)
			until
				found or curr_depth=20
			loop
				engine.perform_search
				if (engine.is_search_successful) then
					print ("solution found: " + engine.obtained_solution.out + " sat depth " + curr_depth.out + ".%N")
					print ("visited states: " + engine.nr_of_visited_states.out + "%N")
					print ("path to solution: %N")
					from
						i := 1
						path := engine.path_to_obtained_solution
					until
						i>path.count
					loop
						if path.i_th (i).rule_applied /= Void then
							-- skips the first state that has void rule
							print ("    " + path.i_th (i).rule_applied + "%N")
						end
						print (path.i_th (i).out + "%N")
						i := i+1
					end
					found := True
				else
					print ("no solution found with depth " + curr_depth.out +".%N")
					print ("visited states: " + engine.nr_of_visited_states.out + "%N")
					curr_depth := curr_depth+1
					engine.reset_engine
					engine.set_max_depth (curr_depth)
				end
			end
		end

end
