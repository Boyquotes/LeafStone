extends AudioStreamPlayer
class_name ExtendedAudioStreamPlayer

func performSound(sound: AudioStream):
	if !playing:
		stream_paused = false
		play()
	
	else:
		if stream != sound:
			stream = sound
			play()		

func performSoundOnce(sound: AudioStream):
	# if stream != sound:
	stream = sound
	play()				
