extends Control

@onready var startButton : Button = $"%StartBtn"
@onready var optionsButton : Button = $"%OptionsBtn"
@onready var quitButton : Button = $"%QuitBtn"


func _ready():
	startButton.button_up.connect(start_level)
	optionsButton.button_up.connect(open_options)
	quitButton.button_up.connect(quit_game)

func start_level():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func open_options():
	print("Aun no has implementado este menu!")

func quit_game():
	get_tree().quit()
	