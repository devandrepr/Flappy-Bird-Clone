class_name Floor
extends StaticBody2D

@export var speed: int = -24

@onready var _sprite1: Sprite2D = $Sprite1
@onready var _sprite2: Sprite2D = $Sprite2
@onready var _vos1: VisibleOnScreenNotifier2D = $Sprite1/VisibleOnScreenNotifier2D
@onready var _vos2: VisibleOnScreenNotifier2D = $Sprite2/VisibleOnScreenNotifier2D
@onready var col_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_vos1.connect("screen_exited", _on_screen_exited.bind(_sprite1, _sprite2))
	_vos2.connect("screen_exited", _on_screen_exited.bind(_sprite2, _sprite1))


func _process(delta: float) -> void:
	_sprite1.position.x += speed * delta
	_sprite2.position.x += speed * delta


func _on_screen_exited(sprite_out: Sprite2D, sprite_in: Sprite2D) -> void:
#	prints("<--   ", sprite_out, "   <--   ", sprite_in)
	sprite_out.position.x = sprite_in.position.x + sprite_out.get_rect().size.x
