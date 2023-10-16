extends Node

signal body_entered_pipe(body: Node2D, pipe_entered: Area2D, pipe_opposite: Area2D)
signal player_collided(player: Player, collider: Node2D)
signal player_jumped
signal point_scored(body: Node2D)

const HIGHSCORE_DATA_PATH = "user://highscore.dat"

var medal_score_thresholds: Array[int] = [1, 10, 20, 30, 40]
var medal_indexes: Array[int] = [0, 1, 2, 3, 4]

var score: int
var highscore: int
var medal_index: int

var _player_has_died_once: bool = false

@onready var sounds: Sounds = get_tree().current_scene.get_node("%Sounds")
@onready var background: Background = get_tree().current_scene.get_node("%Background")
@onready var pipe_wall_spawner: PipeWallSpawner = get_tree().current_scene.get_node("%PipeWallSpawner")
@onready var floor: Floor = get_tree().current_scene.get_node("%Floor")
@onready var player: Player = get_tree().current_scene.get_node("%Player")
@onready var ui: UI = get_tree().current_scene.get_node("%UI")
@onready var crash_effect: CrashEffect = get_tree().current_scene.get_node("%CrashEffect")


func game_start() -> void:
	print("#TODO# Game start")
	player.is_gliding = false
	pipe_wall_spawner.timer.start()
	ui.title_hide()
	ui.get_ready_hide()
	ui.instruction_hide()
	ui.score_show()
	AudioManager.play(sounds.game_start)


func game_over() -> void:
	highscore_save()
	print("#TODO# ---GAME OVER---")
	prints("#TODO# Score:", score)
	prints("#TODO# Highscore:", highscore)
	for i in medal_indexes:
		if int(score / medal_score_thresholds[i]) > 0:
			medal_index = i
	if not medal_index:
		medal_index = 0
	prints("#TODO# Medal index:", medal_index)
	print("#TODO# ---------------")

	ui.medal_set(medal_index)
	ui.highscore_set(highscore)
	ui.score_hide()
	ui.game_over_screen_show()

	medal_index = 0
	score = 0
	_player_has_died_once = true
	ui.instruction_show()
	AudioManager.play(sounds.game_end)


func highscore_save() -> void:
	var _data := FileAccess.open(HIGHSCORE_DATA_PATH, FileAccess.WRITE)
	_data.store_var(highscore)
	_data.close()


func highscore_load() -> void:
	if FileAccess.file_exists(HIGHSCORE_DATA_PATH):
		var _data := FileAccess.open(HIGHSCORE_DATA_PATH, FileAccess.READ)
		highscore = _data.get_var()
		_data.close()


func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	body_entered_pipe.connect(_on_body_entered_pipe)
	player_collided.connect(_on_player_collided)
	point_scored.connect(_on_point_scored)
	player_jumped.connect(_on_player_jumped)


func _ready() -> void:
	await get_tree().process_frame
	ui.score_set(score)
	highscore_load()

	ui.game_over_screen_hide()
	ui.score_hide()
	ui.get_ready_hide()

	ui.title_show()
	ui.instruction_show()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and player.is_dead:
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		pipe_wall_spawner.destroy_all_pipe_walls()
		pipe_wall_spawner.timer.stop()
		player.respawn()
		get_tree().paused = false
		ui.score_set(score)
		if _player_has_died_once:
			ui.get_ready_show()
			ui.game_over_screen_hide()


func _on_body_entered_pipe(body: Node2D, _pipe_entered: Area2D, _pipe_opposite: Area2D) -> void:
	if body == player:
		if not player.is_dropping:
			player.crash()
			crash_effect.crash()
			player.drop()
			get_tree().paused = true


func _on_player_collided(player: Player, collider: Node2D) -> void:
	if collider == floor:
		if not player.is_dropping:
			player.crash()
			crash_effect.crash()

		# Pause the scene and make the Player node pausable like the others already are, so it stops
		# rotating and checking further collisions
		get_tree().paused = true
		player.process_mode = Node.PROCESS_MODE_PAUSABLE

		player.die()
		game_over()


func _on_player_jumped() -> void:
	if player.is_gliding:
		game_start()


func _on_point_scored(body: Node2D) -> void:
	if body == player:
		score += 1
		if score > highscore:
			highscore = score
		ui.score_set(score)
		AudioManager.play(sounds.point_scored)
		prints("#TODO# Score:", score)
