note
	description: "[
		Objects that represent an EV_TITLED_WINDOW.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	generator: "EiffelBuild"
	date: "$Date: 2015-04-03 06:15:42 -0700 (Fri, 03 Apr 2015) $"
	revision: "$Revision: 97017 $"

deferred class
	ADVERSARY_WINDOW_IMP

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects, initialize, is_in_default_state
		end

	CONSTANTS
		undefine
			is_equal, default_create, copy
		end

	VIEW
		undefine
			default_create, copy
		end

feature {NONE}-- Initialization

	frozen initialize
			-- Initialize `Current'.
		local
			internal_font: EV_FONT
		do
			Precursor {EV_TITLED_WINDOW}
			initialize_constants


				-- Build widget structure.
			extend (box_container_main)
			box_container_main.extend (box_container_main_2)
			box_container_main_2.extend (box_container_game)
			box_container_game.extend (box_container_ai)
			box_container_ai.extend (label_store_2_value)
			box_container_ai.extend (label_store_2_name)
			box_container_game.extend (box_container_hole)
			box_container_hole.extend (box_top_row_hole)
			box_top_row_hole.extend (button_hole_12)
			box_top_row_hole.extend (button_hole_11)
			box_top_row_hole.extend (button_hole_10)
			box_top_row_hole.extend (button_hole_9)
			box_top_row_hole.extend (button_hole_8)
			box_top_row_hole.extend (button_hole_7)
			box_container_hole.extend (box_bottom_row_hole)
			box_bottom_row_hole.extend (button_hole_1)
			box_bottom_row_hole.extend (button_hole_2)
			box_bottom_row_hole.extend (button_hole_3)
			box_bottom_row_hole.extend (button_hole_4)
			box_bottom_row_hole.extend (button_hole_5)
			box_bottom_row_hole.extend (button_hole_6)
			box_container_game.extend (box_container_player)
			box_container_player.extend (label_store_1_value)
			box_container_player.extend (label_store_1_name)
			box_container_game.extend (box_container_extra)
			box_container_extra.extend (button_hint)
			box_container_extra.extend (button_log)
			box_container_main_2.extend (text_log)

			box_container_main.set_border_width (5)
			integer_constant_set_procedures.extend (agent box_container_ai.set_padding (?))
			integer_constant_retrieval_functions.extend (agent box_score_padding)
			integer_constant_set_procedures.extend (agent box_container_ai.set_border_width (?))
			integer_constant_retrieval_functions.extend (agent box_score_padding)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (72)
			internal_font.preferred_families.extend ("Ubuntu")
			label_store_2_value.set_font (internal_font)
			label_store_2_value.set_text ("48")
			integer_constant_set_procedures.extend (agent label_store_2_value.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent label_score_width)
			label_store_2_name.set_text ("Cpu Score")
			integer_constant_set_procedures.extend (agent label_store_2_name.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent label_score_width)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_12.set_font (internal_font)
			button_hole_12.disable_sensitive
			button_hole_12.set_text ("12")
			integer_constant_set_procedures.extend (agent button_hole_12.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_12.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_11.set_font (internal_font)
			button_hole_11.disable_sensitive
			button_hole_11.set_text ("11")
			integer_constant_set_procedures.extend (agent button_hole_11.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_11.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_10.set_font (internal_font)
			button_hole_10.disable_sensitive
			button_hole_10.set_text ("10")
			integer_constant_set_procedures.extend (agent button_hole_10.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_10.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_9.set_font (internal_font)
			button_hole_9.disable_sensitive
			button_hole_9.set_text ("9")
			integer_constant_set_procedures.extend (agent button_hole_9.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_9.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_8.set_font (internal_font)
			button_hole_8.disable_sensitive
			button_hole_8.set_text ("8")
			integer_constant_set_procedures.extend (agent button_hole_8.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_8.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_7.set_font (internal_font)
			button_hole_7.disable_sensitive
			button_hole_7.set_text ("7")
			integer_constant_set_procedures.extend (agent button_hole_7.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_7.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_1.set_font (internal_font)
			button_hole_1.set_text ("1")
			integer_constant_set_procedures.extend (agent button_hole_1.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_1.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_2.set_font (internal_font)
			button_hole_2.set_text ("2")
			integer_constant_set_procedures.extend (agent button_hole_2.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_2.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_3.set_font (internal_font)
			button_hole_3.set_text ("3")
			integer_constant_set_procedures.extend (agent button_hole_3.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_3.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_4.set_font (internal_font)
			button_hole_4.set_text ("4")
			integer_constant_set_procedures.extend (agent button_hole_4.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_4.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_5.set_font (internal_font)
			button_hole_5.set_text ("5")
			integer_constant_set_procedures.extend (agent button_hole_5.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_5.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (32)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hole_6.set_font (internal_font)
			button_hole_6.set_text ("6")
			integer_constant_set_procedures.extend (agent button_hole_6.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent button_hole_width)
			integer_constant_set_procedures.extend (agent button_hole_6.set_minimum_height (?))
			integer_constant_retrieval_functions.extend (agent button_hole_height)
			integer_constant_set_procedures.extend (agent box_container_player.set_padding (?))
			integer_constant_retrieval_functions.extend (agent box_score_padding)
			integer_constant_set_procedures.extend (agent box_container_player.set_border_width (?))
			integer_constant_retrieval_functions.extend (agent box_score_padding)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (72)
			internal_font.preferred_families.extend ("Ubuntu")
			label_store_1_value.set_font (internal_font)
			label_store_1_value.set_text ("0")
			integer_constant_set_procedures.extend (agent label_store_1_value.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent label_score_width)
			label_store_1_name.set_text ("Player Score")
			integer_constant_set_procedures.extend (agent label_store_1_name.set_minimum_width (?))
			integer_constant_retrieval_functions.extend (agent label_score_width)
			box_container_extra.set_border_width (10)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_regular)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (20)
			internal_font.preferred_families.extend ("Ubuntu")
			button_hint.set_font (internal_font)
			button_hint.set_text ("Hint")
			button_hint.set_minimum_height (90)
			button_log.set_text ("Hide Log")
			text_log.set_minimum_height (80)
			text_log.disable_edit
			set_title ("Display window")

			set_all_attributes_using_constants

				-- Connect events.
			button_hole_12.select_actions.extend (agent action_hole_click)
			button_hole_11.select_actions.extend (agent action_hole_click)
			button_hole_10.select_actions.extend (agent action_hole_click)
			button_hole_9.select_actions.extend (agent action_hole_click)
			button_hole_8.select_actions.extend (agent action_hole_click)
			button_hole_7.select_actions.extend (agent action_hole_click)
			button_hole_1.select_actions.extend (agent action_hole_click)
			button_hole_2.select_actions.extend (agent action_hole_click)
			button_hole_3.select_actions.extend (agent action_hole_click)
			button_hole_4.select_actions.extend (agent action_hole_click)
			button_hole_5.select_actions.extend (agent action_hole_click)
			button_hole_6.select_actions.extend (agent action_hole_click)
			button_hint.select_actions.extend (agent action_hint_click)
			button_log.select_actions.extend (agent action_log_click)
				-- Close the application when an interface close
				-- request is received on `Current'. i.e. the cross is clicked.
			close_request_actions.extend (agent destroy_and_exit_if_last)

				-- Call `user_initialization'.
			user_initialization
		end

	frozen create_interface_objects
			-- Create objects
		do

				-- Create all widgets.
			create box_container_main
			create box_container_main_2
			create box_container_game
			create box_container_ai
			create label_store_2_value
			create label_store_2_name
			create box_container_hole
			create box_top_row_hole
			create button_hole_12
			create button_hole_11
			create button_hole_10
			create button_hole_9
			create button_hole_8
			create button_hole_7
			create box_bottom_row_hole
			create button_hole_1
			create button_hole_2
			create button_hole_3
			create button_hole_4
			create button_hole_5
			create button_hole_6
			create box_container_player
			create label_store_1_value
			create label_store_1_name
			create box_container_extra
			create button_hint
			create button_log
			create text_log

			create string_constant_set_procedures.make (10)
			create string_constant_retrieval_functions.make (10)
			create integer_constant_set_procedures.make (10)
			create integer_constant_retrieval_functions.make (10)
			create pixmap_constant_set_procedures.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create integer_interval_constant_retrieval_functions.make (10)
			create integer_interval_constant_set_procedures.make (10)
			create font_constant_set_procedures.make (10)
			create font_constant_retrieval_functions.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create color_constant_set_procedures.make (10)
			create color_constant_retrieval_functions.make (10)
			user_create_interface_objects

			--- I added this
			create list_button_hole.make
			list_button_hole.extend (button_hole_1)
			list_button_hole.extend (button_hole_2)
			list_button_hole.extend (button_hole_3)
			list_button_hole.extend (button_hole_4)
			list_button_hole.extend (button_hole_5)
			list_button_hole.extend (button_hole_6)
			list_button_hole.extend (button_hole_7)
			list_button_hole.extend (button_hole_8)
			list_button_hole.extend (button_hole_9)
			list_button_hole.extend (button_hole_10)
			list_button_hole.extend (button_hole_11)
			list_button_hole.extend (button_hole_12)
			---

		end


feature -- Access

	box_container_main, box_container_game, box_top_row_hole, box_bottom_row_hole: EV_HORIZONTAL_BOX
	box_container_main_2,
	box_container_ai, box_container_hole, box_container_player, box_container_extra: EV_VERTICAL_BOX
	label_store_2_value,
	label_store_2_name, label_store_1_value, label_store_1_name: EV_LABEL
	button_hole_12,
	button_hole_11, button_hole_10, button_hole_9, button_hole_8, button_hole_7, button_hole_1,
	button_hole_2, button_hole_3, button_hole_4, button_hole_5, button_hole_6, button_hint,
	button_log: EV_BUTTON
	text_log: EV_TEXT
	list_button_hole:LINKED_LIST[EV_BUTTON]

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN
			-- Is `Current' in its default state?
		do
			Result := True
		end

	user_create_interface_objects
			-- Feature for custom user interface object creation, called at end of `create_interface_objects'.
		deferred
		end

	user_initialization
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end

	action_hole_click (a_hole:INTEGER)
			-- Called by `select_actions' of `button_hole_12'.
		deferred
		end

	action_hint_click
			-- Called by `select_actions' of `button_hint'.
		deferred
		end

	action_log_click
			-- Called by `select_actions' of `button_log'.
		deferred
		end


