extends State

@export_group("Shapeshifting Morphs")
@export var box_morph: State
@export var gift_morph: State

var morph_selection_change = 1
const morph_slection_max = 3
const morph_slection_min = 1

func enter() -> void:
	pass

# Process player input during the state
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("ScrollUP"):
		morph_selection_change += 1
		if morph_selection_change > morph_slection_max:
			morph_selection_change = morph_slection_min
	elif Input.is_action_just_pressed("ScrollDown"):
		morph_selection_change -= 1
		if morph_selection_change < morph_slection_min:
			morph_selection_change = morph_slection_max
	return null

# Process player character actions
func process_physics(delta: float) -> State:
	print(morph_selection_change)
	return null
