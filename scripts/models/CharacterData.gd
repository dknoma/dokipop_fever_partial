@tool
class_name CharacterData extends Resource

@export var name := "NO_NAME"
@export var ID := "NO_ID"

@export_group("Stats")
@export var hp : Stat = Stat.new().set_values("hp", 100, 100, 100)
@export var sp : Stat = Stat.new().set_values("sp", 100, 100, 100)
@export var stat_update_time : float = 0

@export_group("Details")
## Character portrait for dialogue
@export var portrait : Texture2D
## Bubble scene prefab
@export var bubble_scene : PackedScene
## Skill scene prefab
@export var skill_scene : PackedScene
## Dialogic character
@export var dialogue_data : DialogicCharacter

signal hp_updated(new_current_value:float, added_value:float)

## Only used to relay current hp value
var current_hp : float:
	get: return hp.value
	set(value): return

## Only used to relay current sp value
var current_sp : float:
	get: return sp.value
	set(value): return


var stats : Dictionary[String, Stat] = {
	hp.name: hp,
	sp.name: sp
}


#func _init() -> void:
#	if !hp:
#		hp = Stat.new("hp", 100, 100, 100)
#	if !sp:
#		sp = Stat.new("sp", 100, 100, 100)
#	for prop in get_property_list():
#		var p : Variant = get(prop.name)
#		if p is Stat:
#			stats[prop.name] = p


func _on_match_start() -> void:
	hp.update_value(hp.base_value)
	sp.update_value(0)


func _update_hp(value : float) -> void:
	hp.update_value(hp.value + value)
	hp_updated.emit(hp.value, value)


func _update_sp(value : float) -> void:
	sp.update_value(sp.value + value)
	
	
func _update_stat(stat_name : String, value : float) -> void:
	var stat := current_stat(stat_name)
	if stat:
		stat.update_value(stat.value + value)

	
func current_stat_value(stat_name : String) -> float:
	if stats.has(stat_name):
		return stats[stat_name].value
	return -1
	
	
func current_stat(stat_name : String) -> Stat:
	return stats.get(stat_name, null)


#func current_stat(stat_name : String) -> float:
#	if stats.has(stat_name):
#		return stats[stat_name].
#	return -1


func _to_string() -> String:
	return name
