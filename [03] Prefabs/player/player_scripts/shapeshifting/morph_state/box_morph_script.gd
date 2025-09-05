class_name Box_Morph
extends State

#box_morph_script.gd

func enter() -> void:
	animations.play("box_enter")
	print("BOX")

# Process player input during the state
func process_input(event: InputEvent) -> State:
	# Processes morph selection
	return morph_selection_component.process_morph_selection(event, self)
	return null

# Process player character actions
func process_physics(delta: float) -> State:
	return null
