
text_timer += 1;
if (text_timer >= text_speed) {
    text_timer = 0; // Reset the timer
    if (current_text_length < string_length(global.game_text)) {
        current_text_length += 1;
		}
	}



// Get total number of options
option_count = ds_list_size(global.button_options);

// Navigate with Up/Down Arrow Keys
if (keyboard_check_released(vk_up)) {
    selected_index = max(0, selected_index - 1); // Prevent going above index 0
}
if (keyboard_check_released(vk_down)) {
    selected_index = min(option_count - 1, selected_index + 1); // Prevent going below last option
}
// Navigate tabs with Left/Right Arrow Keys
if (keyboard_check_pressed(vk_left)) {
    global.current_tab = max(0, global.current_tab - 1); // Move left, prevent going below 0
}
if (keyboard_check_pressed(vk_right)) {
    global.current_tab = min(array_length(global.tab_list) - 1, global.current_tab + 1); // Move right, prevent exceeding list size
}



if (keyboard_check_released(vk_enter)) {
    if (global.current_tab == 0) { // Options Tab
        var selected_option = ds_list_find_value(global.button_options, selected_index);
        show_debug_message("Selected Option: " + string(selected_option));
        selected_option.action(); // Execute associated function
        option_count = 0;
    }
    else if (global.current_tab == 1) { // Player Info Tab
        show_debug_message("Opening Player Info...");
        
    }
    else if (global.current_tab == 2) { // Car Info Tab
        show_debug_message("Opening Car Info...");
        
    }
	else if (global.current_tab == 3) { // Monster Info Tab
        show_debug_message("Opening Monster Info...");
        
    }
}

