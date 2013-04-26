--[[
Copyright (C) 2013, Diego Martínez <lkaezadl3@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
]]

local MODPATH = minetest.get_modpath("firearms");

firearmslib = { };

dofile(MODPATH.."/config.lua");

firearmslib.bullets = { };
firearmslib.firearms = { };

local function count_ammo ( gundef, player )
    local inv = player:get_inventory();
    local size = inv:get_size("main");
    local bulletname = gundef.bullets;
    local count = 0;
    for i = 1, size do
        local stk = inv:get_stack("main", i);
        local nm = stk:get_name();
        if (nm and (nm == bulletname)) then
            count = count + stk:get_count();
        end
    end
    return count;
end

minetest.register_entity("firearms:smokepuff", {
    physical = false;
    timer = 0;
    textures = { "smoke_puff.png" };
    collisionbox = { 0, 0, 0, 0, 0, 0 };
    on_step = function ( self, dtime )
        self.timer = self.timer + dtime;
        if (self.timer > 1) then
            self.object:remove();
        end
    end;
});

local wielded_firearm = { };

local function make_number_texture ( n )
    local s = tostring(n);
    local w = (s:len()*4);
    -- [combine:WxH:X,Y=filename:X,Y=filename2
    local tex = "^[combine:"..(w - 1).."x5";
    for i = 1, s:len() do
        local t = "firearms_"..s:sub(i, i)..".png";
        tex = tex..":"..((i - 1) * 4)..",0="..t;
    end
    return tex;
end

local function set_ammo ( player, clip, resv )
    local wf = wielded_firearm[player:get_player_name()];
    player:hud_change(wf.hud_clip_ammo, "text", make_number_texture(clip));
    if (resv) then
        player:hud_change(wf.hud_ammo, "text", make_number_texture(resv));
    end
end

local function shoot ( itemstack, player, pointed_thing )

    local gunname = itemstack:get_name();
    local inv = player:get_inventory("main");
    local gundef = firearmslib.firearms[gunname];
    local bulletname = gundef.bullets;
    local bulletdef = firearmslib.bullets[bulletname];
    local burst = gundef.burst or 1;
    
    local function do_shoot ( param )
        local playerpos = player:getpos();
        if (not playerpos) then return; end
        local dir = player:get_look_dir();
        local pellets = bulletdef.pellets or 1;
        for n = 1, pellets do

            local spreadx = (-gundef.spread) + (math.random() * gundef.spread * 2);
            local spready = (-gundef.spread) + (math.random() * gundef.spread * 2);
            local spreadz = (-gundef.spread) + (math.random() * gundef.spread * 2);

            if (gundef.speed) then
                -- Entity based bullet
                local bullet = minetest.env:add_entity(
                    {x=playerpos.x, y=playerpos.y + 1.5, z=playerpos.z },
                    bulletname.."_entity"
                );
    
                bullet:setvelocity({
                    x=((dir.x + spreadx) * bulletdef.speed),
                    y=((dir.y + spready) * bulletdef.speed),
                    z=((dir.z + spreadz) * bulletdef.speed),
                });
                bullet:setacceleration({ x=0, y=-(bulletdef.gravity or 1), z=0 });
            else
                -- Instant hit.
                local pos = player:getpos();
                pos.y = pos.y + 1.625;
                local obj = kutils.find_pointed_thing({
                    pos = pos;
                    delta = player:get_look_dir();
                    range = 20;
                    user = player;
                });
                --print("DEBUG: pointed object: "..dump(obj));
                if (obj and obj.entity) then
                    --local dist = kutils.distance3d(player:getpos(), obj.entity:getpos());
                    obj = obj.entity;
                    obj:set_hp(obj:get_hp() - bulletdef.power);
                    if ((not obj:is_player()) and (obj:get_hp() <= 0)) then
                        obj:remove();
                    end
                end
            end
        end
        local sound = (gundef.sounds and gundef.sounds.shoot);
        minetest.sound_play(sound or 'firearms_default_blast', {
            pos = playerpos;
            gain = 0.3;
            max_hear_distance = 50;
        });
        if (param and (param > 0)) then
            minetest.after(gundef.burst_interval, do_shoot, param - 1);
        end
    end

    --print("DEBUG: on_use: metadata=\""..itemstack:get_metadata().."\"");
    local clip = tonumber(itemstack:get_metadata()) or 0;

    if (player:get_player_control().sneak) then
        -- Reload.
        local ammo = count_ammo(gundef, player);
        local needed = gundef.clip_size - clip;
        needed = math.min(needed, ammo);
        --print(("DEBUG: Reloading: ammo=%d, needed=%d, clip=%d"):format(ammo, needed, clip)); 
        inv:remove_item("main", bulletname.." "..needed);
        set_ammo(player, clip+needed, ammo-needed);
        if (gundef.sounds and gundef.sounds.reload) then
            minetest.sound_play(gundef.sounds.reload, {
                pos = playerpos;
                gain = 0.3;
                max_hear_distance = 50;
            });
        end
        return ItemStack({name=gundef.name, metadata=tostring(clip+needed)});
    end

    if (clip <= 0) then return; end

    burst = math.min(burst, clip);
    clip = clip - burst;

    local creative = minetest.setting_getbool("creative_mode");
    if (not creative) then
        do_shoot(burst - 1, bulletdef.speed);
        set_ammo(player, clip, nil);
        return ItemStack({name=gundef.name, metadata=tostring(clip)});
    elseif (creative) then
        do_shoot(burst - 1, bulletdef.speed);
    end
end

firearmslib.register_firearm = function ( name, def )
    def.name = name;
    firearmslib.firearms[name] = def;
    
    minetest.register_tool(name, {
        description = def.description or "Unnamed Gun";
        inventory_image = def.inventory_image or "firearms_unknown.png";
        stack_max = 1;
        on_use = shoot;
        type = "tool";
        wield_scale = def.wield_scale;
    });
    
end

firearmslib.register_bullet = function ( name, def )
    
    firearmslib.bullets[name] = def;

    minetest.register_craftitem(name, {
        description = def.description or "Unnamed Bullets";
        inventory_image = def.inventory_image;
        stack_max = def.stack_max or 10;
    });

    if (def.speed) then
        local ent = {
            physical = (def.physical or false);
            timer = 0;
            textures = { (def.texture or "firearms_bullet_entity.png") };
            lastpos = { };
            collisionbox = { 0, 0, 0, 0, 0, 0 };
            def = def;
            _destroy = function ( self )
                if (self.def.on_destroy) then
                    self.def.on_destroy(self);
                end
                self.object:remove();
            end;
        };
    
        ent.on_step = function ( self, dtime )
            self.timer = self.timer + dtime;
            local pos = self.object:getpos();
            local node = minetest.env:get_node(pos);
    
            --[[if ((self.def.leaves_smoke) and (self.lastpos.x)) then
                local smoke = minetest.env:add_entity(
                    self.lastpos,
                    "firearms:smokepuff"
                );
            end]]
    
            if (self.timer > 0.10) then
                local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 1);
                local bulletname = self.object:get_entity_name():sub(1, -8);
                local damage = firearmslib.bullets[bulletname].damage;
                for k, obj in pairs(objs) do
                    obj:set_hp(obj:get_hp() - damage);
    
                    if ((obj:get_entity_name() ~= self.object:get_entity_name())
                     and (obj:get_entity_name() ~= "firearms:smokepuff")) then
                        if ((not obj:is_player()) and (obj:get_hp() <= 0)) then
                            obj:remove();
                        end
        
                        self:_destroy();
        
                        --local blood = minetest.env:add_entity({x=pos.x ,y=pos.y ,z=pos.z -0.5 }, "rifle:Blood_entity");
    
                    end
                end
            end
    
            if (self.timer >= (self.def.maxtimer or 3)) then
                self:_destroy();
                return;
            end
    
            if (self.lastpos.x ~= nil) then
                if (node.name ~= "air") then
                    self:_destroy();
                    return;
                end
            end
    
            self.lastpos = { x=pos.x, y=pos.y, z=pos.z };
    
        end
    
        minetest.register_entity(name.."_entity", ent);
    end

