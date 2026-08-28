class_name WalkingZone extends Area3D

var is_player_inside : bool: 
	set(new_value):
		set_process(new_value)
		is_player_inside = new_value
		GameGlobals.player.floor_max_angle = deg_to_rad(80) if is_player_inside else deg_to_rad(45)


func _on_body_entered(body: Node3D) -> void:
	if body is not PlayerCharacter: return
	is_player_inside = true

func _on_body_exited(body: Node3D) -> void:
	if body is not PlayerCharacter: return
	GameGlobals.player.up_direction = Vector3.UP
	set_camera_basis(get_projected_basis(Vector3.UP))
	is_player_inside = false


func _ready() -> void:
	is_player_inside = false


func get_up_direction() -> Vector3:
	return GameGlobals.player.get_floor_normal().normalized()

func get_projected_basis(floor_normal: Vector3) -> Basis:
	var forward_direction := -GameGlobals.player.yaw_pivot.global_basis.z
	var forward_projected := forward_direction - forward_direction.project(floor_normal)
	return Basis.looking_at(forward_projected, floor_normal)

func set_camera_basis(new_basis: Basis) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(GameGlobals.player, "global_basis", new_basis, 0.4) # align player with floor gradually


func _process(_delta: float) -> void:
	var current_floor_normal := get_up_direction()
	#DebugDraw3D.draw_arrow_ray(GameGlobals.player.global_position, GameGlobals.player.up_direction, 1.0, Color.RED, 0.1)
	if current_floor_normal.is_zero_approx() or current_floor_normal.is_equal_approx(GameGlobals.player.up_direction): return
	GameGlobals.player.up_direction = current_floor_normal
	GameGlobals.player.global_basis *= GameGlobals.player.yaw_pivot.basis
	GameGlobals.player.yaw_pivot.rotation = Vector3.ZERO # Align root node yaw with camera yaw
	set_camera_basis(get_projected_basis(current_floor_normal))
