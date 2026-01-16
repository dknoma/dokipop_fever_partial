extends Node


var character_data : Dictionary[String, CharacterData] = {}
var timelines : Dictionary[String, DialogicTimeline] = {}


func _ready() -> void:
	find_resource("res://resources/character_data", character_data)
	find_resource("res://dialogue/timelines", timelines)

	Console.log(character_data)
	Console.log(timelines)
	

func get_character(string : String) -> CharacterData:
	return character_data.get(string)
	

func get_timeline(string : String) -> DialogicTimeline:
	return timelines.get(string)

	
func find_resource(path : String, dict : Dictionary) -> void:
	var dir := DirAccess.open(path)
	dir.list_dir_begin()

	var next := dir.get_next()
	Console.log("next='%s', %s" % [next, dir.get_files()])

	if next.is_empty(): return

	while !next.is_empty():
		Console.log("\tnext=%s" % [next])
		# ignore files beginning with '.'
		if next.begins_with("."):
			next = dir.get_next()
			# next is directory, search directory for valid files
		elif dir.current_is_dir():
			#print_debug("'%s' is dir" % [next])
			find_resource(path + "/" + next, dict)
			next = dir.get_next()
		else:
			Console.log("nnnnext=%s" % [next])
			next = next.trim_suffix(".remap")
			Console.log("new=%s" % [next])
#			if !next.ends_with(".tscn"):
#				next = dir.get_next()
#				continue
			var res : Resource = load(path + "/" + next)
			if !res:
				Console.log_warn("Resource '%s' not found..." % [path])
				next = dir.get_next()
				continue
			dict[path.get_file()] = res
#			levels[next.trim_suffix(".tscn")] = path + "/" + next
			next = dir.get_next()
			Console.log("go next=%s, %s" % [next, dir.get_files()])
