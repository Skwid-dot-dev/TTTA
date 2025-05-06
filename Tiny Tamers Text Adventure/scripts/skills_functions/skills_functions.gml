
function initialize_skills(){
// Initialize skills: name, level, current_exp, exp_to_next, description
ds_map_add(global.skills, "Foraging", {
    name: "Foraging",
    level: 1,
    current_exp: 0,
    exp_to_next: 50,
    description: "Find plants and berries in the wild."
});

ds_map_add(global.skills, "Mining", {
    name: "Mining",
    level: 1,
    current_exp: 0,
    exp_to_next: 50,
    description: "Collect minerals and gems from rock formations."
});

ds_map_add(global.skills, "Crafting", {
    name: "Crafting",
    level: 1,
    current_exp: 0,
    exp_to_next: 50,
    description: "Create useful items from gathered materials."
});

ds_map_add(global.skills, "Fishing", {
    name: "Fishing",
    level: 1,
    current_exp: 0,
    exp_to_next: 50,
    description: "Catch fish from lakes and rivers."
});

ds_map_add(global.skills, "Explorations", {
    name: "Exploring",
    level: 1,
    current_exp: 0,
    exp_to_next: 50,
    description: "Exploration count limits available biomes."
});
}

// View player skills
function view_skills() {
    global.game_text = "Your Skills:\n\n";
    
    var skill_name = ds_map_find_first(global.skills);
    while (!is_undefined(skill_name)) {
        var skill = global.skills[? skill_name];
        global.game_text += skill.name + " - Level " + string(skill.level) + 
                          " (" + string(skill.current_exp) + "/" + 
                          string(skill.exp_to_next) + " XP)\n";
        global.game_text += "  " + skill.description + "\n\n";
        
        skill_name = ds_map_find_next(global.skills, skill_name);
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: change_location
    });
}

// Skill level up function
function skill_level_up(skill_name) {
    var skill = global.skills[? skill_name];
    
    skill.level += 1;
    skill.current_exp -= skill.exp_to_next;
    skill.exp_to_next = Math.floor(skill.level * 50 * 1.5);
    
    global.game_text += "Your " + skill.name + " skill increased to level " + 
                       string(skill.level) + "!\n";
                       
    // Add specific bonuses based on skill type
    switch(skill_name) {
        case "Foraging":
            if (skill.level % 3 == 0) {
                global.player_max_health += 5;
                global.player_health += 5;
                global.game_text += "Your maximum health increased by 5!\n";
            }
            break;
        case "Mining":
            if (skill.level % 3 == 0) {
                var attack_bonus = 1;
                global.game_text += "Your attack power increased by " + string(attack_bonus) + "!\n";
                // Add attack bonus to player stats
            }
            break;
        case "Crafting":
            // Unlocks new craftable items at certain levels
            if (skill.level == 3) {
                global.game_text += "You can now craft Healing Potions!\n";
            } else if (skill.level == 5) {
                global.game_text += "You can now craft Capture Boosters!\n";
            }
            break;
        case "Fishing":
            if (skill.level % 2 == 0) {
                var defense_bonus = 1;
                global.game_text += "Your defense increased by " + string(defense_bonus) + "!\n";
                // Add defense bonus to player stats
            }
            break;
    }
}





// Foraging function
function perform_foraging() {
    var forage_skill = global.skills[? "Foraging"];
    global.game_text = "You search the forest for useful plants...\n\n";
    
    // Success chance based on skill level
    var success_chance = 50 + (forage_skill.level * 5);
    
    if (random(100) < success_chance) {
        // Choose random plant
        var plants = ["Healing Herb", "Energy Root", "Antidote Leaf", "Revival Flower"];
        var item = plants[irandom(array_length_1d(plants) - 1)];
        
        // Add to inventory
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "You found a " + item + "!\n\n";
        
        // Add experience to foraging skill
        var exp_gain = 5 + irandom(5);
        forage_skill.current_exp += exp_gain;
        global.game_text += "You gained " + string(exp_gain) + " Foraging experience.\n";
        
        // Check for level up
        if (forage_skill.current_exp >= forage_skill.exp_to_next) {
            skill_level_up("Foraging");
        }
    } else {
        global.game_text += "You didn't find anything useful this time.\n";
        
        // Still gain some experience for trying
        var exp_gain = 1 + irandom(2);
        forage_skill.current_exp += exp_gain;
        global.game_text += "You gained " + string(exp_gain) + " Foraging experience.\n";
    }
    
    // Add continued exploration options
    ds_list_clear(global.button_options);
    
    ds_list_add(global.button_options, {
        text: "Forage Again",
        action: perform_foraging
    });
    
    ds_list_add(global.button_options, {
        text: "Back",
        action: change_location
    });
}

