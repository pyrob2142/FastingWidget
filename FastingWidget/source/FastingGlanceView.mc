using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Timer;

(:glance)
class FastingGlanceView extends WatchUi.GlanceView {
    var streak_data;
    var is_active;
    var start_data;
    var last_fast_data;
    var m_start;
    var goal_data;
    var d_goal;
    var elapsed;
    var remaining;
    var progress;
    var streak_goal;
    var streak_reset_threshold;
    var streak_inc_threshold;
    var single_color_progress;
    var string_streak;
    var string_elapsed;
    var string_remaining;
    var string_overtime;
    var string_last_fast;
    var string_fasting;
    var time_format;
    var show_days;
    var symbol_days;
    var symbol_hours;
    var symbol_minutes;
    var symbol_seconds;
    var m_now;
    var timer;
    var show_seconds;
    var update_rate;
    var show_time_since_last;
    var m_last_fast;
    var elapsed_since_last_fast;
 	var streak_progress;

    function initialize() {
        GlanceView.initialize();
        load();

        if (is_active == true || show_time_since_last == true) {
            timer = new Timer.Timer();
            timer.start(me.method(:update), update_rate, true);
        }
        
        if (streak_goal != 0) {
        	streak_progress = streak_data / streak_goal.toFloat();
        }
    }

