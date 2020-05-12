using Toybox.Time;
using Toybox.WatchUi;

//! Controls the flow of the application.
class FastManager {
	
	//! The different pages / views of the application.
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
	
	//! Holds the number of the currently displayed page
	var current_page;
	
	
	var toolbox;
	var resource_manager;
	var fast;
	
	//! The current streak.
	var streak;
	//! Backup of the current streak in case it gets reset.
	//! Used to display the "lost" streak in STREAKRES view.
	var streak_old;
	var streak_reset_threshold;
	var streak_inc_threshold;
	
	function initialize() {
		resource_manager = Application.getApp().resource_manager;
		resource_manager.fast_manager = me;
		toolbox = Application.getApp().toolbox;
		streak = resource_manager.streak_data;
		streak_old = streak;
		
		streak_reset_threshold = resource_manager.streak_reset_threshold;
        streak_inc_threshold = resource_manager.streak_inc_threshold;
		
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
	
	//! Starts a fast and navigates the view to the correct page.
	//! @param [Number] goal Target duration in hours.
	function startFast(goal) {
		fast.reset();
		
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
	
	//! Ends the current fast, determines if the streak should be reset and saves the new state.
	//! A streak is reset if the reset threshold set in the user settings has not been surpassed.
	//! A streak is incremented if the increment threshold in the user settings has been surpassed.
	//! If neither is the case the streak is not modified.
	function endFast() {
		fast.end();
		
		if (fast.is_complete == true || fast.progress >= streak_inc_threshold ) {
			streak++;
		} else {
			if (fast.progress < streak_reset_threshold) {
				streak_old = streak;
				streak = 0;
			}
		}
		
		resource_manager.save();
		
		current_page = SUMMARY;
		
		WatchUi.requestUpdate();
		
	}
	
	//! Determines which page to show at start up.
	function initPageCounter() {
		if (fast.is_active == false) {
			current_page = STREAK;
		} else {
			if (fast.has_goal == true) {
				current_page = resource_manager.default_page_goal;
			} else {
				current_page = resource_manager.default_page_no_goal;
			}
		}
	}
	
	//! Advances the view to the next appropriate page.
	//! If no fast is active, the user is limited to STREAK.
	//! If a fast is active, but no goal has been set only the ELAPSED view is available.
	//! If the fast has ended and the user is viewing the SUMMARY the next page will depend on the success of the fast.
	//! If the increment threshold has been surpassed the next page will be STREAKINC.
	//! If the reset threshold has not been surpassed the next page will be STREAKRES.
	//! If neither happens the user will be brought back to the STREAK immediately. 
	//! Otherwise he will get to STREAK after acknowledging the changes to the streak.
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
			
			if (fast.is_complete == true || fast.progress >= streak_inc_threshold) {
				current_page = STREAKINC;
			} else {
				if (fast.progress < streak_reset_threshold) {
					current_page = STREAKRES;
				} else {
					current_page = STREAK;
				}
			}
			
		}
		
		WatchUi.requestUpdate();
	}
	
	//! Returns the current page for display.
	//! @return [number] The current page.
	function getPage() {
		return current_page;
	}
	
	//! Returns the elapsed time in seconds.
	//! @return [number] The elapsed time in seconds.
	function getElapsedRaw() {
		return fast.d_elapsed.value();
	}
	
	//! Returns the elapsed time as a nicely formatted String.
	//! @return [String] Elapsed time as a pretty String.
	function getElapsed() {
		return toolbox.convertSeconds(fast.d_elapsed.value());
	}
	
	//! Returns the remaining time until the goal is met as a nicely formatted String.
	//! @return [String] Remaining time as a pretty String.
	function getRemaining() {
		var remaining = fast.d_goal.subtract(fast.d_elapsed);
		return toolbox.convertSeconds(remaining.value());
	}
	
	//! Returns the Time.Moment of when the fast was started.
	//! @return [Time.Moment] Moment when the fast was started.
	function getStartMoment() {
		return fast.m_start;
	}
	
	//! Returns the Time.Moment of when the fast will reach its goal.
	//! @return [Time.Moment] Moment when the fast will reach its goal.
	function getGoalMoment() {
		var end = fast.m_start.add(fast.d_goal);
		return end;
	}
	
	//! Returns the current progress of the fast as a range from 0 to 1.
	//! @return [Number] Current progress of the fast as a range from 0 to 1.
	function getProgress() {
		return fast.progress;
	}
	
	//! Returns the current calories burnt in kcal.
	//! @return [Number] Current burnt calories in kcal.
	function getCalories() {
		return fast.calories;
	}
}