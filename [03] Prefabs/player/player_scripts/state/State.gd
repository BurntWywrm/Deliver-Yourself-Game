class_name State
extends Node

# Hold a reference to the parent so that it can be controlled by the state
var parent: Player

# Hold a reference to the morph_selection_component so that it can be controlled by the state
var morph_selection_component

# Hold a reference to the morph_selection_component so that it can be controlled by the state
var animations: AnimationPlayer

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
