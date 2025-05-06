function initialize_globals() {
	
	
    // Player stats
    global.player_health = 100;
    global.player_max_health = 100;
    global.player_level = 1;
    global.player_exp = 0;
    global.player_exp_to_next = 100;
	global.player_agility = 5;
	global.player_currency = 0;
    
    // Game state
    global.game_state = "home"; // exploration, battle, capture, inventory, home
    global.current_location = "home";
	
	// Home area features
    global.storage_level = 1;
    global.storage_capacity = 1;  // Initial storage capacity
    global.storage_upgrade_cost = 100;  // Initial upgrade cost
    
    // Monster collection
    global.captured_monsters = ds_list_create();
    global.current_monster = -1;
    global.battle_monster = noone;
    
    // Available locations
    global.locations = ds_list_create();
    ds_list_add(global.locations, "home", "forest", "cave", "meadow", "mountain", "desert");
	
	// Add location level requirements
    global.location_levels = ds_map_create();
	ds_map_add(global.location_levels, "home", 1);
    ds_map_add(global.location_levels, "forest", 1);
    ds_map_add(global.location_levels, "meadow", 3);
    ds_map_add(global.location_levels, "cave", 5);
    ds_map_add(global.location_levels, "mountain", 7);
    ds_map_add(global.location_levels, "desert", 10);
    
    // Monster types with base stats (name, hp, attack, defense, rarity)
    global.monster_types = ds_map_create();
    initialize_monster_data();
	
	// Skills system
	global.skills = ds_map_create();
	initialize_skills();


	window_set_size(display_get_width(), display_get_height());
	display_set_gui_size(display_get_width(), display_get_height());
	
	// Item inventory
	global.item_inventory = ds_map_create();
	
	
	// Random event system
	global.random_events = ds_map_create();
	initialize_events();

    // Game text
    global.game_text = "";
    global.button_options = ds_list_create();
}






// Start the game
function game_start() {
    global.game_text = "Welcome to Tiny Tamers: Text Adventure!\n\n" +
                      "You are a novice tamer exploring the world to catch and train monsters.\n" +
                      "Take a look around to get aquainted.";
    
    // Clear button options
    ds_list_clear(global.button_options);
	
	// Home
	ds_list_add(global.button_options, {
	    text: "Go Home",
	    action: home_area
	});
	
	// View Skills
	ds_list_add(global.button_options, {
	    text: "View Skills",
	    action: view_skills
	});

	// Inventory
	ds_list_add(global.button_options, {
	    text: "View Inventory",
	    action: view_inventory
	});
	
    // Add inventory button
    ds_list_add(global.button_options, {
        text: "View Monsters",
        action: view_monsters
    });
}

function travel_map() {
    global.game_text = "Off into the distance!\n\n" +
                      "Where shall we go today?\n" +
                      "Choose your destination to begin your adventure.";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add location buttons only if the player meets the level requirement
    for (var i = 0; i < ds_list_size(global.locations); i++) {
        var location = global.locations[| i];
        var level_req = global.location_levels[? location];
        
        if (global.player_level >= level_req) {
            var button_text = "Go to " + string(location);
            ds_list_add(global.button_options, {
                text: button_text,
                action: change_location
            });
        }
    }
}
function change_location() {
    var location_index = floor((mouse_x - obj_text_display.text_x) / (obj_text_display.button_width + obj_text_display.button_spacing));
    
    if (location_index < ds_list_size(global.locations)) {
        // Update the player's current location
        global.current_location = global.locations[| location_index];
        
        global.game_text = "You've traveled to the " + global.current_location + ".\n";
        global.game_text += "What would you like to do?";
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add location actions
        ds_list_add(global.button_options, {
            text: "Explore",
            action: explore_area
        });
        
        // Add skill-based actions based on location
        switch(global.current_location) {
            case "forest":
                ds_list_add(global.button_options, {
                    text: "Forage for plants",
                    action: perform_foraging
                });
                break;
            case "cave":
                ds_list_add(global.button_options, {
                    text: "Mine for minerals",
                    action: perform_mining
                });
                break;
            case "meadow":
                ds_list_add(global.button_options, {
                    text: "Collect crafting materials",
                    action: collect_crafting_materials
                });
                break;
            case "mountain":
                ds_list_add(global.button_options, {
                    text: "Mine for rare gems",
                    action: perform_mining_rare
                });
                break;
            case "desert":
                ds_list_add(global.button_options, {
                    text: "Search for desert herbs",
                    action: perform_desert_foraging
                });
                break;
        }
        
        // Add standard buttons
        ds_list_add(global.button_options, {
            text: "View Skills",
            action: view_skills
        });
        
        ds_list_add(global.button_options, {
            text: "Travel",
            action: travel_map
        });
        
        ds_list_add(global.button_options, {
            text: "Return Home",
            action: home_area
        });
        
        ds_list_add(global.button_options, {
            text: "View Monsters",
            action: view_monsters
        });
        
        // If player has crafting materials, add crafting option
        var can_craft = false;
        // Check inventory for crafting materials
        // [Code to check inventory]
        
        if (can_craft || global.skills[? "Crafting"].level > 1) {
            ds_list_add(global.button_options, {
                text: "Craft Items",
                action: perform_crafting
            });
        }
    }
}

       

