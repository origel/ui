import ui

const (
	win_width = 300
	win_height = 300
)

struct App {
mut:
	window     &ui.Window
}

fn main() {
	mut app := &App{}
	window := ui.window({
		width: win_width
		height: win_height
		title: 'TreeView'
		user_ptr: app
	}, [
		ui.IWidgeter(ui.treeview({
		    x:20
		    y:20
	        width: 100
	        height: 200
			children: [
				ui.IWidgeter(ui.treeitem({
					text: 'name1',
					children: [
						ui.IWidgeter(ui.treeitem({
							text: 'sub name1'
							children:[]
						})),
						ui.IWidgeter(ui.treeitem({
							text: 'sub name2'
							children:[]
						})),
					]
				})),
				ui.IWidgeter(ui.treeitem({
					text: 'name2'
				})),
				ui.IWidgeter(ui.treeitem({
					text: 'name3'
				})),
				ui.IWidgeter(ui.treeitem({
					text: 'name4'
				})),
				ui.IWidgeter(ui.treeitem({
					text: 'name5'
				})),
				ui.IWidgeter(ui.treeitem({
					text: 'name6'
				})),
			]
		}))
	])
	app.window = window
	ui.run(window)
}