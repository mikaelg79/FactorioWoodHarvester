--recipe.lua

data:extend(
    {
        {
            type = "recipe-category",
            name = "wood-harvesting"
        },
        {
            type = "recipe",
            name = "wood-harvester",
            enabled = false,
            energy_required = 10,
            ingredients = {
                {"copper-plate",200},
                {"iron-plate",50}
            },
            result = "wood-harvester"
        },
        {
            type = "recipe",
            name = "wood-harvesting",
            enabled = true,
            hidden = true,
            energy_required = 5,
            category = "wood-harvesting",
            ingredients = {},
            results = {
                {
                    type = "item",
                    name = "raw-wood",
                    amount = "2"
                }
            }
        }
    }
)

table.insert( data.raw["technology"]["automation"].effects, { type = "unlock-recipe", recipe = "wood-harvester"	} )