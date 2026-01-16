class_name StoryMode extends Node


var current_story : Story
var current_chapter : Chapter


func set_story(story : Story) -> void:
	current_story = story


func start_chapter(index : int) -> void:
	var chapter := current_story.chapters[index]

	Dialogic.start(chapter.dialogue)


#func _start() -> void:
#	start_chapter(0)
