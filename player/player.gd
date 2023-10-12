class_name Player
extends CharacterBody2D
# Got some hints from this FlappyBird tutorial:
# https://github.com/wojciech-bilicki/FlappyBird/blob/main/Scripts/bird.gd

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

#TODO# Should I use gravity from ProjectSettings instead?
var _gravity: int = 700
var _max_falling_speed: int = 400
var _jump_impulse: int = -240

var _jump_rotation_degrees: int = -20
var _fraction_of_max_falling_speed_to_begin_downward_rotation: float = 0.3
var _falling_rotation_degrees_max: int = 90
var _falling_rotation_degrees_speed: int = 200
var _dead_falling_rotation_degrees_speed: int = 1000
var _dead_bounce_speed: int = 50
#var _last_velocity_y: float

var is_dead: bool = false


func die() -> void:
	is_dead = true
	animated_sprite.stop()
	_falling_rotation_degrees_speed = _dead_falling_rotation_degrees_speed
	velocity.y = _dead_bounce_speed

	#TODO# Probably should skip this signal, since it's only GameManager who calls player.die() anyway
	GameManager.player_died.emit(self)


func _physics_process(delta: float) -> void:
	#TODO# Should this be handled by a GameManager or InputManager instead?
	if Input.is_action_just_pressed("jump") and not is_dead:
#		printt(global_position.y, "jump start")
		velocity.y = _jump_impulse
		rotation_degrees = _jump_rotation_degrees

	# Apply gravity, limiting the falling speed to the preset max
	velocity.y += _gravity * delta  # Gravity = acceleration, so, *delta here and *delta again later
	velocity.y = clampf(velocity.y, _jump_impulse, _max_falling_speed)

	# Apply falling rotation
	if velocity.y > _max_falling_speed * _fraction_of_max_falling_speed_to_begin_downward_rotation \
	 and rotation_degrees < _falling_rotation_degrees_max:
		rotation_degrees += _falling_rotation_degrees_speed * delta
	elif velocity.y < 0 and rotation_degrees > _jump_rotation_degrees:
		rotation_degrees -= _falling_rotation_degrees_speed * delta

#	if _last_velocity_y < 0 and velocity.y >= 0:
#		printt(global_position.y, "jump end")
#	_last_velocity_y = velocity.y

	var _collision := move_and_collide(velocity * delta)
	if _collision and not is_dead:
		GameManager.player_collided.emit(self, _collision.get_collider())
