extends Node

signal lives_changed(current_lives)
signal speed_changed(multiplier)
signal game_over
signal game_won
signal phase_changed(new_phase)

enum GamePhase {
	PRE_GAME,
	ROUND_PREPARATION,
	ROUND_ACTIVE,
	GAME_OVER,
	GAME_WON
}

var current_phase: GamePhase = GamePhase.PRE_GAME : set = set_phase
var lives: int = 20 : set = set_lives
var speed_multiplier: float = 1.0 : set = set_speed_multiplier
var dev_mode: bool = false

func _ready():
	reset_game()

func reset_game():
	self.lives = 20
	self.speed_multiplier = 1.0
	self.current_phase = GamePhase.PRE_GAME
	dev_mode = false

func set_phase(value: GamePhase):
	if current_phase == value:
		return
	current_phase = value
	phase_changed.emit(current_phase)
	
	if current_phase == GamePhase.GAME_OVER:
		MetricsManager.save_playthrough_report()
		game_over.emit()
	elif current_phase == GamePhase.GAME_WON:
		MetricsManager.save_playthrough_report()
		game_won.emit()

func set_lives(value: int):
	lives = max(0, value)
	lives_changed.emit(lives)
	if lives <= 0 and current_phase != GamePhase.GAME_OVER:
		self.current_phase = GamePhase.GAME_OVER

func set_speed_multiplier(value: float):
	speed_multiplier = value
	Engine.time_scale = speed_multiplier
	speed_changed.emit(speed_multiplier)

func toggle_speed():
	if speed_multiplier == 1.0:
		self.speed_multiplier = 2.0
	else:
		self.speed_multiplier = 1.0

func lose_lives(amount: int):
	if current_phase == GamePhase.GAME_OVER or current_phase == GamePhase.GAME_WON:
		return
	if dev_mode:
		return
	self.lives -= amount
