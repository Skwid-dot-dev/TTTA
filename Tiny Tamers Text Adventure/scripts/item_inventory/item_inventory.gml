// View inventory
function view_inventory() {
    global.game_text = "Your Inventory:\n\n";
    
    if (ds_map_size(global.item_inventory) > 0) {
        var item_name = ds_map_find_first(global.item_inventory);
        while (!is_undefined(item_name)) {
            var item_count = global.item_inventory[? item_name];
            global.game_text += item_name + " x" + string(item_count) + "\n";
            item_name = ds_map_find_next(global.item_inventory, item_name);
        }
    } else {
        global.game_text += "Your inventory is empty.";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add use item option if player has items
    if (ds_map_size(global.item_inventory) > 0) {
        ds_list_add(global.button_options, {
            text: "Use Item",
            action: use_item_menu
        });
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: change_location
    });
}

// Use item menu
function use_item_menu() {
    global.game_text = "Which item would you like to use?\n\n";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add an option for each usable item
    var item_name = ds_map_find_first(global.inventory);
    var button_count = 0;
    
    while (!is_undefined(item_name) && button_count < 5) { // Limit to 5 items per page
        var item_count = global.inventory[? item_name];
        
        if (item_count > 0) {
            ds_list_add(global.button_options, {
                text: item_name + " x" + string(item_count),
                action: use_item,
                item: item_name
            });
            button_count++;
        }
        
        item_name = ds_map_find_next(global.inventory, item_name);
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: view_inventory
    });
}

// Use item function
function use_item() {
    // Get the selected item
    var button_index = floor((mouse_x - obj_text_display.text_x) / (obj_text_display.button_width + obj_text_display.button_spacing));
    var item_name = global.button_options[| button_index].item;
    
    // Apply item effect based on name
    switch(item_name) {
        case "Healing Herb":
            // Restore a small amount of health
            var heal_amount = 20;
            global.player_health = min(global.player_max_health, global.player_health + heal_amount);
            global.game_text = "You used a Healing Herb.\n\n";
            global.game_text += "Restored " + string(heal_amount) + " health!";
            global.inventory[? item_name] -= 1;
            break;
            
        case "Energy Root":
            // Temporarily boost attack in next battle
            global.temp_attack_boost = 5;
            global.game_text = "You used an Energy Root.\n\n";
            global.game_text += "Your attack will be boosted by 5 in the next battle!";
            global.inventory[? item_name] -= 1;
            break;
            
        case "Antidote Leaf":
            // Cure status effects (if implemented)
            global.game_text = "You used an Antidote Leaf.\n\n";
            global.game_text += "All status effects are cured!";
            global.inventory[? item_name] -= 1;
            break;
            
        case "Desert Cactus Fruit":
            // Restore health and provide heat resistance
            var heal_amount = 30;
            global.player_health = min(global.player_max_health, global.player_health + heal_amount);
            global.temp_desert_protection = true;
            global.game_text = "You ate the Desert Cactus Fruit.\n\n";
            global.game_text += "Restored " + string(heal_amount) + " health and gained temporary protection from desert heat!";
            global.inventory[? item_name] -= 1;
            break;
            
        case "Ancient Artifact":
            // Grant experience points
            var exp_gain = 100;
            global.player_exp += exp_gain;
            global.game_text = "You study the Ancient Artifact, gaining valuable knowledge.\n\n";
            global.game_text += "You gained " + string(exp_gain) + " experience points!";
            global.inventory[? item_name] -= 1;
            
            // Check for level up
            if (global.player_exp >= global.player_exp_to_next) {
                player_level_up();
            }
            break;
            
        case "Rare Capture Device":
            // Can't use outside of battle
            global.game_text = "This item can only be used during monster encounters to increase capture chance.";
            return; // Don't consume the item
            
        default:
            global.game_text = "You can't use this item right now.";
            return; // Don't consume the item
    }
    
    // Remove item if quantity is zero
    if (global.inventory[? item_name] <= 0) {
        ds_map_delete(global.inventory, item_name);
    }
    
    // Return to inventory
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Back to Inventory",
        action: view_inventory
    });
    
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
}