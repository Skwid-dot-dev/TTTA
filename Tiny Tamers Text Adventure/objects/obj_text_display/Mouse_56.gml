 // Check if any buttons were clicked
    for (var i = 0; i < ds_list_size(buttons) ; i++) {
        var btn = buttons[| i];
        if (point_in_rectangle(mouse_x, mouse_y, btn.x1, btn.y1, btn.x2, btn.y2)) {
            // Call the button's action
            script_execute(btn.action);
			ds_list_clear(buttons);
			current_text_length = 0;
            break;
        }
    }