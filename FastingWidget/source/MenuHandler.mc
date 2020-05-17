using Toybox.WatchUi;
using Toybox.Math;

class MenuHandler extends WatchUi.BehaviorDelegate {
	var resource_manager;
	var toolbox;
	var fast_manager;
	
	function initialize() {
		BehaviorDelegate.initialize();
		resource_manager = Application.getApp().resource_manager;
		toolbox = Application.getApp().toolbox;
		fast_manager = Application.getApp().fast_manager;
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
	
	//! Opens the options menu for open fasts
	//! Allows a user to add a goal to an existing open fast
	function openOptionsMenu() {
		var menu = new WatchUi.Menu2({
			:title => resource_manager.string_options_title
		});
			
		menu.addItem(
			new MenuItem(
				resource_manager.string_end_fast_title,
				null,
				"end_fast",
				{}
			)
		);
		
		menu.addItem(
			new MenuItem(
				resource_manager.string_fast_set_goal,
				null,
				"add_goal",
				{}
			)
		);
		
		WatchUi.pushView(menu, new OptionsMenuDelegate(), WatchUi.SLIDE_UP);
		return true;
	}
	
	//! Opens the finish menu.
	//! A fast is considered finished once the target duration has been reached
	//! or if no goal was set.
	function openConfirmationMenu() {
		var menu = new WatchUi.Menu2({
			:title => resource_manager.string_sure_title
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
	
	//! Opens the confirmation menu.
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
		var menu = new WatchUi.Menu2({
			:title => Rez.Strings.goal_menu_title
		});
		
		for (var i = 0; i < resource_manager.goal_hours.size(); i++) {
			var label = resource_manager.goal_hours[i] + " " + resource_manager.string_hours;
			var id = "hours_" + resource_manager.goal_hours[i];
			
			
			if (resource_manager.goal_hours[i] >= resource_manager.show_days) {
					label = toolbox.makeGoalHoursPretty(resource_manager.goal_hours[i]);
			}
			
			if (fast_manager.fast.is_active) {
				menu.addItem(
					new MenuItem(
						label,
						toolbox.calculateEndDateFromMoment(resource_manager.goal_hours[i], fast_manager.fast.m_start),
						id,
						{}
					)
				);
				
				if (resource_manager.goal_hours[i] == resource_manager.default_goal) {
					menu.setFocus(i);
				}
							
			} else {
				menu.addItem(
					new MenuItem(
						label,
						toolbox.calculateEndDate(resource_manager.goal_hours[i]),
						id,
						{}
					)
				);
				
				if (resource_manager.goal_hours[i] == resource_manager.default_goal) {
					menu.setFocus(i);
				}
			}
		}
		
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
		
		if (fast_manager.fast.is_active && fast_manager.fast.has_goal == false) {
			fast_manager.addGoalToFast(hours);
		} else {
			fast_manager.startFast(hours);
		}
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

//! Handles user input during confirmation menu selections.
class ConfirmationMenuDelegate extends WatchUi.Menu2InputDelegate {
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

//! Handles user input during options menu selections.
class OptionsMenuDelegate extends WatchUi.Menu2InputDelegate {
	var fast_manager;
	
	function initialize() {
		Menu2InputDelegate.initialize();
		fast_manager = Application.getApp().fast_manager;
	}
	
	function onSelect(item) {
		
		if (item.getId().equals("end_fast")) {
			var menu = new MenuHandler();
			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
			menu.openConfirmationMenu();
		}
		
		if (item.getId().equals("add_goal")) {
			var menu = new MenuHandler();
			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
			menu.openGoalMenu();
		}
	}
}