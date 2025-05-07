// ===== BATTLE INITIALIZATION =====

/// @function battle_initialize()
/// @description Initialize battle variables and setup
function battle_initialize() {
    // Initialize battle state
    global.battle_active = true;
    global.battle_turn = 0;
    global.battle_log = [];
    global.battle_status_effects = {};
    
    // Set initial battle text
    global.game_text = "A wild " + global.battle_monster.name + " appeared!\n";
    if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
        var active_monster = global.captured_monsters[| global.current_monster];
        global.game_text += "You sent out " + active_monster.name + "!\n";
    }
    
    // Setup battle UI
    battle_show_options();
}

/// @function battle_show_options()
/// @description Show battle options to the player
function battle_show_options() {
    // Clear previous options
    ds_list_clear(global.button_options);
    
    // Add battle actions
    ds_list_add(global.button_options, {
        text: "Attack",
        action: battle_start_attack
    });
    
    ds_list_add(global.button_options, {
        text: "Try to Capture",
        action: try_capture
    });
    
    ds_list_add(global.button_options, {
        text: "Run Away",
        action: try_run_away
    });
    
    if (ds_list_size(global.captured_monsters) > 0) {
        ds_list_add(global.button_options, {
            text: "Change Monster",
            action: battle_select_monster
        });
    }
    
    // If player has active monster, show monster's moves
    if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
        var active_monster = global.captured_monsters[| global.current_monster];
        // Show monster moves if implemented
        // This would display special moves instead of just basic attack
    }
    
    global.game_text += "\nWhat will you do?";
}

// ===== BATTLE FLOW CONTROL =====

/// @function battle_start_attack()
/// @description Start the attack sequence
function battle_start_attack() {
    // Get player and enemy combatants
    var player_combatant = get_player_combatant();
    var enemy_combatant = global.battle_monster;
    
    // Clear battle text
    global.game_text = "";
    
    // Determine action order
    var move_order = determine_move_order(player_combatant, enemy_combatant);
    
    // Process turn according to move order
    process_battle_turn(move_order);
}

/// @function determine_move_order(player_combatant, enemy_combatant)
/// @description Determine who goes first based on speed/agility
/// @param {struct} player_combatant The player's active combatant (player or monster)
/// @param {struct} enemy_combatant The enemy monster
/// @returns {array} Array containing move order [first, second]
function determine_move_order(player_combatant, enemy_combatant) {
    var player_agility = player_combatant.agility;
    var enemy_agility = enemy_combatant.agility;
    
    // Handle priority moves (could be implemented later)
    // var player_priority = get_move_priority(player_move);
    // var enemy_priority = get_move_priority(enemy_move);
    
    // For now we'll just use agility
    if (enemy_agility > player_agility) {
        // For each point of agility difference, add 10% chance for faster creature to go first
        var agility_diff = enemy_agility - player_agility;
        var chance_to_go_first = min(90, agility_diff * 10); // Cap at 90%
        
        if (random(100) < chance_to_go_first) {
            // Enemy goes first
            return [{
                combatant: enemy_combatant,
                is_player: false
            }, {
                combatant: player_combatant,
                is_player: true
            }];
        }
    }
    
    // Default: player goes first
    return [{
        combatant: player_combatant,
        is_player: true
    }, {
        combatant: enemy_combatant,
        is_player: false
    }];
}

/// @function process_battle_turn(move_order)
/// @description Process a complete battle turn with both sides attacking
/// @param {array} move_order Array containing move order [first, second]
function process_battle_turn(move_order) {
    // Process first combatant's turn
    if (move_order[0].is_player == false) {
        global.game_text += "The " + move_order[0].combatant.name + " is faster and attacks first!\n\n";
    }
    
    process_attack(move_order[0].combatant, move_order[1].combatant, move_order[0].is_player);
    
    // Check if battle is over after first attack
    if (check_battle_status()) return;
    
    // Process second combatant's turn
    process_attack(move_order[1].combatant, move_order[0].combatant, move_order[1].is_player);
    
    // Check if battle is over after second attack
    if (check_battle_status()) return;
    
    // If battle continues, show options again
    battle_show_options();
}

