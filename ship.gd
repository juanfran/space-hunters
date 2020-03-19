extends KinematicBody2D

var speed = 400
var rotation_speed = 5
var velocity = Vector2()
var axis_value

var JOYPAD_SENSITIVITY = 2
const JOYPAD_DEADZONE = 0.2
const TRIGGER_DEADZONE = 0.35

var input_direction_vector = Vector2(0, 0)
var last_speed = 0
var right_dash = false
var left_dash = false
# x   y
# -1, 0 left
# +1, 0 right
# 0, -1 top
# 0, +1 bottom

# angle
# top 0 to -3
# bottom 0 to 3

# 2.4 a -2.9, 0.7 steps (6 - (2.4 + 2.9))

# 2.4 a -2.9, 0.7 steps

# 3 a 2.5, 0,5 diff sub
# 1 a 2, 1 diff sum
# -1 a -3, 2 diff sub

# -2.7
# 2.8 + 2.7 
# 2.8 a -2.7 5 pasos

# 2
# 3 + 2 = 5
# 3 - 2 = 1 // restar

# -1 0 -> + 1 0

# 0 a 2 clockwise -2
# 0 a -2 no clockwise +2
# -2 a 2 no clockwise -4
# 2 a -2 clockwise 0

# -1 0.5 -> + 1 0 (clockwise)
# -1 -0.5 -> + 1 0 (noclockwise)

# -1 0.5 -> + -1 0.7 (clockwise)
# -1 -0.5 -> -1 0.4 (noclockwise)

func _physics_process(delta):
    if Input.get_connected_joypads().size() > 0:
        var user_speed = Input.get_joy_axis(0, JOY_R2) - Input.get_joy_axis(0, JOY_L2)
        var direction = Vector2(cos(self.rotation), sin(self.rotation))
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
            
        last_speed = user_speed
        
        if right_dash || left_dash:   
            if right_dash:
                direction = Vector2(direction.y, -direction.x)
            
            if left_dash:
                direction = Vector2(-direction.y, direction.x) 
                
            if user_speed == 0:
                user_speed = 1
        
        move_and_collide(direction * user_speed * speed * delta)

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
        var joypad_vec = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))

        if joypad_vec.length() < TRIGGER_DEADZONE:
            joypad_vec = Vector2(0, 0)
        else:
            joypad_vec = joypad_vec.normalized()
            
        if Input.is_joy_button_pressed(0, JOY_R):
            right_dash = true

        if Input.is_joy_button_pressed(0, JOY_L):
            left_dash = true            
            
        input_direction_vector = joypad_vec

#func _input(event):
#    if Input.get_connected_joypads().size() > 0 && event is InputEventJoypadButton:
#        print("-----------")
#        print(event.button_index == JOY_R2)
#        print(Input.get_joy_axis(0, JOY_R2))
#        print(event.is_pressed())
#
#        if event.pressure > 0:
#            print("sdfsdf")

# http://docs.godotengine.org/en/3.0/classes/class_input.html
# https://docs.godotengine.org/en/2.1/classes/class_@global%20scope.html

#func _physics_process(delta):
#    if brake:
#        brake_speed -= 10
#        move_and_collide(((speed - brake_speed) * input_movement_vector) * delta)
#    else:
#        move_and_collide((speed * input_movement_vector) * delta)

#func _input(event):
#    if Input.get_connected_joypads().size() > 0:
#        var joypad_vec = Vector2(0, 0)
#        brake = false
#
#        if OS.get_name() == "Windows":
#            joypad_vec = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
#        elif OS.get_name() == "X11":
#            joypad_vec = Vector2(Input.get_joy_axis(0, 1), Input.get_joy_axis(0, 2))
#        elif OS.get_name() == "OSX":
#            joypad_vec = Vector2(Input.get_joy_axis(0, 1), Input.get_joy_axis(0, 2))
#
#        if joypad_vec.length() < JOYPAD_DEADZONE:
#            if input_movement_vector.length():
#                joypad_vec = input_movement_vector
#                brake = true
#            else:
#                joypad_vec = Vector2(0, 0)
#        else:
#            brake_speed = speed
#            joypad_vec = joypad_vec.normalized() * ((joypad_vec.length() - JOYPAD_DEADZONE) / (1 - JOYPAD_DEADZONE))
#
#        input_movement_vector = joypad_vec    
