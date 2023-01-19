extends Node2D
signal strong_beat # Zero
signal beat # Zero
signal music_end # Zero

const BPM = 116
const BARS = 5

#Audio BPM Demo
# Used by system clock.
var time_begin
var time_delay
var playing = false

var last_beat = 0

#Audio BPM Demo
func strsec(secs):
	var s = str(secs)
	if (secs < 10):
		s = "0" + s
	return s

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not playing or $Music.playing == false:
		return
	var time = 0.0
	# Obtain from ticks.
	time = (Time.get_ticks_usec() - time_begin) / 1000000.0
	# Compensate.
	time -= time_delay

	var beat = int(time * BPM / 60.0) % BARS + 1
	var seconds = int(time)
	var seconds_total = int($Music.stream.get_length())

	#Zero: end game when music finished
	if seconds == seconds_total:
		emit_signal("music_end")
		stop_sync()

	#Zero: emit beat signal
	if last_beat != beat && beat == 1:
		emit_signal("strong_beat")
	
	if last_beat != beat:
		emit_signal("beat")
	
	last_beat = beat

	#update hud
	get_tree().get_root().get_node("Main/HUD").update_time(str(seconds / 60, ":", strsec(seconds % 60), " / ", seconds_total / 60, ":", strsec(seconds_total % 60)))

func start_sync():
	time_begin = OS.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	playing = true
	$Music.play()

func stop_sync():
	playing = false
	$Music.stop()
