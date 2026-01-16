class_name BubbleGenerator extends Node2D

const BUBBLE_SCENE = "res://scenes/bubbles/character_bubble.tscn"
const BUBBLE_TYPE_DOKI = "res://scenes/bubbles/doki_01.tscn"
const BUBBLE_TYPE_DRAGOON = "res://scenes/bubbles/dragoon_01.tscn"
const BUBBLE_TYPE_SAGE = "res://scenes/bubbles/sage_dragoon_01.tscn"
const BUBBLE_TYPE_MINT = "res://scenes/bubbles/mint_01.tscn"
const BUBBLE_TYPE_DOOBY = "res://scenes/bubbles/dooby_01.tscn"
const BUBBLE_TYPE_CHIBI = "res://scenes/bubbles/chibi_01.tscn"
const BUBBLE_TYPE_DAD = "res://scenes/bubbles/dad_01.tscn"
const BUBBLE_SKILL_01 = "res://scenes/skills/skill_size_increase.tscn"
const BUBBLE_SKILL_02 = "res://scenes/skills/skill_board_clear.tscn"
const BUBBLE_SKILL_03 = "res://scenes/skills/skill_bubble_creation.tscn"
const BUBBLE_SKILL_04 = "res://scenes/skills/skill_gunblade.tscn"
const BUBBLE_SKILL_05 = "res://scenes/skills/skill_bubble_transformation.tscn"
const S_BUBBLE_TYPE_05 = "res://scenes/bubbles/binding_bubble_body.tscn"
const S_BUBBLE_TYPE_06 = "res://scenes/bubbles/debuff_bubble_body.tscn"
const S_BUBBLE_TYPE_07 = "res://scenes/bubbles/bomb_bubble_body.tscn"

var character_bubbles : Array[PackedScene]

@export var gravity_area : Area2D
@export var center_bubble : CenterBubble

enum {MINT, DOOBY, CHIBI, DAD}
const SAGE = MINT
const MINT2 = CHIBI

func _ready():
	BubbleManager.center_point = gravity_area.global_position
	BubbleManager.bubble_container = self
	ChainHandler.center_bubble = center_bubble
	character_bubbles = [
		load(BUBBLE_TYPE_DOKI),
		load(BUBBLE_TYPE_DRAGOON),
		load(BUBBLE_TYPE_SAGE),
		load(BUBBLE_TYPE_MINT),
		load(BUBBLE_TYPE_DOOBY),
		load(BUBBLE_TYPE_CHIBI),
		load(BUBBLE_TYPE_DAD)
	]
	
func start_game() -> void:
	BubbleManager.types_scenes = []
	var rand_scene : PackedScene
	var i = 0
	var character_bubble_scene : PackedScene = Game.current_player.bubble_scene
	var opponent_bubble_scene : PackedScene = Game.Puzzle.opponent.bubble_scene
	var char_lim
	var possible_bubbles : Array[PackedScene]
	match Game.Puzzle.opponent.ID:
		"sagedragoon01": char_lim = SAGE
		"mint01": char_lim = MINT
		"dooby01": char_lim = DOOBY
		"chibi01": char_lim = CHIBI
		"mint02": char_lim = MINT
		"dad01": char_lim = DAD
		_: Console.log("ID NOT FOUND")
	possible_bubbles = character_bubbles.slice(0, char_lim+4)
	BubbleManager.types_scenes.append(character_bubble_scene)
	BubbleManager.types_scenes.append(opponent_bubble_scene)
	while(i<2):
		rand_scene = possible_bubbles.pick_random()
		if rand_scene in BubbleManager.types_scenes:
			continue
		BubbleManager.types_scenes.append(rand_scene)
		i = i + 1
	BubbleManager.start_game()