// Explore the current area
function explore_area() {
    global.game_text = "You explore the " + global.current_location + "...\n\n";
    
    // Check for random event first (30% chance)
    var event_happened = generate_random_event();
    
    // If no event happened, proceed with normal monster encounter logic
    if (!event_happened) {
    
    // Random chance to find a monster
    if (random(100) < 70) {
        // Find a monster
        find_monster();
    } else {
        // Find nothing
        global.game_text += "You don't find any monsters this time.";
	}
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add exploration actions
        ds_list_add(global.button_options, {
            text: "Explore Again",
            action: explore_area
        });
        
        ds_list_add(global.button_options, {
            text: "View Monsters",
            action: view_monsters
        });
    }
}

// Find a monster
function find_monster() {
    // Create a list of monsters for the current location
    var available_monsters = ds_list_create();
    
    var key = ds_map_find_first(global.monster_types);
    while (!is_undefined(key)) {
        var monster = global.monster_types[? key];
        if (monster.habitat == global.current_location) {
            ds_list_add(available_monsters, monster);
        }
        key = ds_map_find_next(global.monster_types, key);
    }
    
    // Pick a random monster from the available ones
    if (ds_list_size(available_monsters) > 0) {
        var rand_index = irandom(ds_list_size(available_monsters) - 1);
        var monster_template = available_monsters[| rand_index];
        
        // Create a copy of the monster
        global.battle_monster = {
            name: monster_template.name,
            hp: monster_template.hp,
            max_hp: monster_template.max_hp,
            attack: monster_template.attack,
            defense: monster_template.defense,
			agility: monster_template.agility,
            rarity: monster_template.rarity,
            type: monster_template.type,
            habitat: monster_template.habitat,
            description: monster_template.description,
			alpha_type: "none"
        };
		 // Potentially make this an alpha monster
        global.battle_monster = make_alpha_monster(global.battle_monster);
        
        global.game_state = "battle";
        
        global.game_text += "You encountered a wild " + global.battle_monster.name + "!\n\n";
        global.game_text += global.battle_monster.description + "\n\n";
        global.game_text += "What will you do?";
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add battle actions
        ds_list_add(global.button_options, {
            text: "Attack",
            action: battle_attack
        });
        
        ds_list_add(global.button_options, {
            text: "Try to Capture",
            action: try_capture
        });
        
        ds_list_add(global.button_options, {
            text: "Run Away",
            action: run_away
        });
    } else {
        global.game_text += "You don't find any monsters this time.";
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add exploration actions
        ds_list_add(global.button_options, {
            text: "Explore Again",
            action: explore_area
        });
        
        ds_list_add(global.button_options, {
            text: "Travel",
            action: game_start
        });
    }
    
    // Clean up
    ds_list_destroy(available_monsters);
}

// Attack in battle

// Function to select a monster during battle
function battle_select_monster() {
    global.game_state = "battle_select";
    
    global.game_text = "Choose a monster to send into battle:\n\n";
    
    for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
        var monster = global.captured_monsters[| i];
        var active_text = (global.current_monster == i) ? " [ACTIVE]" : "";
        global.game_text += string(i + 1) + ". " + monster.name + active_text + 
                         " (HP: " + string(monster.hp) + "/" + string(monster.max_hp) + 
                         ", Attack: " + string(monster.attack) + 
                         ", Defense: " + string(monster.defense) + ")\n";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add monster buttons
    for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
        var monster = global.captured_monsters[| i];
        ds_list_add(global.button_options, {
            text: "Send " + monster.name,
            action: set_battle_monster
        });
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: return_to_battle
    });
}

