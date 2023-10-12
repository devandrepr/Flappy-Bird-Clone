extends Node

signal player_collided(player: Player, collider: Node2D)
signal player_died(player: Player)
signal point_scored

var score: int = 0


func _init() -> void:
	player_collided.connect(_on_player_collided)
	player_died.connect(_on_player_died)
	point_scored.connect(_on_point_scored)


func _on_player_collided(player: Player, collider: Node2D) -> void:

	if collider is Pipe:
		collider.disable_collision()
		collider.opposite_pipe.disable_collision()

	if collider is Floor:
		# Just so the player stops rotating when already on the floor.
		player.process_mode = Node.PROCESS_MODE_PAUSABLE

	get_tree().paused = true
	player.die()


#TODO# Probably should skip this signal, since it's only GameManager who calls player.die() anyway
func _on_player_died(player: Player) -> void:
	print("#TODO# oh no, player died")


func _on_point_scored() -> void:
	score += 1
	prints("#TODO# Score:", score)
