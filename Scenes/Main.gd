extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()


func game_over():
	# $MobTimer.stop()
	$HUD.show_game_over()
	$DeathSound.play()
	$SyncManager.stop_sync()


func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$WinMusic.stop()
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$SyncManager.start_sync()


func _on_MobTimer_timeout():
	
	pass

func _on_SyncManager_music_end(): #Zero
	#Win
	$HUD.show_game_end()
	$WinMusic.play()
	get_tree().call_group("mobs", "queue_free") #clear mobs


func _on_StartTimer_timeout():
	# $MobTimer.start()
	pass

func _on_SyncManager_strong_beat():
	pass

func _on_SyncManager_beat(): #Zero
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)