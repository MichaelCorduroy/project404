extends Node



# the game's tracklist in dictionary format
@export var music_tracks = {
	"fema": "res://music/femadren.mp3",
	"rabhole1": "res://music/rabhole1.mp3",
	"rabhole2": "res://music/rabhole2.mp3",
	
}
@onready var player = self.get_child(0)


var current_music = null  # Current music track

# play a song 
func play_music(song_name: String, _loop: bool = false):
	if music_tracks.has(song_name):
		var new_music = load(music_tracks[song_name])
		if current_music != new_music:
			current_music = new_music
			player.stop()
			player.stream = current_music
			#player.loop = loop
			player.play()

	else:
		print("No music track assigned for scene:", song_name)


# stop the music
func stop_music():
	player.stop()


# fade music out (good for transitions)
func fade_out_music(duration: float = 1.0):
	if player.playing:
		for t in range(duration * 100):  # Assuming 100 steps for smooth fade
			player.volume_db -= 1 / duration
			await get_tree().create_timer(0.01).timeout
		player.stop()
		
		
# you know what this does.
func decrease_volume(db: float):
	var new_volume = player.volume_db - db
	player.volume_db = clamp(new_volume, -80, 40)

# you know what this does too.
func increase_volume(db: float):
	var new_volume = player.volume_db + db
	player.volume_db = clamp(new_volume, -80, 40)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
