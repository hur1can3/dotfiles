--[[
-- This code is mostly by londonali1010
-- Conky-Colors
]]

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function clock_hands(xc, yc, colour, alpha, show_secs, size)

--[[ Options (xc, yc, colour, alpha, show_secs, size):
	"xc" and "yc" are the x and y coordinates of the centre of the clock hands, in pixels, relative to the top left corner of the Conky window
	"colour" is the colour of the clock hands, in Ox33312c formate
	"alpha" is the alpha of the hands, between 0 and 1
	"show_secs" is a boolean; set to TRUE to show the seconds hand, otherwise set to FALSE
	"size" is the total size of the widget (e.g. twice the length of the minutes hand), in pixels ]]
	
	local secs,mins,hours,secs_arc,mins_arc,hours_arc
	local xh,yh,xm,ym,xs,ys

	secs=os.date("%S")
	mins=os.date("%M")
	hours=os.date("%I")

	secs_arc=(2*math.pi/60)*secs
	mins_arc=(2*math.pi/60)*mins+secs_arc/60
	hours_arc=(2*math.pi/12)*hours+mins_arc/12

	xh=xc+0.4*size*math.sin(hours_arc)
	yh=yc-0.4*size*math.cos(hours_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)

	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(colour,alpha))
	cairo_stroke(cr)

	xm=xc+0.5*size*math.sin(mins_arc)
	ym=yc-0.5*size*math.cos(mins_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)

	cairo_set_line_width(cr,3)
	cairo_stroke(cr)

	if show_secs then
		xs=xc+0.5*size*math.sin(secs_arc)
		ys=yc-0.5*size*math.cos(secs_arc)
		cairo_move_to(cr,xc,yc)
		cairo_line_to(cr,xs,ys)

		cairo_set_line_width(cr,1)
		cairo_stroke(cr)
	end

	cairo_set_line_cap(cr,CAIRO_LINE_CAP_BUTT)
end

--[[ END CLOCK HANDS WIDGET ]]

function ring(name, arg, max, bgc, bga, fgc, fga, xc, yc, r, t, sa, ea, cP)

--[[ Options
	"name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'.
	"arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an argument in the Conky variable, use ''.
	"max" is the maximum value of the ring. If the Conky variable outputs a percentage, use 100.
	"bg_colour" is the colour of the base ring.
	"bg_alpha" is the alpha value of the base ring.
	"fg_colour" is the colour of the indicator part of the ring.
	"fg_alpha" is the alpha value of the indicator part of the ring.
	"x" and "y" are the x and y coordinates of the centre of the ring, relative to the top left corner of the Conky window.
	"radius" is the radius of the ring.
	"thickness" is the thickness of the ring, centred around the radius.
	"start_angle" is the starting angle of the ring, in degrees, clockwise from top. Value can be either positive or negative.
	"end_angle" is the ending angle of the ring, in degrees, clockwise from top. Value can be either positive or negative, but must be larger (e.g. more clockwise) than start_angle. 
	"lr" is the ring direction, left = 0 or right = 1
	"cP" is the variable to check if is a conkyPlayer instead of conky command]]

	local function get_music_percent (player)
		local f = assert(io.popen("python ~/.conkycolors/scripts/conky" .. player .. ".py --datatype=PP")) -- runs command
		local s = assert(f:read('*a'))
		f:close()
		return s
	end

	local function draw_ring(pct)
		local angle_0 = sa * (2 * math.pi/360) - math.pi/2
		local angle_f = ea * (2 * math.pi/360) - math.pi/2
		local pct_arc = pct * (angle_f - angle_0)

		-- Draw background ring

		cairo_arc(cr, xc, yc, r, angle_0, angle_f)
		cairo_set_source_rgba(cr, rgb_to_r_g_b(bgc, bga))
		cairo_set_line_width(cr, t)
		cairo_stroke(cr)
	
		-- Draw indicator ring
		cairo_arc(cr, xc, yc, r, angle_0, angle_0 + pct_arc)
		cairo_set_source_rgba(cr, rgb_to_r_g_b(fgc, fga))
		cairo_stroke(cr)
	end
	
	local function setup_ring()
		local str = ''
		local value = 0
		
		if cP == 1 then
			str = get_music_percent(name)
		else
			str = string.format('${%s %s}', name, arg)
			str = conky_parse(str)
		end

		value = tonumber(str)
		if value == nil then value = 0 end
		pct = value/max
		
		draw_ring(pct)
	end	
	
	local updates = conky_parse('${updates}')
	update_num = tonumber(updates)
	
	if update_num > 5 then setup_ring() end
