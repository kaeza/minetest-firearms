--
--pistol
--

--gun

minetest.register_craft({
  output = 'firearms:pistol_45',
	recipe = {
          {'', 'default:steel_ingot', 'default:wood'},
          {'', '', 'default:stick'},
  },
})

--ammo

minetest.register_craft({
  output = 'firearms:bullet_45 10',
  recipe = {
    {'', 'default:stell_ingot', 'default:steel_ingot'},
  }
})
