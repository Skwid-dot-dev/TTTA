text_timer += 1;
if (text_timer >= text_speed) {
    text_timer = 0; // Reset the timer
    if (current_text_length < string_length(global.game_text)) {
        current_text_length += 1;
    }
}