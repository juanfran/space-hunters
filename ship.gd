extends KinematicBody2D

var speed = 400
var rotation_speed = 50
var velocity = Vector2()
var axis_value

var JOYPAD_SENSITIVITY = 2
const JOYPAD_DEADZONE = 0.35


var input_direction_vector = Vector2(0, 0)
var last_speed = 0
var right_dash = false
var left_dash = false
# x   y
# -1, 0 left
# +1, 0 right
# 0, -1 top
# 0, +1 bottom

func _physics_process(delta):
    if Input.get_connected_joypads().size() > 0:
        var user_speed = Input.get_joy_axis(0, JOY_R2) - Input.get_joy_axis(0, JOY_L2)
        
        if input_direction_vector.x != 0 and input_direction_vector.y != 0:
            if input_direction_vector.x > 0:
                print(self.rotation, self.rotation + 5)
                self.rotation = self.rotation + 0.05
            else:
                self.rotation = self.rotation - 0.05
            #self.rotation = (self.rotation + 5) * rotation_speed * delta
        
        var direction = Vector2(cos(self.rotation), sin(self.rotation))
        
# fix         
#        if last_speed > 0 && user_speed >= 0:
#            if user_speed - 0.1 < last_speed: 
#                user_speed = last_speed - 0.025
#
#                if user_speed < 0:
#                    user_speed = 0
#        elif last_speed < 0 && user_speed <= 0:
#            if user_speed + 0.1 > last_speed: 
#                user_speed = last_speed + 0.025
#
#                if user_speed > 0:
#                    user_speed = 0            
        
        last_speed = user_speed
        
        if right_dash:
            direction = direction.rotated(45)
        
        if left_dash:
            direction = direction.rotated(-45)
        
        move_and_collide(direction * user_speed * speed * delta)

func _input(event):
    right_dash = false
    left_dash = false      
    
    if Input.get_connected_joypads().size() > 0:
        var joypad_vec = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))

        if joypad_vec.length() < JOYPAD_DEADZONE:
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
