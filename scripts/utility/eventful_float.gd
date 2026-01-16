class_name EventfulFloat extends Resource

signal updated(newValue : float)

# internal value
var _value : float
@export var value : float:
	get = get_value,
	set = update_value


func _init(val : float) -> void:
	_value = val # sets value without triggering update


func subscribe(c : Callable) -> void:
	updated.connect(c)


func unsubscribe(c : Callable) -> void:
	updated.disconnect(c)


### only emits updates if the new value isn't the same as the old value
func update_value(new : float) -> void:
	var old : float = _value
	_value = new
	
	if old != _value:
		updated.emit(_value)


func get_value() -> float:
	return _value
