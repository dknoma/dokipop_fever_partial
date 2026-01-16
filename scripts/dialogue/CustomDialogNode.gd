@icon("node_dialog_text_icon.svg")
class_name CustomDialogNode extends DialogicNode_DialogText


func show_root() -> void:
	textbox_root.show()


func _process(delta: float) -> void:
	if !revealing or DialogicUtil.autoload().paused:
		return

	speed_counter += delta

	while speed_counter > active_speed and revealing and !DialogicUtil.autoload().paused:
		speed_counter -= active_speed
		continue_reveal()


func reveal_text(_text: String, keep_previous:=false) -> void:
	current_line = 0
	super.reveal_text(_text, keep_previous)


func finish_text() -> void:
	super.finish_text()
	scroll_to_line(get_line_count())


func continue_reveal() -> void:
	if visible_characters <= get_total_character_count():
		revealing = false

		var current_index := visible_characters - base_visible_characters
		await DialogicUtil.autoload().Text.execute_effects(current_index, self, false)

		if visible_characters == -1:
			return

		revealing = true
		visible_characters += 1

		if visible_characters > -1 and visible_characters <= len(get_parsed_text()):
			scroll_text()
			continued_revealing_text.emit(get_parsed_text()[visible_characters-1])
	else:
		finish_text()
		# if the text finished organically, add a small input block
		# this prevents accidental skipping when you expected the text to be longer
		DialogicUtil.autoload().Inputs.block_input(ProjectSettings.get_setting('dialogic/text/advance_delay', 0.1))


var current_line := 0
func scroll_text() -> void:
	var visible_lines := get_visible_line_count()
#	var total_lines := get_line_count()
#	var scroll_ratio := float(visible_characters) / get_total_character_count()
#	var a := int(scroll_ratio * (total_lines - visible_lines))
#	Console.log("visibles=%s (total=%s), scroll_ratio=%s, [%s]" % [visible_lines, total_lines, scroll_ratio, a])
	
	# TODO: need to take into account font sizes
	# currently hardcoded based off of the current font size (36); but only want to scroll if current line is at the end of the box, then text should scroll to the next new lines
	if visible_lines > 4:
		current_line = visible_lines - 1 if current_line < visible_lines - 1 else current_line + 5
		scroll_to_line(current_line)
