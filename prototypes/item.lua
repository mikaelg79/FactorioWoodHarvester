--item.lua

data:extend(
    {
        {
            flags = {},
            icon = "__WoodHarvester__/graphics/icons/wood-harvester.png",
            icon_size = 32,
            name = "wood-harvester",
            order = "b[fluids]-b[pumpjack]-c[wood-harvester]",
            place_result = "wood-harvester",
            stack_size = 50,
            subgroup = "extraction-machine",
            type = "item"
        },
        {
            name = "timber",
            flags = {},
            fuel_category = "chemical",
            fuel_value = "3MJ",
            icon = "__base__/graphics/icons/tree-03.png",
            icon_size = 32,
            order = "a[wood]-b",
            stack_size = 100,
            subgroup = "raw-resource",
            type = "item"
        }
    }
)