// Function to set active monster during battle
function set_battle_monster() {
    var monster_index = floor((mouse_x - obj_text_display.text_x) / 
                         (obj_text_display.button_width + obj_text_display.button_spacing));
    
    if (monster_index < ds_list_size(global.captured_monsters)) {
        var monster = global.captured_monsters[| monster_index];
        
        // Check if monster has HP
        if (monster.hp <= 0) {
            global.game_text = monster.name + " is too weak to fight!\n";
            global.game_text += "Choose a different monster or go back.";
            
            // Do not change the active monster
            battle_select_monster();
            return;
        }
        
        // Set as active monster
        global.current_monster = monster_index;
        
        global.game_text = "Go, " + monster.name + "!\n\n";
        global.game_text += "The wild " + global.battle_monster.name + " has " + 
                          string(global.battle_monster.hp) + "/" + string(global.battle_monster.max_hp) + 
                          " HP left.\n\n";
        global.game_text += "What will you do?";
        
        return_to_battle();
    }
}

// Function to return to battle
function return_to_battle() {
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add battle actions
    ds_list_add(global.button_options, {
        text: "Attack",
        action: battle_attack
    });
    
    ds_list_add(global.button_options, {
        text: "Try to Capture",
        action: try_capture
    });
    
    ds_list_add(global.button_options, {
        text: "Run Away",
        action: run_away
    });
    
    // Add option to change monster
    if (ds_list_size(global.captured_monsters) > 0) {
        ds_list_add(global.button_options, {
            text: "Change Monster",
            action: battle_select_monster
        });
    }
}



// Victory in battle
function battle_victory() {
    global.game_text = "You defeated the " + global.battle_monster.name + "!\n\n";
    
    // Calculate experience gained
    var exp_gained = global.battle_monster.rarity * 20;
    global.player_exp += exp_gained;
    
	// Add currency reward
    var currency_gained = global.battle_monster.rarity * 10;
    global.player_currency += currency_gained;
    
    global.game_text += "You gained " + string(exp_gained) + " experience points!\n";
    global.game_text += "You found " + string(currency_gained) + " currency!\n\n";
    
    // Check for level up
    if (global.player_exp >= global.player_exp_to_next) {
        player_level_up();
    }
    
    global.game_state = "exploration";
    global.battle_monster = noone;
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add exploration actions
    ds_list_add(global.button_options, {
        text: "Explore Again",
        action: explore_area
    });
    
    ds_list_add(global.button_options, {
        text: "Travel",
        action: game_start
    });
    
    ds_list_add(global.button_options, {
        text: "View Monsters",
        action: view_monsters
    });
}

// Defeat in battle
function battle_defeat() {
    global.game_text = "You were defeated by the " + global.battle_monster.name + "!\n\n";
    global.game_text += "You wake up later, feeling weak but alive.\n\n";
    
    // Reset player health to 25% of max
    global.player_health = global.player_max_health * 0.25;
    
    global.game_state = "exploration";
    global.battle_monster = noone;
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add exploration actions
    ds_list_add(global.button_options, {
        text: "Explore Again",
        action: explore_area
    });
    
    ds_list_add(global.button_options, {
        text: "Travel",
        action: game_start
    });
    
    ds_list_add(global.button_options, {
        text: "View Monsters",
        action: view_monsters
    });
}

