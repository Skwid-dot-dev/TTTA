
room_width = display_get_width();
room_height = display_get_height();

var _ui_layer = layer_get_flexpanel_node("UILayer_1");
var _bg = flexpanel_node_get_child(_ui_layer, "Background");

var _node = flexpanel_node_get_child(_bg, "Textbox");

var _width = flexpanel_node_style_get_width(_node);
var _height = flexpanel_node_style_get_height(_node);



 // Set up text display properties
	var sw = _width.value;
	var sh = _height.value;
	
	
 
    text_x = sw 
    text_y = sh 
    text_width = sw 
    text_height = sh 
	text_speed = 2; // Number of frames between increments
	text_timer = 0;
	current_text_length = 0;
	
    
    // Button properties
    button_width = sw
    button_height = sh 
    button_spacing = sh
    buttons = ds_list_create();