end

firearmslib.on_destroy_explode = function ( self )
    local explosion_range = self.def.explosion_range or 0;
    local explosion_damage = self.def.explosion_damage or 0;
    if (explosion_range <= 0) then
        minetest.debug("firearmslib: explosion has no range");
    end
    if (explosion_damage <= 0) then
        minetest.debug("firearmslib: explosion has no damage");
    end
    local p1 = self.object:getpos();
    local ents = minetest.env:get_objects_inside_radius(p1, explosion_range);
    local sound = (self.def.sounds and self.def.sounds.explode) or "firearms_he_gren_explode";
    minetest.sound_play(sound, {
        pos = self.object:getpos();
        gain = 2.0;
        max_hear_distance = 150;
    });
    firearmslib.explosion(self.object:getpos());
    for _,ent in ipairs(ents) do
        local p2 = ent:getpos();
        local lenx = math.abs(p2.x - p1.x);
        local leny = math.abs(p2.y - p1.y);
        local lenz = math.abs(p2.z - p1.z);
        local hypot = math.sqrt((lenx * lenx) + (lenz * lenz));
        local dist = math.sqrt((hypot * hypot) + (leny * leny));
        local damage = explosion_damage - (explosion_damage * dist / explosion_range);
        ent:set_hp(ent:get_hp() - damage);
    end
