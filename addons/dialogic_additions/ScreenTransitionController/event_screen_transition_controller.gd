@tool
extends DialogicEvent
class_name DialogicScreenTransitionControllerEvent

# Define properties of the event here
var transition := ScreenTransitions.Transition.FadeToBlack
var transition_in := true
var duration := 1.0
var wait := 0.0
var ease_type : Tween.EaseType
var transition_type : Tween.TransitionType

var transitions := [
	{'label': 'FadeToBlack',	'value': ScreenTransitions.Transition.FadeToBlack },
	{'label': 'CircleFade',		'value': ScreenTransitions.Transition.CircleFade },
]

var ease_options := [
	{'label': 'In', 	 'value': Tween.EASE_IN},
	{'label': 'Out', 	 'value': Tween.EASE_OUT},
	{'label': 'In_Out',  'value': Tween.EASE_IN_OUT},
	{'label': 'Out_In',  'value': Tween.EASE_OUT_IN},
]

var trans_options := [
	{'label': 'Linear', 	'value': Tween.TRANS_LINEAR},
	{'label': 'Sine', 		'value': Tween.TRANS_SINE},
	{'label': 'Quint', 		'value': Tween.TRANS_QUINT},
	{'label': 'Quart', 		'value': Tween.TRANS_QUART},
	{'label': 'Quad', 		'value': Tween.TRANS_QUAD},
	{'label': 'Expo', 		'value': Tween.TRANS_EXPO},
	{'label': 'Elastic', 	'value': Tween.TRANS_ELASTIC},
	{'label': 'Cubic', 		'value': Tween.TRANS_CUBIC},
	{'label': 'Circ', 		'value': Tween.TRANS_CIRC},
	{'label': 'Bounce', 	'value': Tween.TRANS_BOUNCE},
	{'label': 'Back', 		'value': Tween.TRANS_BACK},
	{'label': 'Spring', 	'value': Tween.TRANS_SPRING}
]

func _execute() -> void:
	ScreenTransitionController.transition_finished.connect(_on_transition_finished, CONNECT_ONE_SHOT)
	ScreenTransitionController.transition(transition, duration, transition_in, ease_type, transition_type, wait)


func _on_transition_finished() -> void:
	finish() # called to continue with the next event


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Screen Transition Controller"
	set_default_color('Color8')
	event_category = "Custom"



#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "screen_transition_controller"

func get_shortcode_parameters() -> Dictionary:
	return {
	#param_name 		: property_info
	#"my_parameter"		: {"property": "property", "default": "Default"},
		"transition" 		:  {"property": "transition", 		"default": ScreenTransitions.Transition.FadeToBlack},
		"duration" 			:  {"property": "duration", 		"default": 1.0},
		"wait" 				:  {"property": "wait", 			"default": 1.0},
		"transition_in" 	:  {"property": "transition_in", 	"default": true},
		"ease_type" 		:  {"property": "ease_type", 		"default": Tween.EaseType.EASE_OUT},
		"transition_type" 	:  {"property": "transition_type", 	"default": Tween.TransitionType.TRANS_LINEAR},
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_edit("transition", ValueType.FIXED_OPTIONS, {'options': transitions, 'left_text':"Transition:"})
	add_header_edit('transition_in', ValueType.BOOL, {'left_text':'Transition in?'})
	add_header_edit('duration', ValueType.NUMBER, {'left_text':'Duration', 'autofocus':true, 'min':0.1})
	add_header_edit('wait', ValueType.NUMBER, {'left_text':'Wait', 'autofocus':true, 'min':0.0})
	add_body_edit("transform_trans", ValueType.FIXED_OPTIONS, {'options': trans_options, 'left_text':"Trans:"})
	add_body_edit("transform_ease", ValueType.FIXED_OPTIONS, {'options': ease_options, 'left_text':"Ease:"})
#endregion
