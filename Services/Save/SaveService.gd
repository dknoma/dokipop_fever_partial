class_name SaveService extends Service

const SAVE_NAME := "default_save_file.json"
const SAVE_PATH := "user://"


func _get_name() -> String:
	return "Save"


func _ready() -> void:
	await get_tree().create_timer(0.01).timeout

	var save_data := load_file()
	if save_data.is_empty():
		var data := create_default_save_file()
		Console.log("Creating new save file - %s" % [data])
		SaverLoader.save_to_user(SAVE_NAME, SAVE_PATH, data)

	Dialogic.VAR.variable_changed.connect(_on_variable_changed)


func _on_variable_changed(info : Dictionary) -> void:
	var var_name : String = info["variable"]
	var new : Variant = info["new_value"]
	
	if !var_name.begins_with("unlocks"): return # only worried about unlocks variables
	
	Console.log("variable updated - %s: %s" % [var_name, new])
	
	save_partial(var_name, new)


func save_partial(path : String, value : Variant) -> void:
	var dict := SaverLoader.load_from_user(SAVE_NAME, SAVE_PATH)
	get_var(path, dict, value)
	SaverLoader.save_to_user(SAVE_NAME, SAVE_PATH, dict)


func get_var(path : String, data : Dictionary, new : Variant) -> void:
	var parts := path.split(".")
	var value : Variant = data[parts[0]]
	if value is Dictionary:
		get_var(path.trim_prefix("%s." % [parts[0]]), value, new)
	else:
		data[parts[0]] = new
		#Console.log("data[%s]=%s -> %s - %s" % [parts[0], value, new, data])


func save_story(story : Story = null) -> void:
	var dict := SaverLoader.load_from_user(SAVE_NAME, SAVE_PATH)
	if dict.is_empty():
		dict["unlocks"] = {}
	
	find_unlocks(story if story else Game.Story.current_story, dict)
	
	SaverLoader.save_to_user(SAVE_NAME, SAVE_PATH, dict)
	Console.log("Saving file - %s" % [dict])


func load_file() -> Dictionary:
	var dict := SaverLoader.load_from_user(SAVE_NAME, SAVE_PATH)
	Console.log("Loaded save file - %s" % [dict])
	for unlocks_key : String in dict.keys():
		for story_key : String in dict[unlocks_key]:
			for key : String in dict[unlocks_key][story_key]:
				var value : Variant = dict[unlocks_key][story_key][key]
				Dialogic.VAR.set_variable("%s.%s.%s" % [unlocks_key, story_key, key], value)
	return dict

	
func create_default_save_file() -> Dictionary:
	var data := { "unlocks": {} }
	find_all_unlocks("unlocks", Dialogic.VAR.get_variable("unlocks"), data)
	
	return data


func find_unlocks(story : Story, data : Dictionary) -> void:
	if !story: return
	data["unlocks"][story.key] = {}
	
	# Searches Dialogic Variables for variables in the 'unlocks.<story_key>' folder
	var dict : Dictionary = Dialogic.VAR.get_variable("unlocks.%s" % [story.key])
	for key : String in dict.keys():
		data["unlocks"][story.key][key] = dict[key]


func find_all_unlocks(path : String, folder : Dictionary, data : Dictionary) -> void:
	if !folder: return
	for key : String in folder.keys():
		var variable : Variant = folder[key]
		if variable is not Dictionary:
			if data.has(path):
				data[path][key] = variable
			else:
				data[path] = { key: variable }
		else:
			find_all_unlocks(key, variable, data[path])
	
		
	# Searches Dialogic Variables for variables in the 'unlocks.<story_key>' folder
	#var dict : Dictionary = Dialogic.VAR.get_variable("unlocks.%s" % [story.key])
	#for key in dict.keys():
		#data["unlocks"][story.key][key] = dict[key]
