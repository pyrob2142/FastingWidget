using Toybox.Time;
using Toybox.WatchUi;

class FastManager {
	enum {
		STREAK,
		ELAPSED,
		REMAINING,
		OPEN,
		CALORIES,
		SUMMARY,
		STREAKINC,
		STREAKRES
	}
	
	var current_page;
	var toolbox;
	var resource_manager;
	var fast;
	var streak;
	var streak_old;
	
	function initialize() {
		resource_manager = Application.getApp().resource_manager;
		resource_manager.fast_manager = me;
		toolbox = Application.getApp().toolbox;
		streak = resource_manager.streak_data;
		streak_old = streak;
		fast = new Fast();
		
		if (resource_manager.is_active == true) {
			if (resource_manager.goal_data != -1) {
				fast.resume(resource_manager.start_data, resource_manager.goal_data);
			} else {
				fast.resume(resource_manager.start_data, -1);
			}
		}
		
		initPageCounter();
	}
	
	function startFast(goal) {
	
		if (goal != -1) {
			fast.start(goal);
			current_page = ELAPSED;
			WatchUi.requestUpdate();
		} else {
			fast.start(goal);
			current_page = OPEN;
			WatchUi.requestUpdate();
		}	
	}
	
	function endFast() {
		fast.end();
		
		if (fast.is_complete == true) {
				streak++;
		} else {
				streak_old = streak;
				streak = 0;
		}
		
		resource_manager.save();
		
		current_page = SUMMARY;
		
		WatchUi.requestUpdate();
		
	}
	
	function initPageCounter() {
		if (fast.is_active == false) {
			current_page = STREAK;
		} else if (fast.has_goal == true) {
			current_page = ELAPSED;
		} else {
			current_page = OPEN;
		}
	}
	
	function nextPage() {	
	
		if (fast.is_active == true && current_page != SUMMARY) {
			
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
		} 
		
		if (current_page == STREAKINC) {
			fast.reset();
			
			current_page = STREAK;
		}
		
		if (current_page == STREAKRES) {
			fast.reset();
			
			current_page = STREAK;
		}
		
		if (current_page == SUMMARY) {
			
			if (fast.is_complete == true) {
				current_page = STREAKINC;
			} else {
				current_page = STREAKRES;
			}
			
		}
		
		WatchUi.requestUpdate();
	}
	
	function getPage() {
		return current_page;
	}
	
	function getElapsedRaw() {
		return fast.d_elapsed.value();
	}
	
	function getElapsed() {
		return toolbox.convertSeconds(fast.d_elapsed.value());
	}
	
	function getRemaining() {
		var remaining = fast.d_goal.subtract(fast.d_elapsed);
		return toolbox.convertSeconds(remaining.value());
	}
	
	function getStartMoment() {
		return fast.m_start;
	}
	
	function getGoalMoment() {
		var end = fast.m_start.add(fast.d_goal);
		return end;
	}
	
	function getProgress() {
		return fast.progress;
	}
	
	function getCalories() {
		return fast.calories;
	}
}