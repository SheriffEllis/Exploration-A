extends MeshInstance3D

@export var key_id : int = 0
@onready var light : OmniLight3D = $OmniLight3D
@onready var interactable : StaticInteractable = $StaticInteractable

var items_collected : int = 0

func _ready() -> void:
	Events.camcorder_collected.connect(_on_item_collected)
	Events.flashlight_collected.connect(_on_item_collected)

func _on_item_collected() -> void:
	items_collected += 1
	if items_collected >= 2:
		if GameGlobals.LEVEL.skip_intro: return
		interactable.set_collision_layer_value(2, true) # Make interactable
		
		await Events.all_text_queues_finished
		await get_tree().create_timer(3).timeout
		if not visible: return
		light.visible = true
		Events.hint_triggered.emit("[Collect the Key from the Foyer]")
		$GlowHandler.start_glowing()

func _on_static_interactable_interacted(_player: CharacterBody3D) -> void:
	Events.key_collected.emit(key_id)
	Events.hint_triggered.emit("[Unlocked the Grey Door]")
	visible = false
	$StaticInteractable.toggle(false)
	$PickupAudio.play()
	$GlowHandler.stop_glowing()
