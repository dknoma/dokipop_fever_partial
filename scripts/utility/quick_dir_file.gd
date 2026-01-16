class_name QuickDirFile
extends Node

static func is_dir_valid(directory:String) -> bool:
	return DirAccess.dir_exists_absolute(directory)

static func make_dir(dir_name:String) -> void:
	DirAccess.make_dir_absolute(dir_name)

static func make_deep_dir(directory:String) -> void:
	var dir_as_array:Array[String] = []
	var current_valid_path:String = "user://"
	if is_user_dir(directory):
		directory = directory.erase(0, 7)
	for folder_name in directory.split("/"):
		dir_as_array.append(folder_name)
	for dir in dir_as_array:
		current_valid_path += "/" + dir
		if !is_dir_valid(current_valid_path):
			make_dir(current_valid_path)

static func is_json_file(file_name:String) -> bool:
	return file_name.ends_with(".json")

static func is_user_dir(directory:String) -> bool:
	return directory.begins_with("user://")
