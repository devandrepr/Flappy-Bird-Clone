class_name Background
extends Node2D

@onready var _sprite_1: Sprite2D = $Sprite1
@onready var _sprite_2: Sprite2D = $Sprite2
@onready var _vos_notifier_1: VisibleOnScreenNotifier2D = $Sprite1/VOSNotifier1
@onready var _vos_notifier_2: VisibleOnScreenNotifier2D = $Sprite2/VOSNotifier2

@export var motion_speed: int = -5


func _ready() -> void:
	_vos_notifier_1.connect("screen_exited", _on_screen_exited)
	_vos_notifier_2.connect("screen_exited", _on_screen_exited)


func _process(delta: float) -> void:
	global_position.x += motion_speed * delta


func _on_screen_exited() -> void:
	var _pos1 := _sprite_1.global_position.x
	var _pos2 := _sprite_2.global_position.x
	if _pos1 < _pos2:
		_sprite_1.global_position.x = _pos2 + _sprite_2.get_rect().size.x
	else:
		_sprite_2.global_position.x = _pos1 + _sprite_1.get_rect().size.x
