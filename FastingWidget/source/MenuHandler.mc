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
	
	//! Opens the fast-type menu to the User.
	//! Fasts can have a goal or run unrestricted.
	function openFastTypeMenu() {
		var menu = new WatchUi.Menu2({
			:title => resource_manager.string_fast_type_menu_title
		});
			
		menu.addItem(
			new MenuItem(
				resource_manager.string_fast_set_goal,
				null,
				"item_set_goal",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_fast_no_goal,
				 null,
				"item_no_goal",
				{}
			)
		);
		
		WatchUi.pushView(menu, new FastTypeMenuDelegate(), WatchUi.SLIDE_UP);
		
		return true;
	}
	
	//! Opens the finish menu.
	//! A fast is considered finished once the target duration has been reached
	//! or if no goal was set.
	function openFinishMenu() {
		var menu = new WatchUi.Menu2({
			:title => resource_manager.string_end_fast_title
		});
			
		menu.addItem(
			new MenuItem(
				resource_manager.string_yes,
				null,
				"item_yes",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_no,
				null,
				"item_no",
				{}
			)
		);
		
		WatchUi.pushView(menu, new EndFastMenuDelegate(), WatchUi.SLIDE_UP);
		
		return true;
	}
	
	//! Opens the cancel menu.
	//! A fast is considered cancelled, if it ends before the target duration has been reached.
	//! A cancelled fast may lead to the reset of the streak.
	function openCancelMenu() {
		var menu = new WatchUi.Menu2({
			:title => resource_manager.string_cancel_fast_title
		});
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_no,
				 null,
				"item_no",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_yes,
				null,
				"item_yes",
				{}
			)
		);
		
		WatchUi.pushView(menu, new EndFastMenuDelegate(), WatchUi.SLIDE_UP);
		
		return true;
	}
	
	//! Opens the goal menu.
	//! Users can choose from a variety of common fast durations.
	function openGoalMenu() {
		var default_goal_index = resource_manager.default_goal_index;
		
		var menu = new WatchUi.Menu2({
			:title => Rez.Strings.goal_menu_title
		});
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_8,
				toolbox.calculateDate(8),
				"hours_8",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_12,
				toolbox.calculateDate(12),
				"hours_12",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_14,
				toolbox.calculateDate(14),
				"hours_14",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_16,
				toolbox.calculateDate(16),
				"hours_16",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_20,
				toolbox.calculateDate(20),
				"hours_20",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_24,
				toolbox.calculateDate(24),
				"hours_24",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_36,
				toolbox.calculateDate(36),
				"hours_36",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_48,
				toolbox.calculateDate(48),
				"hours_48",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_60,
				toolbox.calculateDate(60),
				"hours_60",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_72,
				toolbox.calculateDate(72),
				"hours_72",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_84,
				toolbox.calculateDate(84),
				"hours_84",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_96,
				toolbox.calculateDate(96),
				"hours_96",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_108,
				toolbox.calculateDate(108),
				"hours_108",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_120,
				toolbox.calculateDate(120),
				"hours_120",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_132,
				toolbox.calculateDate(132),
				"hours_132",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_144,
				toolbox.calculateDate(144),
				"hours_144",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_156,
				toolbox.calculateDate(156),
				"hours_156",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_168,
				toolbox.calculateDate(168),
				"hours_168",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_336,
				toolbox.calculateDate(336),
				"hours_336",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_504,
				toolbox.calculateDate(504),
				"hours_504",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_goal_672,
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

//! Handles user input during fast-type selection.
//! @return [Boolean] Returns false to prevent menu wrapping.
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
			fast_manager.startFast(-1);
			onBack();
		}
	}
	
	function onWrap(key) {
		return false;
	}
}

//! Handles user input during target duration selection.
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

//! Handles user input during end fast and cancel fast selections.
class EndFastMenuDelegate extends WatchUi.Menu2InputDelegate {

	var fast_manager;
	
	function initialize() {
		Menu2InputDelegate.initialize();
		fast_manager = Application.getApp().fast_manager;
	}
	
	function onSelect(item) {
		
		if (item.getId().equals("item_yes")) {
			fast_manager.endFast();
			onBack();
		}
		
		if (item.getId().equals("item_no")) {
			onBack();
		}
	}
}