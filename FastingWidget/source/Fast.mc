using Toybox.Time;

class Fast {
	var fast_manager;
	var resource_manager;
	var m_start;
	var d_goal;
	var m_now;
	var d_elapsed;
	var is_complete;
	var has_goal;
	var progress;
	var calories;
	var weight;
	var height;
	var age;
	var gender;
	var activity_level;
	var bmi;
	
	function initialize(m_start, d_goal, fast_manager) {
		me.fast_manager = fast_manager;
		resource_manager = Application.getApp().resource_manager;
		me.m_start = m_start;
		me.d_goal = d_goal;
		is_complete = false;
		has_goal = false;
		
		if (d_goal != null) {
			has_goal = true;
		} else {
			is_complete = true;
		}
		
		weight = resource_manager.weight;
		height = resource_manager.height;
		age = resource_manager.age;
		gender = resource_manager.gender;
		activity_level = resource_manager.activity_level;
		bmi = resource_manager.bmi;
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
	
	// Calculate kcal burned using Harris-Benedict formula
	function calculateCalories() {
		var bmr;
		
		if (bmi >= 30) {
			if (gender == 0) {
				bmr = 2.4 * weight + 9.0 * height - 4.7 * age - 65;
			} else {
				bmr = 3.4 * weight + 15.3 * height - 6.8 * age - 961;
			}
		} else {
			if (gender == 0) {
				bmr = 655 + 9.6 * weight + 1.8 * height - 4.7 * age;
			} else {
				bmr = 66.5 + 13.7 * weight + 5.0 * height - 6.8 * age;
			}
		}
		
		var calories_per_second = bmr * activity_level / 86400;
		
		return calories_per_second * d_elapsed.value();
	}
	
	function update() {
		m_now = Time.now();
		d_elapsed = m_now.subtract(m_start);
		
		calculateCalories();
		
		if (has_goal == true) {
			calculateProgress();
		}
	}	
	
}