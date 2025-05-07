
function initialize_events(){
	// Common events
ds_map_add(global.random_events, "lost_traveler", {
    name: "Lost Traveler",
    description: "You encounter a lost traveler who needs directions.",
    frequency: 20, // Relative chance of occurring
    min_level: 1,  // Minimum player level required
    action: event_lost_traveler
});

ds_map_add(global.random_events, "treasure_chest", {
    name: "Hidden Treasure",
    description: "You spot a partially buried treasure chest.",
    frequency: 15,
    min_level: 1,
    action: event_treasure_chest
});

ds_map_add(global.random_events, "monster_nest", {
    name: "Monster Nest",
    description: "You've stumbled upon a nest with multiple monsters!",
    frequency: 10,
    min_level: 3,
    action: event_monster_nest
});

// Location-specific events
ds_map_add(global.random_events, "forest_fairy", {
    name: "Forest Fairy",
    description: "A tiny glowing fairy appears from behind a tree.",
    frequency: 8,
    min_level: 2,
    locations: ["forest"],
    action: event_forest_fairy
});

ds_map_add(global.random_events, "cave_collapse", {
    name: "Cave Tremor",
    description: "The ground shakes and some rocks fall from the ceiling!",
    frequency: 8,
    min_level: 4,
    locations: ["cave"],
    action: event_cave_collapse
});

ds_map_add(global.random_events, "meadow_festival", {
    name: "Village Festival",
    description: "You come across a small village holding a festival.",
    frequency: 7,
    min_level: 2,
    locations: ["meadow"],
    action: event_meadow_festival
});

ds_map_add(global.random_events, "mountain_climber", {
    name: "Stranded Climber",
    description: "You spot a climber who is stuck on a cliff edge.",
    frequency: 8,
    min_level: 5,
    locations: ["mountain"],
    action: event_mountain_climber
});

ds_map_add(global.random_events, "desert_mirage", {
    name: "Desert Mirage",
    description: "You see a shimmering oasis in the distance.",
    frequency: 10,
    min_level: 8,
    locations: ["desert"],
    action: event_desert_mirage
});

ds_map_add(global.random_events, "ancient_ruins", {
    name: "Ancient Ruins",
    description: "You discover the entrance to some ancient ruins.",
    frequency: 5,
    min_level: 12,
    locations: ["desert"],
    action: event_ancient_ruins
});
}

// Random event generator function
function generate_random_event() {
    // 30% chance of a random event happening
    if (random(100) > 30) {
        return false; // No event this time
    }
    
    // Get all eligible events
    var eligible_events = ds_list_create();
    var total_frequency = 0;
    
    var event_key = ds_map_find_first(global.random_events);
    while (!is_undefined(event_key)) {
        var _event_data = global.random_events[? event_key];
        
        // Check level requirement
        if (global.player_level >= _event_data.min_level) {
            
            // Check location requirement (if it exists)
            var valid_location = true;
            if (variable_struct_exists(_event_data, "locations")) {
                valid_location = false;
                for (var i = 0; i < array_length(_event_data.locations); i++) {
                    if (_event_data.locations[i] == global.current_location) {
                        valid_location = true;
                        break;
                    }
                }
            }
            
            if (valid_location) {
                // Add to list with its frequency
                ds_list_add(eligible_events, {
                    key: event_key,
                    data: _event_data,
                    cumulative_freq: total_frequency + _event_data.frequency
                });
                total_frequency += _event_data.frequency;
            }
        }
        
        event_key = ds_map_find_next(global.random_events, event_key);
    }
    
    // If no eligible events, return false
    if (ds_list_size(eligible_events) == 0) {
        ds_list_destroy(eligible_events);
        return false;
    }
    
    // Select an event based on frequency weighting
    var roll = random(total_frequency);
    var selected_event = undefined;
    
    for (var i = 0; i < ds_list_size(eligible_events); i++) {
        var event_entry = eligible_events[| i];
        if (roll <= event_entry.cumulative_freq) {
            selected_event = event_entry.data;
            break;
        }
    }
    
    // Clean up and trigger the event
    ds_list_destroy(eligible_events);
    
    if (!is_undefined(selected_event)) {
        script_execute(selected_event.action);
        return true;
    }
    
    return false;
}
	
	// Lost Traveler event