/// @function check_battle_status()
/// @description Check if battle has ended (victory or defeat)
/// @returns {bool} True if battle has ended, false if it continues
function check_battle_status() {
    // Check if wild monster is defeated
    if (global.battle_monster.hp <= 0) {
        battle_victory();
        return true;
    }
    
    // Check if player's active monster is defeated
    if (global.current_monster != -1 && 
        global.current_monster < ds_list_size(global.captured_monsters) &&
        global.captured_monsters[| global.current_monster].hp <= 0) {
        
        var monster = global.captured_monsters[| global.current_monster];
        global.game_text += "Your " + monster.name + " fainted!\n\n";
        
        // Check if player has other monsters
        var has_other_monsters = false;
        for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
            if (i != global.current_monster && global.captured_monsters[| i].hp > 0) {
                has_other_monsters = true;
                break;
            }
        }
        
        if (has_other_monsters) {
            // Show prompt to select another monster
            global.game_text += "Select another monster to continue the battle.";
            battle_force_select_monster();
            return true;
        }
    }
    
    // Check if player is defeated
    if (global.current_monster == -1 && global.player_health <= 0) {
        battle_defeat();
        return true;
    }
    
    // Battle continues
    return false;
}

// ===== BATTLE ACTIONS =====

/// @function get_player_combatant()
/// @description Get the player's active combatant (player or monster)
/// @returns {struct} The active combatant with normalized properties
function get_player_combatant() {
    if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
        // Return active monster
        return global.captured_monsters[| global.current_monster];
    } else {
        // Return player as combatant
        return {
            name: "You",
            attack: global.player_attack,
            defense: global.player_defense,
            agility: global.player_agility,
            hp: global.player_health,
            max_hp: global.player_max_health
        };
    }
}

/// @function process_attack(attacker, defender, is_player_attack)
/// @description Process an attack from one combatant to another
/// @param {struct} attacker The attacking combatant
/// @param {struct} defender The defending combatant
/// @param {bool} is_player_attack Whether this is a player attack or enemy attack
function process_attack(attacker, defender, is_player_attack) {
    // Process status effects before attack
    process_status_effects(attacker, is_player_attack);
    
    // Check if attacker can attack
    if (attacker.hp <= 0) {
        if (is_player_attack) {
            global.game_text += attacker.name + " is too weak to fight!\n";
        }
        return;
    }
    
    // Calculate damage with type effectiveness
    var damage = calculate_damage(attacker, defender);
    
    // Apply damage
    if (is_player_attack) {
        // Player attacks enemy
        global.battle_monster.hp -= damage;
        
        if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
            global.game_text += attacker.name + " attacks the wild " + defender.name + " for " + string(damage) + " damage!\n";
        } else {
            global.game_text += "You attack the " + defender.name + " for " + string(damage) + " damage!\n";
        }
        
        if (global.battle_monster.hp > 0) {
            global.game_text += "The wild " + defender.name + " has " + 
                               string(global.battle_monster.hp) + "/" + 
                               string(global.battle_monster.max_hp) + " HP left.\n\n";
        }
    } else {
        // Enemy attacks player/monster
        if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
            var active_monster = global.captured_monsters[| global.current_monster];
            
            if (active_monster.hp <= 0) {
                // Monster attacks player instead
                global.player_health -= damage;
                
                global.game_text += "The wild " + attacker.name + " attacks you for " + string(damage) + " damage!\n\n";
            } else {
                active_monster.hp -= damage;
                
                global.game_text += "The wild " + attacker.name + " attacks your " + active_monster.name + 
                                   " for " + string(damage) + " damage!\n";
                
                if (active_monster.hp > 0) {
                    global.game_text += "Your " + active_monster.name + " has " + 
                                       string(active_monster.hp) + "/" + 
                                       string(active_monster.max_hp) + " HP left.\n\n";
                }
            }
        } else {
            // Monster attacks player directly
            global.player_health -= damage;
            
            global.game_text += "The wild " + attacker.name + " attacks you for " + string(damage) + " damage!\n\n";
        }
    }
    
    // Process post-attack status effects
    apply_status_effects(attacker, defender, is_player_attack);
}

