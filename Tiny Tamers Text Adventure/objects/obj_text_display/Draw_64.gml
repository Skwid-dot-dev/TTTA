
// Draw text
draw_set_color(c_black);
draw_set_alpha(sin(current_time / 100) * 0.1 + 0.9);
var text_to_draw = string_copy(global.game_text, 1, min(string_length(global.game_text), current_text_length));
draw_text_ext(text_x, text_y, text_to_draw, 20, text_width);
draw_set_alpha(1);

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
draw_set_color(c_white);
// Draw buttons
draw_buttons(info_y + get_button_offset());

   