class_name PipeWall
extends Node2D

signal point_scored

@export var speed: int = -24*3

@onready var _score_area: Area2D = $ScoreArea
@onready var _vos: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	_score_area.connect("body_entered", _on_point_scored)
	_vos.connect("screen_exited", _on_screen_exited)


func _process(delta: float) -> void:
	position.x += speed * delta


func _on_point_scored() -> void:
	point_scored.emit()


func _on_screen_exited() -> void:
	queue_free()
