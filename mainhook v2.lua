-- zinnhook/safehook/mainhook, the only one. zinn#0001

-- get screen size -----------------------------------------------------------------------------------------
local w, h = client.screen_size()
------------------------------------------------------------------------------------------------------------
															
-- references ----------------------------------------------------------------------------------------------
local autowall = ui.reference("RAGE", "Aimbot", "Automatic Penetration")	
local aimbot_on = ui.reference("RAGE", "Aimbot", "Enabled")
local aimbot_fov = ui.reference("RAGE", "Aimbot", "Maximum FOV")
local force_baim = ui.reference("RAGE", "Other", "Force body aim")
local aa_correction = ui.reference("RAGE", "Other", "Anti-aim correction")
local fake_duck = ui.reference("RAGE", "Other", "Duck peek assist")
local antiaim_enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled")
local antiaim_pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local antiaim_yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local antiaim_yaw, antiaim_yaw_slider  = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local antiaim_body_yaw, antiaim_body_yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local antiaim_lower_body_yaw_target = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local antiaim_fake_yaw_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local players_reset_all = ui.reference("PLAYERS", "Players", "Reset all")
local force_trd_alive, force_trd_alive_key = ui.reference("VISUALS", "Effects", "Force third person (alive)")
local hide_from_obs = ui.reference("MISC", "Settings", "Hide from OBS")
local fov_ref = ui.reference("MISC", "Miscellaneous", "Override FOV")
local fov_zoom_ref = ui.reference("MISC", "Miscellaneous", "Override zoom FOV")

------------------------------------------------------------------------------------------------------------

-- semirage ------------------------------------------------------------------------------------------------

-- fakelag changes on fakeduck by mracek
local fakelag = { ui.reference("AA", "Fake lag", "Enabled") }
local trash, fakelag_hotkey =  ui.reference("AA", "Fake lag", "Enabled")
local fakelag_limit = ui.reference("AA", "Fake lag", "Limit")
local fakeduck = ui.reference("Rage", "Other", "Duck peek assist")
local fdfl = ui.new_slider("AA", "Fake lag", "Fake lag on FD", 1, 14, 14)
local fakelag_indicator = ui.new_checkbox("AA", "Fake lag", "Indicator")
local bool = true
local limit = 1
local it_was_on = false

client.set_event_callback("net_update_end", function()
    if not ui.get(fakelag[1] or fakelag[2]) then return end
    if bool then
        limit = ui.get(fakelag_limit)
    end
    if ui.get(fakeduck) then
        bool = false
        ui.set(fakelag_limit, ui.get(fdfl))
    else
        bool = true
        ui.set(fakelag_limit, limit)
    end
end)


-- resolver on/off
local onoff = ui.new_checkbox("RAGE", "Other", "Resolver on/off")
local onoff_key = ui.new_hotkey("RAGE", "Other", "Resolver on/off", true)

-- autowall
local autowalltoggle = ui.new_checkbox("RAGE", "Other", "Autowall key")
local autowalltoggle_key = ui.new_hotkey("RAGE", "Other", "Autowall key",true)
--[[
local autowallafterxsec = ui.new_checkbox("RAGE", "Other", "Autowall timer triggering")
local autowallsecs = ui.new_slider("RAGE", "Other", "Delay", 0, 10000, 1500, "", "ms")
local porcentage = 0;
]]

-- resolver override 
local enemies_only = true
local legit_aa_override = ui.new_checkbox("RAGE", "Other", "Legit AA Override")
local legit_aa_override_key = ui.new_hotkey("RAGE", "Other", "Legit AA Override", true)
local state = 1
local last_tick = 0
local resolver_last_tick = 0
local yaw_set = -60
local first = false
local resolver_left = false
local resolver_auto = true

