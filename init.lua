--Add Chicken
moreanimals = {}

function moreanimals:register_egg(modname, mobname, mobdesc)
	minetest.register_craftitem(modname..":egg_"..mobname, {
		description = mobdesc.." egg",
		inventory_image = modname.."_egg_"..mobname..".png",
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return
			end
			-- Call on_rightclick if the pointed node defines it
			if placer and not placer:get_player_control().sneak then
				local n = minetest.get_node(pointed_thing.under)
				local nn = n.name
				if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].on_rightclick then
					return minetest.registered_nodes[nn].on_rightclick(pointed_thing.under, n, placer, itemstack) or itemstack
				end
			end
			-- Actually spawn the mob
			minetest.env:add_entity(pointed_thing.above, modname..":"..mobname)
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end,
	})
end





mobs:register_mob("moreanimals:chicken", {
	type = "animal",
	hp_max = 2,
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	visual = "upright_sprite",
	visual_size = {x=1, y=1},
	textures = {"chicken.png", "chicken.png"},
	makes_footstep_sound = true,
	view_range = 15,
	walk_velocity = 1,
    drops = {
        {name = "mobs:meat_raw",
		chance = 1,
		min = 2,
		max = 3,},
		{name = "moreanimals:egg_chicken",
		chance = 2,
		min = 1,
		max = 1,},
	},
	sounds = {
		random = "mobs_chicken",
	},
    run_velocity = 2,
	armor = 200,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
    on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "moreanimals:chicken")
			self.object:remove()
		end
	end,
})

minetest.register_craftitem("moreanimals:chicken", {
	description = "Chicken",
	inventory_image = "chicken.png",
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "moreanimals:chicken")
			itemstack:take_item()
		end
		return itemstack
	end,
})

minetest.register_craftitem("moreanimals:egg_chicken_fried", {
	description = "Fried chicken's egg",
	inventory_image = "moreanimals_egg_chicken_fried.png",
	on_use = minetest.item_eat(8),
})

minetest.register_craft({
	type = "cooking",
	output = "moreanimals:egg_chicken_fried",
	recipe = "moreanimals:egg_chicken",
	cooktime = 5,
})

mobs:register_spawn("moreanimals:chicken", {"default:dirt_with_grass"}, 20, 8, 9000, 1, 31000)
moreanimals:register_egg("moreanimals","chicken","Chicken")
