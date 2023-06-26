extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mode7 = get_node("/root/gameplay/landmass/Sprite2D")
	mode7.connect("landing_signal", self._landing_signal);

func _landing_signal():
	$fly_sprite.hide();
	$land_sprite.show();
	print("Player landed!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
