--item.lua

data:extend(
    {
        {
            flags = {
                "goes-to-quickbar"
            },
            icon = "__WoodHarvester__/graphics/icons/wood-harvester.png",
            icon_size = 32,
            name = "wood-harvester",
            order = "a[items]-c[electric-mining-drill]-a[wood-harvester]",
            place_result = "wood-harvester",
            stack_size = 50,
            subgroup = "production-machine",
            type = "item"
        },
        {
            name = "timber",
            flags = {
                "goes-to-main-inventory"
            },
            fuel_category = "chemical",
            fuel_value = "3MJ",
            icon = "__base__/graphics/icons/tree-03.png",
            icon_size = 32,
            order = "a[raw-wood]-b",
            stack_size = 100,
            subgroup = "raw-resource",
            type = "item"
        }
    }
)