/// @function calculate_damage(attacker, defender)
/// @description Calculate damage based on stats and type effectiveness
/// @param {struct} attacker The attacking combatant
/// @param {struct} defender The defending combatant
/// @returns {real} The calculated damage
function calculate_damage(attacker, defender) {
    // Base damage calculation
    var base_damage = max(1, attacker.attack - defender.defense);
    
    // Apply random variance (85% to 100% of base damage)
    var variance = random_range(0.85, 1.0);
    var damage = max(1, floor(base_damage * variance));
    
    // Apply type effectiveness (if implemented)
    if (variable_struct_exists(attacker, "typing") && variable_struct_exists(defender, "typing")) {
        var type_multiplier = get_type_effectiveness(attacker.typing, defender.typing);
        damage = floor(damage * type_multiplier);
        
        // Add message for super effective or not very effective
        if (type_multiplier > 1) {
            global.game_text += "It's super effective!\n";
        } else if (type_multiplier < 1) {
            global.game_text += "It's not very effective...\n";
        }
    }
    
    // Apply critical hit chance (10% chance for 1.5x damage)
    if (random(100) < 10) {
        damage = floor(damage * 1.5);
        global.game_text += "Critical hit!\n";
    }
    
    return damage;
}

// ===== STATUS EFFECTS =====

/// @function process_status_effects(combatant, is_player)
/// @description Process status effects before an attack
/// @param {struct} combatant The combatant to process status effects for
/// @param {bool} is_player Whether this is the player or enemy
function process_status_effects(combatant, is_player) {
    // This would handle status effects like poison, paralysis, etc.
    // For now, this is a placeholder for future implementation
    
    // Example:
    // if (combatant has poison status) {
    //     Take damage from poison
    //     Update game text
    // }
}

/// @function apply_status_effects(attacker, defender, is_player_attack)
/// @description Apply potential status effects after an attack
/// @param {struct} attacker The attacking combatant
/// @param {struct} defender The defending combatant
/// @param {bool} is_player_attack Whether this is a player attack or enemy attack
function apply_status_effects(attacker, defender, is_player_attack) {
    // This would handle applying status effects from attacks
    // For now, this is a placeholder for future implementation
    
    // Example:
    // if (attack can cause poison) {
    //     10% chance to apply poison
    //     Update game text
    // }
}

/// @function get_type_effectiveness(attacker_type, defender_type)
/// @description Get type effectiveness multiplier
/// @param {string} attacker_type The element type of the attacker
/// @param {string} defender_type The element type of the defender
/// @returns {real} Damage multiplier based on type effectiveness
function get_type_effectiveness(attacker_type, defender_type) {
    // This would be filled out with your game's type chart
    // Example:
    //
    // var effectiveness = {
    //     fire: {
    //         grass: 2.0,  // Super effective
    //         water: 0.5,  // Not very effective
    //         fire: 0.5    // Not very effective
    //     },
    //     water: {
    //         fire: 2.0,
    //         grass: 0.5,
    //         water: 0.5
    //     },
    //     grass: {
    //         water: 2.0,
    //         fire: 0.5,
    //         grass: 0.5
    //     }
    // };
    //
    // if (variable_struct_exists(effectiveness, attacker_type)) {
    //     if (variable_struct_exists(effectiveness[attacker_type], defender_type)) {
    //         return effectiveness[attacker_type][defender_type];
    //     }
    // }
    
    // Default: neutral effectiveness
    return 1.0;
}

// ===== BATTLE RESULTS =====

