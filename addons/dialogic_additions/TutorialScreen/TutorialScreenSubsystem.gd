class_name TutorialScreenSubsystem extends DialogicSubsystem

## Describe the subsystems purpose here.
signal finished

var tutorial_layer : TutorialScreenLayer

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
func show_tutorial_screen(path : String) -> void:
	if dialogic.has_subsystem('Tutorial'):
		tutorial_layer = dialogic.Styles.get_first_node_in_layout('tutorial_screen')
	else:
		tutorial_layer = get_tree().get_first_node_in_group('tutorial_screen')
	var scn : PackedScene = load(path)
	if !scn:
		finished.emit()
		return
	var scene := scn.instantiate()
	if scene is not TutorialWindow:
		finished.emit()
		return
	tutorial_layer.set_tutorial_screen(scn)
	#tutorial_layer.show_image(collectible)
	tutorial_layer.closed.connect(finished.emit, CONNECT_ONE_SHOT)
	
	
	# TODO: don't know what we should do with glossaries rn. It would technically be able to support collectibles
#	var glossary := dialogic.Glossary.find_glossary("Collectibles")
#	var dict := glossary.get_entry(collectible.name)
#	dict["enabled"] = true
	
