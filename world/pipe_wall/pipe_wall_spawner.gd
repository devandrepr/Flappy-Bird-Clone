class_name PipeWallSpawner
extends Marker2D

@export var _pipe_wall_scene: PackedScene

@onready var timer: Timer = $Timer

@onready var _range_top: Marker2D = $RangeTop
@onready var _range_bottom: Marker2D = $RangeBottom
@onready var _pipes: Node2D = $Pipes


func _ready() -> void:
	timer.timeout.connect(spawn)


func spawn() -> void:
	var _pipe_wall := _pipe_wall_scene.instantiate() as PipeWall
	_pipe_wall.position.y = int(randf_range(_range_top.position.y, _range_bottom.position.y))
	_pipes.add_child(_pipe_wall)
