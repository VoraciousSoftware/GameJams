extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 500.0
var dashing := false
var can_dash := true
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var dash_timer: Timer = $"Dash Timer"
@onready var dash_cooldown: Timer = $"Dash Cooldown"


func _ready() -> void:
	animation_player.play("idle")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func _input(event: InputEvent) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle dash.
	if event.is_action_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		dash_timer.start()
		dash_cooldown.start()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _on_dash_timer_timeout() -> void:
	dashing = false # Replace with function body.


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
