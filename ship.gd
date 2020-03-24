extends KinematicBody2D

var speed = 400
var rotation_speed = 5
var velocity = Vector2()
var axis_value

var JOYPAD_SENSITIVITY = 2
const JOYPAD_DEADZONE = 0.5
const TRIGGER_DEADZONE = 0.35

var input_direction_vector = Vector2(0, 0)
var last_speed = 0
var right_dash = false
var left_dash = false
var direction = Vector2(0, 0)

func _physics_process(delta):
    if Input.get_connected_joypads().size() > 0:
        direction = self.getCurrentDirection();
       
        self.setRotation(delta)
        self.setMovement(delta)
        
func setMovement(delta):
    var user_speed = 0
    var decelerate = Input.get_joy_axis(0, JOY_L2)
    var accelerate = Input.get_joy_axis(0, JOY_R2)    
    var current_force = 0
    
    if accelerate:
        current_force = accelerate
    elif decelerate:
        current_force = -decelerate
    
    if last_speed > 0 && accelerate < last_speed:
        user_speed = last_speed   
    elif last_speed < 0 && -decelerate > last_speed:
        user_speed = last_speed   
    elif !(accelerate && decelerate):
        user_speed = current_force
    else:
        user_speed = last_speed   

    if !accelerate && decelerate:
        user_speed = lerp(user_speed, -decelerate, 0.02)
    elif accelerate && !decelerate:
        user_speed = lerp(user_speed, +accelerate, 0.02)
    elif accelerate && decelerate:
        user_speed = lerp(user_speed, 0, 0.02)

    last_speed = user_speed
    
    if right_dash || left_dash:   
        if user_speed == 0:
            user_speed = 1
            
        if user_speed > 0:      
            if right_dash:
                direction = Vector2(-direction.y, direction.x)
            
            if left_dash:
                direction = Vector2(direction.y, -direction.x) 
            
        else:
            if right_dash:
                direction = Vector2(direction.y, -direction.x)
            
            if left_dash:
                direction = Vector2(-direction.y, direction.x)                 
            
    direction.x = stepify(direction.x, 0.1)
    direction.y = stepify(direction.y, 0.1)
    user_speed = stepify(user_speed, 0.01)
    
    if direction.length() != 0:
        direction = direction.normalized()    

    self.move_and_collide(direction * (user_speed * speed) * delta)

func getCurrentDirection():
    return Vector2(cos(self.rotation), sin(self.rotation))

func setRotation(delta):
    var stick_rotation = getStickVector()
    
    if stick_rotation.x != 0 and stick_rotation.y != 0:
        var target_angle = stepify(stick_rotation.angle(), 0.1)
        var current_rotation = stepify(self.rotation, 0.1)
        
        if target_angle != current_rotation:
            if direction.angle_to(stick_rotation) > 0:
                var new_angle = stepify(direction.angle() + (rotation_speed * delta), 0.1)  
                self.rotation = new_angle        
            else:
                var new_angle = stepify(direction.angle() - (rotation_speed * delta), 0.1)
                self.rotation = new_angle  

func getStickVector():
    var stick_rotation = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
    
    if stick_rotation.length() < JOYPAD_DEADZONE:
        stick_rotation = Vector2(0, 0)
    else:
        stick_rotation = stick_rotation.normalized() * ((stick_rotation.length() - JOYPAD_DEADZONE) / (1 - JOYPAD_DEADZONE))
        
    return stick_rotation

func _input(event):
    right_dash = false
    left_dash = false      
    
    if Input.get_connected_joypads().size() > 0:
        var joypad_vec = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))

        if abs(joypad_vec.x) < TRIGGER_DEADZONE:
            joypad_vec.x = 0

        if abs(joypad_vec.y) < TRIGGER_DEADZONE:
            joypad_vec.y = 0

        joypad_vec = joypad_vec.normalized()
            
        if Input.is_joy_button_pressed(0, JOY_R):
            right_dash = true

        if Input.is_joy_button_pressed(0, JOY_L):
            left_dash = true            
            
        input_direction_vector = joypad_vec
