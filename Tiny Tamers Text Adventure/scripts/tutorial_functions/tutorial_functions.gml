function tutorial_yes(){
	global.game_text = "It seems you have the hang of this already!\n" +
						"Press buttons, Read things, Try NOT to die :)"
	
	
	
// Clear button options
    ds_list_clear(global.button_options);
	

	
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "Really?",
	    action: tutorial_start
	});
		
	
}

function tutorial_no(){
	global.game_text = "Good! There wasn't much of one anyway!\n" +
						"Press buttons, Read things, Try to win :)"
	
	
	
// Clear button options
    ds_list_clear(global.button_options);
	

	
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "Really?!",
	    action: tutorial_start
	});
		
	
}

function tutorial_start(){
	global.game_text = "Yea Sure, First of all lets talk about your desire to be a player...!\n" +
						"I mean a manager...\n\n" +
						"Could I bother you for your name?"
						
		
// Clear button options
    ds_list_clear(global.button_options);
		
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "You can call me...",
	    action: set_player_name
	});	
	
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "Stranger Danger!",
	    action: set_player_name
	});	
	}
	
function tutorial_continue(){
	global.game_text = "That's the thing... We don't do too much joking around...\n\n" +
						"LMAO JK ROFLCOPTERSAMURAISWORD!!!\n\n"+
						"Hmmm. New weapon... Tim write that down!"
						
						
	// Clear button options
    ds_list_clear(global.button_options);
		
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "This can't be real",
	    action: tutorial_continue_one
	});	
	
	
}
	
function tutorial_continue_one(){
		global.game_text = "Unfortunately... The only thing you HAVE to sign is the disability waiver\n\n" +
						"After that we can get you a fresh new whip, a driver to get you started.\n"+
						"AND... Some company plastic preloaded with funds!"
						
						
	// Clear button options
    ds_list_clear(global.button_options);
		
		ds_list_add(global.button_options, {
	    text: "Whatever gets me out faster!",
	    action: give_starter_car
	});		
		
	ds_list_add(global.button_options, {
	    text: "Lets get this moving!",
	    action: give_starter_car
	});		
	}

function give_starter_car(){
		global.game_text = "You have been granted a 'Vehicle: Skateboard'\n\n" +
						"Doesn't look like much but its in one peice, nothing personal but,\n"+
						"honestly until you show us what your capable of we can't really trust you.\n"+
						"After all you could've just been a homeless person, in which case this is charity.\n"+
						"In which case 'Tax write-off'."
						
	// Clear button options
    ds_list_clear(global.button_options);
		
		ds_list_add(global.button_options, {
	    text: "Oh, wow...",
	    action: give_starter_driver
	});		
		
	ds_list_add(global.button_options, {
	    text: "Free board too!",
	    action: give_starter_driver
	});		
	
	// Give player starter car
    var starter_car = clone_car_from_type("Skateboard");
    ds_list_add(global.player_cars, starter_car);
    global.player_car = starter_car;
}
	
function give_starter_driver(){
	global.game_text = "Here you can see the lineup of current drivers we have in house.\n\n" +
						"These lads will get you across the finish line, just no say on when.\n"+
						"You can hire drivers to your team in a plethora of ways, but you gotta start somewhere.\n\n"+
						"Anyone *Catch* your eye?\n";
						
						
	// Clear button options
    ds_list_clear(global.button_options);
		
		ds_list_add(global.button_options, {
	    text: "Chairmender",
	    action: tutorial_chairmender
	});		
		
	ds_list_add(global.button_options, {
	    text: "Sofasaur",
	    action: tutorial_sofasaur
	});	
	
	ds_list_add(global.button_options, {
	    text: "Barstoolse",
	    action: tutorial_barstoolse
	});
}
	
function tutorial_chairmender(){
	show_driver_details("Chairmender");
	
	// Clear button options
    ds_list_clear(global.button_options);	
		
	ds_list_add(global.button_options, {
	    text: "Sofasaur",
	    action: tutorial_sofasaur
	});	
	
	ds_list_add(global.button_options, {
	    text: "Barstoolse",
	    action: tutorial_barstoolse
	});
	
	ds_list_add(global.button_options, {
	    text: "Accept?",
	    action: tutorial_accept_chairmender
	});	
}
	
function tutorial_accept_chairmender(){

	global.game_text = "You have been granted a 'Driver: Chairmender'\n" +
						"You have been granted 'Currency: 2000''\n\n" +
						"A dusty old wizard lookin fella pops out of the wood work.\n"+
						"'It's dangerous to go alone, here take this'\n\n"+
						"He gives you the middle finger and vanishes... You Black Out...";
	add_driver("Chairmender");					
						
	// Clear button options
    ds_list_clear(global.button_options);
		
		ds_list_add(global.button_options, {
	    text: "Continue...",
	    action: home_area
	});			
}
	
function tutorial_sofasaur(){
	show_driver_details("Sofasaur");
	
	// Clear button options
    ds_list_clear(global.button_options);	
		
	ds_list_add(global.button_options, {
	    text: "Chairmender",
	    action: tutorial_chairmender
	});	
	
	ds_list_add(global.button_options, {
	    text: "Barstoolse",
	    action: tutorial_barstoolse
	});
	
	ds_list_add(global.button_options, {
	    text: "Accept?",
	    action: tutorial_accept_sofasaur
	});	
}
	
function tutorial_accept_sofasaur(){
	global.game_text = "You have been granted a 'Driver: Sofasaur'\n" +
						"You have been granted 'Currency: 2000''\n\n" +
						"A dusty old wizard lookin fella pops out of the wood work.\n"+
						"'It's dangerous to go alone, here take this'\n\n"+
						"He gives you the middle finger and vanishes... You Black Out..."
	add_driver("Sofasaur")					
						
	// Clear button options
    ds_list_clear(global.button_options);
		
		ds_list_add(global.button_options, {
	    text: "Continue...",
	    action: home_area
	});			
}
	
function tutorial_barstoolse(){
	show_driver_details("Barstoolse");
	
	// Clear button options
    ds_list_clear(global.button_options);	
		
	ds_list_add(global.button_options, {
	    text: "Sofasaur",
	    action: tutorial_sofasaur
	});	
	
	ds_list_add(global.button_options, {
	    text: "Chairmender",
	    action: tutorial_chairmender
	});
	
	ds_list_add(global.button_options, {
	    text: "Accept?",
	    action: tutorial_accept_barstoolse
	});	
}
	
function tutorial_accept_barstoolse(){
	global.game_text = "You have been granted a 'Driver: Barstoolse'\n" +
						"You have been granted 'Currency: 2000''\n\n" +
						"A dusty old wizard lookin fella pops out of the wood work.\n"+
						"'It's dangerous to go alone, here take this'\n\n"+
						"He gives you the middle finger and vanishes... You Black Out..."
	add_driver("Barstoolse")					
						
	// Clear button options
    ds_list_clear(global.button_options);
		
		ds_list_add(global.button_options, {
	    text: "Continue...",
	    action: home_area
	});			
}
	
