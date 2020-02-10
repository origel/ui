// Copyright (c) 2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by a GPL license
// that can be found in the LICENSE file.
module ui

pub struct TreeItem {
mut:
	text   string
	parent ILayouter
	x      int
	y      int
	ui     &UI
}

pub struct TreeItemConfig {
	text   string
	ref		&TreeItem
}

fn (l mut TreeItem)init(p &ILayouter) {
	parent := *p
	ui := parent.get_ui()
	l.ui = ui
}

pub fn treeitem(c TreeItemConfig) &TreeItem {
	lbl := &TreeItem{
		text: c.text
	}
	if c.ref != 0 {
		mut ref := c.ref
		*ref = *lbl
		return &ref
	}
	return lbl
}

fn (b mut TreeItem) set_pos(x, y int) {
	b.x = x
	b.y = y
}

fn (b mut TreeItem) size() (int, int) {
	size := b.ui.ft.text_size(b.text)

	// First return the width, then the height multiplied by line count.
	return size.var_0, size.var_1 * b.text.split('\n').len
}

fn (b mut TreeItem) propose_size(w, h int) (int, int) {
	size := b.ui.ft.text_size(b.text)

	// First return the width, then the height multiplied by line count.
	return size.var_0, size.var_1 * b.text.split('\n').len
}

fn (b mut TreeItem) draw() {
	splits := b.text.split('\n') // Split the text into an array of lines.
	height := b.ui.ft.text_height('W') // Get the height of the current font.

	for i, split in splits {
		// Draw the text at b.x and b.y + line height * current line
		b.ui.ft.draw_text(b.x, b.y + (height * i), split, btn_text_cfg)
	}
}

fn (t &TreeItem) focus() {}

fn (t &TreeItem) is_focused() bool {
	return false
}

fn (t &TreeItem) unfocus() {}

fn (t &TreeItem) point_inside(x, y f64) bool {
	return false // x >= t.x && x <= t.x + t.width && y >= t.y && y <= t.y + t.height
}

pub fn (l mut TreeItem) set_text(s string) {
	l.text = s
}
