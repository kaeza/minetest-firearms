
--
--bullets
--

minetest.register_craft({
    output = 'firearms:he_40mm';
    recipe = {
        { '', 'default:steel_ingot', '' },
        { 'default:steel_ingot', 'bucket:bucket_lava', 'default:steel_ingot' },
        { '', 'default:steel_ingot', '' },
    };
    replacements = { { "bucket:bucket_lava", "bucket:bucket_empty" } };
});

minetest.register_craft({
    output = 'firearms:rocket';
    recipe = {
        { 'default:steel_ingot', 'bucket:bucket_lava', 'default:steel_ingot' },
    };
    replacements = { { "bucket:bucket_lava", "bucket:bucket_empty" } };
});

minetest.register_craft({
    output = 'firearms:bullet_45 10';
    recipe = {
        { 'default:steel_ingot', 'default:steel_ingot' },
    };
});

minetest.register_craft({
    output = 'firearms:bullet_556 10';
    recipe = {
        {'default:steel_ingot', 'default:steel_ingot', 'default:leaves'},
    };
});

minetest.register_craft({
    output = 'firearms:shell_12 8';
    recipe = {
        { 'default:steel_ingot', '', '' },
        { 'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot' },
        { 'default:steel_ingot', '', '' },
    };
});

--
--guns
--

minetest.register_craft({
    output = 'firearms:pistol_45';
    recipe = {
        { 'firearms:bullet_45', 'default:steel_ingot', 'default:steel_ingot' },
        { '', 'default:stick', 'deafutl:wood' },
        { '', '', 'deafault:stick' },
    };
});

minetest.register_craft({
    output = 'firearms:m79';
    recipe = {
        { 'firearms:he_40mm', 'default:steel_ingot', 'default:steel_ingot' },
        { '', 'default:stick', 'default:wood' },
        { '', '', 'default:stick' },
    };
});

minetest.register_craft({
    output = 'firearms:bazooka';
    recipe = {
        { 'firearms:rocket', 'default:steel_ingot', 'default:steel_ingot' },
        { '', 'default:stick', 'default:wood' },
        { '', '', 'default:stick' },
    };
});

minetest.register_craft({
    output = 'firearms:m4';
    recipe = {
        { 'firearms:bullet_556', 'default:steel_ingot', 'default:steel_ingot' },
        { '', 'default:stick', 'default:wood' },
        { '', '', 'default:stick' },
    };
});

minetest.register_craft({
    output = 'firearms:m3';
    recipe = {
        { 'firearms:shell_12', 'default:steel_ingot', 'default:steel_ingot' },
        { '', 'default:stick', 'default:wood' },
        { '', '', 'default:stick' },
    };
});
