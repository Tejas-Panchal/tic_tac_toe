extends Node2D

@onready var s_0: AnimatedSprite2D = $Board/b0/s0
@onready var s_1: AnimatedSprite2D = $Board/b1/s1
@onready var s_2: AnimatedSprite2D = $Board/b2/s2
@onready var s_3: AnimatedSprite2D = $Board/b3/s3
@onready var s_4: AnimatedSprite2D = $Board/b4/s4
@onready var s_5: AnimatedSprite2D = $Board/b5/s5
@onready var s_6: AnimatedSprite2D = $Board/b6/s6
@onready var s_7: AnimatedSprite2D = $Board/b7/s7
@onready var s_8: AnimatedSprite2D = $Board/b8/s8
@onready var winner: Sprite2D = $Winner
@onready var w_icon : AnimatedSprite2D = $Winner/winner_icon
@onready var w_1 : Sprite2D = $Winner/w_1

@onready var reset: Button = $Reset
@onready var white_box: Button = $"Color Box/White Box"
@onready var green_box: Button = $"Color Box/Green Box"
@onready var blue_box: Button = $"Color Box/Blue Box"

var data : Array = [ [0,0,0],[0,0,0],[0,0,0] ]
var forCircle = true
var gameActive = true

func _ready() -> void:
	reset.visible = false
	w_1.visible = false
	winner.visible = false
	var box_color = load_data()
	if box_color == 1:
		$Board.set_layer_enabled(0, false)
		$Board.set_layer_enabled(1, true)
		$Board.set_layer_enabled(2, false)
	elif box_color == 2:
		$Board.set_layer_enabled(0, false)
		$Board.set_layer_enabled(1, false)
		$Board.set_layer_enabled(2, true)
	else:
		$Board.set_layer_enabled(0, true)
		$Board.set_layer_enabled(1, false)
		$Board.set_layer_enabled(2, false)

func save_data(box_color):
	var file = FileAccess.open("user://save_data.dat", FileAccess.WRITE)
	if file:
		file.store_8(box_color)
		print("Saved box_color:", box_color)
		file.close()

func load_data():
	if FileAccess.file_exists("user://save_data.dat"):
		var file = FileAccess.open("user://save_data.dat", FileAccess.READ)
		if file:
			var box_color = file.get_8()
			file.close()
			print("Loaded box_color:", box_color)
			return box_color
	return 0

func _process(_delta: float) -> void:
	if gameActive == false:
		winner.visible = true
		w_1.visible = true

func game_over() -> void:
	for i in range(3):
		var row_sum = data[i][0] + data[i][1] + data[i][2]
		var collum_sum = data[0][i] + data[1][i] + data[2][i]
		
		if row_sum == 3 or collum_sum == 3:
			print("circle winner")
			gameActive = false
			w_icon.play("circle")
			return
		elif row_sum == -3 or collum_sum == -3:
			print("cross winner")
			gameActive = false
			w_icon.play("cross")
			return
	
	var cross1 = data[0][0] + data[1][1] + data[2][2]
	var cross2 = data[0][2] + data[1][1] + data[2][0]
	
	if cross1 == 3 or cross2 == 3:
		print("circle winner")
		gameActive = false
		w_icon.play("circle")
		w_1.texture = load("res://assets/winner_button.png")
	elif cross1 == -3 or cross2 == -3:
		print("cross winner")
		gameActive = false
		w_icon.play("cross")
		w_1.texture = load("res://assets/winner_button.png")
	
	var allClicked = 0
	for i in range(3):
		for j in range(3):
			if data[i][j] != 0:
				allClicked += 1
	if allClicked > 0: reset.visible = true
	if allClicked == 9:
		if gameActive == true:
			print("tie")
			w_1.texture = load("res://assets/tie_button.png")
		gameActive = false

func add_circle_or_cross(box,y,x) -> void:
	if box.visible == false and gameActive:
		if forCircle:
			box.play("circle")
			data[y][x] = 1
			forCircle = false
		else:
			box.play("cross")
			data[y][x] = -1
			forCircle = true
		box.visible = true
		game_over()

func _on_b_0_button_down() -> void: add_circle_or_cross(s_0,0,0)
func _on_b_1_button_down() -> void: add_circle_or_cross(s_1,0,1)
func _on_b_2_button_down() -> void: add_circle_or_cross(s_2,0,2)
func _on_b_3_button_down() -> void: add_circle_or_cross(s_3,1,0)
func _on_b_4_button_down() -> void: add_circle_or_cross(s_4,1,1)
func _on_b_5_button_down() -> void: add_circle_or_cross(s_5,1,2)
func _on_b_6_button_down() -> void: add_circle_or_cross(s_6,2,0)
func _on_b_7_button_down() -> void: add_circle_or_cross(s_7,2,1)
func _on_b_8_button_down() -> void: add_circle_or_cross(s_8,2,2)
func _on_quit_button_down() -> void: get_tree().quit()

func _on_reset_button_down() -> void:
	var box_color = -1
	if $Board.is_layer_enabled(0):
		box_color = 0
	elif $Board.is_layer_enabled(1):
		box_color = 1
	elif $Board.is_layer_enabled(2):
		box_color = 2
	if box_color != -1:
		save_data(box_color)
	else:
		print("Error: No active layer detected.")
	get_tree().reload_current_scene()

func _on_white_box_button_down() -> void:
	$Board.set_layer_enabled(0, true)
	$Board.set_layer_enabled(1, false)
	$Board.set_layer_enabled(2, false)
	white_box.icon = load("res://assets/white_button.png")
	green_box.icon = load("res://assets/green_button.png")
	blue_box.icon = load("res://assets/blue_button.png")

func _on_green_box_button_down() -> void:
	$Board.set_layer_enabled(0, false)
	$Board.set_layer_enabled(1, true)
	$Board.set_layer_enabled(2, false)
	white_box.icon = load("res://assets/white_button.png")
	green_box.icon = load("res://assets/green_button.png")
	blue_box.icon = load("res://assets/blue_button.png")

func _on_blue_box_button_down() -> void:
	$Board.set_layer_enabled(0, false)
	$Board.set_layer_enabled(1, false)
	$Board.set_layer_enabled(2, true)
	white_box.icon = load("res://assets/white_button.png")
	green_box.icon = load("res://assets/green_button.png")
	blue_box.icon = load("res://assets/blue_button.png")
