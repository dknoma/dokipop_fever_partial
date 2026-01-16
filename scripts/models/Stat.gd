@tool
class_name Stat extends Resource

signal updated(newValue : float)

@export var name := "STAT"
## Maximum value of the stat
@export var max_value : float = 100.0
## Base value of the state to start with
@export var base_value : float = 100.0
## Current stat value
@export var value : float = 0:
	get = get_value,
	set = update_value
## Used internally; doesn't cause any updates or emit signals when updated
var _value : float


func set_values(name : String, max_val : float, base_val : float, val : float) -> Stat:
	self.name = name
	max_value = max_val
	base_value = base_val
	_value = val # sets value without triggering update
	return self


func subscribe(c : Callable) -> void:
	updated.connect(c)


func unsubscribe(c : Callable) -> void:
	updated.disconnect(c)


### only emits updates if the new value isn't the same as the old value
func update_value(new : float) -> void:
	var old : float = _value
	_value = max(0, min(new, max_value))
	
	if old != _value:
		updated.emit(_value)


func get_value() -> float:
	return _value