    function onUpdate(dc) {
        var center_y = dc.getHeight() / 2;
        var bar_color;

        m_now = Time.now();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        if (is_active == false) {

			if (show_time_since_last == true) {
				elapsed_since_last_fast = m_now.subtract(m_last_fast);
				
				if (streak_goal != 0) {
					dc.drawText(0, -5, Graphics.FONT_SYSTEM_TINY, string_streak + ":", Graphics.TEXT_JUSTIFY_LEFT);
           			dc.drawText(dc.getWidth(), -5, Graphics.FONT_SYSTEM_TINY, streak_data + "/" + streak_goal, Graphics.TEXT_JUSTIFY_RIGHT);
            		dc.drawRectangle(0, center_y - 3, dc.getWidth(), 7);
            		dc.fillRectangle(0, center_y - 3, dc.getWidth() * streak_progress, 7);
            		if (streak_data >= streak_goal) {
            			dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
            			dc.fillRectangle(0, center_y - 3, dc.getWidth(), 7);
            			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            		}
            		
            		dc.drawText(0, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY), Graphics.FONT_SYSTEM_XTINY, string_last_fast + ":", Graphics.TEXT_JUSTIFY_LEFT);
            		dc.drawText(dc.getWidth(), dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY), Graphics.FONT_SYSTEM_XTINY, convertSeconds(elapsed_since_last_fast.value()), Graphics.TEXT_JUSTIFY_RIGHT);
				} else {
					dc.drawText(0, 3, Graphics.FONT_SYSTEM_TINY, string_streak + ":", Graphics.TEXT_JUSTIFY_LEFT);
					dc.drawText(dc.getWidth(), 3, Graphics.FONT_SYSTEM_TINY, streak_data, Graphics.TEXT_JUSTIFY_RIGHT);
					
					dc.drawText(0, dc.getHeight() - 10 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY), Graphics.FONT_SYSTEM_XTINY, string_last_fast + ":", Graphics.TEXT_JUSTIFY_LEFT);
            		dc.drawText(dc.getWidth(), dc.getHeight() - 10 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY), Graphics.FONT_SYSTEM_XTINY, convertSeconds(elapsed_since_last_fast.value()), Graphics.TEXT_JUSTIFY_RIGHT);
				}
			} else {
				if (streak_goal != 0) {
					dc.drawText(0, 7, Graphics.FONT_SYSTEM_TINY, string_streak + ":", Graphics.TEXT_JUSTIFY_LEFT);
           			dc.drawText(dc.getWidth(), 7, Graphics.FONT_SYSTEM_TINY, streak_data + "/" + streak_goal, Graphics.TEXT_JUSTIFY_RIGHT);
            		dc.drawRectangle(0, center_y + 7, dc.getWidth(), 7);
            		dc.fillRectangle(0, center_y + 7, dc.getWidth() * streak_progress, 7);
            		if (streak_data >= streak_goal) {
            			dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
            			dc.fillRectangle(0, center_y + 7, dc.getWidth(), 7);
            			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            		}
            	} else {
					dc.drawText(0, center_y - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2, Graphics.FONT_SMALL, string_streak + ":", Graphics.TEXT_JUSTIFY_LEFT);
					dc.drawText(dc.getWidth(), center_y - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2, Graphics.FONT_SMALL, streak_data, Graphics.TEXT_JUSTIFY_RIGHT);
				}
			}
        } else {
            dc.drawText(0, -5, Graphics.FONT_SYSTEM_TINY, string_fasting.toUpper(), Graphics.TEXT_JUSTIFY_LEFT);
            elapsed = m_now.subtract(m_start);
            if (goal_data != -1) {
                remaining = d_goal.subtract(elapsed);
                progress  = elapsed.value() / d_goal.value().toFloat();

                var mode_label = string_remaining;
                var m_goal = m_start.add(d_goal);
                var bar_color;

                if (m_now.greaterThan(m_goal)) {
                    mode_label = string_overtime;
                }

                dc.drawText(dc.getWidth(), -5, Graphics.FONT_SYSTEM_TINY, (progress * 100.0).format("%.1f") + "%", Graphics.TEXT_JUSTIFY_RIGHT);

                dc.setColor(Graphics.COLOR_LT_GRAY  , Graphics.COLOR_BLACK);
                dc.drawRectangle(0, center_y - 3, dc.getWidth(), 7);

                if (single_color_progress == false) {
                    if (progress < 1.0) {

                        bar_color = Graphics.COLOR_RED;
                        dc.setColor(bar_color, Graphics.COLOR_BLACK);
                        dc.fillRectangle(0, center_y - 3, dc.getWidth() * progress, 7);

                        if (progress >= streak_reset_threshold) {
                            bar_color = Graphics.COLOR_YELLOW;
                            dc.setColor(bar_color, Graphics.COLOR_BLACK);
                            dc.fillRectangle(dc.getWidth() * streak_reset_threshold + 1, center_y - 3, dc.getWidth() * (progress - streak_reset_threshold), 7);
                        }

                        if (progress >= streak_inc_threshold) {
                            bar_color = Graphics.COLOR_GREEN;
                            dc.setColor(bar_color, Graphics.COLOR_BLACK);
                            dc.fillRectangle(dc.getWidth() * streak_inc_threshold + 1, center_y - 3, dc.getWidth() * (progress - streak_inc_threshold), 7);
                        }
                    } else {
                        bar_color = Graphics.COLOR_DK_GREEN;
                        dc.setColor(bar_color, Graphics.COLOR_BLACK);
                        dc.fillRectangle(0, dc.getHeight() / 2 - 3, dc.getWidth(), 8);

                        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
                        dc.fillRectangle(0, dc.getHeight() / 2 - 5, dc.getWidth() * (progress - 1.0), 12);
                    }
                } else {
                    if (progress > 1.0) {
                        bar_color = Graphics.COLOR_DK_GREEN;
                    } else if (progress >= streak_inc_threshold) {
                        bar_color = Graphics.COLOR_GREEN;
                    } else if (progress >= streak_reset_threshold) {
                        bar_color = Graphics.COLOR_YELLOW;
                    } else {
                        bar_color = Graphics.COLOR_RED;
                    }

                    dc.setColor(bar_color, Graphics.COLOR_BLACK);
                    dc.fillRectangle(0, dc.getHeight() / 2 - 3, dc.getWidth() * progress, 8);

                    if (progress > 1.0) {
                        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
                        dc.fillRectangle(0, dc.getHeight() / 2 - 5, dc.getWidth() * (progress - 1.0), 12);
                    }
                }

                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                dc.drawText(0, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY), Graphics.FONT_SYSTEM_XTINY, mode_label + ": ", Graphics.TEXT_JUSTIFY_LEFT);
                dc.drawText(dc.getWidth(), dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY), Graphics.FONT_SYSTEM_XTINY, convertSeconds(remaining.value()), Graphics.TEXT_JUSTIFY_RIGHT);
            } else {
                dc.drawText(0, dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY), Graphics.FONT_SYSTEM_XTINY, string_elapsed + ": ", Graphics.TEXT_JUSTIFY_LEFT);
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
                dc.fillRectangle(0, dc.getHeight()/2 - 3, dc.getWidth(), 8 );
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
                dc.drawText(dc.getWidth(), dc.getHeight() - 5 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY), Graphics.FONT_SYSTEM_XTINY, convertSeconds(elapsed.value()), Graphics.TEXT_JUSTIFY_RIGHT);
            }
        }
    }

    function load() {
        // Lower the update rate and hide seconds due to hardware limitations
        var part_number = System.getDeviceSettings().partNumber;
        var unsupported_devices = [
            "006-B3289-00", // Fenix 6
            "006-B3514-00", // Fenix 6 APAC
            "006-B3287-00", // Fenix 6S
            "006-B3512-00", // Fenix 6S APAC
            "006-B3288-00", // Fenix 6S Pro (not enough space)
            "006-B3513-00", // Fenix 6S Pro APAC (not enough space)
            "006-B3624-00", // MARQ Adventurer
            "006-B3648-00", // MARQ Adventurer APAC
            "006-B3251-00", // MARQ Athlete
            "006-B3451-00", // MARQ Athlete APAC
            "006-B3247-00", // MARQ Aviator
            "006-B3421-00", // MARQ Aviator APAC
            "006-B3248-00", // MARQ Captain
            "006-B3448-00", // MARQ Captain APAC
            "006-B3249-00", // MARQ Commander
            "006-B3449-00", // MARQ Commander APAC
            "006-B3246-00", // MARQ Driver
            "006-B3420-00", // MARQ Driver APAC
            "006-B3250-00", // MARQ Expedition
            "006-B3450-00"  // MARQ Expedition APAC
        ];

        if (unsupported_devices.indexOf(part_number) != -1) {
            show_seconds = false;
            update_rate = 60000;
        } else {
            show_seconds = Application.AppBase.getProperty("show_seconds");

            if (show_seconds == true) {
                update_rate = 1000;
            } else {
                update_rate = 60000;
            }
        }
		
        streak_data = Application.AppBase.getProperty("streak_data").toNumber();
        streak_goal = Application.AppBase.getProperty("streak_goal").toNumber();
        
        streak_reset_threshold = Application.AppBase.getProperty("streak_reset_threshold");
        streak_inc_threshold = Application.AppBase.getProperty("streak_inc_threshold");
        single_color_progress = Application.AppBase.getProperty("single_color_progress");
 
        show_time_since_last = Application.AppBase.getProperty("show_time_since_last");
		if (show_time_since_last == true) {        
	        last_fast_data = Storage.getValue("last_fast_data");
	        if (last_fast_data == null || last_fast_data < 1) {
	           show_time_since_last = false;
	        } else { 
	        	m_last_fast = new Time.Moment(last_fast_data); 
	        }
	    }

        is_active = Storage.getValue("is_active");
        if (is_active == null) {
            is_active = false;
        }

        start_data = Storage.getValue("start_data");
        if (start_data == -1 || start_data == null) {
            start_data = -1;
        } else {
            m_start = new Time.Moment(start_data);
        }

        goal_data = Storage.getValue("goal_data");
        
       	// Uncomment for debug fasts
        // COMMENT BEFORE COMMITTING!
        //goal_data = 108; // 2 min
		//goal_data = 270; // 5 min
		//goal_data = 540; // 10 min
		
        if (goal_data == -1 || goal_data == null) {
            goal_data = -1;
        } else {
            d_goal = new Time.Duration(goal_data);
        }

        streak_reset_threshold = Application.AppBase.getProperty("streak_reset_threshold") / 100.0;
        streak_inc_threshold = Application.AppBase.getProperty("streak_inc_threshold") / 100.0;
        string_streak = WatchUi.loadResource(Rez.Strings.streak);
        string_elapsed = WatchUi.loadResource(Rez.Strings.elapsed);
        string_remaining = WatchUi.loadResource(Rez.Strings.remaining);
        string_fasting = WatchUi.loadResource(Rez.Strings.fasting_title);
        string_last_fast = WatchUi.loadResource(Rez.Strings.last_fast_title);
        string_overtime = WatchUi.loadResource(Rez.Strings.overtime);
        time_format = Application.AppBase.getProperty("time_format");
        show_days = Application.AppBase.getProperty("show_days");
        symbol_days = WatchUi.loadResource(Rez.Strings.symbol_days);
        symbol_hours = WatchUi.loadResource(Rez.Strings.symbol_hours);
        symbol_minutes = WatchUi.loadResource(Rez.Strings.symbol_minutes);
        symbol_seconds = WatchUi.loadResource(Rez.Strings.symbol_seconds);
    }

    function convertSeconds(value) {
        var n = value;

        if (time_format == 0) {
            if (n / 3600 >= show_days) {
                var days = n / (24 * 3600);
                n = n % (24 * 3600);

                var hours = n / 3600;
                n = n % 3600;

                var minutes = n / 60;
                n = n % 60;


                return days.format("%d") + symbol_days + " " + hours.format("%d")
                    + symbol_hours + " " + minutes.format("%02d") + symbol_minutes;
            } else {
                var hours = n / 3600;
                n = n % 3600;

                var minutes = n / 60;
                n = n % 60;

                if (show_seconds == true) {
                    var seconds = n;
                    return hours.format("%d") + symbol_hours + " " + minutes.format("%02d")
                        + symbol_minutes + " " + seconds.format("%02d") + symbol_seconds;
                } else {
                    return hours.format("%d") + symbol_hours + " " + minutes.format("%02d")
                        + symbol_minutes;
                }
            }
        } else {
            if (n / 3600 >= show_days) {
                var days = n / (24 * 3600);
                n = n % (24 * 3600);

                var hours = n / 3600;
                n = n % 3600;

                var minutes = n / 60;
                n = n % 60;

                return days.format("%02d") + ":" + hours.format("%02d") + ":" + minutes.format("%02d");
            } else {
                var hours = n / 3600;
                n = n % 3600;

                var minutes = n / 60;
                n = n % 60;

                if (show_seconds == true) {
                    var seconds = n;
                    return hours.format("%02d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
                } else {
                    return hours.format("%02d") + ":" + minutes.format("%02d");
                }
            }
        }
    }

    function update() {
        WatchUi.requestUpdate();
    }
}
