-- Draw a rounded, semi-transparent panel behind the conky text.
-- Needs the Cairo Lua binding from conky-all (X11 backend only).
require "cairo"
-- Some conky builds split the xlib surface helper into a separate module.
pcall(require, "cairo_xlib")

function conky_draw_bg()
    if conky_window == nil then return end
    local w, h = conky_window.width, conky_window.height
    if w < 1 or h < 1 then return end

    local cs = cairo_xlib_surface_create(conky_window.display,
        conky_window.drawable, conky_window.visual, w, h)
    local cr = cairo_create(cs)

    local r = 14                 -- corner radius
    local a = math.pi / 2

    cairo_new_sub_path(cr)
    cairo_arc(cr, w - r, r,     r, -a, 0)
    cairo_arc(cr, w - r, h - r, r, 0,  a)
    cairo_arc(cr, r,     h - r, r, a,  2 * a)
    cairo_arc(cr, r,     r,     r, 2 * a, 3 * a)
    cairo_close_path(cr)

    cairo_set_source_rgba(cr, 0, 0, 0, 0.55)   -- black panel, 55% opaque
    cairo_fill(cr)

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
