 // Set up text display properties
	var sw = display_get_width();
	var sh = display_get_height();
	
	room_width = sw;
    room_height = sh;
 
    text_x = sw * 0.05;
    text_y = sh * 0.05;
    text_width = sw * 0.9;
    text_height = sh * 0.6;
	
    
    // Button properties
    button_width = sw * 0.2;
    button_height = sh * 0.07;
    button_spacing = sh * 0.02;
    buttons = ds_list_create();