// Try to capture a monster
function try_capture() {
    global.game_text = "You throw a capture device at the " + global.battle_monster.name + "...\n\n";
    
    // Calculate capture chance based on monster's HP percentage and rarity
    var hp_percentage = global.battle_monster.hp / global.battle_monster.max_hp;
    var capture_chance = (1 - hp_percentage) * 100 / global.battle_monster.rarity;
    
    // Alpha monsters are harder to catch
    if (global.battle_monster.alpha_type != "none") {
        capture_chance *= 0.6; // 40% reduction in catch rate for alpha monsters
        global.game_text += "This alpha monster seems harder to capture!\n\n";
    }
    
    if (random(100) < capture_chance) {
        // Successful capture
        global.game_text += "Success! You captured the " + global.battle_monster.name + "!\n\n";
        
        // Check if storage capacity reached
        if (ds_list_size(global.captured_monsters) >= global.storage_capacity) {
            global.game_text += "Warning: Your monster storage is full! You need to upgrade your storage at home or release monsters.\n\n";
        }
        
        // Add monster to collection
        ds_list_add(global.captured_monsters, global.battle_monster);
        
        // Gain experience
        var exp_gained = global.battle_monster.rarity * 30;
        global.player_exp += exp_gained;
        
        // Gain currency for capture
        var currency_gained = global.battle_monster.rarity * 15;
        global.player_currency += currency_gained;
        
        global.game_text += "You gained " + string(exp_gained) + " experience points for the capture!\n";
        global.game_text += "You earned " + string(currency_gained) + " currency for the capture!\n\n";
        
        // Check for level up
        if (global.player_exp >= global.player_exp_to_next) {
            player_level_up();
        }
        
        global.game_state = "exploration";
        global.battle_monster = noone;
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add exploration actions
        ds_list_add(global.button_options, {
            text: "Explore Again",
            action: explore_area
        });
        
        ds_list_add(global.button_options, {
            text: "Travel",
            action: game_start
        });
        
        ds_list_add(global.button_options, {
            text: "View Monsters",
            action: view_monsters
        });
    } else {
        // Failed capture
        global.game_text += "Oh no! The " + global.battle_monster.name + " broke free!\n\n";
        
        // Monster attacks back
        var monster_damage = max(1, global.battle_monster.attack - global.player_level);
        global.player_health -= monster_damage;
        
        global.game_text += "The " + global.battle_monster.name + " attacks you for " + string(monster_damage) + " damage!\n\n";
        
        // Check if player is defeated
        if (global.player_health <= 0) {
            battle_defeat();
            return;
        }
        
        global.game_text += "The " + global.battle_monster.name + " has " + string(global.battle_monster.hp) + 
                          "/" + string(global.battle_monster.max_hp) + " HP left.\n\n";
        global.game_text += "What will you do?";
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add battle actions
        ds_list_add(global.button_options, {
            text: "Attack",
            action: battle_attack
        });
        
        ds_list_add(global.button_options, {
            text: "Try to Capture",
            action: try_capture
        });
        
        ds_list_add(global.button_options, {
            text: "Run Away",
            action: run_away
        });
    }
}

// Run away from battle
function run_away() {
    // Calculate escape chance
    var escape_chance = 50 + (global.player_level * 5) - (global.battle_monster.rarity * 10);
    escape_chance = clamp(escape_chance, 20, 90);
    
    if (random(100) < escape_chance) {
        // Successful escape
        global.game_text = "You successfully ran away from the " + global.battle_monster.name + "!";
        
        global.game_state = "exploration";
        global.battle_monster = noone;
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add exploration actions
        ds_list_add(global.button_options, {
            text: "Explore Again",
            action: explore_area
        });
        
        ds_list_add(global.button_options, {
            text: "Go Home",
            action: home_area
        });
        
        ds_list_add(global.button_options, {
            text: "View Monsters",
            action: view_monsters
        });
    } else {
        // Failed escape
        global.game_text = "You couldn't escape!\n\n";
        
        // Monster attacks
        var monster_damage = max(1, global.battle_monster.attack - global.player_level);
        global.player_health -= monster_damage;
        
        global.game_text += "The " + global.battle_monster.name + " attacks you for " + string(monster_damage) + " damage!\n\n";
        
        // Check if player is defeated
        if (global.player_health <= 0) {
            battle_defeat();
            return;
        }
        
        global.game_text += "What will you do?";
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add battle actions
        ds_list_add(global.button_options, {
            text: "Attack",
            action: battle_attack
        });
        
        ds_list_add(global.button_options, {
            text: "Try to Capture",
            action: try_capture
        });
        
        ds_list_add(global.button_options, {
            text: "Run Away",
            action: run_away
        });
    }
}

// Player level up
function player_level_up() {
    global.player_level += 1;
    global.player_exp -= global.player_exp_to_next;
    global.player_exp_to_next = global.player_level * 100;
    global.player_max_health += 20;
    global.player_health = global.player_max_health;
    
    global.game_text += "Level up! You are now level " + string(global.player_level) + "!\n";
    global.game_text += "Your max health increased to " + string(global.player_max_health) + ".\n\n";
}

// View captured monsters
function view_monsters() {
    global.game_state = "inventory";
    
    if (ds_list_size(global.captured_monsters) > 0) {
        global.game_text = "Your captured monsters: " + string(ds_list_size(global.captured_monsters)) + "/" + string(global.storage_capacity) + "\n\n";
        
        for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
            var monster = global.captured_monsters[| i];
            global.game_text += string(i + 1) + ". " + monster.name + " (Type: " + monster.type + 
                             ", HP: " + string(monster.hp) + "/" + string(monster.max_hp) + 
                             ", Attack: " + string(monster.attack) + 
                             ", Defense: " + string(monster.defense) + ")\n";
        }
    } else {
        global.game_text = "You haven't captured any monsters yet.\n";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add release monster option if player has monsters
    if (ds_list_size(global.captured_monsters) > 0) {
        ds_list_add(global.button_options, {
            text: "Release Monster",
            action: release_monster_prompt
        });
    }
    
    // Add back button based on current location
    if (global.current_location == "home") {
        ds_list_add(global.button_options, {
            text: "Back to Home",
            action: home_area
        });
    } else {
        ds_list_add(global.button_options, {
            text: "Back",
            action: change_location
        });
    }
}

