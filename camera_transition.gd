extends Camera3D
class_name CameraTransition
## A quick util that transitions between two cameras with no additional setup required.

signal s_done

var cam_start: Camera3D
var cam_end: Camera3D
var speed: float = 1.0

var start_transform: Transform3D
var start_fov: float

var _ease := Tween.EASE_IN_OUT
var _trans := Tween.TRANS_LINEAR

var time_passed: float = 0.0

func _init(parent: Node, new_cam: Camera3D, time: float, p_ease := Tween.EASE_IN_OUT, p_trans := Tween.TRANS_QUAD) -> void:
	if not new_cam.get_viewport():
		push_error("Backing out of camera transition because no viewport.")
		return

	top_level = true
	cam_end = new_cam
	cam_start = new_cam.get_viewport().get_camera_3d()
	parent.add_child(self)
	global_transform = cam_start.global_transform
	start_transform = cam_start.global_transform
	fov = cam_start.fov
	start_fov = cam_start.fov
	environment = cam_start.environment
	speed = 1.0 / time
	_ease = p_ease
	_trans = p_trans
	reset_physics_interpolation()
	make_current()
	all_transitions.append(self)

func _physics_process(delta: float) -> void:
	time_passed += (delta * speed)
	var t: float = Tween.interpolate_value(0.0, 1.0, time_passed, 1.0, _trans, _ease)
	global_transform = start_transform.interpolate_with(cam_end.global_transform, t)
	fov = lerp(start_fov, cam_end.fov, t)
	if time_passed >= 1.0:
		set_physics_process(false)
		s_done.emit()
		destroy()

func destroy(use_end_cam: bool = true) -> void:
	if current:
		if use_end_cam:
			cam_end.make_current()
		elif cam_start and is_instance_valid(cam_start):
			cam_start.make_current()

	if self in all_transitions:
		all_transitions.erase(self)

	queue_free()

static var all_transitions: Array[CameraTransition] = []

static func end_all_transitions() -> void:
	for transition: CameraTransition in all_transitions:
		transition.destroy()

	all_transitions = []