feature {NONE} -- Constant setting

	frozen set_attributes_using_string_constants
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant.
		local
			s: STRING_32
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).item (Void)
				string_constant_set_procedures.item.call ([s])
				string_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_integer_constants
			-- Set all attributes relying on integer constants to the current
			-- value of the associated constant.
		local
			i: INTEGER
			arg1, arg2: INTEGER
			int: INTEGER_INTERVAL
		do
			from
				integer_constant_set_procedures.start
			until
				integer_constant_set_procedures.off
			loop
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).item (Void)
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				arg1 := integer_interval_constant_retrieval_functions.item.item (Void)
				integer_interval_constant_retrieval_functions.forth
				arg2 := integer_interval_constant_retrieval_functions.item.item (Void)
				create int.make (arg1, arg2)
				integer_interval_constant_set_procedures.item.call ([int])
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_pixmap_constants
			-- Set all attributes relying on pixmap constants to the current
			-- value of the associated constant.
		local
			p: EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).item (Void)
				pixmap_constant_set_procedures.item.call ([p])
				pixmap_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_font_constants
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant.
		local
			f: EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).item (Void)
				font_constant_set_procedures.item.call ([f])
				font_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_color_constants
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant.
		local
			c: EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).item (Void)
				color_constant_set_procedures.item.call ([c])
				color_constant_set_procedures.forth
			end
		end

	frozen set_all_attributes_using_constants
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end

	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, STRING_32]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER]]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_PIXMAP]]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER_INTERVAL]]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_FONT]]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_COLOR]]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_COLOR]]

	frozen integer_from_integer (an_integer: INTEGER): INTEGER
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

end
