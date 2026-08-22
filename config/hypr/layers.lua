----------------
---- LAYERS ----
----------------

local noctaliaLayerRule = hl.layer_rule({
    name = "noctalia",
    match = { namespace = "noctalia-background-.*$" },
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})

noctaliaLayerRule:set_enabled(true)