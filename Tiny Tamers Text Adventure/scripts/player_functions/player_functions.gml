// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_player_name(){
	msg = get_string_async("What would you like to be called?","Player");
	global.game_text = "Well we saw you at Bizno's Subs and you looked like the perfect fit.\n" +
						"Someone fresh to bring in new drivers for our race team.\n"+
						"As the only Corporate Underground Racing Service Entity,\n"+
						"or 'CURSE', it's difficult to onboard applicants...\n"+
						"Hence the Kidnapping XD";
						
						
	// Clear button options
    ds_list_clear(global.button_options);
		
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "Are you kidding me?!?!",
	    action: tutorial_continue
	});	
	
	//Yes Tutorial
	ds_list_add(global.button_options, {
	    text: "Where do I sign?",
	    action: tutorial_continue_one
	});						
}
	
function player_get_name_seed(){
	// Get detailed date and time values
var dt = date_current_datetime();
var year = date_get_year(dt);
var month = date_get_month(dt);
var day = date_get_day(dt);
var hour = date_get_hour(dt);
var minute = date_get_minute(dt);
var second = date_get_second(dt);
var millisecond = current_time mod 1000; // Approximate milliseconds

// Get game runtime details
var game_time = current_time;
var frame_count = room_speed * (game_time / 1000);

// Generate a near-unique player ID
var player_seed = string(year) + string(month) + string(day) + "_" +
                string(hour) + string(minute) + string(second) + string(millisecond) + "_" +
                string(game_time) + "_" +
                string(frame_count);

global.player_nameseed = player_seed;	
}