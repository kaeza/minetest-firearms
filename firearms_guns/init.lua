--[[
This file is part of the Firearms mod for Minetest.

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

minetest.register_alias("m240bp","firearms_guns:m240bp")
minetest.register_alias("m240b","firearms_guns:m240b")
minetest.register_alias("ar72","firearms_guns:adminrifle")
minetest.register_alias("50calp","firearms_guns:50calp")
minetest.register_alias("50cal","firearms_guns:50cal")
minetest.register_alias("ar10","firearms_guns:ar10g")
minetest.register_alias("ar10p","firearms_guns:ar10")
minetest.register_alias("m3","firearms_guns:m3")
minetest.register_alias("m3p","firearms_guns:m3p")
minetest.register_alias("1911","firearms_guns:pistol_45")
minetest.register_alias("1911p","firearms_guns:pistol_45p")
minetest.register_alias("adminround","firearms_guns:round_admin")
minetest.register_alias("50round","firearms_guns:round_50")
minetest.register_alias("762round","firearms_guns:round_762")
minetest.register_alias("45round","firearms_guns:bullet_45")
minetest.register_alias("12gashell","firearms_guns:shell_12")

firearmslib.register_firearm("firearms_guns:adminrifle", {
    description = "Admin Rifle, AR72";
    inventory_image = "firearmsar72.png";
    bullets = "firearms_guns:round_admin";
    clip_size = 9999;
    spread = 0.050;
	radius = 35;
	range = 1000;
    burst = 1;
    burst_interval = 0.15;
    wield_scale = {x=1.2,y=1.6,z=1.6};
    crosshair_image = "firearms_crosshair_rifle_admin.png";
    hud_image = "firearms_m4_hud.png";
    sounds = {
        shoot = "firearms_m4_shot";
        empty = "firearms_default_empty";
        reload = "firearms_rifle_reload";
    };
});

firearmslib.register_bullet("firearms_guns:round_admin", {
    description = "Admin Rounds";
    inventory_image = "adminround.png";
    wield_scale = {x=0.01,y=0.01,z=0.01};
	spent_image = "adminround_spent.png";
	stack_max = 9999;
    damage = 1000;
    power = 80;
    gravity = 0;
	pellets = 10;
});

firearmslib.register_firearm("firearms_guns:m240b", {
    description = "M240B";
    inventory_image = "firearms_m240b.png";
    bullets = "firearms_guns:round_762";
    clip_size = 100;
    spread = 0.005;
	radius = 10;
	range = 200;
    burst_interval = 0.14;
    wield_scale = {x=1.2,y=1.6,z=1.6};
    crosshair_image = "firearms_crosshair_m240b.png";
    hud_image = "firearms_m4_hud.png";
    sounds = {
        shoot = "firearms_m4_shot";
        empty = "firearms_default_empty";
        reload = "firearms_rifle_reload";
    };
});

firearmslib.register_firearm("firearms_guns:m240bp", {
    description = "Pink M240B";
    inventory_image = "firearms_m240bp.png";
    bullets = "firearms_guns:round_762";
    clip_size = 100;
    spread = 0.005;
	radius = 10;
	range = 200;
    burst_interval = 0.14;
    wield_scale = {x=1.2,y=1.6,z=1.6};
    crosshair_image = "firearms_crosshair_m240b.png";
    hud_image = "firearms_m4_hud.png";
    sounds = {
        shoot = "firearms_m4_shot";
        empty = "firearms_default_empty";
        reload = "firearms_rifle_reload";
    };
});

firearmslib.register_bullet("firearms_guns:round_50", {
    description = ".50 cal Rounds";
    inventory_image = "50round.png";
    wield_scale = {x=0.018,y=0.018,z=0.018};
	spent_image = "50round_spent.png";
    damage = 100;
    power = 8;
    gravity = 0;
});

firearmslib.register_firearm("firearms_guns:50cal", {
    description = "SuperComp Ferret50";
    inventory_image = "50g.png";
    bullets = "firearms_guns:round_50";
    clip_size = 10;
    spread = 0.001;
	radius = 13;
	range = 700;
    burst = 1;
    burst_interval = 0.40;
    wield_scale = {x=1.65,y=1.65,z=1.65};
    crosshair_image = "firearms_crosshair_rifle50.png";
    hud_image = "firearms_m4_hud.png";
    sounds = {
        shoot = "firearms_m3_shot";
        empty = "firearms_default_empty";
        reload = "firearms_rifle_reload";
    };
});

firearmslib.register_firearm("firearms_guns:50calp", {
    description = "Pink SuperComp Ferret50";
    inventory_image = "50.png";
    bullets = "firearms_guns:round_50";
    clip_size = 10;
    spread = 0.001;
	radius = 13;
	range = 700;
    burst = 1;
    burst_interval = 0.40;
    wield_scale = {x=1.65,y=1.65,z=1.65};
    crosshair_image = "firearms_crosshair_rifle50.png";
    hud_image = "firearms_m4_hud.png";
    sounds = {
        shoot = "firearms_m3_shot";
        empty = "firearms_default_empty";
        reload = "firearms_rifle_reload";
    };
});


firearmslib.register_bullet("firearms_guns:bullet_45", {
    description = ".45 APC Rounds";
    inventory_image = "firearms_bullet_45.png";
    wield_scale = {x=0.01,y=0.01,z=0.01};
	spent_image = "firearms_bullet_45_spent.png";
    damage = 4;
    power = 5;
});

firearmslib.register_firearm("firearms_guns:pistol_45", {
    description = ".45 1911";
    inventory_image = "firearms_pistol_45.png";
    wield_scale = {x=0.7,y=0.7,z=0.7};
    bullets = "firearms_guns:bullet_45";
    clip_size = 10;
    burst = 1;
    spread = 0.020;
	radius = 10;
	range = 70;
    crosshair_image = "firearms_crosshair_pistol.png";
    hud_image = "firearms_pistol_45_hud.png";
    sounds = {
        shoot = "firearms_pistol_45_shot";
		empty = "firearms_default_empty";
		reload = "firearms_default_reload";
    };
});

firearmslib.register_firearm("firearms_guns:pistol_45p", {
    description = "Pink .45 1911";
    inventory_image = "firearms_pistol_45p.png";
    wield_scale = {x=0.7,y=0.7,z=0.7};
    bullets = "firearms_guns:bullet_45";
    clip_size = 10;
    burst = 1;
    spread = 0.020;
	radius = 10;
	range = 70;
    crosshair_image = "firearms_crosshair_pistol.png";
    hud_image = "firearms_pistol_45_hud.png";
    sounds = {
        shoot = "firearms_pistol_45_shot";
		empty = "firearms_default_empty";
		reload = "firearms_default_reload";
    };
});


firearmslib.register_bullet("firearms_guns:round_762", {
    description = "7.62 Rifle Rounds";
    inventory_image = "firearms_bullet_556.png";
    wield_scale = {x=0.01,y=0.01,z=0.01};
    spent_image = "firearms_bullet_556_spent.png";
    clip_size = 100;
    damage = 10;
    power = 5;
    gravity = 0;
});

firearmslib.register_firearm("firearms_guns:ar10g", {
    description = "AR10";
    inventory_image = "firearms_m4g.png";
    bullets = "firearms_guns:round_762";
    clip_size = 30;
    spread = 0.001;
	radius = 10;
	range = 300;
    burst = 1;
    burst_interval = 0.15;
    wield_scale = {x=1.65,y=1.65,z=1.65};
    crosshair_image = "firearms_crosshair_rifle.png";
    hud_image = "firearms_m4_hud.png";
    sounds = {
        shoot = "firearms_m4_shot";
        empty = "firearms_default_empty";
        reload = "firearms_rifle_reload";
    };
});

firearmslib.register_firearm("firearms_guns:ar10", {
    description = "Pink AR10";
    inventory_image = "firearms_m4.png";
    bullets = "firearms_guns:round_762";
    clip_size = 30;
    spread = 0.001;
	radius = 10;
	range = 300;
    burst = 1;
    burst_interval = 0.15;
    wield_scale = {x=1.65,y=1.65,z=1.65};
    crosshair_image = "firearms_crosshair_rifle.png";
    hud_image = "firearms_m4_hud.png";
    sounds = {
        shoot = "firearms_m4_shot";
        empty = "firearms_default_empty";
        reload = "firearms_rifle_reload";
    };
});

firearmslib.register_bullet("firearms_guns:shell_12", {
    description = "12 Gauge Shell";
    inventory_image = "firearms_shell_12.png";
    spent_image = "firearms_shell_12_spent.png";
    wield_scale = {x=0.01,y=0.01,z=0.01};
    damage = 15;
    power = 1;
    gravity = 0;
    pellets = 6;
    maxtimer = 0.3;
});

firearmslib.register_firearm("firearms_guns:m3", {
    description = "Benelli M3 Shotgun";
    inventory_image = "firearms_m3.png";
    bullets = "firearms_guns:shell_12";
    clip_size = 8;
    burst = 1;
    spread = 0.500;
	radius = 40;
	range = 15;
    wield_scale = {x=1.65,y=1.65,z=1.65};
    crosshair_image = "firearms_crosshair_shotgun.png";
    hud_image = "firearms_m3_hud.png";
    sounds = {
        shoot = "firearms_m3_shot";
        empty = "firearms_default_empty";
        reload = "firearms_shotgun_reload";
    };
});

firearmslib.register_firearm("firearms_guns:m3p", {
    description = "Pink Benelli M3 Shotgun";
    inventory_image = "firearms_m3p.png";
    bullets = "firearms_guns:shell_12";
    clip_size = 8;
    burst = 1;
    spread = 0.500;
	radius = 40;
	range = 15;
    wield_scale = {x=1.65,y=1.65,z=1.65};
    crosshair_image = "firearms_crosshair_shotgun.png";
    hud_image = "firearms_m3_hud.png";
    sounds = {
        shoot = "firearms_m3_shot";
        empty = "firearms_default_empty";
        reload = "firearms_shotgun_reload";
    };
});

minetest.register_craft({
    output = 'firearms_guns:bullet_45 100';
    recipe = {
        { 'default:cobble', 'default:leaves','default:wood' },
    };
});

minetest.register_craft({
    output = 'firearms_guns:round_762 150';
    recipe = {
         { 'default:cobble', 'default:leaves','default:wood' },
		 { 'default:cobble', 'default:leaves','default:wood' },
    };
});

minetest.register_craft({
    output = 'firearms_guns:round_50 100';
    recipe = {
         { 'default:cobble', 'default:leaves','default:wood' },
		 { 'default:cobble', 'default:leaves','default:wood' },
		 { 'default:cobble', 'default:leaves','default:wood' },
    };
});

minetest.register_craft({
    output = 'firearms_guns:shell_12 240';
    recipe = {
         { 'default:cobble', 'default:leaves', '' },
		 { 'default:cobble', 'default:leaves','default:cobble' },
		 { 'default:cobble', 'default:leaves', '' },
    };
});
