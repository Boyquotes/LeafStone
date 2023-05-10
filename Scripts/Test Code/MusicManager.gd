extends Node2D

#ChatGPT Documentation.
# Music tracks dictionary, keys are track names and values are AudioStream resources
@export var music_tracks = {
	#here goes the music tracks
}

# Tween properties
var fade_duration = 2.0
var initial_volume = 0.0
var muted_volume = -80.0

# Keep track of the active AudioStreamPlayer
var active_player = 1

# Function to change the current music track
func change_track(track_name):
	if track_name in music_tracks:
		var new_stream = music_tracks[track_name]
		var old_player = get_node("MusicPlayer" + str(active_player))
		var new_player
		
		# Swap the active player
		active_player = 3 - active_player
		new_player = get_node("MusicPlayer" + str(active_player))
		
		# Set the new stream to the new player and play it
		new_player.stream = new_stream
		new_player.play()
		
		# Blend the music using the Tween node
		get_node("Tween").interpolate_property(old_player, "volume_db", initial_volume, muted_volume, fade_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		get_node("Tween").interpolate_property(new_player, "volume_db", muted_volume, initial_volume, fade_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		get_node("Tween").start()
	else:
		print("Error: track not found in music_tracks dictionary")

# Example usage: call this function to change the music track
# change_track("track2")

