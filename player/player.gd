class_name Player
extends CharacterBody2D

# Got some hints from this FlappyBird tutorial:
# https://github.com/wojciech-bilicki/FlappyBird/blob/main/Scripts/bird.gd

#TODO# Should I use gravity from ProjectSettings instead?
var _gravity: int = 800
var _max_falling_speed: int = 400
var _jump_force: int = -250

var _jump_rotation_degrees: int = -30
var _fraction_of_max_falling_speed_to_begin_downward_rotation: float = 0.3
var _max_falling_rotation_degrees: int = 90

func _physics_process(delta: float) -> void:

	#TODO# Should this be handled by a GameManager or InputManager instead?
	if Input.is_action_just_pressed("jump"):
		velocity.y = _jump_force
		rotation_degrees = _jump_rotation_degrees

	# Apply gravity, limiting the falling speed to the preset max
	velocity.y += _gravity * delta
	velocity.y = clampf(velocity.y, _jump_force, _max_falling_speed)

	if velocity.y > _max_falling_speed * _fraction_of_max_falling_speed_to_begin_downward_rotation \
	and rotation_degrees < _max_falling_rotation_degrees:
		rotation_degrees += 2
	elif velocity.y < 0 and rotation_degrees > _jump_rotation_degrees:
		rotation_degrees -= 2

	move_and_collide(velocity * delta)
