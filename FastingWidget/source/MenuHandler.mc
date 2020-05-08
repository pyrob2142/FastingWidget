using Toybox.WatchUi;
using Toybox.Math;

class MenuHandler extends WatchUi.BehaviorDelegate {
	var resource_manager;
	var toolbox;
	
	function initialize() {
		BehaviorDelegate.initialize();
		resource_manager = Application.getApp().resource_manager;
		toolbox = Application.getApp().toolbox;
		
	}
	
	function openFastTypeMenu() {
		var menu = new WatchUi.Menu2({
			:title => "Start"
		});
			
		menu.addItem(
			new MenuItem(
				"Set Goal",
				null,
				"item_set_goal",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				"No Goal",
				 null,
				"item_no_goal",
				{}
			)
		);
		
		WatchUi.pushView(menu, new FastTypeMenuDelegate(), WatchUi.SLIDE_UP);
		
		return true;
	}
	
	function openGoalMenu() {
		var default_goal_index = resource_manager.default_goal_index;
		
		var menu = new WatchUi.Menu2({
			:title => "Goal"
		});
		
		menu.addItem(
			new MenuItem(
				"8 Hours",
				toolbox.calculateDate(8),
				"hours_8",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				"12 Hours",
				toolbox.calculateDate(12),
				"hours_12",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				"14 Hours",
				toolbox.calculateDate(14),
				"hours_14",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				"16 Hours",
				toolbox.calculateDate(16),
				"hours_16",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				"20 Hours",
				toolbox.calculateDate(20),
				"hours_20",
				{}
			)
		);
		
		for (var i = 24; i < 168; i = i + 12) {
			
			var label;
			
			if (i >= 108) {
				label = toolbox.hoursToDays(i);
			} else {
				label = i + " Hours";
			}
			var id = "hours_" + i;
			
			menu.addItem(
				new MenuItem(
					label,
					toolbox.calculateDate(i),
					id,
					{}
				)
			);
		}
		
		menu.addItem(
			new MenuItem(
				"1 Week",
				toolbox.calculateDate(168),
				"hours_168",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				"2 Weeks",
				toolbox.calculateDate(336),
				"hours_336",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				"3 Weeks",
				toolbox.calculateDate(504),
				"hours_504",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				"4 Weeks",
				toolbox.calculateDate(672),
				"hours_672",
				{}
			)
		);
		
		menu.setFocus(default_goal_index);
		
		WatchUi.pushView(menu, new GoalMenuDelegate(), WatchUi.SLIDE_UP);
		
		return true;
	}
}

class FastTypeMenuDelegate extends WatchUi.Menu2InputDelegate {
	
	var fast_manager;
	
	function initialize() {
		Menu2InputDelegate.initialize();
		fast_manager = Application.getApp().fast_manager;
	}
	
	function onSelect(item) {
	
		if (item.getId().equals("item_set_goal")) {
			var menu = new MenuHandler();
			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
			menu.openGoalMenu();
		}
		
		if (item.getId().equals("item_no_goal")) {
			fast_manager.startFast(null);
			onBack();
		}
	}
	
	function onWrap(key) {
		return false;
	}
}

class GoalMenuDelegate extends WatchUi.Menu2InputDelegate {

	var fast_manager;
	
	function initialize() {
		Menu2InputDelegate.initialize();
		fast_manager = Application.getApp().fast_manager;
	}
	
	function onSelect(item) {
		var id = item.getId();
		
		var split_index = id.find("_");
		var hours = id.substring(split_index + 1, id.length()).toNumber();
	
		fast_manager.startFast(hours);
		onBack();
	}
}