// Main game loop logic based on game state
    switch(global.game_state) {
        case "exploration":
            // Handle exploration logic
            break;
        case "battle":
            // Handle battle logic
            break;
        case "capture":
            // Handle capture logic
            break;
        case "inventory":
            // Handle inventory logic
            break;
			// Add this to the step_game_controller function
		case GAME_STATE.RACING:

			draw_race();
			
			break;
    }
