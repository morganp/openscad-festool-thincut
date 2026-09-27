//////////////////////////////////////////////////////////////////////////////
// festool_thincut.scad
//   Thin-cut (repeat strip) stop for a Festool FS / FS-2 guide rail.
//
// Library mode: vanilla OpenSCAD, no BOSL2.
//   The part is one 2D section extruded along the rail plus a chamfered
//   key. Nothing here needs BOSL2, so the file has no dependency.
//
// Section, looking along the rail (X across the rail, Y up):
//
//      cutting edge                               top T-slot   back edge
//      x = 0                                          v            |
//      |   ________________________________________ __  __ ___    |
//      |  |              rail (ghost)              |  ||  |   |   |_
//      |__|________________________________________|__[key]___|  | | <- wall
//  ======================== workpiece =========|STOP______________| |
//  ============================================|  under leg        |
//                                              ^
//                                     x = cut_offset (160)
//
//   The jig hooks a key into the T-slot on the TOP face at the rail back
//   edge, wraps down the outside of the back edge, and returns UNDER the
//   rail as a thin leg in the workpiece plane. The inner end face of that
//   leg is the stop. Butt the workpiece edge against it and the strip
//   under the rail is exactly cut_offset wide.
//
// Datum
//   x = 0 is the cutting edge (trimmed splinter guard = blade face).
//   y = 0 is the rail underside = workpiece top face.
//   The key in the slot is the lateral locator (tight fit). The wall only
//   wraps the back edge with edge_clr, it does not locate. So the one
//   measurement that sets the strip width is cutting edge to T-slot.
//   Measure it and put it in slot_c_from_cut_measured.
//
// Print orientation
//   Modelled as printed: section face flat on the bed, rail direction = Z.
//   Every layer holds the whole C, so the wrap and key neck carry load
//   along the extrusion lines. Prism, no supports. Key end chamfers are
//   45 degrees.
//
// Units: mm throughout.
// Version: 0.2.1
//////////////////////////////////////////////////////////////////////////////

/* [Part] */
part           = "jig";    // [jig, key_test]
show_rail      = true;     // ghost of the rail section
show_workpiece = true;     // ghost of the workpiece and strip
center_on_bed  = false;    // true: part centred on the origin, rail coords lost

/* [Cut] */
// v0.1.0 printed with 160 cut 165 on the real rail, so rail_w was 5 short.
// rail_w and cut_offset both +5 keep the printed geometry identical.
cut_offset   = 165;   // mm, cutting edge to stop face = strip width
offset_trim  = 0;     // mm, + makes the strip wider. Tune after a test cut
jig_len      = 20;    // mm, length along the rail (print height)
workpiece_t  = 18;    // mm, ghost only, and checked against the leg

/* [Rail: MEASURE ON REAL RAIL] */
// Cutting edge (trimmed splinter guard) to aluminium back edge.
// FOG forum: 183 aluminium + 2-3 splinter lip. v0.1.0 test cut (160 set,
// 165 cut) calibrates it to 190.
rail_w            = 190;   // mm
// Height from rail underside (incl. grip strips) to top face at the back
// edge, where the jig bridge sits. Estimate.
rail_back_h       = 10.5;  // mm
// Width of the thick back section of the extrusion (ghost only). Estimate.
rail_back_w       = 25;    // mm
// Plate thickness away from the back section (ghost only). Estimate.
rail_plate_t      = 5;     // mm
// T-slot on the TOP face near the back edge ("ceiling facing" track).
slot_c_from_back  = 12;    // mm, back edge to slot centreline. Estimate
// Set to a measured cutting edge to slot centreline distance to override
// rail_w - slot_c_from_back. 0 = derive.
slot_c_from_cut_measured = 0;  // mm
slot_open_w       = 8.0;   // mm, opening between the lips. v0.1.0 neck 1mm narrow
slot_lip_t        = 2.0;   // mm, lip thickness. Estimate
slot_under_w      = 11.0;  // mm, undercut width. Estimate
slot_under_h      = 6.0;   // mm, undercut height, FOG: 6mm nut slides in

