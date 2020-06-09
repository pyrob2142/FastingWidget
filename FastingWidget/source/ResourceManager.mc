using Toybox.Graphics;
using Toybox.WatchUi;
using Toybox.UserProfile;
using Toybox.System;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Time.Gregorian;

//! Handles resources, settings and loading and saving of fasts.
class ResourceManager {
    //! The different forumulas for BMR calculation
    enum {
        MIFFLIN,
        HARRIS,
        KATCH
    }

    var goal_hours = [8, 12, 14, 16, 20, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 144, 156, 168, 336, 504, 672];
    var toolbox;
    var fast_manager;

    //! Settings
    var longpress_threshold;
    var show_seconds;
    var update_rate;
    var default_page_goal;
    var default_page_no_goal;
    var default_goal_hours;
    var default_goal;
    var custom_goal_1;
    var custom_goal_2;
    var custom_goal_3;

    var bmr_formula;
    var custom_bmr;
    var streak_reset_threshold;
    var streak_inc_threshold;
    var single_color_progress;
    var time_format;
    var show_days;

    //! User profile data
    var user;
    var activity_level;
    var weight;
    var height;
    var age;
    var gender;
    var bmi;
    var body_fat;

    //! Fast data
    var is_active;
    var start_data;
    var goal_data;
    var streak_data;
    var last_fast;

    //! Resources
    var bitmap_burn;

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
    var string_options_title;
    var string_sure_title;

    var string_hour;
    var string_hours;
    var string_day;
    var string_days;
    var string_week;
    var string_weeks;
    var symbol_days;
    var symbol_hours;
    var symbol_minutes;
    var symbol_seconds;
    var string_date_format;

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
    }

    //! Loads the user settings.
    function loadSettings() {
        longpress_threshold = Application.AppBase.getProperty("longpress_threshold");
        show_seconds = Application.AppBase.getProperty("show_seconds");
        if (show_seconds == true) {
            update_rate = 1000;
        } else {
            update_rate = 60000;
        }

        default_page_goal = Application.AppBase.getProperty("default_page_goal");
        default_page_no_goal = Application.AppBase.getProperty("default_page_no_goal");

        default_goal = Application.AppBase.getProperty("default_goal");

        custom_goal_1 = Application.AppBase.getProperty("custom_goal_1");
        custom_goal_2 = Application.AppBase.getProperty("custom_goal_2");
        custom_goal_3 = Application.AppBase.getProperty("custom_goal_3");

        if (custom_goal_1 != 0) {
            goal_hours.add(custom_goal_1);
        }
        if (custom_goal_2 != 0) {
            goal_hours.add(custom_goal_2);
        }
        if (custom_goal_3 != 0) {
            goal_hours.add(custom_goal_3);
        }

        toolbox.sort(goal_hours, 0, goal_hours.size() - 1);

        streak_reset_threshold = Application.AppBase.getProperty("streak_reset_threshold") / 100.0;
        streak_inc_threshold = Application.AppBase.getProperty("streak_inc_threshold") / 100.0;
        single_color_progress = Application.AppBase.getProperty("single_color_progress");

        streak_data = Application.AppBase.getProperty("streak_data");

        var overwrite_date_format = Application.AppBase.getProperty("overwrite_date_format");

        if (overwrite_date_format != null && overwrite_date_format.length == 8) {
            string_date_format = overwrite_date_format;
        }

        time_format = Application.AppBase.getProperty("time_format");
        show_days = Application.AppBase.getProperty("show_days");

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

        bmr_formula = Application.AppBase.getProperty("bmr_formula");
        custom_bmr = Application.AppBase.getProperty("custom_bmr");
        body_fat = Application.AppBase.getProperty("body_fat");
    }

    //! Saves the current state of the fast, as well as the streak.
    function save() {
        Application.AppBase.setProperty("streak_data", fast_manager.streak);

        if (fast_manager.fast.is_active == true) {
            Storage.setValue("is_active", true);
            Storage.setValue("start_data", fast_manager.fast.m_start.value());
        } else {
            Storage.setValue("last_fast", fast_manager.last_fast.value());
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
        last_fast = Storage.getValue("last_fast");

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
    }

    //! Loads all necessary resources.
    function loadResources() {
        bitmap_burn = WatchUi.loadResource(Rez.Drawables.burn);

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
        string_options_title = WatchUi.loadResource(Rez.Strings.options_title);
        string_sure_title = WatchUi.loadResource(Rez.Strings.sure_title);

        string_hour = WatchUi.loadResource(Rez.Strings.string_hour);
        string_hours = WatchUi.loadResource(Rez.Strings.string_hours);
        string_day = WatchUi.loadResource(Rez.Strings.string_day);
        string_days = WatchUi.loadResource(Rez.Strings.string_days);
        string_week = WatchUi.loadResource(Rez.Strings.string_week);
        string_weeks = WatchUi.loadResource(Rez.Strings.string_weeks);
        symbol_days = WatchUi.loadResource(Rez.Strings.symbol_days);
        symbol_hours = WatchUi.loadResource(Rez.Strings.symbol_hours);
        symbol_minutes = WatchUi.loadResource(Rez.Strings.symbol_minutes);
        symbol_seconds = WatchUi.loadResource(Rez.Strings.symbol_seconds);
        string_date_format = WatchUi.loadResource(Rez.Strings.default_date_format);
    }
}


