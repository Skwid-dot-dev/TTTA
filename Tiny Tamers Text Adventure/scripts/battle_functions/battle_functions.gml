function battle_attack() {
    var player_goes_first = true;
    var player_agility = global.player_agility;
    
    // Determine who goes first based on agility
    if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
        // Use monster's agility if one is active
        var active_monster = global.captured_monsters[| global.current_monster];
        player_agility = active_monster.agility;
    }
    
    // Wild monster might go first if its agility is higher
    if (global.battle_monster.agility > player_agility) {
        // For each point of agility difference, add 10% chance for faster creature to go first
        var agility_diff = global.battle_monster.agility - player_agility;
        var chance_to_go_first = min(90, agility_diff * 10); // Cap at 90%
        
        if (random(100) < chance_to_go_first) {
            player_goes_first = false;
        }
    }
    
    // Handle the attack order
    if (player_goes_first) {
        // Player attacks first
        player_attack_turn();
        
        // Check if monster is defeated
        if (global.battle_monster.hp <= 0) {
            battle_victory();
            return;
        }
        
        // Monster attacks second
        monster_attack_turn();
    } else {
        // Monster attacks first
        global.game_text = "The " + global.battle_monster.name + " is faster and attacks first!\n\n";
        monster_attack_turn();
        
        // Check if player/monster is defeated
        if ((global.current_monster != -1 && 
             global.current_monster < ds_list_size(global.captured_monsters) &&
             global.captured_monsters[| global.current_monster].hp <= 0) ||
            (global.current_monster == -1 && global.player_health <= 0)) {
            
            if (global.player_health <= 0) {
                battle_defeat();
                return;
            } else {
                // Player's monster fainted
                var monster = global.captured_monsters[| global.current_monster];
                global.game_text += "Your " + monster.name + " fainted!\n\n";
                global.game_text += "What will you do?";
                
                // Clear button options
                ds_list_clear(global.button_options);
                
                // Add battle actions
                ds_list_add(global.button_options, {
                    text: "Attack Yourself",
                    action: player_attack
                });
                
                ds_list_add(global.button_options, {
                    text: "Try to Capture",
                    action: try_capture
                });
                
                ds_list_add(global.button_options, {
                    text: "Run Away",
                    action: run_away
                });
                
                ds_list_add(global.button_options, {
                    text: "Change Monster",
                    action: battle_select_monster
                });
                
                return;
            }
        }
        
        // Player attacks second
        player_attack_turn();
        
        // Check if monster is defeated
        if (global.battle_monster.hp <= 0) {
            battle_victory();
            return;
        }
    }
    
    // Add battle status and options
    global.game_text += "\nWhat will you do?";
    
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

// 6. Helper functions for battle turns
function player_attack_turn() {
    var damage_dealt = 0;
    
    if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
        // Use active monster to attack
        var active_monster = global.captured_monsters[| global.current_monster];
        
        // Check if monster has HP
        if (active_monster.hp <= 0) {
            global.game_text += active_monster.name + " is too weak to fight!\n";
            return;
        }
        
        // Calculate monster damage
        damage_dealt = max(1, active_monster.attack - global.battle_monster.defense);
        
        global.game_text += active_monster.name + " attacks the wild " + 
                           global.battle_monster.name + " for " + string(damage_dealt) + " damage!\n";
    } else {
        // Player attacks directly
        damage_dealt = max(1, global.player_level * 5 - global.battle_monster.defense);
        
        global.game_text += "You attack the " + global.battle_monster.name + 
                           " for " + string(damage_dealt) + " damage!\n";
    }
    
    // Apply damage
    global.battle_monster.hp -= damage_dealt;
    
    if (global.battle_monster.hp > 0) {
        global.game_text += "The wild " + global.battle_monster.name + " has " + 
                           string(global.battle_monster.hp) + "/" + 
                           string(global.battle_monster.max_hp) + " HP left.\n";
    }
}

function monster_attack_turn() {
    // Monster attacks back - either player or active monster
    var monster_damage = max(1, global.battle_monster.attack - global.player_level);
    
    if (global.current_monster != -1 && global.current_monster < ds_list_size(global.captured_monsters)) {
        // Monster attacks player's monster
        var active_monster = global.captured_monsters[| global.current_monster];
        
        // Check if monster has HP
        if (active_monster.hp <= 0) {
            // Monster attacks player instead
            global.player_health -= monster_damage;
            
            global.game_text += "The wild " + global.battle_monster.name + 
                               " attacks you for " + string(monster_damage) + " damage!\n";
                               
            // Check if player is defeated
            if (global.player_health <= 0) {
                battle_defeat();
                return;
            }
        } else {
            active_monster.hp -= monster_damage;
            
            global.game_text += "The wild " + global.battle_monster.name + 
                               " attacks your " + active_monster.name + 
                               " for " + string(monster_damage) + " damage!\n";
            
            // Check if player's monster is defeated
            if (active_monster.hp <= 0) {
                global.game_text += "Your " + active_monster.name + " was defeated!\n";
            } else {
                global.game_text += "Your " + active_monster.name + " has " + 
                                   string(active_monster.hp) + "/" + 
                                   string(active_monster.max_hp) + " HP left.\n";
            }
        }
    } else {
        // Monster attacks player directly
        global.player_health -= monster_damage;
        
        global.game_text += "The wild " + global.battle_monster.name + 
                           " attacks you for " + string(monster_damage) + " damage!\n";
        
        // Check if player is defeated
        if (global.player_health <= 0) {
            battle_defeat();
            return;
        }
    }
}
