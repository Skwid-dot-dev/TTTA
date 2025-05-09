// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function initialize_cars(){
// Starter cars

ds_map_add(global.car_types, "Skateboard", {
        name: "Skateboard",
		doors: 2,
		mileage: 200,
        acceleration: 2,
        top_speed: 85,
        handling: 8,
        shift_timing: 4,
        value: 500,
        upgrade_level: 0,
        max_upgrade: 3,
        description: "Small plank of wood with a crayoned face on one side.\n" +
					"You vaguely remember the kid with braces you had to fight for it."
    });
    ds_map_add(global.car_types, "Capsule Car", {
        name: "Capsule Car",
		mileage: 400,
		doors: 2,
        acceleration: 3,
        top_speed: 120,
        handling: 7,
        shift_timing: 4,
        value: 1000,
        upgrade_level: 0,
        max_upgrade: 3,
        description: "A small, nimble car with decent gas mileage.\n" + 
					"Storable in your pocket like everything else"
    });
    
    ds_map_add(global.car_types, "4 Door Coupe", {
        name: "4 Door Coupe",
		doors: 4,
		mileage: 200,
        acceleration: 4,
        top_speed: 150,
        handling: 5,
        shift_timing: 5,
        value: 2000,
        upgrade_level: 0,
        max_upgrade: 3,
        description: "You know what they say, more doors, more ..." +
					"Windows to look out of."
    });
    
    ds_map_add(global.car_types, "RhinaRock",{
		name: "RhinaRock",
		doors: 4,
		mileage: 400,
        acceleration: 7,
        top_speed: 180,
        handling: 6,
        shift_timing: 3,
        value: 5000,
        upgrade_level: 0,
        max_upgrade: 3,
        description: "This bad boy can fit so many Tamers." +
					"The chicks might get jealous."
    });
}
	
	// Clone a car from car types
function clone_car_from_type(car_type_name) {
    var car_template = global.car_types[? car_type_name];
    
    if (car_template != undefined) {
        var new_car = {
            name: car_template.name,
            acceleration: car_template.acceleration,
            top_speed: car_template.top_speed,
            handling: car_template.handling,
            shift_timing: car_template.shift_timing,
            value: car_template.value,
            upgrade_level: car_template.upgrade_level,
            max_upgrade: car_template.max_upgrade,
            description: car_template.description
        };
        
        return new_car;
    }
    
    return noone;
}
	
	function view_garage() {
    global.game_state = "garage";
    
    if (ds_list_size(global.player_cars) > 0) {
        global.game_text = "Your Garage:\n\n";
        
        for (var i = 0; i < ds_list_size(global.player_cars); i++) {
            var car = global.player_cars[| i];
            var selected = (car == global.player_car) ? " [SELECTED]" : "";
            global.game_text += string(i + 1) + ". " + car.name + selected + " (Level " + string(car.upgrade_level) + ")\n";
            global.game_text += "   Acceleration: " + string(car.acceleration) + 
                             ", Top Speed: " + string(car.top_speed) + 
                             ", Handling: " + string(car.handling) + "\n";
        }
        
        global.game_text += "\nYour money: $" + string(global.player_currency);
    } else {
        global.game_text = "You don't have any cars yet.\n";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add car shop button
    ds_list_add(global.button_options, {
        text: "Car Shop",
        action: car_shop
    });
    
    if (ds_list_size(global.player_cars) > 0) {
        // Add select car button
        ds_list_add(global.button_options, {
            text: "Select Car",
            action: select_car
        });
        
        // Add upgrade car button
        ds_list_add(global.button_options, {
            text: "Upgrade Car",
            action: upgrade_car_menu
        });
        
        // Add race button
        ds_list_add(global.button_options, {
            text: "Go Racing",
            action: race_menu
        });
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back to Adventure",
        action: change_location
    });
}
		
