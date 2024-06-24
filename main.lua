-- Drones Inherit Items v1.0.3
-- SmoothSpatula

log.info("Successfully loaded ".._ENV["!guid"]..".")
mods.on_all_mods_loaded(function() for k, v in pairs(mods) do if type(v) == "table" and v.hfuncs then Helper = v end end end)
mods.on_all_mods_loaded(function() for k, v in pairs(mods) do if type(v) == "table" and v.tomlfuncs then Toml = v end end 
    params = {
        drones_inherit_items_enabled = true
    }

    params = Toml.config_update(_ENV["!guid"], params)
end)

-- ========== ImGui ==========

gui.add_to_menu_bar(function()
    local new_value, clicked = ImGui.Checkbox("Enable Drones Inherit Items", params['drones_inherit_items_enabled'])
    if clicked then
        params['drones_inherit_items_enabled'] = new_value
        Toml.save_cfg(_ENV["!guid"], params)
    end
end)
-- ========== Main ==========

gm.post_script_hook(gm.constants.item_give_internal, function(self, other, result, args)
    if not params['drones_inherit_items_enabled'] then return end

    local drones = Helper.find_active_instance_all(gm.constants.pDrone)
    for _, drone in ipairs(drones) do
        drone:recalculate_stats()
    end
end)

gm.post_script_hook(gm.constants.init_drone, function(self, other, result, args)
    if not params['drones_inherit_items_enabled'] then return end

    self.inventory_item_order = self.master.inventory_item_order
    self.inventory_item_stack = self.master.inventory_item_stack
    self:recalculate_stats()
end)