extends AudioStreamPlayer


onready var levelMusic = preload("res://Sounds/ES_The Sanctuary Within - Erasmus Talbot.wav")
onready var combatSong = preload("res://Sounds/ES_Roused - Sons Of Hades.wav")

func _ready():
	stream = levelMusic
	play()


func _on_DetentionArea_body_entered(body:Node):
	if stream != combatSong:
		stream = combatSong
		play()
