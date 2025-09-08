extends Node

## Morph selection variables
var gift_morph_change = 1
var box_morph_change = 2
var envelope_morph_change = 3
var morph_selection_change := 1
const morph_slection_max := 3
const morph_slection_min := 1

var on_cycle_cd = false
@onready var cycle_cd_timer: Timer = %Cycle_CD

@export_group("Shapeshifting Morphs")
@export var envelope_morph: State
@export var gift_morph: State
@export var box_morph: State

func process_morph_selection(event: InputEvent, current_state: State) -> State:
	# Cycles morph
	cycle_morph()
	# Handles selection
	var next_state: State = select_morph()
	if next_state == current_state:
		print("ERROR: tried to morph into same state")
		return null
	if next_state != null and next_state != current_state and on_cycle_cd == false:
		on_cycle_cd = true
		cycle_cd_timer.start()
		return next_state
	return null
	
func cycle_morph()-> void:
	# Morph Selection
	if Input.is_action_pressed("ScrollUP"):
		morph_selection_change += 1
		if morph_selection_change > morph_slection_max:
			morph_selection_change = morph_slection_min
	elif Input.is_action_pressed("ScrollDown"):
		morph_selection_change -= 1
		if morph_selection_change < morph_slection_min:
			morph_selection_change = morph_slection_max

func select_morph() -> State:
	if Input.is_action_just_pressed("Select") and on_cycle_cd == false:
		match morph_selection_change:
			1: return box_morph
			2: return gift_morph
			3: return envelope_morph
			_: return null
	# Cycle cooldown error handling
	elif Input.is_action_just_pressed("Select") and on_cycle_cd == true:
		print("ERROR: On cooldown")
		return null
	return null

func _physics_process(delta: float) -> void:
	pass

func _on_cycle_cd_timeout() -> void:
	on_cycle_cd = false