/* [Key] */
key_style   = "T";   // [T:T key slides on from the rail end, bar:neck only drops in from above]
key_clr     = 0.25;  // mm per side, sliding fit in the slot
key_vclr    = 0.3;   // mm, T head below the lip underside
key_head_h  = 3.0;   // mm, T head height (less than slot_under_h)
bar_depth   = 1.5;   // mm, bar key reach below the lip underside
lead_cham   = 1.5;   // mm, lead-in chamfer at both key ends

/* [Body] */
bridge_t     = 5;     // mm, bridge thickness above the rail top
bridge_past  = 4;     // mm, bridge beyond the key towards the cutting edge
wall_t       = 6;     // mm, vertical leg outside the back edge
edge_clr     = 0.5;   // mm, wall to rail back edge. Does not locate
// Under leg: MUST be thinner than the thinnest workpiece minus under_clr,
// or it holds the rail off the work. 6 suits 12mm and up; use 4 for 6mm ply.
under_t      = 6;     // mm
under_clr    = 0.3;   // mm, leg top below rail underside
stop_cham    = 0.5;   // mm, small chamfer at the stop bottom edge
outer_cham   = 1.5;   // mm, outer corners of the C
inner_fillet = 1.0;   // mm, inner corners. 0.29*r intrudes, keep < edge_clr/0.29

/* [Label] */
show_label   = true;  // emboss the cut width on the bridge top
label_size   = 8;     // mm, text height
label_h      = 0.6;   // mm, emboss height

/* [Key test coupon] */
key_test_len = 15;    // mm

/* [Hidden] */
$fn = 64;
EPS = 0.01;

//////////////////////////////////////////////////////////////////////////////
// Derived
//////////////////////////////////////////////////////////////////////////////
slot_c   = slot_c_from_cut_measured > 0 ? slot_c_from_cut_measured
                                        : rail_w - slot_c_from_back;
x_stop   = cut_offset + offset_trim;
x_wall_i = rail_w + edge_clr;          // wall inner face
x_wall_o = x_wall_i + wall_t;          // wall outer face
y_leg_t  = -under_clr;                 // under leg top
y_leg_b  = y_leg_t - under_t;          // under leg bottom
y_top    = rail_back_h;                // rail top at the back, bridge bottom
y_bridge = y_top + bridge_t;           // jig top
y_lip_u  = y_top - slot_lip_t;         // lip underside
neck_w   = slot_open_w - 2 * key_clr;
head_w   = slot_under_w - 2 * key_clr;
y_head_t = y_lip_u - key_vclr;
y_head_b = y_head_t - key_head_h;
y_key_b  = key_style == "T" ? y_head_b : y_lip_u - bar_depth;
key_w_max = key_style == "T" ? head_w : neck_w;
x_bridge = slot_c - key_w_max / 2 - bridge_past;   // bridge inner end

echo(str("slot centre from cutting edge = ", slot_c));
echo(str("stop face from cutting edge   = ", x_stop));
echo(str("stop inboard of back edge     = ", rail_w - x_stop));
echo(str("thinnest workpiece            = ", under_t + under_clr));

assert(x_stop < x_bridge, "stop must lie inboard of the bridge / key");
assert(x_stop < rail_w - 5, "stop too close to the rail back edge");
assert(key_style != "T" || key_head_h + key_vclr < slot_under_h,
       "T head does not fit the undercut height");
assert(neck_w > 1.2, "key neck thinner than a printable wall");
if (under_t + under_clr > workpiece_t)
    echo("WARNING: under leg thicker than workpiece, it will lift the rail");

//////////////////////////////////////////////////////////////////////////////
// 2D sections
//////////////////////////////////////////////////////////////////////////////

