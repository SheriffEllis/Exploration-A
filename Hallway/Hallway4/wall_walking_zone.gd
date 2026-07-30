extends Area3D

var is_player_inside : bool: 
	set(new_value):
		set_process(new_value)
		is_player_inside = new_value


func _on_body_entered(body: Node3D) -> void:
	if body is not PlayerCharacter: return
	is_player_inside = true

func _on_body_exited(body: Node3D) -> void:
	if body is not PlayerCharacter: return
	is_player_inside = false


func _ready() -> void:
	is_player_inside = false


func _process(_delta: float) -> void:
	var current_floor_normal := GameGlobals.player.get_floor_normal()
	#DebugDraw3D.draw_arrow_ray(GameGlobals.player.global_position, GameGlobals.player.up_direction, 1.0, Color.RED, 0.1)
	if current_floor_normal.is_zero_approx() or current_floor_normal.is_equal_approx(GameGlobals.player.up_direction): return
	current_floor_normal = current_floor_normal.normalized()
	GameGlobals.player.up_direction = current_floor_normal
	#DebugDraw3D.draw_arrow_ray(GameGlobals.player.global_position, current_floor_normal, 1.0, Color.RED, 0.1, false, 1)
	var forward_direction := -GameGlobals.player.yaw_pivot.global_basis.z
	#DebugDraw3D.draw_arrow_ray(GameGlobals.player.global_position, forward_direction, 1.0, Color.BLUE, 0.1, false, 1)
	var forward_projected := forward_direction - forward_direction.project(current_floor_normal)
	#DebugDraw3D.draw_arrow_ray(GameGlobals.player.global_position, forward_projected, 1.0, Color.LIGHT_BLUE, 0.1, false, 1)
	GameGlobals.player.global_basis *= GameGlobals.player.yaw_pivot.basis
	GameGlobals.player.yaw_pivot.rotation = Vector3.ZERO # Align root node yaw with camera yaw
	#GameGlobals.player.look_at(GameGlobals.player.global_position + forward_projected, current_floor_normal) 
	var tween := create_tween()
	tween.tween_property(GameGlobals.player, "global_basis", Basis.looking_at(forward_projected, current_floor_normal), 0.1) # align player with floor gradually
	#GameGlobals.player.transform = GameGlobals.player.transform.orthonormalized()
