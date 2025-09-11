class_name Envelope_Morph
extends State
#envelope_morph_script.gd

@onready var envelope_movement_manager: Node = $envelope_movement_manager

func enter() -> void:
	animations.play("envelope_enter")
	print("ENVELOPE")

func exit() -> void:
	envelope_movement_manager.deinit()

# Process player input during the state
func process_input(event: InputEvent) -> State:
	# Processes morph selection
	return morph_selection_component.process_morph_selection(event, self)
	return null

# Process player character actions
func process_physics(delta: float) -> State:
	return null