/// @function battle_victory()
/// @description Handle victory in battle
function battle_victory() {
    global.game_text += "You defeated the wild " + global.battle_monster.name + "!\n";
    
    // Calculate experience gained
    var exp_gained = calculate_experience(global.battle_monster);
    
    // Award experience to player or monster
    if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
        var active_monster = global.captured_monsters[| global.current_monster];
        award_experience_to_monster(active_monster, exp_gained);
    } else {
        // Award experience to player
        global.player_exp += exp_gained;
        global.game_text += "You gained " + string(exp_gained) + " experience points!\n";
        
        // Check for level up
        check_player_level_up();
    }
    
    // End battle
    global.battle_active = false;
    
    // Clear battle options
    ds_list_clear(global.button_options);
    
    // Add continue option
    ds_list_add(global.button_options, {
        text: "Continue",
        action: end_battle
    });
}

/// @function battle_defeat()
/// @description Handle defeat in battle
function battle_defeat() {
    global.game_text += "You were defeated by the wild " + global.battle_monster.name + "!\n";
    global.game_text += "You quickly retreat to safety...\n";
    
    // End battle
    global.battle_active = false;
    
    // Clear battle options
    ds_list_clear(global.button_options);
    
    // Add continue option
    ds_list_add(global.button_options, {
        text: "Continue",
        action: retreat_to_safety
    });
}

/// @function calculate_experience(defeated_monster)
/// @description Calculate experience gained from defeating a monster
/// @param {struct} defeated_monster The defeated monster
/// @returns {real} Experience points gained
function calculate_experience(defeated_monster) {
    // Simple calculation: base exp * monster level
    var base_exp = 10;
    var monster_level = defeated_monster.level || 1;
    
    return base_exp * monster_level;
}

/// @function award_experience_to_monster(monster, exp_amount)
/// @description Award experience to a monster and handle level ups
/// @param {struct} monster The monster to award experience to
/// @param {real} exp_amount The amount of experience to award
function award_experience_to_monster(monster, exp_amount) {
    // Add experience
    monster.exp += exp_amount;
    global.game_text += monster.name + " gained " + string(exp_amount) + " experience points!\n";
    
    // Check for level up
    check_monster_level_up(monster);
}

/// @function check_monster_level_up(monster)
/// @description Check if a monster should level up and handle it
/// @param {struct} monster The monster to check for level up
function check_monster_level_up(monster) {
    // Calculate exp needed for next level (simple formula)
    var next_level_exp = monster.level * 100;
    
    // Check if monster has enough exp to level up
    if (monster.exp >= next_level_exp) {
        // Level up!
        monster.level += 1;
        global.game_text += monster.name + " grew to level " + string(monster.level) + "!\n";
        
        // Increase stats
        monster.max_hp += 5;
        monster.hp = monster.max_hp; // Heal to full on level up
        monster.attack += 2;
        monster.defense += 1;
        monster.agility += 1;
        
        global.game_text += "Its stats increased!\n";
        
        // Check for evolutions or new moves
        check_monster_evolution(monster);
    }
}

/// @function check_monster_evolution(monster)
/// @description Check if a monster should evolve
/// @param {struct} monster The monster to check for evolution
function check_monster_evolution(monster) {
    // This would handle monster evolutions
    // For now, this is a placeholder for future implementation
}

// ===== MONSTER SWITCHING =====

/// @function battle_force_select_monster()
/// @description Force player to select a monster after one faints
function battle_force_select_monster() {
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add monsters that can fight
    for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
        var monster = global.captured_monsters[| i];
        
        // Skip current monster and fainted monsters
        if (i == global.current_monster || monster.hp <= 0) continue;
        
        ds_list_add(global.button_options, {
            text: monster.name + " (HP: " + string(monster.hp) + "/" + string(monster.max_hp) + ")",
            action: script_execute_ext(battle_switch_monster, [i])
        });
    }
    
    // Add option to fight directly
    ds_list_add(global.button_options, {
        text: "Fight Yourself",
        action: battle_switch_to_player
    });
}

