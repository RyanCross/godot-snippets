extends VehicleBody3D


func _physics_process(delta):
	steering = Input.get_axis("move_right", "move_left") *0.4
	engine_force = Input.get_axis("move_forward","move_back") *100
	
