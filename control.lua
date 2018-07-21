--control.lua

require("whutil")

debug_on = 0

local harvest_speed = 60 -- in ticks (60 tick/s)
local harvest_min_range = 2 -- starting radius of harvesting area, in tiles
local harvest_max_range = 24 -- max radius of harvesting area, in tiles
local harvest_stack = 5 -- Harvest this much timber before waiting.

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

function checkForUpdate(event)
    if (event.mod_changes["WoodHarvester"]) then
        local mod = event.mod_changes["WoodHarvester"]
        local old_version = splitversion(mod.old_version)
        -- New global.woodHarvesters structure
        if (old_version.major < 1) and (old_version.minor < 1) and (old_version.build < 8) then
            game.print("Updating global structure...")
            tempHarvesters = {}
            for i,harvester in pairs(global.woodHarvesters) do
                tempHarvesters[i] = {["machine"]=harvester,["range"]=2}
            end
            global.woodHarvesters = tempHarvesters
        end

    end
    registerTickHandler()
end

script.on_load(registerTickHandler)
script.on_init(registerTickHandler)
script.on_configuration_changed(checkForUpdate)

function unRegisterTickHandler()
    script.on_nth_tick(harvest_speed,nil)
end



function onBuilt(entity)
    debug_print("In onBuilt")
    if entity.name == "wood-harvester" then
        if not global.woodHarvesters then global.woodHarvesters = {} end
        global.woodHarvesters[#global.woodHarvesters+1] = {["machine"]=entity,["range"]=harvest_min_range}
        debug_print("Harvesters: " .. #global.woodHarvesters)
        registerTickHandler()
    end
end

function doHarvest()
    debug_print("In doHarvest, " .. #global.woodHarvesters .. " active harvesters")
    for i,harvester in pairs(global.woodHarvesters) do
        if not harvester.machine.valid then
            debug_print("Removed invalid harvester")
            table.remove(global.woodHarvesters, i)
        else
            if (harvester.machine.get_inventory(defines.inventory.assembling_machine_input).get_item_count() <= 4) and (harvester.machine.energy > 0) then
                local tree
                while (not tree) and (harvester.range < harvest_max_range) do
                    local searchArea = {
                        {harvester.machine.position.x-harvester.range,harvester.machine.position.y-harvester.range},
                        {harvester.machine.position.x+harvester.range,harvester.machine.position.y+harvester.range}
                    }
                    tree = harvester.machine.surface.find_entities_filtered{type="tree",limit=1,area=searchArea}[1]
                    if not tree then
                        debug_print("No tree found at range " .. harvester.range ..", increasing range")
                        harvester.range = harvester.range + 1
                    end
                end
                if not tree then
                    debug_print("No more trees to harvest.")
                    table.remove(global.woodHarvesters,i)
                else
                    local got_product = nil
                    local treeProducts = tree.prototype.mineable_properties.products
                    for _,product in pairs(treeProducts) do
                        if product.name == "raw-wood" then
                            got_product = true
                            if harvester.machine.can_insert({name="timber",count=product.amount}) then
                                debug_print("Harvested " .. product.amount .. " units of timber")
                                harvester.machine.insert{name="timber",count=product.amount}
                                tree.die()
                            else
                                debug_print("Can't insert timber - invalid inputs in machine?")
                            end
                        else
                            debug_print("unknown product: " .. product.name)
                        end
                    end
                    if not got_product then
                        -- Tree modded not to give raw wood? Just kill it, otherwise harvester will be stuck on the same tree forever.
                        debug_print ("Tree did not provide wood - possible mod conflict.")
                        tree.die()
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

