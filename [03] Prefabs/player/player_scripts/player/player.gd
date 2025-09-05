class_name Player
extends RigidBody3D

@onready var shapeshift_manager: Node = $shapeshift_manager
@onready var morph_selection_component: Node = $morph_selection_component

func _ready() -> void:
	# Initialize the state machine, that way they can move and react accordingly
	shapeshift_manager.init(self, morph_selection_component)

## Passes a reference from the player to the states.
func _unhandled_input(event: InputEvent) -> void:
	shapeshift_manager.process_input(event)

func _physics_process(delta: float) -> void:
	shapeshift_manager.process_physics(delta)

func _process(delta: float) -> void:
	shapeshift_manager.process_frame(delta)
