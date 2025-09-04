extends Node

@export_group("Current Morphs")
@export var starting_morph: State
@export var current_morph: State

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_morph.
func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent

	# Initialize to the default state
	change_morph(starting_morph)

# Change to the new state by first calling any exit logic on the current state.
func change_morph(new_morph: State) -> void:
	if current_morph:
		current_morph.exit()

	current_morph = new_morph
	current_morph.enter()
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_morph = current_morph.process_physics(delta)
	if new_morph:
		change_morph(new_morph)

func process_input(event: InputEvent) -> void:
	var new_morph = current_morph.process_input(event)
	if new_morph:
		change_morph(new_morph)

func process_frame(delta: float) -> void:
	var new_morph = current_morph.process_frame(delta)
	if new_morph:
		change_morph(new_morph)
