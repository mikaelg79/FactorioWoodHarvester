--entity.lua



data:extend(
    {
        {
            name = "wood-harvester",
            minable = {
                hardness = 0.2,
                mining_time = 0.5,
                result = "wood-harvester"
            },

            picture =
            {
                filename = "__WoodHarvester__/graphics/entity/wood-harvester/wood-harvester.png",
                priority = "high",
                height = 114,
                width = 114,
                shift = {
                    0,
                    0.0625
                },
            },
            type = "assembling-machine",
            fixed_recipe = "wood-harvesting",
            -- inventory_size = 1,
            -- enable_inventory_bar = false,
            alert_icon_shift = {-0.09375,-0.375},
            animation = {
                layers = {
                    {
                        filename = "__WoodHarvester__/graphics/entity/wood-harvester/wood-harvester.png",
                        frame_count = 32,
                        height = 114,
                        hr_version = {
                            filename = "__WoodHarvester__/graphics/entity/wood-harvester/hr-wood-harvester.png",
                            frame_count = 32,
                            height = 226,
                            line_length = 8,
                            priority = "high",
                            scale = 0.5,
                            shift = {
                                0,
                                0.0625
                            },
                            width = 214
                        },
                        line_length = 8,
                        priority = "high",
                        shift = {
                            0,
                            0.0625
                        },
                        width = 108
                    },
                    {
                        draw_as_shadow = true,
                        filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1-shadow.png",
                        frame_count = 1,
                        height = 83,
                        hr_version = {
                            draw_as_shadow = true,
                            filename = "__base__/graphics/entity/assembling-machine-1/hr-assembling-machine-1-shadow.png",
                            frame_count = 1,
                            height = 165,
                            line_length = 1,
                            priority = "high",
                            repeat_count = 32,
                            scale = 0.5,
                            shift = {
                                0.265625,
                                0.15625
                            },
                            width = 190
                        },
                        line_length = 1,
                        priority = "high",
                        repeat_count = 32,
                        shift = {
                            0.265625,
                            0.171875
                        },
                        width = 95
                    }
                }
            },
            close_sound = {
                filename = "__base__/sound/machine-close.ogg",
                volume = 0.75
            },
            collision_box = {{-1.2,-1.2},{1.2,1.2}},
            selection_box = {{-1.5,-1.5},{1.5,1.5}},
            corpse = "big-remnants",
            crafting_categories = {"wood-harvesting"},
            crafting_speed = 1,
            dying_explosion = "medium-explosion",
            energy_source = {
                emissions = 0.03333333333333333,
                type = "electric",
                usage_priority = "secondary-input"
            },
            energy_usage = "90kW",
            flags = {"placeable-neutral","placeable-player","player-creation"},
            icon = "__base__/graphics/icons/assembling-machine-1.png",
            icon_size = 32,
            ingredient_count = 2,
            max_health = 300,
            open_sound = {
                filename = "__base__/sound/machine-open.ogg",
                volume = 0.85
            },
            resistances = {
                {
                    percent = 70,
                    type = "fire"
                }
            },
            vehicle_impact_sound = {
                filename = "__base__/sound/car-metal-impact.ogg",
                volume = 0.65
            },
            working_sound = {
                apparent_volume = 1.5,
                idle_sound = {
                    filename = "__base__/sound/idle1.ogg",
                    volume = 0.6
                },
                sound = {
                    {
                        filename = "__base__/sound/assembling-machine-t1-1.ogg",
                        volume = 0.8
                    },
                    {
                        filename = "__base__/sound/assembling-machine-t1-2.ogg",
                        volume = 0.8
                    }
                }
            },
        }
    }
)