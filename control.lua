--control.lua

require("util")

debug_on = 0

local harvest_speed = 60 -- in ticks (60 tick/s)
local harvest_range = 24 -- radius of harvesting area, in tiles
local harvest_stack = 5 -- amount of timber to harvest before waiting for processing

script.on_event(
    {
        defines.events.on_built_entity,
        defines.events.on_robot_built_entity
    },
    function(event) onBuilt(event.created_entity) end
)

function registerTickHandler()
    if global.woodHarvesters then
        script.on_nth_tick(harvest_speed,doHarvest)
    end
end

script.on_load(registerTickHandler)
script.on_init(registerTickHandler)
script.on_configuration_changed(registerTickHandler)

function unRegisterTickHandler()
    script.on_nth_tick(harvest_speed,nil)
end

function onBuilt(entity)
    debug_print("In onBuilt")
    if entity.name == "wood-harvester" then
        if not global.woodHarvesters then global.woodHarvesters = {} end
        global.woodHarvesters[#global.woodHarvesters+1] = entity
        debug_print("Harvesters: " .. #global.woodHarvesters)
        -- start animation
        registerTickHandler()
    end
end

function doHarvest()
    debug_print("In doHarvest")
    debug_print(#global.woodHarvesters .. " active harvesters")
    for i,harvester in pairs(global.woodHarvesters) do
        if not harvester.valid then
            debug_print("Removed invalid harvester")
            table.remove(global.woodHarvesters, i)
        else
            if (harvester.get_inventory(defines.inventory.assembling_machine_input).get_item_count() <= 4) and (harvester.energy > 0) then
                local searchArea = {
                    {harvester.position.x-harvest_range,harvester.position.y-harvest_range},
                    {harvester.position.x+harvest_range,harvester.position.y+harvest_range}
                }
                local tree = harvester.surface.find_entities_filtered{type="tree",limit=1,area=searchArea}[1]
                if not tree then
                    debug_print("No more trees to harvest.")
                    table.remove(global.woodHarvesters,i)
                else
                    local treeProducts = tree.prototype.mineable_properties.products
                    for _,product in pairs(treeProducts) do
                        if product.name == "raw-wood" then
                            if harvester.can_insert({name="timber",count=product.amount}) then
                                debug_print("Harvested " .. product.amount .. " units of timber")
                                harvester.insert{name="timber",count=product.amount}
                                tree.die()
                            else
                                debug_print("Can't insert timber - invalid inputs in machine?")
                            end
                        end
                    end
                end
            else
                debug_print("Harvester full or no power")
            end
        end
    end
    if #global.woodHarvesters == 0 then
        debug_print("No valid harvesters left")
        global.woodHarvesters = nil
        unRegisterTickHandler()
    end
end

