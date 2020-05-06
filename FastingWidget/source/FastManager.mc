using Toybox.Time;

class FastManager {
	enum {
		STREAK,
		ELAPSED,
		REMAINING,
		CALORIES
	}
	
	var current_page;
	var toolbox;
	var resource_manager;
	var fast;
	
	function initialize() {
		resource_manager = Application.getApp().resource_manager;
		toolbox = Application.getApp().toolbox;
		current_page = STREAK;
		fast = null;
	}
	
	function toggleFast() {
		if (fast == null) {
			fast = new Fast(Time.now(), new Time.Duration(36 * 3600), me);
		} else {
		
			// TODO: clean up fast and manage streak
			fast = null;
		}
	}
	
	function nextPage() {
		if (fast != null) {
			current_page++;
			
			if (current_page > 3) {
				current_page = 0;
			}
			
			WatchUi.requestUpdate();
		}
	}
	
	function getPage() {
		return current_page;
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
	
	function getGoalDate() {
		if (fast != null && fast.d_goal != null) {
			return toolbox.calculateEnd(fast.m_start, fast.d_goal);
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
}