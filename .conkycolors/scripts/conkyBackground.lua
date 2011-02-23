--[[
-- This code is mostly by londonali1010
-- Conky-Colors by helmuthdu
]]

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_background(bg_colour, bg_alpha)

	-- "corner_r" is the radius, in pixels, of the rounded corners. If you don't want rounded corners, use 0.

	corner_r = 0

	-- Tweaks the height of your background, in pixels. If you don't need to adjust the height, use 0.

	vindsl_hack = 0

	local w = conky_window.width
	local h = conky_window.height
	local v=vindsl_hack

	local function draw_shape()

		cairo_move_to(cr,corner_r,0)
		cairo_line_to(cr,w-corner_r,0)
		cairo_curve_to(cr,w,0,w,0,w,corner_r)
		cairo_line_to(cr,w,h+v-corner_r)
		cairo_curve_to(cr,w,h+v,w,h+v,w-corner_r,h+v)
		cairo_line_to(cr,corner_r,h+v)
		cairo_curve_to(cr,0,h+v,0,h+v,0,h+v-corner_r)
		cairo_line_to(cr,0,corner_r)
		cairo_curve_to(cr,0,0,0,0,corner_r,0)
		cairo_close_path(cr)

		cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,bg_alpha))
		cairo_fill(cr)
	
	end
	
	draw_shape()

end

function draw_vertical_bar(name, arg, max, width, height, x, y, borderRed, borderGreen, borderBlue, fillRed, fillGreen, fillBlue)
    
	local function draw_bar(pct)
		cairo_set_source_rgb (cr, borderRed, borderGreen, borderBlue)
		cairo_set_line_width (cr, 0)
		cairo_rectangle (cr, x, y, width, height)
		cairo_stroke (cr)
		cairo_set_source_rgb (cr, fillRed, fillGreen, fillBlue)
		cairo_set_line_width (cr, width - 2)
		cairo_move_to (cr, (width / 2) + x, height + y - 1)
		cairo_line_to (cr, (width / 2) + x, height - (height * pct) + y - 1)
		cairo_stroke (cr)
	end
	
	local function setup_ring()
		local str = ''
		local value = 0
		
		str = string.format('${%s %s}', name, arg)
		str = conky_parse(str)

		value = tonumber(str)
		if value == nil then value = 0 end
		pct = value/max
		
		draw_bar(pct)
	end	
	
	local updates = conky_parse('${updates}')
	update_num = tonumber(updates)
	
	if update_num > 5 then setup_ring() end

end

function weather(bg_colour, area_code)


	local function get_day_info(data, day, area_code)
		local f = assert(io.popen("conky-colors --systemdir"))
		local s = assert(f:read('*l'))
		f:close()
		f = assert(io.popen("sh " .. s .. "/bin/conkyForecast --location=" .. area_code .. " --datatype=" .. data .. " --startday=" .. day)) -- runs command
		s = assert(f:read('*l'))
		f:close()
		return s
	end

	local w = conky_window.width
	local h = conky_window.height
	
	-- font size
	size = w*0.044
	alpha = 0.6

	
	local function setup_text()
		
		cairo_select_font_face(cr, "Droid Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)

		day1 = get_day_info("DW", 0, area_code)
		day2 = get_day_info("DW", 1, area_code)
		day3 = get_day_info("DW", 2, area_code)

		cairo_set_font_size(cr, size)
		cairo_move_to(cr, w/2.6, h/1.8)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,.8))
		cairo_show_text(cr, day1)
		cairo_set_font_size(cr, size*1.2)
		cairo_move_to(cr, w/2.6-100, h/1.8+20)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,.2))
		cairo_show_text(cr, day2)
		cairo_set_font_size(cr, size*1.1)
		cairo_move_to(cr, w/2.6+80, h/1.8-20)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,.3))
		cairo_show_text(cr, day3)

		day1 = ("[" .. get_day_info("CT", 0, area_code) .. "]")
		day2 = ("[" .. get_day_info("CT", 1, area_code) .. "]")
		day3 = ("[" .. get_day_info("CT", 2, area_code) .. "]")

		cairo_set_font_size(cr, size*.3)
		cairo_move_to(cr, w/2, h/1.68)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,.8))
		cairo_show_text(cr, day1)
		cairo_set_font_size(cr, size*1.2*.3)
		cairo_move_to(cr, w/2-100, h/1.68+20)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,.2))
		cairo_show_text(cr, day2)
		cairo_set_font_size(cr, size*1.1*.3)
		cairo_move_to(cr, w/2+80, h/1.68-20)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,.3))
		cairo_show_text(cr, day3)
	

		cairo_select_font_face(cr, "Arial", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)

		day1 = get_day_info("HT", 1, area_code)

		cairo_set_font_size(cr, size*.8)
		cairo_move_to(cr, w/2.08, h/2.28)
		cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,.6))
		cairo_show_text(cr, day1)
	end
	
	local updates = conky_parse('${updates}')
	update_num = tonumber(updates)
	
	if update_num > 5 then setup_text() end

end

function conky_widgets(color, theme, drawbg, draw_weather, area_code)
	
	if conky_window == nil then return end

	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
 
	cr=cairo_create(cs)

	if color == "white" then 
		bgc = 0xffffff -- the colour of the base ring.
		fgc = 0xffffff -- the colour of the indicator part of the ring.
		bga = 0.4 --the alpha value of the base ring. 
		fga = 0.8 -- the alpha value of the indicator part of the ring.
	else 
		bgc = 0x1e1c1a -- the colour of the base ring.
		fgc = 0x1e1c1a -- the colour of the indicator part of the ring.
		bga = 0.6 -- the alpha value of the base ring. 
		fga = 0.8 -- the alpha value of the indicator part of the ring.
	end

	theme = ("0x" .. theme)

	if drawbg == "on" then
		draw_background(bgc, bga)
	end
	
	if draw_weather == "on" then
		weather(theme, area_code)
	end

	cairo_destroy(cr)
end
