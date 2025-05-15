
///// Enhanced Draw Event
//// GameBoy-style color tones
//var text_color = c_black;
//var bg_color = make_color_rgb(15, 56, 15); // Deep green for retro aesthetic

//// Draw background for a classic screen effect
//draw_set_color(bg_color);
//draw_rectangle(0, 0, room_width, room_height, false);

//// Reset alpha before UI elements
//draw_set_alpha(1);

//// Draw UI elements with better spacing
//var info_y = text_y + text_height + 30;
//var current_y = info_y;

//// Draw player info (styled for better readability)
//draw_set_font(global.pixel_font);
//draw_player_info(current_y);
//current_y += 50;

//// Draw active monster info with color differentiation
//if (has_active_monster()) {
//    draw_set_color(make_color_rgb(72, 108, 72)); // Slight green tint for contrast
//    draw_active_monster_info(current_y);
//    current_y += 50;
//}

//// Draw battle monster info if needed
//if (global.game_state == "battle" && global.battle_monster != noone) {
//    draw_set_color(make_color_rgb(108, 72, 72)); // Reddish tint for battle UI
//    draw_battle_monster_info(current_y);
//    current_y += 50;
//}

//// Reset color and draw buttons with hover effects
//draw_set_color(c_white);
//draw_set_alpha(1);
//draw_buttons(current_y);

var padding = 20; // Padding around text box
var text_box_width = display_get_width() * 0.8; // Scales to 80% of screen width
var text_box_height = display_get_height() * 0.09;

// Calculate text box position to center it
var text_x = (display_get_width() - text_box_width) / 2;
var text_y = display_get_height() * 0.1; // Positions near the top with a consistent offset

// Set font properties
draw_set_font(fnt_dialogue); // Make sure `fnt_game` is a valid font
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw background for readability
draw_roundrect(text_x - padding, text_y - padding, text_x + text_box_width + padding, text_y + text_box_height + padding, true);
draw_set_alpha(sin(current_time / 150) * 0.2 + 0.8);
var text_to_draw = string_copy(global.game_text, 1, min(string_length(global.game_text), current_text_length));


draw_text(display_get_width() * 0.1, display_get_height() * 0.1, text_to_draw);
draw_set_alpha(1);




// Define base values
var padding = 20;
var box_width = display_get_width() * 0.6; // Scales to 60% of screen width
var box_height = display_get_height() * 0.2; // Scales dynamically with options
var box_x = (display_get_width() - box_width) / 2;
var box_y = display_get_height() * 0.7; // Positions near bottom of screen

// Draw background for options box
draw_roundrect(box_x - padding, box_y - padding, box_x + box_width + padding, box_y + box_height + padding, true);


var tab_padding = 10;
var tab_width = box_width / array_length(global.tab_list);
var tab_y = box_y - 40; // Position above options box

// Draw each tab
for (var i = 0; i < array_length(global.tab_list); i++) {
    var tab_x = box_x + (i * tab_width);
    var tab_color = (i == global.current_tab) ? c_yellow : c_gray; // Highlight selected tab
	var tab_text_color = (i == global.current_tab) ? c_black : c_white;//Change text color.

    draw_set_color(tab_color);
    draw_roundrect(tab_x, tab_y, tab_x + tab_width - tab_padding, tab_y + 30, false);
    draw_set_color(tab_text_color);
    draw_text(tab_x + tab_padding, tab_y + 10, global.tab_list[i]);
}
// Set font and color
draw_set_font(fnt_dialogue);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (global.current_tab == 0) {
    // Draw each option manually
if (option_count > 0) {
		for (var i = 0; i < option_count; i++) {
		var text_color = (i == selected_index) ? c_yellow : c_white; // Highlight selected text
		draw_set_color(text_color);
		draw_text(box_x + padding, box_y + (i * 30), ds_list_find_value(global.button_options, i).text);
	}
}
}
else if (global.current_tab == 1) {
    draw_player_info(box_x + padding, box_y);
}
else if (global.current_tab == 2) {
    draw_vehicle_info(box_x + padding, box_y);
}
else if (global.current_tab == 3) {
		
}






   