--legit aa
local legit_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "Legit AA")
local legit_aa_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Legit AA", true)
local legit_aa_custom_color = ui.new_label("AA", "Anti-aimbot angles", "Dashes color")
local legitaa_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Dashes color", 255, 255, 255, 150)
local legit_aa_fps = ui.new_checkbox("AA", "Anti-aimbot angles", "Disable AA by low FPS")
local disabled_color = ui.new_color_picker("AA", "Anti-aimbot angles", "Disable AA by low FPS", 255, 0, 0, 150)
local legit_aa_fps_slider = ui.new_slider("AA", "Anti-aimbot angles", "Minimum FPS", 0, 400, 50, true, "fs")
local hide_head = ui.new_checkbox("AA", "Anti-aimbot angles", "Hide your head")
local hide_head_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Hide your head", true)
ui.set(antiaim_enabled, true)
ui.set(antiaim_pitch, "off")
ui.set(antiaim_yaw_base, "Local view")
ui.set(antiaim_yaw, "Off")
ui.set(antiaim_body_yaw, "Off")
ui.set(antiaim_body_yaw_slider, 0)
ui.set(antiaim_lower_body_yaw_target, "Off")
ui.set(antiaim_fake_yaw_limit, 0)
local legitaa_last_tick = 0
local left = false
local fps
local ft_prev = 0
local disabled_by_fps = false

--extra functions
local clear_console = ui.new_checkbox("Misc", "Miscellaneous", "Clear console")
local override_fov = ui.new_checkbox("VISUALS", "Effects", "Thirdperson FOV override")
local override_fov_slider = ui.new_slider("VISUALS", "Effects", "Thirdperson FOV", 1, 135, 90, true, "°")
local override_fp_fov_slider = ui.new_slider("VISUALS", "Effects", "Firstperson FOV", 1, 135, 90, true, "°")
local override_zoom_fov = ui.new_checkbox("VISUALS", "Player ESP", "No zoom on thirdperson")
--[[
local AA_occurs = ui.new_checkbox("AA", "Other", "Antiaim occurrences indicator")
local AA_identify = 0
local combo = 0
local last_aa_not_detect = 0
]]
------------------------------------------------------------------------------------------------------------


-- RELOAD VARS EVERYTIME MATCH ENDS
client.set_event_callback("cs_win_panel_match", function ()
	enemies_only = true
	state = 1
	last_tick = 0
	resolver_last_tick = 0
	yaw_set = -60
	first = false
	legitaa_last_tick = 0
	left = false
end)

--Scope fov override
client.set_event_callback("setup_command", function(cmd)
	if not ui.get(override_zoom_fov) then
		return
	else
		if ui.get(force_trd_alive_key) and ui.get(force_trd_alive) then
			ui.set(fov_zoom_ref, 0)
		else
			ui.set(fov_zoom_ref, 100)
		end
	end
end)

-- FOV override
client.set_event_callback("setup_command", function(cmd) 
	if not ui.get(override_fov) or not ui.get(force_trd_alive) then
		return
	else
		if ui.get(force_trd_alive_key) then
			ui.set(fov_ref, ui.get(override_fov_slider))
		else
			ui.set(fov_ref, ui.get(override_fp_fov_slider))
		end
	end
end)

--[[
--Antiaim detector
client.set_event_callback("setup_command", function(cmd)
	local body_yaw = entity.get_prop(entity.get_local_player(), "m_flLowerBodyYawTarget")
	local pitch, yaw, roll = client.camera_angles()
	local lbyDelta = body_yaw - yaw;
	print("My yaw = " .. tostring(yaw) .. "\nMy pitch = " .. tostring(pitch))
	if lbyDelta <= 40 or pitch == 0 or yaw == 0 then
		last_aa_not_detect = globals.curtime()	
		return
	else
		AA_identify = AA_identify + 1;
	end
end)

-- Combo indicator
client.set_event_callback("setup_command", function(cmd)
	if globals.curtime() - last_aa_not_detect > 5 then
		combo = 0
	else
		combo = combo + 1
	end
end)
 
-- Antiaim detections counter indicator
client.set_event_callback("paint", function()
	if not ui.get(AA_occurs) then
		return
	else
		renderer.indicator(10, 10, 240, 240, "Antiaim detections: " .. tostring(AA_identify))
	end
	if combo > 100 then
		renderer.indicator(10, 10, 240, 240, "DETECTED!")
	else
		renderer.indicator(10, 10, 240, 240, "NOT DETECTED!")
	end
end)
]]

-- Clear console function
local function clear_the_console()
	client.exec("clear")
	client.delay_call(0.1, function()
		ui.set(clear_console, false)
	end)
end
ui.set_callback(clear_console, clear_the_console)

-- get_fps dependencies
local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- returns fps
local function get_fps()
	ft_prev = ft_prev * 0.9 + globals.absoluteframetime() * 0.1
	return round(1 / ft_prev)
