class_name PipeWall
extends Node2D

@export var speed: int = -24*3

@onready var pipe_bottom: Area2D = $PipeBottom
@onready var pipe_top: Area2D = $PipeTop
@onready var _score_area: Area2D = $ScoreArea
@onready var _vos: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	pipe_bottom.body_entered.connect(_on_body_entered_pipe.bind(pipe_bottom, pipe_top))
	pipe_top.body_entered.connect(_on_body_entered_pipe.bind(pipe_top, pipe_bottom))
	_score_area.body_entered.connect(_on_body_entered_score_area)
	_vos.screen_exited.connect(_on_screen_exited)


func _process(delta: float) -> void:
	position.x += speed * delta


func _on_body_entered_pipe(body: Node2D, pipe: Area2D, other_pipe: Area2D) -> void:
	GameManager.body_entered_pipe.emit(body, pipe, other_pipe)


func _on_body_entered_score_area(_body: Node2D) -> void:
	GameManager.point_scored.emit()


func _on_screen_exited() -> void:
	queue_free()
