class_name PipeWall
extends Node2D

@export var speed: int = -24*3

@onready var pipe_bottom: Pipe = $PipeBottom
@onready var pipe_top: Pipe = $PipeTop
@onready var _score_area: Area2D = $ScoreArea
@onready var _vos: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	_score_area.connect("body_entered", _on_body_entered_score_area)
	_vos.connect("screen_exited", _on_screen_exited)

	pipe_bottom.opposite_pipe = pipe_top
	pipe_top.opposite_pipe = pipe_bottom


func _process(delta: float) -> void:
	position.x += speed * delta


func _on_body_entered_score_area(_body: Node2D) -> void:
	GameManager.point_scored.emit()


func _on_screen_exited() -> void:
	queue_free()