// Mining function
function perform_mining() {
    var mining_skill = global.skills[? "Mining"];
    global.game_text = "You search for minerals in the cave...\n\n";
    
    // Success chance based on skill level
    var success_chance = 40 + (mining_skill.level * 5);
    
    if (random(100) < success_chance) {
        // Choose random mineral
        var minerals = ["Iron Ore", "Copper Ore", "Coal", "Silver Ore"];
        var item = minerals[irandom(array_length_1d(minerals) - 1)];
        
        // Add to inventory
        if (ds_map_exists(global.inventory, item)) {
            global.inventory[? item] += 1;
        } else {
            ds_map_add(global.inventory, item, 1);
        }
        
        global.game_text += "You mined some " + item + "!\n\n";
        
        // Add experience to mining skill
        var exp_gain = 8 + irandom(7);
        mining_skill.current_exp += exp_gain;
        global.game_text += "You gained " + string(exp_gain) + " Mining experience.\n";
        
        // Check for level up
        if (mining_skill.current_exp >= mining_skill.exp_to_next) {
            skill_level_up("Mining");
        }
    } else {
        global.game_text += "You didn't find any valuable minerals this time.\n";
        
        // Still gain some experience for trying
        var exp_gain = 2 + irandom(3);
        mining_skill.current_exp += exp_gain;
        global.game_text += "You gained " + string(exp_gain) + " Mining experience.\n";
    }
    
    // Add continued exploration options
    ds_list_clear(global.button_options);
    
    ds_list_add(global.button_options, {
        text: "Mine Again",
        action: perform_mining
    });
    
    ds_list_add(global.button_options, {
        text: "Back",
        action: change_location
    });
}
	
	// Crafting function
function perform_crafting() {
    var crafting_skill = global.skills[? "Crafting"];
    global.game_text = "What would you like to craft?\n\n";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add crafting recipes based on crafting level
    
    // Basic healing potion
    if (crafting_skill.level >= 1) {
        ds_list_add(global.button_options, {
            text: "Basic Healing Potion",
            action: craft_healing_potion
        });
    }
    
    // Capture booster
    if (crafting_skill.level >= 5) {
        ds_list_add(global.button_options, {
            text: "Capture Booster",
            action: craft_capture_booster
        });
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: change_location
    });
}

// Craft healing potion
function craft_healing_potion() {
    // Check if player has required materials
    var has_materials = false;
    
    // Example requirement: 2 Healing Herbs
    if (ds_map_exists(global.item_inventory, "Healing Herb") && 
        global.item_inventory[? "Healing Herb"] >= 2) {
        has_materials = true;
    }
    
    if (has_materials) {
        // Remove materials
        global.item_inventory[? "Healing Herb"] -= 2;
        
        // Add potion to inventory
        if (ds_map_exists(global.item_inventory, "Healing Potion")) {
            global.item_inventory[? "Healing Potion"] += 1;
        } else {
            ds_map_add(global.item_inventory, "Healing Potion", 1);
        }
        
        global.game_text = "You successfully crafted a Healing Potion!\n\n";
        
        // Add experience to crafting skill
        var crafting_skill = global.skills[? "Crafting"];
        var exp_gain = 10;
        crafting_skill.current_exp += exp_gain;
        global.game_text += "You gained " + string(exp_gain) + " Crafting experience.\n";
        
        // Check for level up
        if (crafting_skill.current_exp >= crafting_skill.exp_to_next) {
            skill_level_up("Crafting");
        }
    } else {
        global.game_text = "You don't have enough materials to craft this item.\n";
        global.game_text += "Required: 2 Healing Herbs\n";
    }
    
    // Add back button
    ds_list_clear(global.button_options);
    
    ds_list_add(global.button_options, {
        text: "Craft Something Else",
        action: perform_crafting
    });
    
    ds_list_add(global.button_options, {
        text: "Back",
        action: change_location
    });
}