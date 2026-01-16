class_name SettingsService extends Service

const CONFIG_PATH := "user://settings.cfg"


func _get_name() -> String:
	return "Settings"
	

func get_settings() -> ConfigFile:
	var cfg := ConfigFile.new()
	var err := cfg.load(CONFIG_PATH)
	return cfg if err == OK else null


func text_speed() -> StoryService.TextSpeed:
	var cfg := ConfigFile.new()
	var err := cfg.load(CONFIG_PATH)
	if err == OK:
		return cfg.get_value("dialogue", "text_speed")
	return StoryService.TextSpeed.Normal


func master_volume() -> float:
	return get_volume("master_volume")


func music_volume() -> float:
	return get_volume("music_volume")


func sfx_volume() -> float:
	return get_volume("sfx_volume")


func dialogue_volume() -> float:
	return get_volume("dialogue_volume")


func get_volume(key : String) -> float:
	var cfg := ConfigFile.new()
	var err := cfg.load(CONFIG_PATH)
	
	if err == OK:
		return cfg.get_value("volume", key)
	return 1


func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("volume", "master_volume", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	cfg.set_value("volume", "music_volume", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	cfg.set_value("volume", "sfx_volume", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	cfg.set_value("volume", "dialogue_volume", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Dialogue")))
	cfg.set_value("dialogue", "text_speed", Game.Story.text_speed)
	cfg.save(CONFIG_PATH)
	pass


func load_settings() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(CONFIG_PATH)
	
	if err == OK:
		var master : float = cfg.get_value("volume", "master_volume")
		var music : float = cfg.get_value("volume", "music_volume")
		var sfx : float = cfg.get_value("volume", "sfx_volume")
		var dialogue : float = cfg.get_value("volume", "dialogue_volume")
		var text_speed : StoryService.TextSpeed = cfg.get_value("dialogue", "text_speed")
		
		Game.Story.set_text_speed(text_speed)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialogue"), dialogue)
	else:
		Console.log("Failed to load savings. Saving default settings...")
		save_settings()
