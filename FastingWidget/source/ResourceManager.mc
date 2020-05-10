using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.UserProfile;
using Toybox.System;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Time.Gregorian;


class ResourceManager {
	
	var toolbox;
	var fast_manager;
	var bitmap_burn;
	var longpress_threshold;
	var default_goal_hours;
	var default_goal_index;
	var arc_yellow_threshold;
	var arc_green_threshold;
	
	// User profile data
	var user;
	var activity_level;
	var weight;
	var height;
	var age;
	var gender;
	var bmi;
	
	// Fast data
	var is_active;
	var start_data;
	var goal_data;
	var streak_data;
	
	function initialize() {
		toolbox = Application.getApp().toolbox;
		fast_manager = null;
		bitmap_burn = WatchUi.loadResource(Rez.Drawables.burn);
		
		user = UserProfile.getProfile();
		weight = toolbox.convertWeight(user.weight);
		height = user.height;
		gender = user.gender;
		bmi = toolbox.calculateBMI(weight, height);
		
		reloadSettings();
		load();
	}
	
	function reloadSettings() {
		longpress_threshold = Application.AppBase.getProperty("longpress_threshold");
		
		default_goal_index = Application.AppBase.getProperty("default_goal");
		
		arc_yellow_threshold = Application.AppBase.getProperty("arc_yellow_threshold") * 3600;
		arc_green_threshold = Application.AppBase.getProperty("arc_green_threshold") * 3600;
		streak_data = Application.AppBase.getProperty("streak_data").toNumber();
	
		
		var raw_activity = Application.AppBase.getProperty("activity_level");
		if (raw_activity != null) {
			switch (raw_activity) {
				case 0:
					activity_level = 1.2;
					break;
				case 1:
					activity_level = 1.375;
					break;
				case 2:
					activity_level = 1.55;
					break;
				case 3: 
					activity_level = 1.725;
					break;
				case 4:
					activity_level = 1.9;
					break;
			}
		} else {
			activity_level = 1.2;
		}
		
		var birthday = Application.AppBase.getProperty("birthday");
		if (birthday != null) {
			age = toolbox.calculateAge(birthday);
		} else {
			age = 30;
		} 
		
		// DEBUG
		System.println("SETTINGS");
		System.println("longpress_threshold: " + longpress_threshold);
		System.println("default_goal_index: " + default_goal_index);
		System.println("arc_yellow_threshold: " + arc_yellow_threshold);
		System.println("arc_green_threshold: " + arc_green_threshold);
		System.println("streak_data: " + streak_data);
		System.println("raw_activity: " + raw_activity);
		System.println("activity_level: " + activity_level);
		System.println("birthday: " + birthday);
		System.println("age: " + age);
		System.println("\n");
	}
	
	function save() {
		// DEBUG
		System.println("SAVE DATA");
		System.println("streak_data: " + fast_manager.streak);
		System.println("is_active: " + fast_manager.fast.is_active);
		System.println("start_data: " + fast_manager.fast.m_start.value());
		System.println("goal_data: " + fast_manager.fast.d_goal.value());
		System.println("\n");
		
		
		Application.AppBase.setProperty("streak_data", fast_manager.streak);
		
		if (fast_manager.fast.is_active == true) {
			Storage.setValue("is_active", true);
			Storage.setValue("start_data", fast_manager.fast.m_start.value());
		} else {
			Storage.setValue("is_active", false);
			Storage.setValue("start_data", -1);
		} 
		
		if (fast_manager.fast.has_goal == true) {
			Storage.setValue("goal_data", fast_manager.fast.d_goal.value());
		} else {
			Storage.setValue("goal_data", -1);
		}
	}
	
	function load() {
		streak_data = Application.AppBase.getProperty("streak_data").toNumber();
	
		is_active = Storage.getValue("is_active");
		if (is_active == null) {
			is_active = false;
		}
		
		start_data = Storage.getValue("start_data");
		if (start_data == -1 || start_data == null) {
			start_data = -1;
		}
		
		goal_data = Storage.getValue("goal_data");
		if (goal_data == -1 || goal_data == null) {
			goal_data = -1;
		}
		
		// DEBUG
		System.println("LOAD");
		System.println("streak_data: " + streak_data);
		System.println("is_active: " + is_active);
		System.println("start_data: " + start_data);
		System.println("goal_data: " + goal_data);
		System.println("\n");
	}
}


