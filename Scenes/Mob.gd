extends RigidBody2D

var start_move = false

func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	get_node("/root/Main/SyncManager").connect("beat", self, "_on_SyncManager_beat")#Zero
	get_node("/root/Main/SyncManager").connect("strong_beat", self, "_on_SyncManager_strong_beat")#Zero


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_SyncManager_beat(): #Zero
	if start_move:
		$AnimatedSprite.play()
		var velocity = Vector2(450.0, 0.0)
		linear_velocity = velocity.rotated(rotation)

func _on_AnimatedSprite_animation_finished(): #Zero
	$AnimatedSprite.stop()
	$AnimatedSprite.frame = 0

func _on_SyncManager_strong_beat(): #Zero
	start_move = true

