class_name ShowImageSubsystem extends DialogicSubsystem

## Describe the subsystems purpose here.
signal finished

var show_image_layer : ShowImageLayer

#region STATE
####################################################################################################

func clear_game_state(clear_flag := Dialogic.ClearFlags.FULL_CLEAR) -> void:
	dialogic.current_state_info['match_file_path'] = ""


func load_game_state(load_flag := LoadFlags.FULL_LOAD) -> void:
	pass

#endregion


#region MAIN METHODS
####################################################################################################

# Add some useful methods here.
func set_image(path : String) -> void:
	if dialogic.has_subsystem('Styles'):
		show_image_layer = dialogic.Styles.get_first_node_in_layout('show_image_layer')
	else:
		show_image_layer = get_tree().get_first_node_in_group('show_image_layer')
	var collectible : Collectible = load(path)
	if !collectible: return
	show_image_layer.show_image(collectible)
	show_image_layer.finished.connect(finished.emit, CONNECT_ONE_SHOT)
	
	
	# TODO: don't know what we should do with glossaries rn. It would technically be able to support collectibles
#	var glossary := dialogic.Glossary.find_glossary("Collectibles")
#	var dict := glossary.get_entry(collectible.name)
#	dict["enabled"] = true
	
