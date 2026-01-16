class_name StoryService extends Service

enum TextSpeed {
	Slow,
	Normal,
	Fast
}

var current_story : Story
var current_player : CharacterData

@onready var dragoon_keyhole : Texture2D = preload("res://assets/transition_art/dragoonkeyhole.png")
@onready var story_base_scene : PackedScene = preload("res://scenes/story/story_base_scene.tscn")
var story_scene : StoryBaseScene

var text_speed := TextSpeed.Normal


func _initialize(info : Dictionary) -> void:
	var story : Story = info["story"]
	start_story(story)
	

func _execute() -> void:
	pass
	
	
func start_story(story : Story) -> void:
	current_story = story
	current_player = Game.current_player
	# TODO: transitions
	
#	ScreenTransitionController.show_ui("CircleFade")
	ScreenTransitionController.keyhole_transition(dragoon_keyhole, 1, true, Tween.EASE_OUT, Tween.TRANS_LINEAR, Color.BLACK, 0)
	await ScreenTransitionController.transition_finished

	var chapter := current_story.get_current_chapter()
	if !chapter: return
	
	get_tree().change_scene_to_packed(story_base_scene)	
	
	await get_tree().create_timer(0.01).timeout

	story_scene = get_tree().get_current_scene()

	Dialogic.start(chapter.dialogue)
	

func start_chapter(chapter : Chapter) -> void:
	start_at(chapter, chapter.starting_point)
	
	
func start_at(chapter : Chapter, label : String) -> void:
	ScreenTransitionController.keyhole_transition(dragoon_keyhole, 1, true, Tween.EASE_OUT, Tween.TRANS_LINEAR, Color.BLACK, 0)
	await ScreenTransitionController.transition_finished

	get_tree().change_scene_to_packed(story_base_scene)

	await get_tree().create_timer(0.01).timeout
	
	Console.log("changed to story scene - %s, %s" % [chapter.name, label])

	story_scene = get_tree().get_current_scene()

	Dialogic.timeline_started.connect(func () -> void: Console.log("timeline started"))
	var node := Dialogic.start(chapter.dialogue, label)


func set_text_speed(speed : TextSpeed) -> void:
	text_speed = speed
	match text_speed:
		TextSpeed.Slow:
			ProjectSettings.set_setting('dialogic/text/letter_speed', 0.05)
		TextSpeed.Normal:
			ProjectSettings.set_setting('dialogic/text/letter_speed', 0.025)
		TextSpeed.Fast:
			ProjectSettings.set_setting('dialogic/text/letter_speed', 0.0125)


func update_text_speed() -> void:
	set_text_speed(text_speed)


func _get_name() -> String:
	return "Story"
