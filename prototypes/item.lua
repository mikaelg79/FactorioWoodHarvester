--item.lua

local woodHarvester = table.deepcopy(data.raw.item["assembling-machine-1"])
woodHarvester.name = "wood-harvester"
woodHarvester.place_result = "wood-harvester"
woodHarvester.icons = {
    {
       icon = "__WoodHarvester__/graphics/icons/wood-harvester.png",
       icon_size = 32,
    },
}

local timber = table.deepcopy(data.raw.item["raw-wood"])
timber.name = "timber"
timber.icons = {
    {
        icon = "__base__/graphics/icons/tree-03.png",
        icon_size = 32,
    }
}


data:extend{woodHarvester,timber}