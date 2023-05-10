extends AudioStreamPlayer

@onready var levelMusic = preload("res://Sounds/ES_The Sanctuary Within - Erasmus Talbot.wav")
@onready var combatSong = preload("res://Sounds/ES_Roused - Sons Of Hades.wav")
@export var seconds = 0.5

func _ready():
	stream = levelMusic
	play()

func playMusic(song):
	if stream != song:
		stream = song
		volume_db = -60
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "volume_db", -20, seconds).set_ease(Tween.EASE_IN)
		play()

func _on_Events_combatStart():
	playMusic(combatSong)


func _on_Events_outOfCombat():
	playMusic(levelMusic)
