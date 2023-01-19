extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Dodge the\nCreeps"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func show_game_end(): #Zero
	show_message("You Win")
	yield($MessageTimer, "timeout")
	$StartButton.show()


# func update_score(score):
# 	$ScoreLabel.text = str(score)

func update_time(time): #Zero
	$ScoreLabel.text = str(time)

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _play_note():
	# $Note.frame = 0
	$Note.play()

func _on_Note_animation_finished():
	# $Note.frame = 0
	$Note.stop()

func _on_SyncManager_beat():
	_play_note()

# func _on_SyncManager_beat()