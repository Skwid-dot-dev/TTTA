// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function initialize_monster_data(){

// Forest monsters
    ds_map_add(global.monster_types, "Leafling", {
        name: "Leafling",
		level: 1,
		knowledge: 0,
        hp: 30,
        max_hp: 30,
        attack: 5,
        defense: 3,
		agility:7,
        rarity: 1,
        typing: "plant",
        habitat: "forest",
        description: "A small creature covered in leaves.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
    
    ds_map_add(global.monster_types, "Timberwolf", {
        name: "Timberwolf",
		level: 1,
		knowledge: 0,
        hp: 45,
        max_hp: 45,
        attack: 8,
        defense: 4,
		agility: 8,
        rarity: 2,
        typing: "beast",
        habitat: "forest",
        description: "A wolf-like creature with bark for skin.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
	
	ds_map_add(global.monster_types, "Barkfang", {
		name: "Barkfang",
		level: 1,
		knowledge: 0,
		hp: 50,
		max_hp: 50,
		attack: 9,
		defense: 5,
		agility: 6,
		rarity: 2,
		typing: "beast",
		habitat: "forest",
		description: "A large predator with wooden fangs.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});

	ds_map_add(global.monster_types, "Thornback", {
	    name: "Thornback",
		level: 1,
		knowledge: 0,
	    hp: 35,
	    max_hp: 35,
	    attack: 6,
	    defense: 7,
	    agility: 5,
	    rarity: 1,
	    typing: "plant",
	    habitat: "forest",
	    description: "A slow-moving creature covered in sharp thorns.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});
    
    // Cave monsters
    ds_map_add(global.monster_types, "Stalactite", {
        name: "Stalactite",
		level: 1,
		knowledge: 0,
        hp: 50,
        max_hp: 50,
        attack: 6,
        defense: 10,
		agility: 4,
        rarity: 2,
        typing: "rock",
        habitat: "cave",
        description: "A living rock formation that drops from cave ceilings.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
    
    ds_map_add(global.monster_types, "Glowshroom", {
        name: "Glowshroom",
		level: 1,
		knowledge: 0,
        hp: 25,
        max_hp: 25,
        attack: 4,
        defense: 2,
		agility: 9,
        rarity: 1,
        typing: "fungus",
        habitat: "cave",
        description: "A bioluminescent mushroom creature.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
	
	ds_map_add(global.monster_types, "Lurker", {
	    name: "Lurker",
		level: 1,
		knowledge: 0,
	    hp: 40,
	    max_hp: 40,
	    attack: 7,
	    defense: 6,
	    agility: 8,
	    rarity: 2,
	    typing: "shadow",
	    habitat: "cave",
	    description: "A lurking creature that blends into the darkness.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});

	ds_map_add(global.monster_types, "Quaketail", {
	    name: "Quaketail",
		level: 1,
		knowledge: 0,
	    hp: 55,
	    max_hp: 55,
	    attack: 9,
	    defense: 10,
	    agility: 4,
	    rarity: 3,
	    typing: "rock",
	    habitat: "cave",
	    description: "A massive, tail-swinging beast that shakes the ground.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});
    
    // Meadow monsters
    ds_map_add(global.monster_types, "Buzzwing", {
        name: "Buzzwing",
		level: 1,
		knowledge: 0,
        hp: 20,
        max_hp: 20,
        attack: 7,
        defense: 2,
		agility: 8,
        rarity: 1,
        typing: "insect",
        habitat: "meadow",
        description: "A fast-flying insect with sharp wings.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
    
    ds_map_add(global.monster_types, "Fluffball", {
        name: "Fluffball",
		level: 1,
		knowledge: 0,
        hp: 35,
        max_hp: 35,
        attack: 3,
        defense: 8,
		agility: 5,
        rarity: 2,
        typing: "normal",
        habitat: "meadow",
        description: "A round, fluffy creature that bounces around.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
	
	ds_map_add(global.monster_types, "Dewfang", {
	    name: "Dewclaw",
		level: 1,
		knowledge: 0,
	    hp: 25,
	    max_hp: 25,
	    attack: 8,
	    defense: 3,
	    agility: 9,
	    rarity: 1,
	    typing: "water",
	    habitat: "meadow",
	    description: "A nimble predator with fierce glistening paws.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});

	ds_map_add(global.monster_types, "Sunmoth", {
	    name: "Sunmoth",
		level: 1,
		knowledge: 0,
	    hp: 40,
	    max_hp: 40,
	    attack: 5,
	    defense: 6,
	    agility: 7,
	    rarity: 2,
	    typing: "insect",
	    habitat: "meadow",
	    description: "A glowing moth that gathers sunlight for energy.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});
    
    // Mountain monsters
    ds_map_add(global.monster_types, "Rocktooth", {
        name: "Rocktooth",
		level: 1,
		knowledge: 0,
        hp: 60,
        max_hp: 60,
        attack: 10,
        defense: 7,
		agility: 6,
        rarity: 3,
        typing: "rock",
        habitat: "mountain",
        description: "A boulder-like monster with sharp stone teeth.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
    
    ds_map_add(global.monster_types, "Frostfeather", {
        name: "Frostfeather",
		level: 1,
		knowledge: 0,
        hp: 40,
        max_hp: 40,
        attack: 8,
        defense: 5,
		agility: 10,
        rarity: 3,
        typing: "ice",
        habitat: "mountain",
        description: "A bird-like creature with crystalized ice feathers.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
    });
	
	ds_map_add(global.monster_types, "Blizzardhorn", {
	    name: "Blizzardhorn",
		level: 1,
		knowledge: 0,
	    hp: 65,
	    max_hp: 65,
	    attack: 11,
	    defense: 9,
	    agility: 5,
	    rarity: 3,
	    typing: "ice",
	    habitat: "mountain",
	    description: "A massive horned beast that commands icy winds.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});

	ds_map_add(global.monster_types, "Slatewing", {
	    name: "Slatewing",
		level: 1,
		knowledge: 0,
	    hp: 50,
	    max_hp: 50,
	    attack: 7,
	    defense: 8,
	    agility: 6,
	    rarity: 2,
	    typing: "rock",
	    habitat: "mountain",
	    description: "A bird with rock-like feathers that can crush foes.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});
	
	// Desert Monsters
	ds_map_add(global.monster_types, "Sandfang", {
	    name: "Sandfang",
		level: 1,
		knowledge: 0,
	    hp: 45,
	    max_hp: 45,
	    attack: 8,
	    defense: 4,
	    agility: 10,
	    rarity: 2,
	    typing: "earth",
	    habitat: "desert",
	    description: "A swift burrowing predator with razor-sharp fangs.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});

	ds_map_add(global.monster_types, "Cactisaur", {
	    name: "Cactisaur",
		level: 1,
		knowledge: 0,
	    hp: 60,
	    max_hp: 60,
	    attack: 9,
	    defense: 11,
	    agility: 4,
	    rarity: 3,
	    typing: "plant",
	    habitat: "desert",
	    description: "A towering cactus-like beast with spiked armor.",
	    alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});
	
	ds_map_add(global.monster_types, "Sandcrawler", {
	    name: "Sandcrawler",
		level: 1,
		knowledge: 0,
	    hp: 55,
	    max_hp: 55,
	    attack: 9,
	    defense: 8,
		agility: 5,
	    rarity: 3,
	    typing: "ground",
	    habitat: "desert",
	    description: "A large scorpion-like creature that burrows through sand.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});

	ds_map_add(global.monster_types, "Cactoid", {
	    name: "Cactoid",
		level: 1,
		knowledge: 0,
	    hp: 70,
	    max_hp: 70,
	    attack: 7,
	    defense: 12,
		agility: 10,
	    rarity: 4,
	    typing: "plant",
	    habitat: "desert",
	    description: "A sentient cactus with spines that can shoot like darts.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});

	ds_map_add(global.monster_types, "Mirage", {
	    name: "Mirage",
		level: 1,
		knowledge: 0,
	    hp: 45,
	    max_hp: 45,
	    attack: 15,
	    defense: 3,
		agility: 15,
	    rarity: 5,
	    typing: "shadow",
	    habitat: "desert",
	    description: "A shimmering creature that can bend light to create illusions.",
		alpha_type: "none",
		shiny_chance: 0.05, // 5% chance of being shiny
    shiny_color: c_yellow, // Color to use for shiny variant nameplate
    shiny_bonus: 1.2 // Stat multiplier for shiny monsters (20% stronger)
	});

}
	
function make_alpha_monster(monster) {
    // 25% chance to be an alpha
    if (random(100) < 25) {
        // Determine alpha type (equal probability for each)
        var alpha_roll = irandom(2);
        
        switch(alpha_roll) {
            case 0: // Runt
                monster.alpha_type = "runt";
                monster.name = "Runt " + monster.name;
                monster.agility += round(monster.agility * 0.5); // +50% agility
                monster.description = "[ALPHA: RUNT] " + monster.description + " This one is smaller but quicker.";
                break;
                
            case 1: // Aggressive
                monster.alpha_type = "aggressive";
                monster.name = "Aggressive " + monster.name;
                monster.attack += round(monster.attack * 0.5); // +50% attack
                monster.description = "[ALPHA: AGGRESSIVE] " + monster.description + " This one is more fierce and dangerous.";
                break;
                
            case 2: // Beefy
                monster.alpha_type = "beefy";
                monster.name = "Beefy " + monster.name;
                monster.max_hp += round(monster.max_hp * 0.5); // +50% HP
                monster.hp = monster.max_hp;
                monster.description = "[ALPHA: BEEFY] " + monster.description + " This one is larger and tougher than others.";
                break;
        }
    }
    
    return monster;
}
	
