// Check keyboard inputs
function check_keyboard_input() {
    up_pressed = keyboard_check(vk_up);
    down_pressed = keyboard_check(vk_down);
    left_pressed = keyboard_check(vk_left);
    right_pressed = keyboard_check(vk_right);
    a_pressed = keyboard_check(ord("Z"));
    b_pressed = keyboard_check(ord("X"));
}

// Check touch/mouse inputs
function check_touch_input(touch_x, touch_y) {
    // Convert to GUI coordinates if using the GUI layer
    var gui_x = device_mouse_x_to_gui(0);
    var gui_y = device_mouse_y_to_gui(0);
    
    // D-pad up button
    if (point_in_rectangle(gui_x, gui_y, 
                         dpad_center_x - dpad_size/2, dpad_center_y - dpad_size - dpad_size/2,
                         dpad_center_x + dpad_size/2, dpad_center_y - dpad_size/2)) {
        up_pressed = true;
    }
    
    // D-pad down button
    if (point_in_rectangle(gui_x, gui_y, 
                         dpad_center_x - dpad_size/2, dpad_center_y + dpad_size/2,
                         dpad_center_x + dpad_size/2, dpad_center_y + dpad_size + dpad_size/2)) {
        down_pressed = true;
    }
    
    // D-pad left button
    if (point_in_rectangle(gui_x, gui_y, 
                         dpad_center_x - dpad_size - dpad_size/2, dpad_center_y - dpad_size/2,
                         dpad_center_x - dpad_size/2, dpad_center_y + dpad_size/2)) {
        left_pressed = true;
    }
    
    // D-pad right button
    if (point_in_rectangle(gui_x, gui_y, 
                         dpad_center_x + dpad_size/2, dpad_center_y - dpad_size/2,
                         dpad_center_x + dpad_size + dpad_size/2, dpad_center_y + dpad_size/2)) {
        right_pressed = true;
    }
    
    // A button (accept)
    if (point_in_circle(gui_x, gui_y, button_a_x, button_a_y, button_size/2)) {
        a_pressed = true;
    }
    
    // B button (back)
    if (point_in_circle(gui_x, gui_y, button_b_x, button_b_y, button_size/2)) {
        b_pressed = true;
    }
}

// Process inputs for dialogue navigation
function process_input() {
    // You'll connect this with your dialogue system
    // Here's a simple example assuming you have a dialogue controller object
    
    if (instance_exists(obj_dialogue_controller)) {
        var dialogue = obj_dialogue_controller;
        
        // Only process one input per step for cleaner interaction
        if (up_pressed && !dialogue.input_processed) {
            dialogue.move_selection(-1);
            dialogue.input_processed = true;
            alarm[0] = room_speed * 0.2; // Input delay for repeats
        }
        else if (down_pressed && !dialogue.input_processed) {
            dialogue.move_selection(1);
            dialogue.input_processed = true;
            alarm[0] = room_speed * 0.2;
        }
        else if (left_pressed && !dialogue.input_processed) {
            dialogue.page_left();
            dialogue.input_processed = true;
            alarm[0] = room_speed * 0.2;
        }
        else if (right_pressed && !dialogue.input_processed) {
            dialogue.page_right();
            dialogue.input_processed = true;
            alarm[0] = room_speed * 0.2;
        }
        else if (a_pressed && !dialogue.input_processed) {
            dialogue.select_option();
            dialogue.input_processed = true;
        }
        else if (b_pressed && !dialogue.input_processed) {
            dialogue.back();
            dialogue.input_processed = true;
        }
    }
}
