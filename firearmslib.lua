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

local function shoot ( itemstack, player, pointed_thing )

    local gunname = itemstack:get_name();
    local inv = player:get_inventory("main");
    local gundef = firearmslib.firearms[gunname];
    local bulletname = gundef.bullets;
    local bulletdef = firearmslib.bullets[bulletname];
    local burst = gundef.burst or 1;
    local usestack = ItemStack(bulletname.." "..burst);

    local function do_shoot ( param )
        local playerpos = player:getpos();
        if (not playerpos) then return; end
        local dir = player:get_look_dir();
        local pellets = bulletdef.pellets or 1;
        for n = 1, pellets do
            local bullet = minetest.env:add_entity(
                {x=playerpos.x, y=playerpos.y + 1.5, z=playerpos.z },
                bulletname.."_entity"
            );

            local spreadx = (-gundef.spread) + (math.random() * gundef.spread * 2);
            local spready = (-gundef.spread) + (math.random() * gundef.spread * 2);
            local spreadz = (-gundef.spread) + (math.random() * gundef.spread * 2);

            bullet:setvelocity({
                x=((dir.x + spreadx) * bulletdef.speed),
                y=((dir.y + spready) * bulletdef.speed),
                z=((dir.z + spreadz) * bulletdef.speed),
            });
            bullet:setacceleration({ x=0, y=-(bulletdef.gravity or 1), z=0 });
        
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

    local creative = minetest.setting_getbool("creative_mode");
    local has_ammo = inv:contains_item("main", usestack);
    if ((not creative) and has_ammo) then
        inv:remove_item("main", usestack);
        do_shoot(burst - 1);
    elseif (creative) then
        do_shoot(burst - 1);
    end
end

firearmslib.register_firearm = function ( name, def )
    
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