/// @function battle_select_monster()
/// @description Allow player to select a monster during battle
function battle_select_monster() {
    global.game_text = "Select a monster to send out:\n";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add monsters
    for (var i = 0; i < ds_list_size(global.captured_monsters); i++) {
        var monster = global.captured_monsters[| i];
        
        // Skip current monster
        if (i == global.current_monster) continue;
        
        var status_text = monster.hp <= 0 ? " (Fainted)" : " (HP: " + string(monster.hp) + "/" + string(monster.max_hp) + ")";
        
        ds_list_add(global.button_options, {
            text: monster.name + status_text,
            action: script_execute_ext(battle_switch_monster, [i])
        });
    }
    
    // Add option to fight directly
    ds_list_add(global.button_options, {
        text: "Fight Yourself",
        action: battle_switch_to_player
    });
    
    // Add cancel option
    ds_list_add(global.button_options, {
        text: "Cancel",
        action: battle_show_options
    });
}

/// @function battle_switch_monster(monster_index)
/// @description Switch to a different monster during battle
/// @param {real} monster_index The index of the monster to switch to
function battle_switch_monster(monster_index) {
    var monster = global.captured_monsters[| monster_index];
    
    // Check if monster has HP
    if (monster.hp <= 0) {
        global.game_text = monster.name + " is too weak to fight!\n";
        battle_select_monster();
        return;
    }
    
    // Switch to the new monster
    global.current_monster = monster_index;
    
    global.game_text = "Go, " + monster.name + "!\n";
    
    // Enemy gets a free attack when switching
    monster_free_attack();
    
    // Show battle options
    battle_show_options();
}

/// @function battle_switch_to_player()
/// @description Switch to player fighting directly
function battle_switch_to_player() {
    global.current_monster = -1;
    global.game_text = "You'll fight directly!\n";
    
    // Enemy gets a free attack when switching
    monster_free_attack();
    
    // Show battle options
    battle_show_options();
}

/// @function monster_free_attack()
/// @description Enemy monster gets a free attack when player switches
function monster_free_attack() {
    // Get player combatant
    var player_combatant = get_player_combatant();
    
    // Enemy attacks
    global.game_text += "The wild " + global.battle_monster.name + " attacks while you switch!\n";
    process_attack(global.battle_monster, player_combatant, false);
    
    // Check battle status
    check_battle_status();
}

// ===== CAPTURE SYSTEM =====

/// @function try_capture()
/// @description Try to capture the wild monster
function try_capture() {
    // Calculate capture chance
    var capture_chance = calculate_capture_chance();
    
    global.game_text = "You throw a capture device at the wild " + global.battle_monster.name + "...\n";
    
    // Roll for capture
    if (random(100) < capture_chance) {
        // Capture successful
        global.game_text += "Gotcha! " + global.battle_monster.name + " was captured!\n";
        
        // Add monster to collection
        add_monster_to_collection(global.battle_monster);
        
        // End battle
        global.battle_active = false;
        
        // Clear battle options
        ds_list_clear(global.button_options);
        
        // Add continue option
        ds_list_add(global.button_options, {
            text: "Continue",
            action: end_battle
        });
    } else {
        // Capture failed
        global.game_text += "Oh no! The " + global.battle_monster.name + " broke free!\n";
        
        // Monster gets a free attack
        monster_free_attack();
        
        if (global.battle_active) {
            // Show battle options if battle is still active
            battle_show_options();
        }
    }
}

/// @function calculate_capture_chance()
/// @description Calculate the chance of capturing a wild monster
/// @returns {real} Capture chance percentage (0-100)
function calculate_capture_chance() {
    // Base capture rate
    var base_capture_rate = 40;
    
    // HP factor: lower HP means higher chance
    var hp_factor = 1 - (global.battle_monster.hp / global.battle_monster.max_hp);
    
    // Status factor: status effects could increase chance
    var status_factor = 1.0; // Default: no status effect
    
    // Calculate final capture chance
    var capture_chance = base_capture_rate * (1 + hp_factor) * status_factor;
    
    // Cap at 90%
    return min(90, capture_chance);
}

