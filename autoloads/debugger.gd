extends Node

const SLOWMOTION_TOGGLE_KEY := KEY_F1
const SLOWMOTION_FASTER_KEY := KEY_F2
const SLOWMOTION_SLOWER_KEY := KEY_F3
const GLIDE_TOGGLE_KEY := KEY_F4

const SLOWMOTION_MIN: float = 0.01
const SLOWMOTION_MAX: float = 0.75
const SLOWMOTION_INCREMENT: float = 0.01

var slowmotion_is_enabled: bool = true # refers to the slow motion control as a whole
var background_is_enabled: bool = true
var floor_is_enabled: bool = true
var pipe_wall_is_enabled: bool = true
var player_is_enabled: bool = true

var _slowmotion_is_active: bool = false # refers to slow motion being applied or not
var _glide_is_active: bool = false
var _slowmotion_time_scale: float = SLOWMOTION_MIN


func _input(event: InputEvent) -> void:
	if slowmotion_is_enabled:
		if Input.is_key_pressed(SLOWMOTION_TOGGLE_KEY):
			if _slowmotion_is_active:
				_slowmotion_is_active = false
				Engine.time_scale = 1
				print("[Debugger] Slow motion deactivated")
			else:
				_slowmotion_is_active = true
				Engine.time_scale = _slowmotion_time_scale
				print("[Debugger] Slow motion activated")
				prints("[Debugger] (Slow motion) Engine.time_scale =", Engine.time_scale)
		if _slowmotion_is_active:
			if Input.is_key_pressed(SLOWMOTION_FASTER_KEY):
				_slowmotion_time_scale += SLOWMOTION_INCREMENT
				_slowmotion_time_scale = clampf(_slowmotion_time_scale, SLOWMOTION_MIN, SLOWMOTION_MAX)
				Engine.time_scale = _slowmotion_time_scale
				prints("[Debugger] (Slow motion) Engine.time_scale =", Engine.time_scale)
			elif Input.is_key_pressed(SLOWMOTION_SLOWER_KEY):
				_slowmotion_time_scale -= SLOWMOTION_INCREMENT
				_slowmotion_time_scale = clampf(_slowmotion_time_scale, SLOWMOTION_MIN, SLOWMOTION_MAX)
				Engine.time_scale = _slowmotion_time_scale
				prints("[Debugger] (Slow motion) Engine.time_scale =", Engine.time_scale)
	if Input.is_key_pressed(GLIDE_TOGGLE_KEY):
		if _glide_is_active:
			_glide_is_active = false
			GameManager.player.is_gliding = false
			print("[Debugger] Glide deactivated")
		else:
			_glide_is_active = true
			GameManager.player.is_gliding = true
			print("[Debugger] Glide activated")


func _ready() -> void:
	if not background_is_enabled:
		prints("[Debugger] Background is disabled; freeing", GameManager.background)
		GameManager.background.queue_free()
	if not floor_is_enabled:
		prints("[Debugger] Floor is disabled; freeing", GameManager.floor)
		GameManager.floor.queue_free()
	if not pipe_wall_is_enabled:
		prints("[Debugger] PipeWall is disabled; freeing", GameManager.pipe_wall_spawner)
		GameManager.pipe_wall_spawner.queue_free()
	if not player_is_enabled:
		prints("[Debugger] Player is disabled; freeing", GameManager.player)
		GameManager.player.queue_free()

	if slowmotion_is_enabled:
		print("[Debugger] Slow motion control is enabled")
