using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.UserProfile;
using Toybox.System;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Time.Gregorian;

//! Handles resources, settings and loading and saving of fasts.
class ResourceManager {
	
	var toolbox;
	var fast_manager;
	
	//! Settings
	var longpress_threshold;
	var default_page_goal;
	var default_page_no_goal;
	var default_goal_hours;
	var default_goal_index;
	var streak_reset_threshold;
	var streak_inc_threshold;
	
	//! User profile data
	var user;
	var activity_level;
	var weight;
	var height;
	var age;
	var gender;
	var bmi;
	
	//! Fast data
	var is_active;
	var start_data;
	var goal_data;
	var streak_data;
	
	//! Resources
	var bitmap_burn;
	var string_goal_8;
	var string_goal_12;
	var string_goal_14;
	var string_goal_16;
	var string_goal_20;
	var string_goal_24;
	var string_goal_36;
	var string_goal_48;
	var string_goal_60;
	var string_goal_72;
	var string_goal_84;
	var string_goal_96;
	var string_goal_108;
	var string_goal_120;
	var string_goal_132;
	var string_goal_144;
	var string_goal_156;
	var string_goal_168;
	var string_goal_336;
	var string_goal_504;
	var string_goal_672;
	
	var string_summary;
	var string_duration;
	var string_calories;
	var string_streak;
	var string_fast_sg;
	var string_fast_pl;
	var string_elapsed;
	var string_remaining;
	var string_since;
	var string_until;
	var string_kcal;
	var string_overtime;
	var string_nominalization;
	var nominalization;
	
	var string_fast_type_menu_title;
	var string_fast_set_goal;
	var string_fast_no_goal;
	var string_end_fast_title;
	var string_yes;
	var string_no;
	var string_cancel_fast_title;
	var string_goal_menu_title;
	
	var symbol_days;
	var symbol_hours;
	var symbol_minutes;
	var symbol_seconds;
	var string_days;
	
	function initialize() {
		toolbox = Application.getApp().toolbox;
		toolbox.resource_manager = me;
		fast_manager = null;
		
		loadResources();
		loadSettings();
		loadUserData();
		load();
	}
	
	//! Loads the user profile.
	function loadUserData() {
		user = UserProfile.getProfile();
		weight = toolbox.convertWeight(user.weight);
		height = user.height;
		gender = user.gender;
		bmi = toolbox.calculateBMI(weight, height);
		
		// DEBUG
		System.println("USER PROFILE");
		
		if (gender == 0) {
			System.println("Gender: FEMALE");
		} else {
			System.println("Gender: MALE");
		}
		
		System.println("Height: " + height);
		System.println("Weight: " + weight);
		System.println("BMI: " + bmi);
		System.println("\n");
		
	}
	
	//! Loads the user settings.
	function loadSettings() {
		longpress_threshold = Application.AppBase.getProperty("longpress_threshold");
		
		default_page_goal = Application.AppBase.getProperty("default_page_goal");
		default_page_no_goal = Application.AppBase.getProperty("default_page_no_goal");
		
		default_goal_index = Application.AppBase.getProperty("default_goal");
		
		streak_reset_threshold = Application.AppBase.getProperty("streak_reset_threshold") / 100.0;
		streak_inc_threshold = Application.AppBase.getProperty("streak_inc_threshold") / 100.0;
		streak_data = Application.AppBase.getProperty("streak_data");
	
		
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
		System.println("streak_reset_threshold: " + streak_reset_threshold);
		System.println("streak_inc_threshold: " + streak_inc_threshold);
		System.println("streak_data: " + streak_data);
		System.println("raw_activity: " + raw_activity);
		System.println("activity_level: " + activity_level);
		System.println("birthday: " + birthday);
		System.println("age: " + age);
		System.println("\n");
	}
	
	//! Saves the current state of the fast, as well as the streak.
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
	
	//! Loads a previous fast and streak.
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
	
