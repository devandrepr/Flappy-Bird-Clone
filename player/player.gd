class_name Player
extends CharacterBody2D
# Got some hints from this FlappyBird tutorial:
# https://github.com/wojciech-bilicki/FlappyBird/blob/main/Scripts/bird.gd

var is_gliding: bool: set = _set_is_gliding
var is_dropping: bool = false
var is_dead: bool = false

var _gravity: int = 700
var _max_falling_speed: int = 400
var _jump_impulse: int = -240
var _jump_rotation_degrees: int = -20
var _fraction_of_max_falling_speed_to_begin_rotating_down: float = 0.3
var _falling_rotation_degrees_max: int = 90
var _falling_rotation_degrees_speed: int = 200
var _dead_falling_rotation_degrees_speed: int = 1000
var _dead_bounce_speed: int = 50

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func drop() -> void:
	print("#TODO# drop called")
	is_dropping = true
	is_gliding = false
	animated_sprite.stop()
	_falling_rotation_degrees_speed = _dead_falling_rotation_degrees_speed
	velocity.y = _dead_bounce_speed


func die() -> void:
	print("#TODO# die called")
	is_dropping = false
	is_gliding = false
	animated_sprite.stop()
	is_dead = true


# This should be flap(), but oh well
func jump() -> void:
	velocity.y = _jump_impulse
	rotation_degrees = _jump_rotation_degrees
	GameManager.player_jumped.emit()


func _set_is_gliding(new_value: bool) -> void:
	is_gliding = new_value
	if new_value:
		velocity.y = 0
		rotation_degrees = 0
		animation_player.play("glide")
	else:
		animation_player.stop()


func _ready() -> void:
	is_gliding = true


func _physics_process(delta: float) -> void:
	#TODO# Should this be handled by a GameManager or InputManager instead?
	if Input.is_action_just_pressed("jump") and not is_dropping and not is_dead:
		jump()

	if not is_gliding:
		# Apply gravity, limiting the falling speed to the preset max
		velocity.y += _gravity * delta  # Gravity = acceleration, so, *delta here and *delta again later
		velocity.y = clampf(velocity.y, _jump_impulse, _max_falling_speed)

		# Apply falling rotation
		if velocity.y > _max_falling_speed * _fraction_of_max_falling_speed_to_begin_rotating_down \
		 and rotation_degrees < _falling_rotation_degrees_max:
			rotation_degrees += _falling_rotation_degrees_speed * delta
		elif velocity.y < 0 and rotation_degrees > _jump_rotation_degrees:
			rotation_degrees -= _falling_rotation_degrees_speed * delta

	var _collision := move_and_collide(velocity * delta)
	if _collision:
		GameManager.player_collided.emit(self, _collision.get_collider())
