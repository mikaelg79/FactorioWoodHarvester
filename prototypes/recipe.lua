--recipe.lua

data:extend(
    {
        -- Harvesting machine
        {
            type = "recipe",
            name = "wood-harvester",
            enabled = false,
            energy_required = 10,
            ingredients = {
                {"iron-axe",5},
                {"iron-gear-wheel",5},
                {"iron-plate",10}
            },
            result = "wood-harvester",
            order = "b[fluids]-b[pumpjack]-c[wood-harvester]"
        },
        -- Recipe category
        {
            type = "recipe-category",
            name = "wood-harvesting"
        },
        -- Hidden recipe for the fixed recipe
        {
            type = "recipe",
            name = "wood-harvesting",
            enabled = true,
            hidden = true,
            energy_required = 1,
            category = "wood-harvesting",
            ingredients = {
                {
                    type = "item",
                    name = "timber",
                    amount = 1
                }
            },
            results = {
                {
                    type = "item",
                    name = "raw-wood",
                    amount = 1
                }
            }
        }
    }
)

table.insert( data.raw["technology"]["automation"].effects, { type = "unlock-recipe", recipe = "wood-harvester"	} )