	//! Loads all necessary resources.
	function loadResources() {
		bitmap_burn = WatchUi.loadResource(Rez.Drawables.burn);
		string_goal_8 = WatchUi.loadResource(Rez.Strings.goal_8);
		string_goal_12 = WatchUi.loadResource(Rez.Strings.goal_12);
		string_goal_14 = WatchUi.loadResource(Rez.Strings.goal_14);
		string_goal_16 = WatchUi.loadResource(Rez.Strings.goal_16);
		string_goal_20 = WatchUi.loadResource(Rez.Strings.goal_20);
		string_goal_24 = WatchUi.loadResource(Rez.Strings.goal_24);
		string_goal_36 = WatchUi.loadResource(Rez.Strings.goal_36);
		string_goal_48 = WatchUi.loadResource(Rez.Strings.goal_48);
		string_goal_60 = WatchUi.loadResource(Rez.Strings.goal_60);
		string_goal_72 = WatchUi.loadResource(Rez.Strings.goal_72);
		string_goal_84 = WatchUi.loadResource(Rez.Strings.goal_84);
		string_goal_96 = WatchUi.loadResource(Rez.Strings.goal_96);
		string_goal_108 = WatchUi.loadResource(Rez.Strings.goal_108);
		string_goal_120 = WatchUi.loadResource(Rez.Strings.goal_120);
		string_goal_132 = WatchUi.loadResource(Rez.Strings.goal_132);
		string_goal_144 = WatchUi.loadResource(Rez.Strings.goal_144);
		string_goal_156 = WatchUi.loadResource(Rez.Strings.goal_156);
		string_goal_168 = WatchUi.loadResource(Rez.Strings.goal_168);
		string_goal_336 = WatchUi.loadResource(Rez.Strings.goal_336);
		string_goal_504 = WatchUi.loadResource(Rez.Strings.goal_504);
		string_goal_672 = WatchUi.loadResource(Rez.Strings.goal_672);
		
		string_summary = WatchUi.loadResource(Rez.Strings.summary);
		string_duration = WatchUi.loadResource(Rez.Strings.duration);
		string_calories = WatchUi.loadResource(Rez.Strings.calories);
		string_streak = WatchUi.loadResource(Rez.Strings.streak);
		string_fast_sg = WatchUi.loadResource(Rez.Strings.fast_sg);
		string_fast_pl = WatchUi.loadResource(Rez.Strings.fast_pl);
		string_elapsed = WatchUi.loadResource(Rez.Strings.elapsed);
		string_remaining = WatchUi.loadResource(Rez.Strings.remaining);
		string_since = WatchUi.loadResource(Rez.Strings.since);
		string_until = WatchUi.loadResource(Rez.Strings.until);
		string_kcal = WatchUi.loadResource(Rez.Strings.kcal);
		string_overtime = WatchUi.loadResource(Rez.Strings.overtime);
		string_nominalization = WatchUi.loadResource(Rez.Strings.nominalization);
		
		if (string_nominalization.equals("y")) {
			nominalization = true;
		} else {
			nominalization = false;
		}
		
		string_fast_type_menu_title = WatchUi.loadResource(Rez.Strings.fast_type_menu_title);
		string_fast_set_goal = WatchUi.loadResource(Rez.Strings.fast_set_goal);
		string_fast_no_goal = WatchUi.loadResource(Rez.Strings.fast_no_goal);
		string_end_fast_title = WatchUi.loadResource(Rez.Strings.end_fast_title);
		string_yes = WatchUi.loadResource(Rez.Strings.yes);
		string_no = WatchUi.loadResource(Rez.Strings.no);
		string_cancel_fast_title = WatchUi.loadResource(Rez.Strings.cancel_fast_title);
		string_goal_menu_title = WatchUi.loadResource(Rez.Strings.goal_menu_title);
		
		symbol_days = WatchUi.loadResource(Rez.Strings.symbol_days);
		symbol_hours = WatchUi.loadResource(Rez.Strings.symbol_hours);
		symbol_minutes = WatchUi.loadResource(Rez.Strings.symbol_minutes);
		symbol_seconds = WatchUi.loadResource(Rez.Strings.symbol_seconds);
		string_days = WatchUi.loadResource(Rez.Strings.days);
	}
}


