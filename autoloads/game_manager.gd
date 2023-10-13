extends Node

signal body_entered_pipe(body: Node2D, pipe_entered: Area2D, pipe_opposite: Area2D)
signal player_collided(player: Player, collider: Node2D)
signal player_died(player: Player)
signal point_scored

var score: int = 0


func _init() -> void:
	body_entered_pipe.connect(_on_body_entered_pipe)
	player_collided.connect(_on_player_collided)
	player_died.connect(_on_player_died)
	point_scored.connect(_on_point_scored)


func _on_body_entered_pipe(body: Node2D, _pipe_entered: Area2D, _pipe_opposite: Area2D) -> void:
	if body is Player:
		if not body.is_dead:
			body.die()
			get_tree().paused = true


func _on_player_collided(player: Player, collider: Node2D) -> void:
	if collider is Floor:
		# Just so the player stops rotating when already on the floor
		player.process_mode = Node.PROCESS_MODE_PAUSABLE

	get_tree().paused = true
	player.die()


#TODO# Probably should skip this signal, since it's only GameManager who calls player.die() anyway
func _on_player_died(player: Player) -> void:
	print("#TODO# oh no, player died")


func _on_point_scored() -> void:
	score += 1
	prints("#TODO# Score:", score)
