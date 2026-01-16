class_name Story extends Resource

@export var key := "dpf"
@export var chapters : Array[Chapter] = []


var index := 0


func get_current_chapter() -> Chapter:
	return chapters[index]


func get_next_chapter() -> Chapter:
	index += 1
	return chapters[index] if index < chapters.size() else null
