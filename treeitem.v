// Copyright (c) 2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by a GPL license
// that can be found in the LICENSE file.
module ui

import gx
import freetype

const (
	tree_item_text_cfg = gx.TextCfg{
		color: gx.black
		size: freetype.default_font_size
		align: gx.ALIGN_LEFT
	}
	tree_item_selected_text_cfg = gx.TextCfg{
		color: gx.white
		size: freetype.default_font_size
		align: gx.ALIGN_LEFT
	}
	tree_item_padding = 2
)

pub struct TreeItem {
pub mut:
	selected bool = false

mut:
	text   string
	parent ILayouter
	x      int
	y      int
	width int
	height int
	ui     &UI
	open  bool = false
	children []IWidgeter
}

pub struct TreeItemConfig {
	text   string
	children []IWidgeter
	ref		&TreeItem
}

fn (t mut TreeItem)init(p &ILayouter) {
	parent := *p
	ui := parent.get_ui()
	t.ui = ui
	
	size := t.ui.ft.text_size(t.text)

	// First return the width, then the height multiplied by line count.
	t.width = size.var_0
	t.height = size.var_1

	mut subscriber := parent.get_subscriber()
	subscriber.subscribe_method(events.on_click, item_click, t)
}

pub fn treeitem(c TreeItemConfig) &TreeItem {
	lbl := &TreeItem{
		text: c.text
		children: c.children
	}
	return lbl
}

fn (b mut TreeItem) set_pos(x, y int) {
	b.x = x
	b.y = y
}

fn (b mut TreeItem) size() (int, int) {
	size := b.ui.ft.text_size('+ ' + b.text)

	return size.var_0 + tree_item_padding * 2, size.var_1 + tree_item_padding * 2
}

fn (b mut TreeItem) propose_size(w, h int) (int, int) {
	size := b.ui.ft.text_size(b.text)

	// First return the width, then the height multiplied by line count.
	return size.var_0 + tree_item_padding * 2, size.var_1 + tree_item_padding * 2
}

fn (b mut TreeItem) draw() {
	height := b.ui.ft.text_height('W') // Get the height of the current font.
	
	mut text := ''
	
	
	if b.open {
        text = '- ' + b.text
    }else{
        text = '+ ' + b.text
    }

    /*if b.selected {
        b.ui.gg.draw_rect(b.x, b.y, b.width + 2*tree_item_padding, b.height + 2* tree_item_padding, gx.blue)
	    b.ui.ft.draw_text(b.x + tree_item_padding, b.y + tree_item_padding, text, tree_item_selected_text_cfg)
	}else{
	}*/
    b.ui.ft.draw_text(b.x + tree_item_padding, b.y + tree_item_padding, text, tree_item_text_cfg)
}

fn (t &TreeItem) focus() {}

fn (t &TreeItem) is_focused() bool {
	return false
}

fn (t &TreeItem) unfocus() {}

fn (t &TreeItem) point_inside(x, y f64) bool {
	return x >= t.x && x <= t.x + t.width && y >= t.y && y <= t.y + t.height
}

fn item_click(r mut TreeItem, e &MouseEvent) {
	if !r.point_inside(e.x, e.y) {
		return
	}

    if e.action == 1 {
    	r.selected = true
    }

    if e.action == 0 {
    	r.open = !r.open
    }
}

pub fn (l mut TreeItem) set_text(s string) {
	l.text = s
}