end


-- Legit AA painting
client.set_event_callback("paint", function()
	if not ui.get(legit_aa) then
			return
	else
		local r, g, b, a = ui.get(legitaa_color)
		if disabled_by_fps then
			r, g, b, a = ui.get(disabled_color)
		end
		if left and ui.get(hide_head_key) == false then
			if ui.get(force_trd_alive_key) then
				renderer.text(w/2-150, h/2-4, r, g, b, a, "c+", 0, "(")
			else
				renderer.text(w/2-40, h/2-4, r, g, b, a, "c+", 0, "-")
			end
		end
		if not left and ui.get(hide_head_key) == false then
			if ui.get(force_trd_alive_key) then
				renderer.text(w/2+150, h/2-4, r, g, b, a, "c+", 0, ")")
			else
				renderer.text(w/2+40, h/2-4, r, g, b, a, "c+", 0, "-")
			end
		end
	end
end)

-- Fakelag indicator painting
client.set_event_callback("paint", function()
	if not ui.get(fakelag_indicator) then
		return
	else
		if ui.get(fakelag_hotkey) then
			renderer.indicator(0, 255, 0, 240, "Fakelag")
		else
			renderer.indicator(255, 0, 0, 240, "Fakelag")
		end
	end
end)


-- Hide Head painting
client.set_event_callback("paint", function()
	if not ui.get(hide_head) then
			return
	else
		if ui.get(hide_head_key) then
			renderer.text(w/2, h/2+17, 254, 0, 0, 200, "c", 0, "Pitch: Down")
		end
	end
end)



-- Legit AA and Hide Head function
client.set_event_callback("setup_command", function(cmd) 
	if get_fps() < ui.get(legit_aa_fps_slider) and ui.get(legit_aa_fps) and not ui.get(hide_head_key) then
			disabled_by_fps = true
			ui.set(antiaim_enabled, false)
			ui.set(antiaim_pitch, "Off")
			ui.set(antiaim_body_yaw, "Off")
			ui.set(antiaim_body_yaw_slider, 0)
			ui.set(antiaim_fake_yaw_limit, 0)
			ui.set(antiaim_yaw_base, "Local View")
		return
	end
	if ui.get(hide_head) then
		if ui.get(hide_head_key) then
			ui.set(antiaim_enabled, true)
			ui.set(antiaim_yaw, "180")
			ui.set(antiaim_yaw_slider, 0)
			ui.set(antiaim_pitch, "Down")
			ui.set(antiaim_yaw_base, "At targets")
			ui.set(antiaim_body_yaw, "Opposite")
			return
		else
			ui.set(antiaim_yaw, "Off")
			ui.set(antiaim_pitch, "Off")
			ui.set(antiaim_yaw_base, "Local view")
		end
	end
	if ui.get(legit_aa) then
		if ui.get(legit_aa_key) and globals.tickcount() - legitaa_last_tick > 15 then
			if ui.get(antiaim_body_yaw_slider) == 180 then
				ui.set(antiaim_enabled, true)
				ui.set(antiaim_body_yaw, "Static")
				ui.set(antiaim_body_yaw_slider, -180)
				ui.set(antiaim_fake_yaw_limit, 60)
				left = true
				disabled_by_fps = false
				legitaa_last_tick = globals.tickcount()
			else
				ui.set(antiaim_enabled, true)
				ui.set(antiaim_body_yaw, "Static")
				ui.set(antiaim_body_yaw_slider, 180)
				ui.set(antiaim_fake_yaw_limit, 60)
				left = false
				disabled_by_fps = false
				legitaa_last_tick = globals.tickcount()
			end
		end
	end
	if ui.get(legit_aa) == false then
		ui.set(antiaim_enabled, false)
		ui.set(antiaim_pitch, "Off")
		ui.set(antiaim_body_yaw, "Off")
		ui.set(antiaim_body_yaw_slider, 0)
		ui.set(antiaim_fake_yaw_limit, 0)
	end
end)


-- Override left/right
local function override_yaw(value)
	local players = entity.get_players(enemies_only)
	for i=1, #players do
		plist.set(players[i], "Correction active", true)
		plist.set(players[i], "Force body yaw", true)
		plist.set(players[i], "Force body yaw value", value)
	end
	return value