end

local timer = 0;

local HUD_CLIP_AMMO_SCALE = 8;
local HUD_AMMO_SCALE = 4;

local function remove_huds ( player, wf )
    if (wf.hud_crosshair) then
        player:hud_remove(wf.hud_crosshair);
        wf.hud_crosshair = nil;
    end
    if (wf.hud_clip_ammo) then
        player:hud_remove(wf.hud_clip_ammo);
        wf.hud_clip_ammo = nil;
    end
    if (wf.hud_ammo) then
        player:hud_remove(wf.hud_ammo);
        wf.hud_ammo = nil;
    end
end

minetest.register_globalstep(function ( dtime )
    timer = timer + dtime;
    if (timer < 0.5) then return; end
    timer = 0;
    for _,player in ipairs(minetest.get_connected_players()) do
        local name = player:get_player_name();
        local stack = player:get_wielded_item();
        local wpndef = firearmslib.firearms[stack:get_name()];
        if (not wielded_firearm[name]) then wielded_firearm[name] = { }; end
        local wf = wielded_firearm[name];
        if (wpndef) then
            if (wf.weapon ~= wpndef) then
                --minetest.chat_send_player(name, "New crosshair: "..wpndef.crosshair_image);
                wf.weapon = wpndef;
                if (wpndef.crosshair_image) then
                    local clip = tonumber(stack:get_metadata()) or 0;
                    local ammo = count_ammo(wpndef, player);
                    remove_huds(player, wf);
                    player:hud_set_flags({crosshair=false});
                    wf.hud_crosshair = player:hud_add({
                        name = "firearms:crosshair";
                        hud_elem_type = "image";
                        position = { x=0.5, y=0.5 };
                        text = wpndef.crosshair_image;
                        scale = { x=1, y=1 };
                        alignment = { x=0, y=0 };
                    });
                    wf.hud_clip_ammo = player:hud_add({
                        name = "firearms:clip";
                        hud_elem_type = "image";
                        position = { x=1, y=1 };
                        text = make_number_texture(clip);
                        scale = { x=HUD_CLIP_AMMO_SCALE, y=HUD_CLIP_AMMO_SCALE };
                        alignment = { x=-1, y=-1 };
                        offset = {
                            x = -8;
                            y = -8 - (HUD_AMMO_SCALE * 5) - 8;
                        };
                    });
                    wf.hud_ammo = player:hud_add({
                        name = "firearms:ammo";
                        hud_elem_type = "image";
                        position = { x=1, y=1 };
                        text = make_number_texture(ammo);
                        scale = { x=HUD_AMMO_SCALE, y=HUD_AMMO_SCALE };
                        alignment = { x=-1, y=-1 };
                        offset = {
                            x = -8;
                            y = -8;
                        };
                    });
                else
                    wpndef = nil;
                end
            end
        else
            wf.weapon = nil;
        end
        if (not wpndef) then
            player:hud_set_flags({crosshair=true});
            remove_huds(player, wf);
        end
    end
end);

firearmslib.count_ammo = count_ammo;
firearmslib.count_clip_ammo = count_clip_ammo;
