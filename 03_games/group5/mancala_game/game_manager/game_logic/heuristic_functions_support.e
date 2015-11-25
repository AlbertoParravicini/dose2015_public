note
	description: "Summary description for {MATH_STUFF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HEURISTIC_FUNCTIONS_SUPPORT

inherit

	DOUBLE_MATH

create
	make

feature

	num_of_weights: INTEGER = 6

	random_number_generator: RANDOM
		-- Random numbers generator to have a random number;

	time_seed_for_random_generator: TIME
		-- Time variable in order to get new random numbers from random numbers generator every time the program runs.

	breeding_factor: REAL_64 = 0.7
		-- How much the better weights list should be valued over the worse list when breeding a new weights list;

	split_factor: REAL_64 = 0.1
		-- If the mean difference between two weights is lower than this value, the weights should start to converge;

	starting_variance: REAL_64 = 0.08
		-- The variance of the starting weights list;


	make
		do
			create time_seed_for_random_generator.make_now
				-- Initializes random generator using current time seed.
			create random_number_generator.set_seed (((time_seed_for_random_generator.hour * 60 + time_seed_for_random_generator.minute) * 60 + time_seed_for_random_generator.second) * 1000 + time_seed_for_random_generator.milli_second)
			random_number_generator.start
		end

	initialize_weights: ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			-- Initialize the weights with average 1 / weights.count and variance = 1;
		local
			i: INTEGER
			l_weights: ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
		do
			from
				i := 1
				create l_weights.make (num_of_weights)
			until
				i > num_of_weights
			loop
				l_weights.extend ([1 / l_weights.capacity, starting_variance])
				i := i + 1
			end

			Result := l_weights
		end

	generate_gaussian_weights (a_weights:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]): ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			-- Updates the given weights list by applying the Box-Muller transform to each element;
		local
			box_muller_result: TUPLE[z1: REAL_64; z2: REAL_64]
		do
			from
				a_weights.start
			until
				a_weights.exhausted
			loop
				box_muller_result := box_muller_transform
				a_weights.item.weight := update_gaussian_value (box_muller_result.z1, a_weights.item.weight, a_weights.item.variance)
				a_weights.forth
				a_weights.item.weight := update_gaussian_value (box_muller_result.z2, a_weights.item.weight, a_weights.item.variance)
				a_weights.forth
			end
			if num_of_weights \\ 2 = 1 then
				box_muller_result := box_muller_transform
				a_weights.item.weight := update_gaussian_value (box_muller_result.z1, a_weights.item.weight, a_weights.item.variance)
			end

			Result := a_weights
		end

	generate_uniform_weights (a_weights:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]): ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			-- Updates the given weights list by generating a set of uniformly distributed weights of given mean and support (support = 2 * variance, in this case);
		do
			from
				a_weights.start
			until
				a_weights.exhausted
			loop
				a_weights.item.weight := random_number_generator.real_item * (2 * a_weights.item.variance) + (a_weights.item.weight - a_weights.item.variance)

					-- Negative numbers are truncated;
				if a_weights.item.weight < 0 then
					a_weights.item.weight := 0
				end
				a_weights.forth
				random_number_generator.forth
			end

			Result := a_weights
		end

	box_muller_transform: TUPLE [z1: REAL_64; z2: REAL_64]
			-- Return two indipendent random numbers generated with normal distribution N(0, 1);
		local
			u1: REAL_64
			u2: REAL_64
			z1: REAL_64
			z2: REAL_64
		do
			u1 := random_number_generator.real_item
			random_number_generator.forth
			u2 := random_number_generator.real_item


			z1 := sqrt (-2 * log (u1)) * cosine (2 * pi * u2)
			z2 := sqrt (-2 * log (u1)) * sine (2 * pi * u2)

			Result := [z1, z2]
		end

	update_gaussian_value (gaussian_value: REAL_64; a_mean: REAL_64; a_variance: REAL_64): REAL_64
			-- Turn a gaussian random number generated by a distribution N(mu, sigma^2)
			-- into a random number with distribution N(mu + a_mean; a_variance * sigma^2);
		do
			Result := gaussian_value * sqrt (a_variance) + a_mean
		end

	log_normal_weights (a_weights:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]): ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			-- Turn the given list, made of normally distibuted weights,
			-- into a list of log-normally distributed weights, so that their values are always positive;
		do
			from
				a_weights.start
			until
				a_weights.exhausted
			loop
				a_weights.item.weight := exp (a_weights.item.weight)
				a_weights.forth
			end

			Result := a_weights
		end

	normalize_weights (a_weights:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]): ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			-- Normalize the weights so that their sum is 1; useful so that the results aren't randomly skewed;
		local
			weights_sum: REAL_64
		do
			from
				a_weights.start
			until
				a_weights.exhausted
			loop
				weights_sum := weights_sum + a_weights.item.weight
				a_weights.forth
			end

			from
				a_weights.start
			until
				a_weights.exhausted
			loop
				a_weights.item.weight := a_weights.item.weight / weights_sum
				a_weights.forth
			end
			Result := a_weights
		end

	breed_weights (better_weights:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]; worse_weigths:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]): ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			-- Given two lists of weights, breeds a new list of weights by giving priority to the better weights;
		local
			bred_vector: ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			i: INTEGER
			bred_mean: REAL_64
			bred_variance: REAL_64

			mean_diff: REAL_64
		do
			create bred_vector.make (num_of_weights)
			from
				i := 1
			until
				i > num_of_weights
			loop
				bred_mean := breeding_factor * better_weights.i_th (i).weight + (1.0 - breeding_factor) * worse_weigths.i_th (i).weight

				mean_diff := dabs(better_weights.i_th (i).weight - worse_weigths.i_th (i).weight)

				bred_variance := (breeding_factor * (better_weights.i_th (i).variance + better_weights.i_th (i).weight.power(2)) + (1.0 - breeding_factor) * (worse_weigths.i_th (i).variance + worse_weigths.i_th (i).weight.power(2))) - bred_mean.power (2)

				--bred_variance := better_weights.i_th (i).variance * (mean_diff / split_factor).power(1/3)


				bred_vector.extend ([bred_mean, bred_variance])
				i := i + 1
			end

			bred_vector := generate_gaussian_weights (bred_vector)
			bred_vector := log_normal_weights (bred_vector)
			bred_vector := normalize_weights (bred_vector)
			Result := bred_vector
		end

	breed_uniform_weights (better_weights:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]; worse_weigths:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]): ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			-- Given two lists of weights, breeds a new list of weights by giving priority to the better weights.
			-- The assumed distribution of the given weights is assumed to be uniform;
		local
			bred_vector: ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]]
			i: INTEGER
			bred_mean: REAL_64
			bred_variance: REAL_64

			better_weight: REAL_64
			worse_weight: REAL_64
			better_variance: REAL_64
			worse_variance: REAL_64

			mean_diff: REAL_64
		do
			create bred_vector.make (num_of_weights)
			from
				i := 1
			until
				i > num_of_weights
			loop
				better_weight := better_weights.i_th (i).weight
				worse_weight := worse_weigths.i_th (i).weight
				better_variance := better_weights.i_th (i).variance
				worse_variance := worse_weigths.i_th (i).variance

				bred_mean := breeding_factor * better_weight + (1.0 - breeding_factor) * worse_weight
				mean_diff := dabs(better_weight - worse_weight)

				-- 2-Way entanglement:
--				if (better_weight < worse_variance + worse_weight) and (better_weight > - worse_variance + worse_weight) and
--					(worse_weight < better_variance + better_weight) and (worse_weight > - better_variance + better_weight) then

--					bred_variance := mean_diff
--				else
--					print ("diverging")
--					bred_variance := (breeding_factor * better_variance) + ((1.0 - breeding_factor) * worse_variance)
--				end
				bred_variance := (breeding_factor * better_variance) + ((1.0 - breeding_factor) * worse_variance)

				bred_vector.extend ([bred_mean, bred_variance])
				i := i + 1
			end

			bred_vector := generate_uniform_weights (bred_vector)
			bred_vector := normalize_weights (bred_vector)
			Result := bred_vector

		end


	print_weights (a_weights:  ARRAYED_LIST [TUPLE [weight: REAL_64; variance: REAL_64]])
		do
			from
				a_weights.start
			until
				a_weights.exhausted
			loop
				print ("WEIGHT: " + a_weights.item.weight.truncated_to_real.out + ", VARIANCE: " + a_weights.item.variance.truncated_to_real.out + "%N")
				a_weights.forth
			end
			print ("%N")
		end
end
