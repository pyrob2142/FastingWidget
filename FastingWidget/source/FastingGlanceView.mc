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
    var m_start;
    var goal_data;
    var d_goal;
    var elapsed;
    var remaining;
    var progress;
    var streak_reset_threshold;
    var streak_inc_threshold;
    var string_streak;
    var string_elapsed;
    var string_remaining;
    var string_overtime;
    var string_fasting;
    var time_format;
    var show_days;
    var symbol_days;
    var symbol_hours;
    var symbol_minutes;
    var symbol_seconds;
    var m_now;
    var timer;
    var streak_inc_threshold;
    var streak_reset_threshold;

    function initialize() {
        GlanceView.initialize();
        load();

        if (is_active == true) {
            timer = new Timer.Timer();
            timer.start(me.method(:update), 1000, true);
        }
    }

    function onUpdate(dc) {
        var center_y = dc.getHeight() / 2;
        var bar_color;
        var percent;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        if (is_active == false) {
            dc.drawText(0, center_y - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2, Graphics.FONT_SMALL, string_streak + ": " + streak_data, Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            m_now = Time.now();
            elapsed = m_now.subtract(m_start);
            
            dc.drawText(0, -5, Graphics.FONT_SYSTEM_TINY, string_fasting.toUpper(), Graphics.TEXT_JUSTIFY_LEFT);

            if (goal_data != -1) {
                remaining = d_goal.subtract(elapsed);
                progress  = elapsed.value() / d_goal.value().toFloat();
                percent = (progress * 100).toNumber();

                var mode_label = string_remaining;
                var m_goal = m_start.add(d_goal);
                var bar_color;

                if (m_now.greaterThan(m_goal)) {
                    mode_label = string_overtime;
                }

                dc.drawText(dc.getWidth(), -5, Graphics.FONT_SYSTEM_TINY, (progress * 100.0).format("%.1f") + "%", Graphics.TEXT_JUSTIFY_RIGHT);

                dc.setColor(Graphics.COLOR_LT_GRAY  , Graphics.COLOR_BLACK);
                dc.fillRectangle(0, dc.getHeight() / 2, dc.getWidth(), 2);
                
                if (progress < 1.0) {
					bar_color = Graphics.COLOR_RED;
					dc.setColor(bar_color, Graphics.COLOR_BLACK);
					dc.fillRectangle(0, center_y - 3, dc.getWidth() * progress, 7);
										
					if (percent > streak_reset_threshold) {
						bar_color = Graphics.COLOR_YELLOW;
						dc.setColor(bar_color, Graphics.COLOR_BLACK);
						dc.fillRectangle(dc.getWidth() * streak_reset_threshold / 100, center_y - 3, dc.getWidth() * progress, 7);
					} 
					
					if (percent > streak_inc_threshold) {
						bar_color = Graphics.COLOR_GREEN;
						dc.setColor(bar_color, Graphics.COLOR_BLACK);
						dc.fillRectangle(dc.getWidth() * streak_inc_threshold / 100, center_y - 3, dc.getWidth() * progress, 7);
					}
                } else (progress > 1.0) {
					bar_color = Graphics.COLOR_DK_GREEN;
                    dc.setColor(bar_color, Graphics.COLOR_BLACK);
                    dc.fillRectangle(0, dc.getHeight() / 2 - 3, dc.getWidth(), 8);
                    
                    dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
                	dc.fillRectangle(0, dc.getHeight() / 2 - 5, dc.getWidth() * (progress - 1.0), 12);
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
        streak_data = Application.AppBase.getProperty("streak_data").toNumber();
        streak_reset_threshold = Application.AppBase.getProperty("streak_reset_threshold");
        streak_inc_threshold = Application.AppBase.getProperty("streak_inc_threshold");

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

                var seconds = n;
                return days.format("%d") + symbol_days + " " + hours.format("%d")
                    + symbol_hours + " " + minutes.format("%02d") + symbol_minutes;
            } else {
                var hours = n / 3600;
                n = n % 3600;

                var minutes = n / 60;
                n = n % 60;

                var seconds = n;
                return hours.format("%d") + symbol_hours + " " + minutes.format("%02d")
                    + symbol_minutes + " " + seconds.format("%02d") + symbol_seconds;
            }
        } else {
            if (n / 3600 >= show_days) {
                var days = n / (24 * 3600);
                n = n % (24 * 3600);

                var hours = n / 3600;
                n = n % 3600;

                var minutes = n / 60;
                n = n % 60;

                var seconds = n;
                return days.format("%02d") + ":" + hours.format("%02d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
            } else {
                var hours = n / 3600;
                n = n % 3600;

                var minutes = n / 60;
                n = n % 60;

                var seconds = n;
                return hours.format("%02d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
            }
        }
    }

    function update() {
        WatchUi.requestUpdate();
    }
}
