class_name Background
extends Node2D

@export var sky_speed: int = -2
@export var buildings_speed: int = -4

@onready var _sky_sprite1: Sprite2D = $Sky/Sprite1
@onready var _sky_sprite2: Sprite2D = $Sky/Sprite2
@onready var _sky_vos1: VisibleOnScreenNotifier2D = $Sky/Sprite1/VOSNotifier1
@onready var _sky_vos2: VisibleOnScreenNotifier2D = $Sky/Sprite2/VOSNotifier2
@onready var _buildings_sprite1: Sprite2D = $Buildings/Sprite1
@onready var _buildings_sprite2: Sprite2D = $Buildings/Sprite2
@onready var _buildings_vos1: VisibleOnScreenNotifier2D = $Buildings/Sprite1/VOSNotifier1
@onready var _buildings_vos2: VisibleOnScreenNotifier2D = $Buildings/Sprite2/VOSNotifier2


func _ready() -> void:
	_sky_vos1.connect("screen_exited", _on_screen_exited.bind(_sky_sprite1, _sky_sprite2))
	_sky_vos2.connect("screen_exited", _on_screen_exited.bind(_sky_sprite2, _sky_sprite1))
	_buildings_vos1.connect("screen_exited", _on_screen_exited.bind(_buildings_sprite1, _buildings_sprite2))
	_buildings_vos2.connect("screen_exited", _on_screen_exited.bind(_buildings_sprite2, _buildings_sprite1))


func _process(delta: float) -> void:
	_sky_sprite1.global_position.x += sky_speed * delta
	_sky_sprite2.global_position.x += sky_speed * delta
	_buildings_sprite1.global_position.x += buildings_speed * delta
	_buildings_sprite2.global_position.x += buildings_speed * delta


func _on_screen_exited(sprite_out: Sprite2D, sprite_in: Sprite2D) -> void:
#	prints("<--   ", sprite_out, "   <--   ", sprite_in)
	sprite_out.global_position.x = sprite_in.global_position.x + sprite_out.get_rect().size.x
