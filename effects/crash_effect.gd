class_name CrashEffect
extends ColorRect


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func crash() -> void:
	animation_player.play("crash")
