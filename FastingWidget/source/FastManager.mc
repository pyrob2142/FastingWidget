using Toybox.Time;
using Toybox.WatchUi;

class FastManager {
	enum {
		STREAK,
		ELAPSED,
		REMAINING,
		OPEN,
		CALORIES
	}
	
	var current_page;
	var toolbox;
	var resource_manager;
	var fast;
	var streak;
	
	function initialize() {
		resource_manager = Application.getApp().resource_manager;
		toolbox = Application.getApp().toolbox;
		current_page = STREAK;
		streak = resource_manager.streak;
	
		fast = null;
	}
	
	function startFast(goal) {
		if (fast == null) {
		System.println("Goal: " + goal);
			if (goal != null) {
				fast = new Fast(Time.now(), new Time.Duration(goal * 3600), me);
				current_page = ELAPSED;
				WatchUi.requestUpdate();
			} else {
				fast = new Fast(Time.now(), null, me);
				current_page = OPEN;
				WatchUi.requestUpdate();
			}
		}
	}
	
	function initPageCounter() {
		if (fast == null) {
			current_page = STREAK;
		} else if (fast.has_goal == true) {
			current_page = ELAPSED;
		} else {
			current_page = OPEN;
		}
	}
	
	function nextPage() {
		if (fast != null) {
			current_page++;
			
			if (fast.has_goal == true) {
				if (current_page == OPEN) {
					current_page = CALORIES;
				}
			} else {
				if (current_page == ELAPSED) {
					current_page = OPEN;
				}
			}
			
			if (current_page > CALORIES) {
				current_page = STREAK;
			}
			
			WatchUi.requestUpdate();
		}
	}
	
	function getPage() {
		return current_page;
	}
	
	function getElapsedRaw() {
		return fast.d_elapsed.value();
	}
	
	function getElapsed() {
		if (fast != null) {
			return toolbox.convertSeconds(fast.d_elapsed.value());
		} else {
			return null;
		}
	}
	
	function getRemaining() {
		if (fast != null && fast.d_goal != null) {
			var remaining = fast.d_goal.subtract(fast.d_elapsed);
			return toolbox.convertSeconds(remaining.value());
		} else {
			return null;
		}
	}
	
	function getStartMoment() {
		if (fast != null) {
			return fast.m_start;
		} else {
			return null;
		}
	}
	
	function getGoalMoment() {
		if (fast != null && fast.d_goal != null) {
			var end = fast.m_start.add(fast.d_goal);
			return end;
		} else {
			return null;
		}
	}
	
	function getProgress() {
		if (fast != null && fast.d_goal != null) {
			return fast.progress;
		} else {
			return 0;
		}
	}
	
	function getCalories() {
		if (fast != null) {
			return fast.calories;
		} else {
			return null;
		}
	}
	
	function update() {
		if (fast != null) {
			fast.update();
		}
	}
	
	function getStreak() {
		return streak;
	}
}