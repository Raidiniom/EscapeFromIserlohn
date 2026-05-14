# mobile_controls.gd
extends Node

# ── tunables ──────────────────────────────────────────────────────────
const JOYSTICK_RADIUS  : float = 100.0
const LOOK_SENSITIVITY : float = 0.004

# ── node refs (set in _ready) ─────────────────────────────────────────
@onready var hud        : Control = get_parent()
@onready var joystick   : Control = hud.get_node("MoveJoystick")
@onready var thumb      : Control = hud.get_node("MoveJoystick/JoystickThumb")
@onready var look_zone  : Control = hud.get_node("LookZone")
@onready var jump_btn   : Control = hud.get_node("JumpButton")
@onready var sprint_btn : Control = hud.get_node("SprintButton")
@onready var plant_btn  : Control = hud.get_node("PlantButton")
@onready var seed_btns  : Array   = [
	hud.get_node("SeedBar/SeedBtn0"),
	hud.get_node("SeedBar/SeedBtn1"),
	hud.get_node("SeedBar/SeedBtn2"),
	hud.get_node("SeedBar/SeedBtn3"),
	hud.get_node("SeedBar/SeedBtn4"),
	hud.get_node("SeedBar/SeedBtn5"),
]
@onready var debug_display : Control = hud.get_node("TopRight/DebugMessages")

# ── joystick state ────────────────────────────────────────────────────
var joy_touch  : int     = -1
var joy_origin : Vector2 = Vector2.ZERO
var joy_vec    : Vector2 = Vector2.ZERO   # -1..1

# ── look state ────────────────────────────────────────────────────────
var look_touch : int     = -1
var look_last  : Vector2 = Vector2.ZERO

# ── button states (we track these ourselves) ──────────────────────────
var sprint_held  : bool = false
var jump_touched : bool = false   # set true on press, cleared after physics reads it
var plant_touched: bool = false

# ── touch index → which button it's holding ───────────────────────────
var sprint_touch : int = -1
var jump_touch   : int = -1
var plant_touch  : int = -1
# seed touches: index → seed slot
var seed_touches : Dictionary = {}

func _ready() -> void:
	# Let ALL controls pass through mouse/touch so MobileControls._input sees everything.
	_set_passthrough(joystick)
	_set_passthrough(look_zone)
	_set_passthrough(jump_btn)
	_set_passthrough(sprint_btn)
	_set_passthrough(plant_btn)
	for b in seed_btns:
		_set_passthrough(b)

func _set_passthrough(ctrl: Control) -> void:
	ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE

# ── push virtual actions every frame ─────────────────────────────────
func _process(_delta: float) -> void:
	if not InputManager.is_mobile():
		return
	# Movement
	var t := 0.15
	if joy_vec.x < -t:
		Input.action_press("left",  -joy_vec.x); Input.action_release("right")
	elif joy_vec.x > t:
		Input.action_press("right",  joy_vec.x); Input.action_release("left")
	else:
		Input.action_release("left");  Input.action_release("right")

	if joy_vec.y < -t:
		Input.action_press("forward", -joy_vec.y); Input.action_release("backward")
	elif joy_vec.y > t:
		Input.action_press("backward", joy_vec.y); Input.action_release("forward")
	else:
		Input.action_release("forward"); Input.action_release("backward")

	# Sprint (held)
	if sprint_held:
		Input.action_press("sprint")
	else:
		Input.action_release("sprint")

	if jump_touched:
		jump_touched = false
		jump_touch = -1
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.jump_buffered = true
			

	if plant_touched:
		plant_touched = false
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.plant_buffered = true
	

# ── raw touch input ────────────────────────────────────────────────────
func _input(event: InputEvent) -> void:
	if not InputManager.is_mobile():
		return
	
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(e: InputEventScreenTouch) -> void:
	if e.pressed:
		# Priority order matters: check specific controls before the catch-all look zone
		if _hit(joystick, e.position) and joy_touch == -1:
			joy_touch  = e.index
			joy_origin = e.position
			debug_display.text = "Moving"

		elif _hit(jump_btn, e.position):
			jump_touch   = e.index
			jump_touched = true          # physics will read this next frame
			debug_display.text = "Pressed Jump"

		elif _hit(sprint_btn, e.position):
			sprint_touch = e.index
			sprint_held  = true
			debug_display.text = "Pressed Sprint"

		elif _hit(plant_btn, e.position):
			plant_touch   = e.index
			plant_touched = true
			debug_display.text = "Pressed Plant"

		else:
			# check seed bar
			var found_seed := false
			for i in seed_btns.size():
				if _hit(seed_btns[i], e.position):
					seed_touches[e.index] = i
					_select_seed(i)
					found_seed = true
					break

			# fallback: look zone (anything not caught above)
			if not found_seed and look_touch == -1:
				look_touch = e.index
				look_last  = e.position
	else:
		# Release
		if e.index == joy_touch:
			joy_touch = -1
			joy_vec   = Vector2.ZERO
			_center_thumb()

		elif e.index == sprint_touch:
			sprint_touch = -1
			sprint_held  = false

		elif e.index == jump_touch:
			jump_touch = -1

		elif e.index == plant_touch:
			plant_touch = -1

		elif seed_touches.has(e.index):
			seed_touches.erase(e.index)

		elif e.index == look_touch:
			look_touch = -1

func _handle_drag(e: InputEventScreenDrag) -> void:
	if e.index == joy_touch:
		var delta   := e.position - joy_origin
		var clamped := delta.limit_length(JOYSTICK_RADIUS)
		joy_vec      = clamped / JOYSTICK_RADIUS
		thumb.position = joystick.size * 0.5 + clamped - thumb.size * 0.5

	elif e.index == look_touch:
		var delta  := e.position - look_last
		look_last   = e.position
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.yaw_input   += -delta.x * LOOK_SENSITIVITY
			player.pitch_input += -delta.y * LOOK_SENSITIVITY

# ── helpers ───────────────────────────────────────────────────────────
func _hit(ctrl: Control, screen_pos: Vector2) -> bool:
	var local := ctrl.get_global_transform().affine_inverse() * screen_pos
	return Rect2(Vector2.ZERO, ctrl.size).has_point(local)

func _center_thumb() -> void:
	thumb.position = joystick.size * 0.5 - thumb.size * 0.5

func _select_seed(idx: int) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.selected_seed = idx
		player.update_stats_display()
	# update highlight via HUD
	var hud_script = hud.get_script()
	if hud.has_method("_highlight_seed"):
		hud._highlight_seed(idx)
