// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function tutorial_yes(){
	global.game_text = "It seems you have the hang of this already!\n" +
						"Press buttons, Read things, Try NOT to die :)"
	
	
	
// Clear button options
    ds_list_clear(global.button_options);
	

	
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "Home?",
	    action: home_area
	});
		
	
}

function tutorial_no(){
	global.game_text = "Good! There wasn't much of one anyway!\n" +
						"Press buttons, Read things, Try NOT to die :)"
	
	
	
// Clear button options
    ds_list_clear(global.button_options);
	

	
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "Home?",
	    action: home_area
	});
		
	
}