function adjust_ui(){
// Set up text display properties
	var sw = display_get_width();
	var sh = display_get_height();
 
    obj_text_display.text_x = sw * 0.05;
    obj_text_display.text_y = sh * 0.05;
    obj_text_display.text_width = sw * 0.9;
    obj_text_display.text_height = sh * 0.6;
    
    // Button properties
    obj_text_display.button_width = sw * 0.2;
    obj_text_display.button_height = sh * 0.07;
    obj_text_display.button_spacing = sh * 0.02;
}

// Add release monster functionality
function release_monster_prompt() {
    global.game_text = "Select a monster number to release (1-" + string(ds_list_size(global.captured_monsters)) + "):\n\n";
    
    for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
        var monster = global.captured_monsters[| i];
        global.game_text += string(i + 1) + ". " + monster.name + " (Type: " + monster.type + 
                         ", HP: " + string(monster.hp) + "/" + string(monster.max_hp) + ")\n";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add buttons for each monster
    for (var i = 0; i < min(ds_list_size(global.captured_monsters), 10); i++) { // Limit to 10 buttons
        ds_list_add(global.button_options, {
            text: string(i + 1),
            action: release_monster
        });
    }
    
    // Add cancel button
    ds_list_add(global.button_options, {
        text: "Cancel",
        action: view_monsters
    });
}

// Release monster function
function release_monster() {
    var monster_index = real(string_digits(self.text)) - 1;
    
    if (monster_index >= 0 && monster_index < ds_list_size(global.captured_monsters)) {
        var monster = global.captured_monsters[| monster_index];
        global.game_text = "You released " + monster.name + " back into the wild.\n\n";
        
        // Remove monster from collection
        ds_list_delete(global.captured_monsters, monster_index);
        
        // Return some currency for releasing
        var currency_refund = monster.rarity * 5;
        global.player_currency += currency_refund;
        global.game_text += "You received " + string(currency_refund) + " currency in return.\n\n";
    }
    
    // Return to monster view
    view_monsters();
}

// Keep heal_monsters function but modify it
function heal_monsters() {
    for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
        var monster = global.captured_monsters[| i];
        monster.hp = monster.max_hp;
    }
    
    global.game_text = "All of your monsters have been healed to full health!\n\n";
    
    // Go back to home instead of monster view
    home_area();
}

function select_monster() {
    global.game_state = "select_monster";
    
    global.game_text = "Choose a monster to set as active:\n\n";
    
    if (ds_list_size(global.captured_monsters) > 0) {
        for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
            var monster = global.captured_monsters[| i];
            var active_text = (global.current_monster == i) ? " [ACTIVE]" : "";
            global.game_text += string(i + 1) + ". " + monster.name + active_text + 
                             " (Type: " + monster.type + 
                             ", HP: " + string(monster.hp) + "/" + string(monster.max_hp) + 
                             ", Attack: " + string(monster.attack) + 
                             ", Defense: " + string(monster.defense) + ")\n";
        }
    } else {
        global.game_text += "You haven't captured any monsters yet.\n";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add monster buttons
    for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
        var monster = global.captured_monsters[| i];
        ds_list_add(global.button_options, {
            text: "Select " + monster.name,
            action: set_active_monster
        });
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: view_monsters
    });
}

function set_active_monster() {
    var monster_index = floor((mouse_x - obj_text_display.text_x) / 
                         (obj_text_display.button_width + obj_text_display.button_spacing));
    
    if (monster_index < ds_list_size(global.captured_monsters)) {
        var monster = global.captured_monsters[| monster_index];
        global.current_monster = monster_index;
        
        global.game_text = "You selected " + monster.name + " as your active monster!\n";
        global.game_text += monster.description;
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add back buttons
        ds_list_add(global.button_options, {
            text: "View Monsters",
            action: view_monsters
        });
        
        ds_list_add(global.button_options, {
            text: "Back to Adventure",
            action: change_location
        });
    }
}
