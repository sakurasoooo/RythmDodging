extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var isDash = false # Zero
var canDash = true #Zero

var velocity = Vector2.ZERO # The player's movement vector. # Zero

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	isDash = false #Zero
	canDash = true #Zero

func _dash(): # Zero dash method
	canDash = false
	#start dash
	$Trail.emitting = true
	speed = 800
	isDash = true
	$CollisionShape2D.set_deferred("disabled", true)
	$DashTimer.start()
	yield($DashTimer,"timeout")

	#end dash
	speed = 400
	$Trail.emitting = false
	isDash = false
	$CollisionShape2D.set_deferred("disabled", false)

	$DashCoolDown.start()

func _process(delta):
	
	if !isDash: # Zero
		velocity = Vector2.ZERO # The player's movement vector. # Zero
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_just_pressed("dash") && velocity.length() > 0 && canDash: # Zero Only allow dash when other buttons pressed
			_dash() # Zero

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func _on_DashCoolDown_timeout():
	canDash = true;