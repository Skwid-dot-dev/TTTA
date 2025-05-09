function home_area() {
    global.game_state = "home";
    
    global.game_text = "Welcome to your home!\n\n";
    global.game_text += "This is your base of operations where you can rest, manage your monsters, and upgrade facilities.\n\n";
    global.game_text += "Storage: Level " + string(global.storage_level) + " (" + string(ds_list_size(global.captured_monsters)) + "/" + string(global.storage_capacity) + " monsters)\n";
    global.game_text += "Upgrade cost: " + string(global.storage_upgrade_cost) + " currency\n\n";
    global.game_text += "What would you like to do?";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add home actions
    ds_list_add(global.button_options, {
        text: "Bed(Heal)",
        action: rest_and_heal
    });
       
	ds_list_add(global.button_options, {
        text: "Garage",
        action: view_garage
    });
    // Add upgrade storage button if player has enough currency
    if (global.player_currency >= global.storage_upgrade_cost) {
        ds_list_add(global.button_options, {
            text: "Upgrade Storage",
            action: upgrade_storage
        });
    }
    
    ds_list_add(global.button_options, {
        text: "View Monsters",
        action: view_monsters
    });
    
    ds_list_add(global.button_options, {
        text: "Travel",
        action: travel_map
    });
}

// Rest and heal function
function rest_and_heal() {
    global.player_health = global.player_max_health;
    
    global.game_text = "You rest at home and recover your strength.\n";
    global.game_text += "Your health has been fully restored!\n\n";
    // Clear button options
    ds_list_clear(global.button_options);
    // Return to home area
    home_area();
}

// Upgrade storage function
function upgrade_storage() {
    if (global.player_currency >= global.storage_upgrade_cost) {
        global.player_currency -= global.storage_upgrade_cost;
        global.storage_level += 1;
        global.storage_capacity += 5;  // Increase capacity by 5
        global.storage_upgrade_cost = global.storage_level * 100;  // Increase cost for next upgrade
        
        global.game_text = "Storage upgraded!\n\n";
        global.game_text += "Your storage is now level " + string(global.storage_level) + " with capacity for " + string(global.storage_capacity) + " monsters.\n";
        global.game_text += "Next upgrade will cost " + string(global.storage_upgrade_cost) + " currency.\n\n";
    } else {
        global.game_text = "You don't have enough currency to upgrade your storage!\n\n";
    }
    // Clear button options
    ds_list_clear(global.button_options);
    // Return to home area
    home_area();
}
