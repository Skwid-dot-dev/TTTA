// Draw player info
function draw_player_info(info_x,info_y) {
	var text_x = info_x;
    draw_text(text_x, info_y, "Health: " + string(global.player_health) + "/" + string(global.player_max_health));
    draw_text(text_x + 200, info_y, "Level: " + string(global.player_level));
    draw_text(text_x + 400, info_y, "EXP: " + string(global.player_exp) + "/" + string(global.player_exp_to_next));
    draw_text(text_x + 600, info_y, "Agility: " + string(global.player_agility));
    draw_text(text_x, info_y + 20, "Location: " + string(global.current_location));
	draw_text(text_x + 800, info_y, "Currency: " + string(global.player_currency));
}

function draw_vehicle_info(info_x,info_y) {
	var text_x = info_x;
    draw_text(text_x, info_y, "Name: " + string(global.player_car.name));
    draw_text(text_x + 200, info_y, "Seats: " + string(global.player_car.seats));
    draw_text(text_x + 400, info_y, "Mileage: " + string(global.player_car.mileage));
    draw_text(text_x + 600, info_y, "Value: " + string(global.player_car.value));
    draw_text(text_x, info_y + 20, "Paintjob: " + string(global.player_car.description));
}



// Check for active monster
function has_active_monster() {
    return global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters);
}

// Draw active monster info
function draw_active_monster_info(info_x,info_y) {
	var text_x = info_x;
    var active_monster = global.captured_monsters[| global.current_monster];
    draw_text(text_x, info_y, "Active Monster: " + active_monster.name);
    
    var alpha_text = (active_monster.alpha_type != "none") 
        ? " [ALPHA: " + string_upper(active_monster.alpha_type) + "]" 
        : "";
    
    draw_text(text_x + 200, info_y, "HP: " + string(active_monster.hp) + "/" + string(active_monster.max_hp) + alpha_text);
    draw_text(text_x, info_y + 20, "ATK: " + string(active_monster.attack) + ", DEF: " + string(active_monster.defense) + ", AGI: " + string(active_monster.agility));
}

// Draw battle monster info
function draw_battle_monster_info(battle_y) {
    draw_text(text_x, battle_y, "Wild Monster: " + global.battle_monster.name);
    
    var alpha_text = (global.battle_monster.alpha_type != "none") 
        ? " [ALPHA: " + string_upper(global.battle_monster.alpha_type) + "]" 
        : "";
    
    draw_text(text_x + 200, battle_y, "HP: " + string(global.battle_monster.hp) + "/" + string(global.battle_monster.max_hp) + alpha_text);
    draw_text(text_x, battle_y + 20, "ATK: " + string(global.battle_monster.attack) + ", DEF: " + string(global.battle_monster.defense) + ", AGI: " + string(global.battle_monster.agility));
}

// Get button offset based on battle state
function get_button_offset() {
    return global.game_state == "battle" ? (has_active_monster() ? 110 : 80) : (has_active_monster() ? 90 : 50);
}

// Draw buttons
function draw_buttons(button_y) {
    var button_x = text_x;
    
    for (var i = 0; i < ds_list_size(global.button_options); i++) {
        var btn = global.button_options[| i];
        
        draw_set_color(c_gray);
        draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
        
        draw_set_color(c_white);
        draw_text(button_x + 10, button_y + 10, btn.text);
        
        store_button_position(i, button_x, button_y, btn.action);
        
        button_x += button_width + button_spacing;
        if (button_x + button_width > room_width) {
            button_x = text_x;
            button_y += button_height + button_spacing;
        }
    }
}

// Store button positions
function store_button_position(index, button_x, button_y, action) {
		
    if (index >= ds_list_size(buttons)) {
        ds_list_add(buttons, { x1: button_x, y1: button_y, x2: button_x + button_width, y2: button_y + button_height, action: action });
    } else {
        buttons[| index].x1 = button_x;
        buttons[| index].y1 = button_y;
        buttons[| index].x2 = button_x + button_width;
        buttons[| index].y2 = button_y + button_height;
        buttons[| index].action = action;
    }
}