// C body without the key. Concave corners filleted, outer corners chamfered.
module body_2d() {
    oc = outer_cham;
    pts = [
        [x_stop,             y_leg_b + stop_cham],
        [x_stop + stop_cham, y_leg_b],
        [x_wall_o - oc,      y_leg_b],
        [x_wall_o,           y_leg_b + oc],
        [x_wall_o,           y_bridge - oc],
        [x_wall_o - oc,      y_bridge],
        [x_bridge + oc,      y_bridge],
        [x_bridge,           y_bridge - oc],
        [x_bridge,           y_top],
        [x_wall_i,           y_top],
        [x_wall_i,           y_leg_t],
        [x_stop,             y_leg_t]
    ];
    if (inner_fillet > 0)
        offset(r = -inner_fillet) offset(delta = inner_fillet) polygon(pts);
    else
        polygon(pts);
}

// Rail ghost. Only the back section is meant to be dimensionally useful.
module rail_2d() {
    difference() {
        union() {
            square([rail_w, rail_plate_t]);
            translate([rail_w - rail_back_w, 0]) square([rail_back_w, rail_back_h]);
        }
        // top T-slot
        translate([slot_c - slot_open_w / 2, y_lip_u - EPS])
            square([slot_open_w, slot_lip_t + 2 * EPS]);
        translate([slot_c - slot_under_w / 2, y_lip_u - slot_under_h])
            square([slot_under_w, slot_under_h]);
    }
}

//////////////////////////////////////////////////////////////////////////////
// 3D
//////////////////////////////////////////////////////////////////////////////

// Rectangular prism along Z with c x 45 degree chamfers on all four long
// edges at both ends (lead-in).
module cham_prism(x0, x1, y0, y1, len, c) {
    hull() {
        translate([x0 + c, y0 + c, 0]) cube([x1 - x0 - 2 * c, y1 - y0 - 2 * c, len]);
        translate([x0, y0, c]) cube([x1 - x0, y1 - y0, len - 2 * c]);
    }
}

module key_3d(len) {
    c = lead_cham;
    // neck runs up into the bridge by c so its chamfer is buried
    cham_prism(slot_c - neck_w / 2, slot_c + neck_w / 2,
               y_key_b, y_top + c + 1, len, min(c, neck_w / 2 - 0.5));
    if (key_style == "T")
        cham_prism(slot_c - head_w / 2, slot_c + head_w / 2,
                   y_head_b, y_head_t, len, min(c, key_head_h / 2 - 0.3));
}

// cut width raised on the bridge top, reads from above with the rail
// cutting edge towards the viewer
module label_3d(len) {
    translate([(x_bridge + x_wall_o) / 2, y_bridge - EPS, len / 2])
        rotate([-90, 0, 0]) linear_extrude(label_h + EPS)
            text(str(x_stop), size = label_size, halign = "center",
                 valign = "center", font = "Liberation Sans:style=Bold");
}

module thincut_jig(len = jig_len) {
    linear_extrude(len) body_2d();
    key_3d(len);
    if (show_label) label_3d(len);
}

module key_test() {
    // short slice of the bridge and key only: print first to prove slot fit
    intersection() {
        thincut_jig(key_test_len);
        translate([x_bridge - 1, y_key_b - 1, -1])
            cube([x_wall_i - x_bridge, y_bridge - y_key_b + 2, key_test_len + 2]);
    }
}

module ghosts(len) {
    over = 20;
    if (show_rail)
        %translate([0, 0, -over]) linear_extrude(len + 2 * over) rail_2d();
    if (show_workpiece)
        %translate([-30, -workpiece_t, -over])
            cube([x_stop + 30, workpiece_t, len + 2 * over]);
}

//////////////////////////////////////////////////////////////////////////////
// Output: already in print orientation (section on the bed, Z = rail)
//////////////////////////////////////////////////////////////////////////////
// center_on_bed moves the part to the origin (online customizers put
// the origin mid plate). Placement only, the shape does not change.
translate(center_on_bed ? [-(x_stop + x_wall_o) / 2, -(y_leg_b + y_bridge) / 2, 0]
                        : [0, 0, 0]) {
    if (part == "jig") {
        thincut_jig();
        ghosts(jig_len);
    } else if (part == "key_test") {
        key_test();
        ghosts(key_test_len);
    }
}