/// @function add_monster_to_collection(monster)
/// @description Add a captured monster to the player's collection
/// @param {struct} monster The monster to add
function add_monster_to_collection(monster) {
    // Create a copy of the monster
    var new_monster = {
        name: monster.name,
        level: monster.level,
        hp: monster.hp,
        max_hp: monster.max_hp,
        attack: monster.attack,
        defense: monster.defense,
        agility: monster.agility,
        knowledge: 0,
        typing: monster.typing
    };
    
    // Add to collection
    ds_list_add(global.captured_monsters, new_monster);
    
    // Ask if player wants to use this monster
    global.game_text += "Do you want to use " + new_monster.name + " now?";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add yes/no options
    ds_list_add(global.button_options, {
        text: "Yes",
        action: script_execute_ext(use_new_monster, [ds_list_size(global.captured_monsters) - 1])
    });
    
    ds_list_add(global.button_options, {
        text: "No",
        action: end_battle
    });
}

/// @function use_new_monster(monster_index)
/// @description Set a newly captured monster as the active monster
/// @param {real} monster_index The index of the monster to use
function use_new_monster(monster_index) {
    global.current_monster = monster_index;
    var monster = global.captured_monsters[| monster_index];
    
    global.game_text = "You'll now use " + monster.name + " in battles!";
    
    // Add continue option
    ds_list_clear(global.button_options);
    ds_list_add(global.button_options, {
        text: "Continue",
        action: end_battle
    });
}

// ===== ESCAPE SYSTEM =====

/// @function try_run_away()
/// @description Try to escape from battle
function try_run_away() {
    // Calculate escape chance
    var escape_chance = calculate_escape_chance();
    
    global.game_text = "You try to run away...\n";
    
    // Roll for escape
    if (random(100) < escape_chance) {
        // Escape successful
        global.game_text += "Got away safely!\n";
        
        // End battle
        global.battle_active = false;
        
        // Clear battle options
        ds_list_clear(global.button_options);
        
        // Add continue option
        ds_list_add(global.button_options, {
            text: "Continue",
            action: end_battle
        });
    } else {
        // Escape failed
        global.game_text += "Can't escape!\n";
        
        // Monster gets a free attack
        monster_free_attack();
        
        if (global.battle_active) {
            // Show battle options if battle is still active
            battle_show_options();
        }
    }
}

/// @function calculate_escape_chance()
/// @description Calculate the chance of escaping from battle
/// @returns {real} Escape chance percentage (0-100)
function calculate_escape_chance() {
    // Base escape rate
    var base_escape_rate = 50;
    
    // Speed factor: higher player speed means higher chance
    var player_speed = global.player_agility;
    if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
        var active_monster = global.captured_monsters[| global.current_monster];
        player_speed = active_monster.agility;
    }
    
    var speed_ratio = player_speed / max(1, global.battle_monster.agility);
    var speed_factor = min(2.0, speed_ratio); // Cap at 2x
    
    // Calculate final escape chance
    var escape_chance = base_escape_rate * speed_factor;
    
    // Cap at 95%
    return min(95, escape_chance);
}

/// @function end_battle()
/// @description End the battle and return to normal gameplay
function end_battle() {
    // Reset battle state
    global.battle_active = false;
	global.game_text = "You can keep going, or return with everything.\n";
    
    // Return to normal gameplay
    // This would typically restore the previous game state
    // Clear battle options
        ds_list_clear(global.button_options);
        
        // Add continue option
        ds_list_add(global.button_options, {
            text: "Explore?",
            action: explore_area
        });
		
        // Add continue option
        ds_list_add(global.button_options, {
            text: "Return Home",
            action: end_battle
        });
}

/// @function retreat_to_safety()
/// @description Retreat after being defeated
function retreat_to_safety() {
    // Restore some health
    global.player_health = max(1, global.player_max_health * 0.5);
    
    // Return to a safe location (e.g. last town)
    global.game_text = "You wake up at the nearest safe location...\n";
    global.game_text += "Your health has been partially restored.";
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add continue option
    ds_list_add(global.button_options, {
        text: "Continue",
        action: return_to_gameplay
    });
}
/// @function return_to_gameplay()
/// @description Return to normal gameplay after battle
function return_to_gameplay() {
    // Reset game state to normal gameplay mode
    global.game_state = GAME_STATE.EXPLORE;
    
    // Set appropriate text
    global.game_text = "You continue on your journey.";
    
    // Show normal exploration options
    show_exploration_options();
}
