using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi;

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
	var is_active;
	var timer;
	
	function initialize() {
		resource_manager = Application.getApp().resource_manager;
		timer = new Timer.Timer();
		reset();
	}
	
	function start(goal) {
		if (goal != -1) {
			d_goal = new Time.Duration(goal * 3600);
			has_goal = true;
		} else {
			is_complete = true;
		}
		
		timer.start(me.method(:update), 1000, true);
		m_start = Time.now();
		is_active = true;
		update();
	}
	
	function end() {
		is_active = false;
		timer.stop();
	}
	
	function reset() {
		weight = resource_manager.weight;
		height = resource_manager.height;
		age = resource_manager.age;
		gender = resource_manager.gender;
		activity_level = resource_manager.activity_level;
		bmi = resource_manager.bmi;
		
		m_start = Time.now();
		m_now = Time.now();
		d_goal = new Time.Duration(0);
		d_elapsed = new Time.Duration(0);
		is_complete = false;
		has_goal = false;
		progress = 0.0;
		calories = 0;
		is_active = false;		
	}
	
	function calculateProgress() {
		var m_goal = m_start.add(d_goal);
		
		if (m_now.greaterThan(m_goal)) {
			is_complete = true;
		}
		
		var goal_val = d_goal.value();
		var elapsed_val = d_elapsed.value();
		
		progress = elapsed_val / goal_val.toFloat();
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
		
		var calories_per_second = bmr * activity_level / 86400.0;
	
		calories = calories_per_second * d_elapsed.value().toDouble();
	}
	
	function update() {
		
		m_now = Time.now();
		d_elapsed = m_now.subtract(m_start);
		
		calculateCalories();
		
		if (has_goal == true) {
			calculateProgress();
		}
		
		WatchUi.requestUpdate();
	}
}