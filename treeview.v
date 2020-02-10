// Copyright (c) 2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by a GPL license
// that can be found in the LICENSE file.
module ui

import gx

pub struct TreeView {
pub mut:
    height         int
    width          int
    x              int
    y              int
    parent ILayouter
    ui             &UI
    children []IWidgeter
    margin_left int = 5
    margin_top int = 10
    margin_right int = 5
    margin_bottom int = 5
    spacing int = 5
}

pub struct TreeViewConfig {
pub mut:
    x          int
    y          int
    width  int
    height int
    children []IWidgeter
}

fn (r mut TreeView)init(p &ILayouter) {
    parent := *p
    r.parent = parent
    ui := parent.get_ui()
    r.ui = ui

    for child in r.children {
        child.init(r)
    }

    mut widgets := r.children
    mut start_x := r.x + r.margin_left
    mut start_y := r.y + r.margin_top
    for widget in widgets {
        mut pw, ph := widget.size()
        widget.set_pos(start_x, start_y)
        start_y = start_y + ph + r.spacing
        if(pw > r.width - r.margin_left - r.margin_right){
            r.width = pw + r.margin_left + r.margin_right
        }
        if(start_y + r.margin_bottom > r.height){
            r.height = start_y -ph
        }
    }
}

pub fn treeview(c TreeViewConfig) &TreeView {
    mut cb := &TreeView{
        x: c.x
        y:c.y
        width: c.width
        height: c.height
        children: c.children
    }
    return cb
}

fn (g mut TreeView) set_pos(x, y int) {
    g.x = x
    g.y = y
}

fn (g mut TreeView) propose_size(w, h int) (int, int) {
    g.width = w
    g.height = h
    return g.width, g.height
}

fn (b mut TreeView) draw() {
    b.ui.gg.draw_rect(b.x, b.y, b.width, b.height, gx.white)
    // Border
    b.ui.gg.draw_empty_rect(b.x, b.y, b.width, b.height, gx.gray)

    for child in b.children {
        child.draw()
    }
}

fn (t &TreeView) point_inside(x, y f64) bool {
    return x >= t.x && x <= t.x + t.width && y >= t.y && y <= t.y + t.height
}

fn (b mut TreeView) focus() {
}

fn (b mut TreeView) unfocus() {
}

fn (t &TreeView) is_focused() bool {
    return false
}

fn (t &TreeView) get_ui() &UI {
    return t.ui
}

fn (t &TreeView) unfocus_all() {
    for child in t.children {
        child.unfocus()
    }
}

fn (t &TreeView) resize(width, height int) {
}

fn (t &TreeView) get_user_ptr() voidptr {
    parent := t.parent
    return parent.get_user_ptr()
}

fn (b &TreeView) get_subscriber() &eventbus.Subscriber {
    parent := b.parent
    return parent.get_subscriber()
}

fn (c &TreeView) size() (int, int) {
    return c.width, c.height
}
