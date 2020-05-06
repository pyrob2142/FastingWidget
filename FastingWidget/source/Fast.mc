using Toybox.Time;
using Toybox.UserProfile;

class Fast {
	var m_start;
	var d_goal;
	var m_now;
	var d_elapsed;
	var is_complete;
	var has_goal;
	var progress;
	var calories;
	var user;
	
	function initialize(m_start, d_goal) {
		me.m_start = m_start;
		me.d_goal = d_goal;
		is_complete = false;
		has_goal = false;
		
		if (d_goal != null) {
			has_goal = true;
		} else {
			is_complete = true;
		}
		
		user = UserProfile.getProfile();
		
		update();
	}
	
	function calculateProgress() {
		var m_goal = m_start.add(d_goal);
		
		if (m_now.greaterThan(m_goal)) {
			is_complete = true;
		}
		
		var goal_val = d_goal.value();
		var elapsed_val = d_elapsed.value();
		
		progress = elapsed_val / goal_val;
	}
	
	function calculateCalories() {
		
	}
	

	function update() {
		m_now = Time.now();
		d_elapsed = m_now.subtract(m_start);
		
		if (has_goal == true) {
			calculateProgress();
		}
	}	
	
	
}