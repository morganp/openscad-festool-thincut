# Festool Thin Cut - todo

## Done (v0.1.0)
- [x] Parametric C jig: T key in the top back-edge slot, wall round the back
      edge, under leg with the stop at `cut_offset` 160 from the cutting edge
- [x] Stop position derived from the slot centreline, with
      `slot_c_from_cut_measured` as a one-number override
- [x] `key_style` T (slides on from the rail end) or bar (drops in)
- [x] `part = "key_test"` 15mm coupon to prove the slot fit first
- [x] Rail and workpiece ghosts, section and 3D renders, STLs exported

## Measure on real rail
Rail dimensions are estimates. Web sources only gave: about 183mm of
aluminium plus a 2-3mm splinter lip (FOG forum), and a nut 6mm thick or
less slides in the top ("ceiling facing") track (FOG forum). No published
drawing with slot numbers was reachable.
- [ ] **Cutting edge to T-slot centreline** (measure to both slot walls,
      average). This sets the strip width. Enter as `slot_c_from_cut_measured`
- [x] Cutting edge to aluminium back edge (`rail_w` 190, from v0.1.0 test cut: 160 set gave 165)
- [x] Slot opening width (`slot_open_w` 8.0, v0.1.0 neck 1mm narrow, >1mm play OK)
- [ ] Lip thickness (`slot_lip_t`, guess 2.0)
- [ ] Undercut width (`slot_under_w`, guess 11.0)
- [ ] Undercut height (`slot_under_h`, guess 6.0)
- [ ] Back edge to slot centreline (`slot_c_from_back`, guess 12)
- [ ] Rail height at the back edge, underside grip strips included
      (`rail_back_h`, guess 10.5)
- [ ] Confirm the top slot is open along the full rail length so a T key
      can slide on from the end. If it is not, use `key_style = "bar"`
- [ ] Check the back edge profile is square below the slot. If it has a
      bead or step, the wall needs a matching relief

## Open
- [ ] Print `key_test`, tune `key_clr` (0.25 per side is a guess)
- [ ] Print the jig, cut a test strip, measure, correct with `offset_trim`
- [ ] Decide on two jigs per rail (one each end) for parallel strips
- [ ] Under leg 6mm: fine for 12mm stock and up. For 6mm ply set
      `under_t` 4 or less
- [ ] Stop face is 6mm tall. Consider a taller stop (leg pads that reach
      below the rail line) only if thin strips ride over it
- [ ] Underside grip strips on the rail may not be at the back edge. If the
      rail rocks, add a pad to the under leg top

## Done (v0.2.0)
- [x] Key neck 1mm wider (`slot_open_w` 7 to 8)
- [x] Calibrated: `rail_w` 190, `cut_offset` 165. Stop, wall and bridge sit where v0.1.0 had them relative to the key
- [x] Cut width (`x_stop`) embossed on the bridge top (`show_label`)
