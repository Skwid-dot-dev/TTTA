// Draw background
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

// Draw text area
draw_set_color(c_dkgray);
draw_rectangle(text_x - 10, text_y - 10, text_x + text_width + 10, text_y + text_height + 10, false);
draw_set_color(c_white);

// Draw text
draw_text_ext(text_x, text_y, global.game_text, 20, text_width);

// Draw player info
var info_y = text_y + text_height + 20;
draw_player_info(info_y);

// Draw active monster info
if (has_active_monster()) {
    draw_active_monster_info(info_y + 40);
}

// Draw battle monster info
if (global.game_state == "battle" && global.battle_monster != noone) {
    draw_battle_monster_info(info_y + (has_active_monster() ? 80 : 40));
}

// Draw buttons
draw_buttons(info_y + get_button_offset());