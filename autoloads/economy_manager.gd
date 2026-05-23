extends Node

signal minerals_changed(current_minerals)

var minerals: int = 200 : set = set_minerals

func _ready():
	reset_economy()

func reset_economy():
	self.minerals = 200

func set_minerals(value: int):
	minerals = max(0, value)
	minerals_changed.emit(minerals)

func can_afford(amount: int) -> bool:
	return GameManager.dev_mode or minerals >= amount

func spend_minerals(amount: int) -> bool:
	if GameManager.dev_mode:
		return true
	if can_afford(amount):
		self.minerals -= amount
		return true
	return false

func add_minerals(amount: int):
	self.minerals += amount

func get_reposition_fee(base_cost: int) -> int:
	return ceil(base_cost * 0.15)

func get_sell_refund(total_value: int) -> int:
	return floor(total_value * 0.70)
