class_name UI
extends Control

@export var medal_textures: Array[Texture2D]

@onready var score: Label = $Score
@onready var title: Label = $Title
@onready var get_ready: Label = $GetReady
@onready var instruction: TextureRect = $Instruction
@onready var game_over_screen: Control = $GameOverScreen
@onready var game_over_medal: TextureRect = $GameOverScreen/Panel/Medal
@onready var game_over_score: Label = $GameOverScreen/Panel/Score
@onready var game_over_highscore: Label = $GameOverScreen/Panel/Highscore


func score_set(score: int) -> void:
	self.score.text = str(score)
	game_over_score.text = str(score)


func highscore_set(score: int) -> void:
	game_over_highscore.text = str(score)


func medal_set(medal_index: int) -> void:
	game_over_medal.texture = medal_textures[medal_index]


func score_show() -> void:
	score.visible = true


func score_hide() -> void:
	score.visible = false


func title_hide() -> void:
	title.visible = false


func get_ready_show() -> void:
	get_ready.visible = true


func get_ready_hide() -> void:
	get_ready.visible = false


func instruction_show() -> void:
	instruction.visible = true


func instruction_hide() -> void:
	instruction.visible = false


func game_over_screen_show() -> void:
	game_over_screen.visible = true


func game_over_screen_hide() -> void:
	game_over_screen.visible = false