function car_shop() {
    global.game_text = "Welcome to the Car Shop!\n\n";
    
    var key = ds_map_find_first(global.car_types);
    var i = 1;
    
    while (!is_undefined(key)) {
        var car = global.car_types[? key];
        global.game_text += string(i) + ". " + car.name + " - $" + string(car.value) + "\n";
        global.game_text += "   Acceleration: " + string(car.acceleration) + 
                         ", Top Speed: " + string(car.top_speed) + 
                         ", Handling: " + string(car.handling) + "\n";
        global.game_text += "   " + car.description + "\n\n";
        
        i++;
        key = ds_map_find_next(global.car_types, key);
    }
    
    global.game_text += "Your money: $" + string(global.player_currency);
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add buy buttons
    var key = ds_map_find_first(global.car_types);
    i = 0;
    
    while (!is_undefined(key)) {
        var car = global.car_types[? key];
        
        ds_list_add(global.button_options, {
            text: "Buy " + car.name + " ($" + string(car.value) + ")",
            action: buy_car,
            car_index: i
        });
        
        i++;
        key = ds_map_find_next(global.car_types, key);
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: view_garage
    });
}

// Buy car
function buy_car() {
    var button_index = 0;
    
    // Find which button was clicked
    for (var i = 0; i < ds_list_size(global.button_options); i++) {
        var btn = global.button_options[| i];
        if (point_in_rectangle(mouse_x, mouse_y, 
                              btn.x1, btn.y1, 
                              btn.x2, btn.y2)) {
            button_index = i;
            break;
        }
    }
    
    // Get car type index from button
    var car_index = global.button_options[| button_index].car_index;
    
    // Find car type
    var key = ds_map_find_first(global.car_types);
    var current_index = 0;
    
    while (!is_undefined(key) && current_index < car_index) {
        current_index++;
        key = ds_map_find_next(global.car_types, key);
    }
    
    if (!is_undefined(key)) {
        var car = global.car_types[? key];
        
        // Check if player can afford the car
        if (global.player_currency >= car.value) {
            // Deduct money
            global.player_currency -= car.value;
            
            // Add car to collection
            var new_car = clone_car_from_type(key);
            ds_list_add(global.player_cars, new_car);
            
            global.game_text = "Congratulations! You purchased a " + new_car.name + "!\n\n";
            global.game_text += "Your money: $" + string(global.player_currency);
        } else {
            global.game_text = "You don't have enough money to purchase this car.\n\n";
            global.game_text += "Your money: $" + string(global.player_currency);
        }
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add continue buttons
    ds_list_add(global.button_options, {
        text: "Continue Shopping",
        action: car_shop
    });
    
    ds_list_add(global.button_options, {
        text: "Back to Garage",
        action: view_garage
    });
}

// Select car
function select_car() {
    global.game_text = "Select a car from your garage:\n\n";
    
    for (var i = 0; i < ds_list_size(global.player_cars); i++) {
        var car = global.player_cars[| i];
        var selected = (car == global.player_car) ? " [SELECTED]" : "";
        global.game_text += string(i + 1) + ". " + car.name + selected + " (Level " + string(car.upgrade_level) + ")\n";
        global.game_text += "   Acceleration: " + string(car.acceleration) + 
                         ", Top Speed: " + string(car.top_speed) + 
                         ", Handling: " + string(car.handling) + "\n";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add select buttons
    for (var i = 0; i < ds_list_size(global.player_cars); i++) {
        var car = global.player_cars[| i];
        
        ds_list_add(global.button_options, {
            text: "Select " + car.name,
            action: confirm_select_car,
            car_index: i
        });
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: view_garage
    });
}

// Confirm select car
function confirm_select_car() {
    var button_index = 0;
    
    // Find which button was clicked
    for (var i = 0; i < ds_list_size(global.button_options); i++) {
        var btn = global.button_options[| i];
        if (point_in_rectangle(mouse_x, mouse_y, 
                              btn.x1, btn.y1, 
                              btn.x2, btn.y2)) {
            button_index = i;
            break;
        }
    }
    
    // Get car index from button
    var car_index = global.button_options[| button_index].car_index;
    
    if (car_index < ds_list_size(global.player_cars)) {
        global.player_car = global.player_cars[| car_index];
        
        global.game_text = "You selected the " + global.player_car.name + ".\n";
    }
    
    // Go back to garage
    view_garage();
}

// Upgrade car menu
function upgrade_car_menu() {
    if (global.player_car != noone) {
        global.game_text = "Current Car: " + global.player_car.name + " (Level " + string(global.player_car.upgrade_level) + "/" + string(global.player_car.max_upgrade) + ")\n\n";
        global.game_text += "Stats:\n";
        global.game_text += "- Acceleration: " + string(global.player_car.acceleration) + "\n";
        global.game_text += "- Top Speed: " + string(global.player_car.top_speed) + "\n";
        global.game_text += "- Handling: " + string(global.player_car.handling) + "\n\n";
        
        if (global.player_car.upgrade_level < global.player_car.max_upgrade) {
            var upgrade_cost = global.upgrade_prices[global.player_car.upgrade_level];
            global.game_text += "Upgrade cost: $" + string(upgrade_cost) + "\n";
        } else {
            global.game_text += "This car is fully upgraded!\n";
        }
        
        global.game_text += "Your money: $" + string(global.player_money);
    } else {
        global.game_text = "No car selected.\n";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add upgrade buttons
    if (global.player_car != noone && global.player_car.upgrade_level < global.player_car.max_upgrade) {
        ds_list_add(global.button_options, {
            text: "Upgrade Acceleration",
            action: upgrade_acceleration
        });
        
        ds_list_add(global.button_options, {
            text: "Upgrade Top Speed",
            action: upgrade_speed
        });
        
        ds_list_add(global.button_options, {
            text: "Upgrade Handling",
            action: upgrade_handling
        });
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: view_garage
    });
}

// Upgrade acceleration
function upgrade_acceleration() {
    if (global.player_car != noone && global.player_car.upgrade_level < global.player_car.max_upgrade) {
        var upgrade_cost = global.upgrade_prices[global.player_car.upgrade_level];
        
        if (global.player_money >= upgrade_cost) {
            // Deduct money
            global.player_money -= upgrade_cost;
            
            // Upgrade car
            global.player_car.acceleration += 2;
            global.player_car.upgrade_level += 1;
            
            global.game_text = "You upgraded your car's acceleration!\n\n";
            global.game_text += "New stats:\n";
            global.game_text += "- Acceleration: " + string(global.player_car.acceleration) + "\n";
            global.game_text += "- Top Speed: " + string(global.player_car.top_speed) + "\n";
            global.game_text += "- Handling: " + string(global.player_car.handling) + "\n\n";
            
            global.game_text += "Your money: $" + string(global.player_money);
        } else {
            global.game_text = "You don't have enough money for this upgrade.\n\n";
            global.game_text += "Your money: $" + string(global.player_money);
        }
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add continue buttons
    ds_list_add(global.button_options, {
        text: "Continue Upgrading",
        action: upgrade_car_menu
    });
    
    ds_list_add(global.button_options, {
        text: "Back to Garage",
        action: view_garage
    });
}

// Upgrade top speed
function upgrade_speed() {
    if (global.player_car != noone && global.player_car.upgrade_level < global.player_car.max_upgrade) {
        var upgrade_cost = global.upgrade_prices[global.player_car.upgrade_level];
        
        if (global.player_money >= upgrade_cost) {
            // Deduct money
            global.player_money -= upgrade_cost;
            
            // Upgrade car
            global.player_car.top_speed += 20;
            global.player_car.upgrade_level += 1;
            
            global.game_text = "You upgraded your car's top speed!\n\n";
            global.game_text += "New stats:\n";
            global.game_text += "- Acceleration: " + string(global.player_car.acceleration) + "\n";
            global.game_text += "- Top Speed: " + string(global.player_car.top_speed) + "\n";
            global.game_text += "- Handling: " + string(global.player_car.handling) + "\n\n";
            
            global.game_text += "Your money: $" + string(global.player_money);
        } else {
            global.game_text = "You don't have enough money for this upgrade.\n\n";
            global.game_text += "Your money: $" + string(global.player_money);
        }
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add continue buttons
    ds_list_add(global.button_options, {
        text: "Continue Upgrading",
        action: upgrade_car_menu
    });
    
    ds_list_add(global.button_options, {
        text: "Back to Garage",
        action: view_garage
    });
}

// Upgrade handling
function upgrade_handling() {
    if (global.player_car != noone && global.player_car.upgrade_level < global.player_car.max_upgrade) {
        var upgrade_cost = global.upgrade_prices[global.player_car.upgrade_level];
        
        if (global.player_money >= upgrade_cost) {
            // Deduct money
            global.player_money -= upgrade_cost;
            
            // Upgrade car
            global.player_car.handling += 2;
            global.player_car.upgrade_level += 1;
            // Improved shift timing with better handling
            global.player_car.shift_timing = max(2, global.player_car.shift_timing - 0.5);
            
            global.game_text = "You upgraded your car's handling!\n\n";
            global.game_text += "New stats:\n";
            global.game_text += "- Acceleration: " + string(global.player_car.acceleration) + "\n";
            global.game_text += "- Top Speed: " + string(global.player_car.top_speed) + "\n";
            global.game_text += "- Handling: " + string(global.player_car.handling) + "\n\n";
            
            global.game_text += "Your money: $" + string(global.player_money);
        } else {
            global.game_text = "You don't have enough money for this upgrade.\n\n";
            global.game_text += "Your money: $" + string(global.player_money);
        }
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add continue buttons
    ds_list_add(global.button_options, {
        text: "Continue Upgrading",
        action: upgrade_car_menu
    });
    
    ds_list_add(global.button_options, {
        text: "Back to Garage",
        action: view_garage
    });
}
	
	

// Race menu
function race_menu() {
    global.game_text = "Welcome to the Drag Strip!\n\n";
    global.game_text += "Choose an opponent for your race:\n\n";
    
    var key = ds_map_find_first(global.car_types);
    var i = 1;
    
    while (!is_undefined(key)) {
        var car = global.car_types[? key];
        global.game_text += string(i) + ". " + car.name + "\n";
        global.game_text += "   Difficulty: " + string(i) + "/3\n";
        global.game_text += "   Reward: $" + string(i * 500) + "\n\n";
        
        i++;
        key = ds_map_find_next(global.car_types, key);
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add race buttons
    var key = ds_map_find_first(global.car_types);
    i = 0;
    
    while (!is_undefined(key)) {
        var car = global.car_types[? key];
        
        ds_list_add(global.button_options, {
            text: "Race against " + car.name,
            action: start_race,
            opponent_index: i
        });
        
        i++;
        key = ds_map_find_next(global.car_types, key);
    }
    
    // Add back button
    ds_list_add(global.button_options, {
        text: "Back",
        action: view_garage
    });
}

// Start race
function start_race() {
    if (global.player_car == noone) {
        global.game_text = "You need to select a car first!\n";
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add back button
        ds_list_add(global.button_options, {
            text: "Back",
            action: view_garage
        });
        
        return;
    }
    
    var button_index = 0;
    
    //// Find which button was clicked
    //for (var i = 0; i < ds_list_size(global.button_options); i++) {
    //    var btn = global.button_options[| i];
    //    if (point_in_rectangle(mouse_x, mouse_y, 
    //                          btn.x1, btn.y1, 
    //                          btn.x2, btn.y2)) {
    //        button_index = i;
    //        break;
    //    }
    //}
    
    // Get opponent index from button
    var opponent_index = global.button_options[| button_index].opponent_index;
    
    // Find opponent car type
    var key = ds_map_find_first(global.car_types);
    var current_index = 0;
    
    while (!is_undefined(key) && current_index < opponent_index) {
        current_index++;
        key = ds_map_find_next(global.car_types, key);
    }
    
    if (!is_undefined(key)) {
        // Create opponent car
        global.race_opponent = clone_car_from_type(key);
        
        // Adjust opponent difficulty based on car type
        global.race_opponent.acceleration += opponent_index * 2;
        global.race_opponent.top_speed += opponent_index * 15;
        
        // Set up race
        global.game_state = "racing";
        global.race_state = "racing";
        global.race_progress = 0;
        global.race_opponent_progress = 0;
        global.race_current_speed = 0;
        global.race_current_gear = 1;
        global.race_shift_window = 0;
        global.race_shift_perfect = false;
        
        global.game_text = "3... 2... 1... GO!\n\n";
        global.game_text += "Your car: " + global.player_car.name + "\n";
        global.game_text += "Opponent: " + global.race_opponent.name + "\n\n";
        global.game_text += "Current Gear: " + string(global.race_current_gear) + "\n";
        global.game_text += "Speed: " + string(floor(global.race_current_speed)) + " km/h\n";
        global.game_text += "Distance: " + string(floor(global.race_progress)) + " / " + string(global.race_length) + " meters\n\n";
        global.game_text += "Press 'Shift Up' when the gear indicator appears for the best acceleration!";
        
        // Clear button options
        ds_list_clear(global.button_options);
        
        // Add race buttons
        ds_list_add(global.button_options, {
            text: "Shift Up",
            action: shift_gear
        });
    }
}

// Update race (add this to the step_game_controller function under the "racing" case)
function update_race() {
    if (global.race_state == "racing") {
        // Update player car
        if (global.race_current_gear < global.race_max_gear) {
            // Calculate when to show shift prompt (based on car's shift timing)
            var gear_shift_point = (global.race_current_gear / global.race_max_gear) * global.player_car.top_speed * 0.8;
            
            if (global.race_current_speed >= gear_shift_point && global.race_shift_window == 0) {
                global.race_shift_window = global.player_car.shift_timing * room_speed; // Set shift window timer
                global.race_shift_perfect = true;
                
                // Update text to show shift prompt
                global.game_text = "SHIFT NOW for perfect timing!\n\n";
                global.game_text += "Your car: " + global.player_car.name + "\n";
                global.game_text += "Opponent: " + global.race_opponent.name + "\n\n";
                global.game_text += "Current Gear: " + string(global.race_current_gear) + " [SHIFT!]\n";
                global.game_text += "Speed: " + string(floor(global.race_current_speed)) + " km/h\n";
                global.game_text += "Distance: " + string(floor(global.race_progress)) + " / " + string(global.race_length) + " meters";
            }
        }
        
        // Handle shift window timer
        if (global.race_shift_window > 0) {
            global.race_shift_window--;
            
            if (global.race_shift_window == 0 && global.race_current_gear < global.race_max_gear) {
                // Auto-shift if player missed the window (with penalty)
                global.race_current_gear++;
                global.race_shift_perfect = false;
                global.race_current_speed *= 0.7; // Speed drops significantly for missing shift
                
                // Update text
                global.game_text = "Missed the shift! Speed dropped.\n\n";
                global.game_text += "Your car: " + global.player_car.name + "\n";
                global.game_text += "Opponent: " + global.race_opponent.name + "\n\n";
                global.game_text += "Current Gear: " + string(global.race_current_gear) + "\n";
                global.game_text += "Speed: " + string(floor(global.race_current_speed)) + " km/h\n";
                global.game_text += "Distance: " + string(floor(global.race_progress)) + " / " + string(global.race_length) + " meters";
            }
        }
        
        // Calculate acceleration based on current gear and car stats
        var gear_factor = 1 - ((global.race_current_gear - 1) / global.race_max_gear * 0.5);
        var current_acceleration = global.player_car.acceleration * gear_factor;
        
        // Calculate top speed for current gear
        var gear_top_speed = (global.race_current_gear / global.race_max_gear) * global.player_car.top_speed;
        
        // Update speed (accelerate until reaching gear's top speed)
        if (global.race_current_speed < gear_top_speed) {
            global.race_current_speed += current_acceleration * (1/60); // Assuming 60 FPS
        }
        
        // Update progress
        global.race_progress += global.race_current_speed * (1/60) * 0.28; // Convert km/h to m/s
        
        // Update opponent
        var opponent_acceleration = global.race_opponent.acceleration * (1 - (global.race_opponent_progress / global.race_length * 0.3));
        var opponent_speed = min(global.race_opponent.top_speed, global.race_opponent_progress * 0.5 + opponent_acceleration * 20);
        global.race_opponent_progress += opponent_speed * (1/60) * 0.28;
        
        // Check if race is finished
        if (global.race_progress >= global.race_length || global.race_opponent_progress >= global.race_length) {
            race_finish();
        } else {
            // Update game text every 0.5 seconds
            if (floor(current_time / 500) != floor((current_time - delta_time) / 500)) {
                // Only update if not in shift window
                if (global.race_shift_window == 0) {
                    global.game_text = "Racing...\n\n";
                    global.game_text += "Your car: " + global.player_car.name + "\n";
                    global.game_text += "Opponent: " + global.race_opponent.name + "\n\n";
                    global.game_text += "Current Gear: " + string(global.race_current_gear) + "\n";
                    global.game_text += "Speed: " + string(floor(global.race_current_speed)) + " km/h\n";
                    global.game_text += "Distance: " + string(floor(global.race_progress)) + " / " + string(global.race_length) + " meters";
                }
            }
        }
    }
}



function shift_gear() {
    if (global.race_state == "racing" && global.race_current_gear < global.race_max_gear) {
        if (global.race_shift_window > 0) {
            // Perfect shift if within the optimal window
            global.race_current_gear++;
            
            // Calculate shift quality based on remaining window time
            var shift_quality = global.race_shift_window / (global.player_car.shift_timing * room_speed);
            var bonus_factor = 0.9 + shift_quality * 0.2;
            
            if (shift_quality > 0.7) {
                global.game_text = "PERFECT SHIFT! Speed boost activated!\n\n";
                // Maintain most of current speed when shifting (bonus for perfect timing)
                global.race_current_speed *= bonus_factor;
            } else {
                global.game_text = "Good shift!\n\n";
                // Slight speed drop for good but not perfect timing
                global.race_current_speed *= 0.85;
            }
            
            // Reset shift window
            global.race_shift_window = 0;
            
            // Update text
            global.game_text += "Your car: " + global.player_car.name + "\n";
            global.game_text += "Opponent: " + global.race_opponent.name + "\n\n";
            global.game_text += "Current Gear: " + string(global.race_current_gear) + "\n";
            global.game_text += "Speed: " + string(floor(global.race_current_speed)) + " km/h\n";
            global.game_text += "Distance: " + string(floor(global.race_progress)) + " / " + string(global.race_length) + " meters";
        } else {
            // Early shift (before window appears)
            global.race_current_gear++;
            // Significant speed drop for shifting too early
            global.race_current_speed *= 0.7;
            
            global.game_text = "Early shift! Speed dropped.\n\n";
            global.game_text += "Your car: " + global.player_car.name + "\n";
            global.game_text += "Opponent: " + global.race_opponent.name + "\n\n";
            global.game_text += "Current Gear: " + string(global.race_current_gear) + "\n";
            global.game_text += "Speed: " + string(floor(global.race_current_speed)) + " km/h\n";
            global.game_text += "Distance: " + string(floor(global.race_progress)) + " / " + string(global.race_length) + " meters";
        }
    }
}

// Add the race_finish function
function race_finish() {
    global.race_state = "finished";
    
    var player_won = global.race_progress >= global.race_length && global.race_progress > global.race_opponent_progress;
    
    // Find opponent index
    var opponent_index = -1;
    var key = ds_map_find_first(global.car_types);
    var i = 0;
    
    while (!is_undefined(key)) {
        if (global.race_opponent == key) {
            opponent_index = i;
            break;
        }
        
        i++;
        key = ds_map_find_next(global.car_types, key);
    }
    
    // Calculate reward amount based on opponent difficulty
    var reward_amount = (opponent_index + 1) * 500;
    
    if (player_won) {
        global.game_text = "Victory! You won the race!\n\n";
        global.game_text += "Race time: " + string(floor(global.race_progress / (global.race_current_speed * 0.28))) + " seconds\n\n";
        global.game_text += "You earned $" + string(reward_amount) + "!";
        
        // Add reward money
        global.player_money += reward_amount;
    } else {
        global.game_text = "Defeat! Your opponent won the race!\n\n";
        global.game_text += "Better luck next time!";
    }
    
    // Clear button options
    ds_list_clear(global.button_options);
    
    // Add post-race buttons
    ds_list_add(global.button_options, {
        text: "Return to Garage",
        action: view_garage
    });
    
    ds_list_add(global.button_options, {
        text: "Race Again",
        action: race_menu
    });
}

// Add an additional helper function to reset the race state
function reset_race() {
    global.race_state = "ready";
    global.race_progress = 0;
    global.race_opponent_progress = 0;
    global.race_current_speed = 0;
    global.race_current_gear = 1;
    global.race_shift_window = 0;
    global.race_shift_perfect = false;
    
    // Return to race menu
    race_menu();
}