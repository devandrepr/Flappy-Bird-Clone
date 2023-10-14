extends Node

signal body_entered_pipe(body: Node2D, pipe_entered: Area2D, pipe_opposite: Area2D)
signal player_collided(player: Player, collider: Node2D)
signal player_died(player: Player)
signal player_jumped
signal point_scored

var score: int = 0

@onready var background: Background = get_tree().current_scene.get_node("%Background")
@onready var pipe_wall_spawner: PipeWallSpawner = get_tree().current_scene.get_node("%PipeWallSpawner")
@onready var floor: Floor = get_tree().current_scene.get_node("%Floor")
@onready var player: Player = get_tree().current_scene.get_node("%Player")


func _init() -> void:
	body_entered_pipe.connect(_on_body_entered_pipe)
	player_collided.connect(_on_player_collided)
	player_died.connect(_on_player_died)
	point_scored.connect(_on_point_scored)
	player_jumped.connect(_on_player_jumped)


func _on_body_entered_pipe(body: Node2D, _pipe_entered: Area2D, _pipe_opposite: Area2D) -> void:
	if body == player:
		if not body.is_dead:
			body.die()
			get_tree().paused = true


func _on_player_collided(player: Player, collider: Node2D) -> void:
	if collider == floor:
		# Stop processing physics on Player, so it stops rotating and checking further collisions
		player.process_mode = Node.PROCESS_MODE_PAUSABLE
	if not player.is_dead:
		player.die()
		get_tree().paused = true


#TODO# Probably should skip this signal, since it's only GameManager who calls player.die() anyway
func _on_player_died(player: Player) -> void:
	print("#TODO# oh no, player died")


func _on_point_scored() -> void:
	score += 1
	prints("#TODO# Score:", score)
