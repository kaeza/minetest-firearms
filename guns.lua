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

firearmslib.register_bullet("firearms:bullet_45", {
    description = ".45 Rounds";
    inventory_image = "firearms_bullet_45.png";
    damage = 4;
    power = 5;
    speed = 40;
});

firearmslib.register_firearm("firearms:pistol_45", {
    description = ".45 Pistol";
    inventory_image = "firearms_pistol_45.png";
    bullets = "firearms:bullet_45";
    clip_size = 10;
    spread = 0.020;
    sounds = {
        shoot = "firearms_pistol_45_shot";
    };
});

firearmslib.register_bullet("firearms:he_40mm", {
    description = "40mm HE Rounds";
    inventory_image = "firearms_he_40mm.png";
    damage = 5;
    power = 5;
    speed = 20;
    gravity = 20;
    explosion_range = 5;
    explosion_damage = 10;
    on_destroy = firearmslib.on_destroy_explode;
});

firearmslib.register_firearm("firearms:m79", {
    description = "M79 Grenade Launcher";
    inventory_image = "firearms_m79.png";
    bullets = "firearms:he_40mm";
    clip_size = 10;
    spread = 0.020;
	wield_scale = {x=2,y=2,z=2};
    sounds = {
        shoot = "firearms_m79_shot";
    };
});

firearmslib.register_bullet("firearms:rocket", {
    description = "40mm HE Rounds";
    inventory_image = "firearms_rocket.png";
    texture = "firearms_rocket_entity.png";
    damage = 10;
    power = 5;
    speed = 25;
    gravity = 0;
    explosion_range = 7.5;
    explosion_damage = 6;
    leaves_smoke = true;
    on_destroy = firearmslib.on_destroy_explode;
});

firearmslib.register_firearm("firearms:bazooka", {
    description = "Bazooka";
    inventory_image = "firearms_bazooka.png";
    bullets = "firearms:rocket";
    clip_size = 5;
    spread = 0.035;
	wield_scale = {x=3,y=3,z=3};
    sounds = {
        shoot = "firearms_m79_shot"; -- TODO: Find a better sound
    };
});

firearmslib.register_bullet("firearms:bullet_556", {
    description = "5.56 Rifle Rounds";
    inventory_image = "firearms_bullet_556.png";
    damage = 6;
    power = 5;
    speed = 40;
    gravity = 0;
});

firearmslib.register_firearm("firearms:m4", {
    description = "M4 Carbine";
    inventory_image = "firearms_m4.png";
    bullets = "firearms:bullet_556";
    clip_size = 10;
    spread = 0.035;
    burst = 3;
    burst_interval = 0.15;
	wield_scale = {x=2,y=2,z=2};
    sounds = {
        shoot = "firearms_m4_shot";
    };
});

firearmslib.register_bullet("firearms:shell_12", {
    description = "12 Gauge Shell";
    inventory_image = "firearms_shell_12.png";
    damage = 2;
    power = 5;
    speed = 40;
    gravity = 0;
    pellets = 12;
    maxtimer = 0.3;
});

firearmslib.register_firearm("firearms:m3", {
    description = "Benelli M3 Shotgun";
    inventory_image = "firearms_m3.png";
    bullets = "firearms:shell_12";
    clip_size = 8;
    spread = 0.100;
	wield_scale = {x=2,y=2,z=2};
    sounds = {
        shoot = "firearms_m3_shot";
    };
});
