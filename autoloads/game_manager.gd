extends Node

signal body_entered_pipe(body: Node2D, pipe_entered: Area2D, pipe_opposite: Area2D)
signal player_collided(player: Player, collider: Node2D)
signal player_jumped
signal point_scored

var score: int = 0
var medals := {
	platinum = 40,
	gold = 30,
	silver = 20,
	bronze = 10,
}
var medal: String

@onready var background: Background = get_tree().current_scene.get_node("%Background")
@onready var pipe_wall_spawner: PipeWallSpawner = get_tree().current_scene.get_node("%PipeWallSpawner")
@onready var floor: Floor = get_tree().current_scene.get_node("%Floor")
@onready var player: Player = get_tree().current_scene.get_node("%Player")
@onready var crash_effect: CrashEffect = get_tree().current_scene.get_node("%CrashEffect")


func game_over() -> void:
	print("#TODO# ---GAME OVER---")
	prints("#TODO# Score:", score)
	for m in medals.keys():
		var _score_threshold: int = medals[str(m)]
		if int(score / _score_threshold) > 0:
			medal = m
			break

	prints("#TODO# Medal:", medal.to_pascal_case() + "!" if medal else "none")
	print("#TODO# ---------------")

	medal = ""
	score = 0


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	body_entered_pipe.connect(_on_body_entered_pipe)
	player_collided.connect(_on_player_collided)
	point_scored.connect(_on_point_scored)
	player_jumped.connect(_on_player_jumped)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player.is_dead:
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		pipe_wall_spawner.destroy_all_pipe_walls()
		pipe_wall_spawner.timer.stop()
		player.respawn()
		get_tree().paused = false


func _on_body_entered_pipe(body: Node2D, _pipe_entered: Area2D, _pipe_opposite: Area2D) -> void:
	if body == player:
		if not player.is_dropping:
			crash_effect.crash()
			player.drop()
			get_tree().paused = true


func _on_player_collided(player: Player, collider: Node2D) -> void:
	if collider == floor:
		if not player.is_dropping:
			crash_effect.crash()

		# Pause the scene and make the Player node pausable like the others already are, so it stops
		# rotating and checking further collisions
		get_tree().paused = true
		player.process_mode = Node.PROCESS_MODE_PAUSABLE

		player.die()
		game_over()


func _on_player_jumped() -> void:
	if player.is_gliding:
		player.is_gliding = false
		pipe_wall_spawner.timer.start()


func _on_point_scored() -> void:
	score += 1
	prints("#TODO# Score:", score)