function event_lost_traveler() {
    global.game_text = "You encounter a lost traveler who needs directions.\n\n";
    global.game_text += "\"Could you help me find my way to the nearest town?\" they ask.\n\n";
    global.game_text += "What will you do?";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add event options
    ds_list_add(global.button_options, {
        text: "Help them (gain XP)",
        action: event_lost_traveler_help
    });
    
    ds_list_add(global.button_options, {
        text: "Ignore them",
        action: event_lost_traveler_ignore
    });
    
    if (global.player_level >= 5) {
        ds_list_add(global.button_options, {
            text: "Show a secret shortcut",
            action: event_lost_traveler_shortcut
        });
    }
}

function event_lost_traveler_help() {
    global.game_text = "You spend some time helping the traveler find their way.\n\n";
    global.game_text += "\"Thank you so much!\" they say. \"Please take this as a token of my gratitude.\"\n\n";
    
    // Give player a random item
    var possible_items = ["Healing Herb", "Energy Root", "Antidote Leaf"];
    var item = possible_items[irandom(array_length(possible_items) - 1)];
    
    // Add to inventory
    if (ds_map_exists(global.item_inventory, item)) {
        global.item_inventory[? item] += 1;
    } else {
        ds_map_add(global.item_inventory, item, 1);
    }
    
    global.game_text += "You received a " + item + "!\n\n";
    
    // Give player some XP
    var exp_gain = 15 + irandom(10);
    global.player_exp += exp_gain;
    global.game_text += "You gained " + string(exp_gain) + " experience points!\n";
    
    // Check for level up
    if (global.player_exp >= global.player_exp_to_next) {
        player_level_up();
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
}

function event_lost_traveler_ignore() {
    global.game_text = "You ignore the traveler and continue on your way.\n\n";
    global.game_text += "They look disappointed as you pass by.\n\n";
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    

}

function event_lost_traveler_shortcut() {
    global.game_text = "Using your extensive knowledge of the area, you show the traveler a secret shortcut.\n\n";
    global.game_text += "\"Wow, I never knew about this path!\" they exclaim. \"You've saved me hours of travel time!\"\n\n";
    global.game_text += "The traveler is extremely grateful and hands you a special reward.\n\n";
    
    // Give player a better reward
    var item = "Rare Capture Device";
    
    // Add to inventory
    if (ds_map_exists(global.item_inventory, item)) {
        global.item_inventory[? item] += 1;
    } else {
        ds_map_add(global.item_inventory, item, 1);
    }
    
    global.game_text += "You received a " + item + "!\n\n";
    
    // Give player more XP
    var exp_gain = 30 + irandom(15);
    global.player_exp += exp_gain;
    global.game_text += "You gained " + string(exp_gain) + " experience points!\n";
    
    // Check for level up
    if (global.player_exp >= global.player_exp_to_next) {
        player_level_up();
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
}


// Hidden Treasure event
function event_treasure_chest() {
    global.game_text = "You spot a partially buried treasure chest.\n\n";
    global.game_text += "Do you wish to open it and see what's inside?";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add event options
    ds_list_add(global.button_options, {
        text: "Open the Chest",
        action: event_treasure_chest_open
    });
    
    ds_list_add(global.button_options, {
        text: "Leave it be",
        action: event_treasure_chest_ignore
    });
}

function event_treasure_chest_open() {
    global.game_text = "You pry open the old wooden chest...\n\n";
    
    // Define possible rewards
    var possible_rewards = ["Gold Coins", "Mystic Amulet", "Rare Gem", "Ancient Scroll"];
    var reward = possible_rewards[irandom(array_length(possible_rewards) - 1)];
    
    // Add to inventory
    if (ds_map_exists(global.item_inventory, reward)) {
        global.item_inventory[? reward] += 1;
    } else {
        ds_map_add(global.item_inventory, reward, 1);
    }
    
    global.game_text += "Inside, you find a " + reward + "!\n\n";
    
    // Grant some bonus experience
    var exp_gain = 20 + irandom(10);
    global.player_exp += exp_gain;
    global.game_text += "You gained " + string(exp_gain) + " experience points!\n";
    
    // Check for level up
    if (global.player_exp >= global.player_exp_to_next) {
        player_level_up();
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
}

function event_treasure_chest_ignore() {
    global.game_text = "You decide to leave the chest untouched and walk away.\n\n";
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
}

// Desert Mirage event
function event_desert_mirage() {
    global.game_text = "As you trudge through the scorching desert, you see a shimmering oasis in the distance.\n\n";
    global.game_text += "Palm trees and cool water beckon to you. It looks so refreshing!\n\n";
    global.game_text += "What will you do?";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add event options
    ds_list_add(global.button_options, {
        text: "Rush toward the oasis",
        action: event_desert_mirage_rush
    });
    
    ds_list_add(global.button_options, {
        text: "Approach cautiously",
        action: event_desert_mirage_cautious
    });
    
    if (global.player_level >= 12) {
        ds_list_add(global.button_options, {
            text: "Use your experience to assess",
            action: event_desert_mirage_expert
        });
    }
}

function event_desert_mirage_rush() {
    global.game_text = "You rush toward the inviting oasis, desperate for water...\n\n";
    global.game_text += "As you get closer, the palm trees and water shimmer and fade away - it was just a mirage!\n\n";
    global.game_text += "Exhausted from your sprint, you lose some health.\n\n";
    
    // Player loses health
    var health_loss = max(5, global.player_health * 0.1);
    global.player_health -= health_loss;
    global.game_text += "You lost " + string(health_loss) + " health!\n";
    
    // Check if player is defeated
    if (global.player_health <= 0) {
        battle_defeat(); // Reuse the defeat function
        return;
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
    ds_list_add(global.button_options, {
        text: "Travel",
        action: game_start
    });
}

function event_desert_mirage_cautious() {
    global.game_text = "You approach the oasis cautiously, suspicious of its sudden appearance...\n\n";
    global.game_text += "As you get closer, you notice the image wavering. It's definitely a mirage.\n\n";
    global.game_text += "However, your careful approach revealed some desert plants that were hidden nearby.\n\n";
    
    // Give player a desert plant
    var item = "Desert Cactus Fruit";
    
    // Add to inventory
    if (ds_map_exists(global.inventory, item)) {
        global.inventory[? item] += 1;
    } else {
        ds_map_add(global.inventory, item, 1);
    }
    
    global.game_text += "You collected a " + item + "!\n\n";
    
    // Give player some XP
    var exp_gain = 20;
    global.player_exp += exp_gain;
    global.game_text += "You gained " + string(exp_gain) + " experience points!\n";
    
    // Check for level up
    if (global.player_exp >= global.player_exp_to_next) {
        player_level_up();
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
    ds_list_add(global.button_options, {
        text: "Travel",
        action: game_start
    });
}

// Ancient Ruins event
function event_ancient_ruins() {
    global.game_text = "After hours of exploring the desert, you discover the entrance to ancient ruins!\n\n";
    global.game_text += "The entrance is partially buried in sand, but you can see hieroglyphs carved around the doorway.\n\n";
    global.game_text += "What will you do?";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add event options
    ds_list_add(global.button_options, {
        text: "Enter the ruins",
        action: event_ancient_ruins_enter
    });
    
    ds_list_add(global.button_options, {
        text: "Leave them alone",
        action: event_ancient_ruins_leave
    });
    
    if (global.player_level >= 15) {
        ds_list_add(global.button_options, {
            text: "Decipher the hieroglyphs first",
            action: event_ancient_ruins_decipher
        });
    }
}

function event_ancient_ruins_enter() {
    global.game_text = "You enter the dark, ancient ruins. The air is cool and stale.\n\n";
    
    // 50% chance to trigger a monster encounter or find treasure
    if (random(100) < 50) {
        global.game_text += "Suddenly, something stirs in the darkness...\n\n";
        
        // Create a special desert ruin monster - stronger than normal
        global.battle_monster = {
            name: "Ancient Guardian",
            hp: 100,
            max_hp: 100,
            attack: 20,
            defense: 15,
            rarity: 8,
            type: "spirit",
            habitat: "ruins",
            description: "A mystical construct created to guard the ancient ruins."
        };
        
        global.game_state = "battle";
        
        global.game_text += "An Ancient Guardian appears, ready to defend its territory!\n\n";
        global.game_text += "What will you do?";
        
        // Add battle actions
        ds_list_clear(global.button_options);
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
        global.game_text += "You find an ancient treasure chest partially buried in rubble!\n\n";
        
        // Give player a special item
        var item = "Ancient Artifact";
        
        // Add to inventory
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "You found an " + item + "!\n\n";
        
        // Give player XP
        var exp_gain = 50;
        global.player_exp += exp_gain;
        global.game_text += "You gained " + string(exp_gain) + " experience points!\n";
        
        // Check for level up
        if (global.player_exp >= global.player_exp_to_next) {
            player_level_up();
        }
        
        // Return to exploration
        ds_list_clear(global.button_options);
        ds_list_add(global.button_options, {
            text: "Continue Exploring",
            action: explore_area
        });
        
        ds_list_add(global.button_options, {
            text: "Travel",
            action: game_start
        });
    }
}
// event_monster_nest, event_forest_fairy, etc.

// Forest Fairy event
function event_forest_fairy() {
    global.game_text = "A tiny glowing fairy appears from behind a tree.\n\n";
    global.game_text += "She flutters around you curiously, radiating a mystical aura.\n\n";
    global.game_text += "How will you respond?";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add event options
    ds_list_add(global.button_options, {
        text: "Greet the fairy",
        action: event_forest_fairy_greet
    });
    
    ds_list_add(global.button_options, {
        text: "Try to catch the fairy",
        action: event_forest_fairy_catch
    });
    
    ds_list_add(global.button_options, {
        text: "Ignore her and move on",
        action: event_forest_fairy_ignore
    });
}

function event_forest_fairy_greet() {
    global.game_text = "You gently greet the fairy.\n\n";
    global.game_text += "She twirls in the air happily and sprinkles a bit of glowing dust on you.\n\n";
    global.game_text += "You feel a wave of energy coursing through you!";
    
    // Provide player a temporary stat boost
    global.player_health += 10;
    
    global.game_text += "\n\nYour health increased by 10!";
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
    ds_list_add(global.button_options, {
        text: "Travel",
        action: game_start
    });
}

function event_forest_fairy_catch() {
    global.game_text = "You attempt to catch the fairy...\n\n";
    
    if (random(100) < 30) {
        global.game_text += "Against all odds, you manage to gently enclose the fairy in your hands!\n\n";
        global.game_text += "She laughs and grants you a special gift before vanishing into the forest.";
        
        // Provide player a magical item
        var item = "Enchanted Leaf";
        
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "\n\nYou received a " + item + "!";
    } else {
        global.game_text += "The fairy darts away before you can react.\n\n";
        global.game_text += "Perhaps a gentler approach would have worked.";
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
    ds_list_add(global.button_options, {
        text: "Travel",
        action: game_start
    });
}

function event_forest_fairy_ignore() {
    global.game_text = "You choose to ignore the fairy and continue on your way.\n\n";
    global.game_text += "She watches curiously for a moment before disappearing into the trees.";
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue Exploring",
        action: explore_area
    });
    
    ds_list_add(global.button_options, {
        text: "Travel",
        action: game_start
    });
}
	
	// Cave Tremor event
function event_cave_collapse() {
    global.game_text = "The ground rumbles beneath your feet, and dust fills the air!\n\n";
    global.game_text += "A deep groan echoes through the cave as chunks of rock begin to fall from the ceiling.\n\n";
    global.game_text += "You must act quickly!";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add event options
    ds_list_add(global.button_options, {
        text: "Dash forward!",
        action: event_cave_collapse_dodge
    });
    
    ds_list_add(global.button_options, {
        text: "Find shelter!",
        action: event_cave_collapse_hide
    });
    
    ds_list_add(global.button_options, {
        text: "Hold your ground!",
        action: event_cave_collapse_brace
    });
}

function event_cave_collapse_dodge() {
    global.game_text = "You sprint forward, dodging falling debris!\n\n";
    
    if (random(100) < 60) {
        global.game_text += "You make it out unscathed, though your heart pounds in your chest.\n\n";
        global.game_text += "Among the rubble, you find a rare mineral lodged in the rock.\n\n";
        
        var item = "Glowing Geode";
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "You received a " + item + "!";
    } else {
        global.game_text += "A rock grazes your shoulder as you dive forward. You escape, but not without injury.\n\n";
        global.player_health -= 10;
        global.game_text += "You lost 10 health points!";
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_cave_collapse_hide() {
    global.game_text = "You scramble for cover beneath an outcropping of stone.\n\n";
    
    if (random(100) < 50) {
        global.game_text += "The cave trembles, but your chosen shelter holds firm.\n\n";
        global.game_text += "Once the dust settles, you spot an ancient carving in the rock nearby, hinting at hidden treasure.";
        
        var item = "Ancient Map Fragment";
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "\n\nYou received an " + item + "!";
    } else {
        global.game_text += "Your shelter is not as stable as you hoped—a small collapse buries part of your arm.\n\n";
        global.player_health -= 5;
        global.game_text += "You lost 5 health points!";
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_cave_collapse_brace() {
    global.game_text = "You plant your feet firmly, ready to endure the quake.\n\n";
    
    if (random(100) < 40) {
        global.game_text += "Your resilience pays off! As the tremors subside, a section of the cave wall crumbles, revealing an unexpected passageway.\n\n";
        global.game_text += "Inside, you find a mysterious artifact.";
        
        var item = "Ancient Talisman";
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "\n\nYou received an " + item + "!";
    } else {
        global.game_text += "The tremors overwhelm you, and a sharp rock strikes your leg.\n\n";
        global.player_health -= 8;
        global.game_text += "You lost 8 health points!";
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}
	
	// Monster Nest event
function event_monster_nest() {
    global.game_text = "You've stumbled upon a nest teeming with monsters!\n\n";
    global.game_text += "Their eyes gleam as they notice your presence, some appearing aggressive while others seem wary.\n\n";
    global.game_text += "You must decide what to do!";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add event options
    ds_list_add(global.button_options, {
        text: "Fight your way through!",
        action: event_monster_nest_fight
    });
    
    ds_list_add(global.button_options, {
        text: "Observe quietly",
        action: event_monster_nest_observe
    });
    
    ds_list_add(global.button_options, {
        text: "Attempt to tame one",
        action: event_monster_nest_tame
    });
    
    ds_list_add(global.button_options, {
        text: "Retreat carefully",
        action: event_monster_nest_retreat
    });
}

function event_monster_nest_fight() {
    global.game_text = "You brace yourself and charge into battle!\n\n";
    
    if (random(100) < 50) {
        global.game_text += "The monsters are strong, but you manage to defeat them after a tough fight.\n\n";
        global.game_text += "Among the fallen, you find a rare item left behind.";
        
        var item = "Monster Fang";
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "\n\nYou received a " + item + "!";
        
        var exp_gain = 25 + irandom(10);
        global.player_exp += exp_gain;
        global.game_text += "\n\nYou gained " + string(exp_gain) + " experience points!";
        
        // Check for level up
        if (global.player_exp >= global.player_exp_to_next) {
            player_level_up();
        }
    } else {
        global.game_text += "The monsters overwhelm you, forcing you to retreat after taking some hits.\n\n";
        global.player_health -= 15;
        global.game_text += "You lost 15 health points!";
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_monster_nest_observe() {
    global.game_text = "You stay hidden, watching the creatures interact.\n\n";
    global.game_text += "You learn more about their behaviors, gaining insight into their weaknesses.";
    
    var exp_gain = 15 + irandom(5);
    global.player_exp += exp_gain;
    global.game_text += "\n\nYou gained " + string(exp_gain) + " experience points!";
    
    // Check for level up
    if (global.player_exp >= global.player_exp_to_next) {
        player_level_up();
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_monster_nest_tame() {
    global.game_text = "You cautiously approach, trying to earn the trust of a monster.\n\n";
    
    if (random(100) < 35) {
        global.game_text += "One of the creatures hesitantly steps forward, accepting your presence.\n\n";
        global.game_text += "You've successfully tamed a new companion!";
        
        var new_monster = "Wild Hatchling";
        ds_list_add(global.monster_collection, new_monster);
        
        global.game_text += "\n\n" + new_monster + " has joined your team!";
    } else {
        global.game_text += "The creatures refuse to trust you, forcing you to leave before they turn hostile.";
    }
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_monster_nest_retreat() {
    global.game_text = "You carefully back away, ensuring you don't provoke the monsters.\n\n";
    
    global.game_text += "You escape without incident, but you feel that you might have missed an opportunity.";
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}
	
	// Village Festival event
function event_meadow_festival() {
    global.game_text = "You come across a small village holding a festival!\n\n";
    global.game_text += "Laughter and music fill the air as villagers gather to celebrate. Stalls are set up with food, games, and unique wares.\n\n";
    global.game_text += "What would you like to do?";

    // Clear button options
    ds_list_clear(global.button_options);

    // Add event options
    ds_list_add(global.button_options, {
        text: "Join the feast!",
        action: event_meadow_festival_feast
    });

    ds_list_add(global.button_options, {
        text: "Try your luck at a game",
        action: event_meadow_festival_game
    });

    ds_list_add(global.button_options, {
        text: "Trade for rare goods",
        action: event_meadow_festival_trade
    });

    ds_list_add(global.button_options, {
        text: "Watch the performances",
        action: event_meadow_festival_watch
    });
}

function event_meadow_festival_feast() {
    global.game_text = "You sit down to enjoy the grand feast. Delicious aromas fill the air, and villagers welcome you warmly.\n\n";
    
    global.game_text += "After indulging in the meal, you feel rejuvenated!\n\n";
    global.player_health += 10;
    global.game_text += "Your health increased by 10!";
    
    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_meadow_festival_game() {
    global.game_text = "You decide to play a festival game!\n\n";
    
    if (random(100) < 50) {
        global.game_text += "You skillfully win the challenge and receive a prize!\n\n";
        var prize = "Lucky Charm";
        
        if (ds_map_exists(global.inventory, prize)) {
            global.inventory[? prize] += 1;
        } else {
            ds_map_add(global.inventory, prize, 1);
        }
        
        global.game_text += "You received a " + prize + "!";
    } else {
        global.game_text += "Despite your best effort, luck wasn’t on your side today. Better luck next time!";
    }

    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_meadow_festival_trade() {
    global.game_text = "You browse the market stalls, spotting rare and exotic goods.\n\n";
    
    if (ds_map_exists(global.inventory, "Gold Coins") && global.inventory[? "Gold Coins"] >= 5) {
        global.inventory[? "Gold Coins"] -= 5;
        var item = "Enchanted Trinket";
        
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "You traded 5 Gold Coins for a " + item + "!";
    } else {
        global.game_text += "Unfortunately, you don't have enough coins for a trade.";
    }

    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_meadow_festival_watch() {
    global.game_text = "You enjoy the festival performances—acrobats, musicians, and storytellers fill the stage.\n\n";
    global.game_text += "Inspired by their skill, you gain newfound motivation!";
    
    var exp_gain = 15 + irandom(5);
    global.player_exp += exp_gain;
    global.game_text += "\n\nYou gained " + string(exp_gain) + " experience points!";
    
    // Check for level up
    if (global.player_exp >= global.player_exp_to_next) {
        player_level_up();
    }

    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}
	
	// Stranded Climber event
function event_mountain_climber() {
    global.game_text = "You spot a climber stuck on a narrow cliff edge!\n\n";
    global.game_text += "They wave frantically, clearly unable to move without risking a fall.\n\n";
    global.game_text += "What will you do?";

    // Clear button options
    ds_list_clear(global.button_options);

    // Add event options
    ds_list_add(global.button_options, {
        text: "Throw them a rope!",
        action: event_mountain_climber_rope
    });

    ds_list_add(global.button_options, {
        text: "Try to climb down and assist",
        action: event_mountain_climber_climb
    });

    ds_list_add(global.button_options, {
        text: "Call for help",
        action: event_mountain_climber_help
    });

    ds_list_add(global.button_options, {
        text: "Walk away...",
        action: event_mountain_climber_ignore
    });
}

function event_mountain_climber_rope() {
    global.game_text = "You secure a rope and toss it down.\n\n";

    if (random(100) < 70) {
        global.game_text += "The climber grabs hold and pulls themselves up, breathing a sigh of relief.\n\n";
        global.game_text += "\"You saved my life! Please take this in return.\"";

        var item = "Climbing Gear";
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }

        global.game_text += "\n\nYou received " + item + "!";
    } else {
        global.game_text += "The climber struggles to hold on and slips!\n\n";
        global.game_text += "They manage to grab a lower ledge but are still stranded.";
    }

    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_mountain_climber_climb() {
    global.game_text = "You carefully scale the rock to reach the stranded climber...\n\n";

    if (random(100) < 50) {
        global.game_text += "You make it down safely and help them get back up.\n\n";
        global.game_text += "The climber is eternally grateful and shares valuable survival knowledge.";
        var exp_gain = 25 + irandom(10);
        global.player_exp += exp_gain;
        global.game_text += "\n\nYou gained " + string(exp_gain) + " experience points!";
    } else {
        global.game_text += "A loose rock slips beneath your feet, causing you to lose your footing!\n\n";
        global.game_text += "You recover but take some damage in the process.";
        global.player_health -= 12;
        global.game_text += "\n\nYou lost 12 health points!";
    }

    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_mountain_climber_help() {
    global.game_text = "You shout for help, hoping someone nearby hears you.\n\n";

    if (random(100) < 60) {
        global.game_text += "A group of experienced climbers rush over and successfully rescue the stranded person.\n\n";
        global.game_text += "They thank you for your quick thinking and offer a small token.";
        
        var item = "Emergency Beacon";
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }

        global.game_text += "\n\nYou received " + item + "!";
    } else {
        global.game_text += "Unfortunately, nobody responds. The climber remains trapped.";
    }

    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}

function event_mountain_climber_ignore() {
    global.game_text = "You turn away, deciding not to interfere.\n\n";
    global.game_text += "As you leave, you hear their desperate calls fade into the wind.";

    // Return to exploration
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, { text: "Continue Exploring", action: explore_area });
    ds_list_add(global.button_options, { text: "Travel", action: game_start });
}