function initialize_driver_data(){
		ds_map_add(global.driver_types, "Chairmender", {
        name: "Chairmender",
		basespeed : 4,
        acceleration: 2,
        handling: 3,
		perfectshift: 3,
        rarity: 1,
        typing: "Aggresive",
        description: "Seems to appear anytime someone says 'Break A Leg'.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
    
    ds_map_add(global.driver_types, "Sofasaur", {
        name: "Sofasaur",
		basespeed: 2,
		acceleration: 3,
		handling: 4,
		perfectshift: 3,
        rarity: 1,
        typing: "Focused",
        description: "Yeeter of seaters.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
	
	ds_map_add(global.driver_types, "Barstoolse", {
		name: "Barstoolse",
		basespeed: 3,
		acceleration: 4,
		handling: 2,
		perfectshift: 3,
		rarity: 2,
		typing: "Chillax",
		description: "Enjoys showing off the fact it's just a barstool... Bar-stool... Whatever.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});
	
	ds_map_add(global.driver_types, "Baby T-Flex", {
	    name: "Baby T-Flex",
	    basespeed: 4,
		acceleration: 2,
		handling: 2,
		perfectshift: 4,
	    rarity: 1,
	    typing: "Jurasskicked",
	    description: "Big Head. Little Arms. Ego to match.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});
	
	ds_map_add(global.driver_types, "Stimmy Sherman", {
	    name: "Stimmy Sherman",
	    basespeed: 2,
		acceleration: 5,
		handling: 1,
		perfectshift: 5,
	    rarity: 1,
	    typing: "Freeloading",
	    description: "Rose's are red, Violets are blue. I can't wait for Covid #2",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});
    
    // Cave monsters
    ds_map_add(global.driver_types, "PlayerHater", {
        name: "PlayerHater",
        basespeed: 5,
		acceleration: 4,
		handling: 1,
		perfectshift: 4,
        rarity: 2,
        typing: "Scrub",
        description: "Has no Game, Equal amount of maidens.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
	
	
}
	
function show_driver_details(driver_name) {
    if (ds_map_exists(global.driver_types, driver_name)) {
        var driver_data = ds_map_find_value(global.driver_types, driver_name);
        global.game_text = 
            "Name: " + driver_data.name + "\n" +
            "Base Speed: " + string(driver_data.basespeed) + "\n" +
            "Acceleration: " + string(driver_data.acceleration) + "\n" +
            "Handling: " + string(driver_data.handling) + "\n" +   
            "Typing: " + driver_data.typing + "\n" +
            "Description: " + driver_data.description + "\n";

    } else {
        global.game_text = "Driver not found.";
    }
}
	
function add_driver(driver_name) {
    
    if (ds_map_exists(global.driver_types, driver_name)) {
        var driver_data = ds_map_find_value(global.driver_types, driver_name);
        ds_map_add(global.player_drivers, driver_name, driver_data);
    } else {
        show_debug_message("Driver not found: " + driver_name);
    }
}
