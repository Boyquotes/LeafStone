extends AudioStreamPlayer

@onready var levelMusic = preload("res://Sounds/ES_The Sanctuary Within - Erasmus Talbot.wav")
@onready var combatSong = preload("res://Sounds/ES_Roused - Sons Of Hades.wav")

func _ready():
	stream = levelMusic
	play()

func playMusic(song):
	if stream != song:
		stream = song
		play()

func _on_Events_combatStart():
	playMusic(combatSong)


func _on_Events_outOfCombat():
	playMusic(levelMusic)