end


function conky_widgets(default_color, n_cpu, cputype, swap, clock_theme, player, player_theme)
	
	if conky_window == nil then return end

	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
 
	cr=cairo_create(cs)

	if default_color == "white" then 
		default_color = 0xffffff
	elseif default_color == "black" then
		default_color = 0x1e1c1a
	else
		default_color = ("0x" .. default_color)
	end

	ring_position = 50
	-- options: name, arg, max, bg_colour, bg_alpha, fg_colour, fg_alpha, xc, yc, radius, thickness, start_angle, end_angle, conkyPlayer

	-- CPU
	if cputype == "orcpu" then
		fg_alpha = 0.4
		bg_alpha = 0.2
		for i=1,n_cpu do
			cpu_number = ("cpu" .. i)
			ring('cpu', cpu_number, 100, default_color, bg_alpha, default_color, fg_alpha, 190, ring_position, 20, 10, 180, 360, 0) 
			bg_alpha = 0
			fg_alpha = fg_alpha + 0.15
		end	
		ring_position = ring_position + 64
	else
		for i=1,n_cpu do
			cpu_number = ("cpu" .. i)
			ring('cpu', cpu_number, 100, default_color, 0.2, default_color, 0.8, 190, ring_position, 20, 10, 180, 360, 0) 
			ring_position = ring_position + 64
		end
	end

	-- MEMORY
	ring('memperc', '', 100, default_color, 0.2, default_color, 0.8, 190, ring_position, 20, 10, 180, 360, 0)
	ring_position = ring_position + 64

	-- SWAP
	if swap == "on" then
		ring('swapperc', '', 100, default_color, 0.2, default_color, 0.8, 190, ring_position, 20, 10, 180, 360, 0)
		ring_position = ring_position + 64
	end

	-- CLOCK
	if clock_theme == "cairo" then
		clock_hands(154, ring_position, default_color, 0.8, true, 30)
		ring('time', '%S', 60, default_color, 0.2, default_color, 0.8, 154, ring_position, 20, 5, 0, 360, 0)
		ring_position = ring_position + 64
	elseif clock_theme == "bigcairo" then
		ring_position = ring_position + 20
		clock_hands(124, ring_position, default_color, 0.8, false, 60)
		ring('time', '%d', 31, default_color, 0.2, default_color, 0.8, 124, ring_position, 51, 5, 215, 325, 0)
		ring('time', '%S', 60, default_color, 0.2, default_color, 0.8, 124, ring_position, 40, 10, 0, 360, 0)
		ring('time', '%m', 12, default_color, 0.2, default_color, 0.8, 124, ring_position, 51, 5, 35, 145, 0)
		ring_position = ring_position + 64 + 20
	end

	-- DISKS
	disks = {'/', '/home'}
	for i, partitions in ipairs(disks) do
		ring('fs_used_perc', partitions, 100, default_color, 0.2, default_color, 0.8, 190, ring_position, 20, 10, 180, 360, 0)
		ring_position = ring_position + 64
	end

	-- PLAYERS
	if player == "Banshee" then
		if player_theme == "cairo" then
			ring(player, '', 100, default_color, 0.2, default_color, 0.8, 154, ring_position, 10, 20, 0, 360, 1)
			ring(player, '', 100, default_color, 0.4, default_color, 0.2, 154, ring_position, 20, 1, 0, 360, 1)
		else
			ring(player, '', 100, default_color, 0.2, default_color, 0.8, 190, ring_position, 20, 10, 180, 360, 1)
		end
	elseif player == "Rhythmbox" then
		if player_theme == "cairo" then
			ring(player, '', 100, default_color, 0.2, default_color, 0.8, 154, ring_position, 10, 20, 0, 360, 1)
			ring(player, '', 100, default_color, 0.4, default_color, 0.2, 154, ring_position, 20, 1, 0, 360, 1)
		else
			ring(player, '', 100, default_color, 0.2, default_color, 0.8, 190, ring_position, 20, 10, 180, 360, 1)
		end
	elseif player == "Exaile" then
		if player_theme == "cairo" then
			ring(player, '', 100, default_color, 0.2, default_color, 0.8, 154, ring_position, 10, 20, 0, 360, 1)
			ring(player, '', 100, default_color, 0.4, default_color, 0.2, 154, ring_position, 20, 1, 0, 360, 1)
		else
			ring(player, '', 100, default_color, 0.2, default_color, 0.8, 190, ring_position, 20, 10, 180, 360, 1)
		end
	end
	cairo_destroy(cr)
end
