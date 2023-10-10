class_name Floor
extends StaticBody2D

@onready var _sprites: Node2D = $Sprites
@onready var _sprite_1: Sprite2D = $Sprites/Sprite1
@onready var _sprite_2: Sprite2D = $Sprites/Sprite2
@onready var _vos_notifier_1: VisibleOnScreenNotifier2D = $Sprites/Sprite1/VOSNotifier1
@onready var _vos_notifier_2: VisibleOnScreenNotifier2D = $Sprites/Sprite2/VOSNotifier2

@export var motion_speed: int = -30


func _ready() -> void:
	_vos_notifier_1.connect("screen_exited", _on_screen_exited)
	_vos_notifier_2.connect("screen_exited", _on_screen_exited)


func _process(delta: float) -> void:
	_sprites.global_position.x += motion_speed * delta


func _on_screen_exited() -> void:
	var _pos1 := _sprite_1.global_position.x
	var _pos2 := _sprite_2.global_position.x
	if _pos1 < _pos2:
		_sprite_1.global_position.x = _pos2 + _sprite_2.get_rect().size.x
	else:
		_sprite_2.global_position.x = _pos1 + _sprite_1.get_rect().size.x