end


-- Override off
local function disable_override()
	ui.set(players_reset_all, true)
	local players = entity.get_players(enemies_only)
	for i=1, #players do
		plist.set(players[i], "Correction active", false)
		plist.set(players[i], "Force body yaw", false)
		plist.set(players[i], "Force body yaw value", 0)
	end
	return 0;
end

--Player ESP Override FLAG
client.register_esp_flag(".", 100, 200, 255, function(ent)
	if not ui.get(aa_correction) then
		return
	elseif resolver_auto then
		return true, "AUTO"
	elseif resolver_left then
		return true, "LEFT"
	elseif not resolver_left then
		return true, "RIGHT"
	end
end)

-- Painting OVERRIDE
client.set_event_callback("paint", function()
	if not ui.get(legit_aa_override) then
			return
	else
		if yaw_set == 60 and first then
			if ui.get(aa_correction) then
				renderer.indicator(0, 255, 0, 240, "R: Left")
				resolver_left = true
				resolver_auto = false
			else
				renderer.indicator(255, 0, 0, 240, "R: Left")
				resolver_auto = false
			end
		end
		if yaw_set == -60 and first then
			if ui.get(aa_correction) then
				renderer.indicator(0, 255, 0, 240, "R: Right")
				resolver_left = false
				resolver_auto = false
			else
				renderer.indicator(255, 0, 0, 240, "R: Right")
				resolver_auto = false
			end
		end
		if yaw_set == 0 then
			if ui.get(aa_correction) then
				renderer.indicator(0, 255, 0, 240, "R: Automatic")
				resolver_auto = true
			else
				renderer.indicator(255, 0, 0, 240, "R: Automatic")
				resolver_auto = false
			end
		end
	end
end)

-- Resolver override left/right/disabled
client.set_event_callback("setup_command", function(cmd)
	if not ui.get(legit_aa_override) then
			return
	else
		if ui.get(legit_aa_override_key) then
			first = true
			if yaw_set == 0 and globals.tickcount() - last_tick > 15 then
				
				yaw_set = override_yaw(60)
				last_tick = globals.tickcount()
			end
			if yaw_set == 60 and globals.tickcount() - last_tick > 15 then
				yaw_set = override_yaw(-60)
				last_tick = globals.tickcount()
			end
			if yaw_set == -60 and globals.tickcount() - last_tick > 15 then
				yaw_set = disable_override()
				last_tick = globals.tickcount()
			end
		end
		-- this extra fucking lines makes it keep overriding
		if yaw_set ~= 0 then
			override_yaw(yaw_set)
		else
			disable_override()
		end
	end
end)



-- Autowall command
client.set_event_callback("setup_command", function(cmd)
    if ui.get(autowalltoggle) then
		ui.set(autowall, ui.get(autowalltoggle_key))
	end
	if ui.get(onoff_key) and globals.tickcount() - resolver_last_tick > 15 then
		if ui.get(aa_correction) then
			ui.set(aa_correction, false)
			resolver_last_tick = globals.tickcount()
		else 
			ui.set(aa_correction, true)
			resolver_last_tick = globals.tickcount()
		end
	end
end)

-- Autowall painting
client.set_event_callback("paint", function()
	if not ui.get(autowalltoggle) then
			return
	else 
		if ui.get(autowall)	then
			renderer.indicator(0, 255, 0, 240, "Autowall")
		end
	end
end)

-- Force baim painting
client.set_event_callback("paint", function()
	if ui.get(force_baim) then
		renderer.indicator(0, 255, 0, 240, "F-Baim")
	end
end)

local function menu_call()
	ui.set_visible(legit_aa_custom_color, ui.get(legit_aa))
	ui.set_visible(legitaa_color, ui.get(legit_aa))
	ui.set_visible(legit_aa_fps, ui.get(legit_aa))
	ui.set_visible(legit_aa_fps_slider, ui.get(legit_aa_fps))
	ui.set_visible(disabled_color, ui.get(legit_aa_fps))
	ui.set_visible(override_fov_slider, ui.get(override_fov))
	ui.set_visible(override_fp_fov_slider, ui.get(override_fov))
end
menu_call()
ui.set_callback(legit_aa, menu_call)
ui.set_callback(legit_aa_fps, menu_call)
ui.set_callback(override_fov, menu_call)

