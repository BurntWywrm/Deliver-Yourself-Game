extends Node
# movement_manager.gd

@export_group("Current Movement")
@export var starting_movement: State
@export var current_movement: State

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_morph.
func init(parent: Player, animations: AnimationPlayer) -> void:
	for child in get_children():
		child.parent = parent
		child.animations = animations

	# Initialize to the default state
	change_movement(starting_movement)

# Gets called the _morph_script exit(): De-initializes the state machine to prevent it from getting called in another morph state
func deinit() -> void:
	for child in get_children():
		child.parent = null
	if current_movement:
		current_movement.exit()
		current_movement = null	

# Change to new movement states by calling any logic on the current state
func change_movement(new_movement: State) -> void:
	if current_movement:
		current_movement.exit() # Exits current movement state
	
	current_movement = new_movement # Recieves new movement state
	current_movement.enter() # Enters new movement state

# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	if current_movement == null:
		return
	var new_movement = current_movement.process_physics(delta)
	if new_movement:
		change_movement(new_movement)

func process_input(event: InputEvent) -> void:
	if current_movement == null:
		return
	var new_movement = current_movement.process_input(event)
	if new_movement:
		change_movement(new_movement)

func process_frame(delta: float) -> void:
	if current_movement == null:
		return
	var new_movement = current_movement.process_frame(delta)
	if new_movement:
		change_movement(new_movement)
