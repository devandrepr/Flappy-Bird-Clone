class_name Pipe
extends StaticBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var opposite_pipe: Pipe


func disable_collision() -> void:
	collision_shape.disabled = true
