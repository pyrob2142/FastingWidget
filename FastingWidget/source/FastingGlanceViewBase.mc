using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application.Storage;
using Toybox.Time;
using Toybox.Timer;

(:glance)
class FastingGlanceViewBase extends WatchUi.GlanceView {
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
    var string_fast_streak;
    var string_elapsed;
    var string_remaining;
    var string_overtime;
    var string_last_fast;
    var string_not_available;
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
 	var layout;

    function initialize() {
        GlanceView.initialize();
        load();

        streak_progress = 0.0;
        if (streak_goal > 0) {
            streak_progress = streak_data / (streak_goal * 1.0);
        }
    }

    function startUpdates() {
        if (is_active == true || show_time_since_last == true) {
            timer = new Timer.Timer();
            timer.start(me.method(:update), update_rate, true);
        }
    }

    function configureLayout() {
        layout = {
            :active_top_text => [-5, Graphics.FONT_SYSTEM_TINY],
            :active_bottom_padding => 5,
            :active_bottom_font => Graphics.FONT_SYSTEM_XTINY,
            :idle_last_bottom_padding => 5,
            :idle_last_bottom_font => Graphics.FONT_SYSTEM_XTINY,
            :idle_top_bottom_padding => 10,
            :idle_top_bottom_font => Graphics.FONT_SYSTEM_XTINY,
            :regular_bar_height => 7,
            :bar_offset => 3,
            :overtime_bar_height => 8
        };
    }

    function drawLeftText(dc, y, font, text) {
        dc.drawText(0, y, font, text, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawRightText(dc, y, font, text) {
        dc.drawText(dc.getWidth(), y, font, text, Graphics.TEXT_JUSTIFY_RIGHT);
    }

    function drawBottomTexts(dc, padding, font, left_text, right_text) {
        var y = getBottomTextY(dc, padding, font);
        drawLeftText(dc, y, font, left_text);
        drawRightText(dc, y, font, right_text);
    }

    function getBottomTextY(dc, padding, font) {
        return dc.getHeight() - padding - Graphics.getFontHeight(font);
    }

    function onUpdate(dc) {
        var center_y = dc.getHeight() / 2;
        var bar_color;

        m_now = Time.now();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (is_active == false) {
            if (show_time_since_last == true) {
                var last_fast_text;
                if (last_fast_data == null || last_fast_data < 1) {
                    last_fast_text = string_not_available;
                } else {
                    elapsed_since_last_fast = m_now.subtract(m_last_fast);
                    last_fast_text = convertSeconds(elapsed_since_last_fast.value());
                }

                if (streak_goal != 0) {
                    var active_top_text = layout[:active_top_text];
                    drawLeftText(dc, active_top_text[0], active_top_text[1], string_fast_streak + ":");
                    drawRightText(dc, active_top_text[0], active_top_text[1], streak_data + "/" + streak_goal);
                    drawIdleGoalProgress(dc, center_y);
                    drawBottomTexts(dc, layout[:idle_last_bottom_padding], layout[:idle_last_bottom_font],
                        string_last_fast + ":", last_fast_text);
                } else {
                    var active_top_text = layout[:active_top_text];
                    drawLeftText(dc, active_top_text[0], active_top_text[1], string_fast_streak + ":");
                    drawRightText(dc, active_top_text[0], active_top_text[1], streak_data);
                    drawBottomTexts(dc, layout[:idle_top_bottom_padding], layout[:idle_top_bottom_font],
                        string_last_fast + ":", last_fast_text);
                }
            } else {
                if (streak_goal != 0) {
                    var active_top_text = layout[:active_top_text];
                    drawLeftText(dc, active_top_text[0], active_top_text[1], string_fast_streak + ":");
                    drawRightText(dc, active_top_text[0], active_top_text[1], streak_data + "/" + streak_goal);
                    drawIdleGoalProgress(dc, center_y);
                } else {
                    var active_top_text = layout[:active_top_text];
                    drawLeftText(dc, active_top_text[0], active_top_text[1], string_fast_streak + ":");
                    drawRightText(dc, active_top_text[0], active_top_text[1], streak_data);
                }
            }
        } else {
            var active_top_text = layout[:active_top_text];
            drawLeftText(dc, active_top_text[0], active_top_text[1], string_fasting.toUpper());
            elapsed = m_now.subtract(m_start);
            if (goal_data != -1) {
                remaining = d_goal.subtract(elapsed);
                progress  = elapsed.value() / d_goal.value().toFloat();

                var mode_label = string_remaining;
                var m_goal = m_start.add(d_goal);

                if (m_now.greaterThan(m_goal)) {
                    mode_label = string_overtime;
                }

                drawRightText(dc, active_top_text[0], active_top_text[1], (progress * 100.0).format("%.1f") + "%");

                dc.setColor(Graphics.COLOR_LT_GRAY  , Graphics.COLOR_TRANSPARENT);
                var bar_y = center_y - layout[:bar_offset];
                var regular_bar_height = layout[:regular_bar_height];
                var overtime_bar_height = layout[:overtime_bar_height];
                var overtime_bar_y = bar_y - (overtime_bar_height - regular_bar_height) / 2;
                var overtime_progress = progress - 1.0;
                if (overtime_progress > 1.0) {
                    overtime_progress = 1.0;
                }
                dc.drawRectangle(0, bar_y, dc.getWidth(), regular_bar_height);

                if (single_color_progress == false) {
                    if (progress < 1.0) {

                        bar_color = Graphics.COLOR_RED;
                        dc.setColor(bar_color, Graphics.COLOR_TRANSPARENT);
                        dc.fillRectangle(0, bar_y, dc.getWidth() * progress, regular_bar_height);

                        if (progress >= streak_reset_threshold) {
                            bar_color = Graphics.COLOR_YELLOW;
                            dc.setColor(bar_color, Graphics.COLOR_TRANSPARENT);
                            dc.fillRectangle(dc.getWidth() * streak_reset_threshold + 1, bar_y, dc.getWidth() * (progress - streak_reset_threshold), regular_bar_height);
                        }

                        if (progress >= streak_inc_threshold) {
                            bar_color = Graphics.COLOR_GREEN;
                            dc.setColor(bar_color, Graphics.COLOR_TRANSPARENT);
                            dc.fillRectangle(dc.getWidth() * streak_inc_threshold + 1, bar_y, dc.getWidth() * (progress - streak_inc_threshold), regular_bar_height);
                        }
                    } else {
                        bar_color = Graphics.COLOR_DK_GREEN;
                        dc.setColor(bar_color, Graphics.COLOR_TRANSPARENT);
                        dc.fillRectangle(0, overtime_bar_y, dc.getWidth(), regular_bar_height);

                        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
                        dc.fillRectangle(0, bar_y, dc.getWidth() * overtime_progress, overtime_bar_height);
                    }
                } else {
                    var active_bar_height = regular_bar_height;
                    var active_bar_y = bar_y;
                    var active_bar_width = dc.getWidth() * progress;

                    if (progress > 1.0) {
                        bar_color = Graphics.COLOR_DK_GREEN;
                        active_bar_width = dc.getWidth();
                    } else if (progress >= streak_inc_threshold) {
                        bar_color = Graphics.COLOR_GREEN;
                    } else if (progress >= streak_reset_threshold) {
                        bar_color = Graphics.COLOR_YELLOW;
                    } else {
                        bar_color = Graphics.COLOR_RED;
                    }

                    dc.setColor(bar_color, Graphics.COLOR_TRANSPARENT);
                    dc.fillRectangle(0, active_bar_y, active_bar_width, active_bar_height);

                    if (progress > 1.0) {
                        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
                        dc.fillRectangle(0, overtime_bar_y, dc.getWidth() * overtime_progress, overtime_bar_height);
                    }
                }

                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                var active_bottom_font = layout[:active_bottom_font];
                drawBottomTexts(dc, layout[:active_bottom_padding], active_bottom_font,
                    mode_label + ": ", convertSeconds(remaining.value()));
            } else {
                var active_bottom_font_no_goal = layout[:active_bottom_font];
                var active_bottom_y_no_goal = getBottomTextY(dc, layout[:active_bottom_padding], active_bottom_font_no_goal);
                drawLeftText(dc, active_bottom_y_no_goal, active_bottom_font_no_goal, string_elapsed + ": ");
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(0, center_y - layout[:bar_offset],
                    dc.getWidth(), layout[:regular_bar_height]);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                drawRightText(dc, active_bottom_y_no_goal, active_bottom_font_no_goal, convertSeconds(elapsed.value()));
            }
        }
    }

    function drawIdleGoalProgress(dc, center_y) {
        var regular_bar_height = layout[:regular_bar_height];
        var overtime_bar_height = layout[:overtime_bar_height];
        var bar_y = center_y - layout[:bar_offset];

        if (streak_data > streak_goal) {
            var overtime_progress = streak_progress - 1.0;
            if (overtime_progress > 1.0) {
                overtime_progress = 1.0;
            }

            var overtime_bar_y = bar_y - (overtime_bar_height - regular_bar_height) / 2;
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(0, bar_y, dc.getWidth(), regular_bar_height);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(0, overtime_bar_y, dc.getWidth() * overtime_progress, overtime_bar_height);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawRectangle(0, bar_y, dc.getWidth(), regular_bar_height);

            if (streak_data >= streak_goal) {
                dc.fillRectangle(0, bar_y, dc.getWidth(), regular_bar_height);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(0, bar_y, dc.getWidth() * streak_progress, regular_bar_height);
            }
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
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
            show_seconds = Application.Properties.getValue("show_seconds");

            if (show_seconds == true) {
                update_rate = 1000;
            } else {
                update_rate = 60000;
            }
        }

        streak_data = Application.Properties.getValue("streak_data");
        if (streak_data == null || streak_data == "") {
            streak_data = 0;
        }
        var streak_goal_value = Application.Properties.getValue("streak_goal");
        if (streak_goal_value == null || streak_goal_value == "") {
            streak_goal = 0;
        } else {
            streak_goal = streak_goal_value;
        }
        streak_reset_threshold = Application.Properties.getValue("streak_reset_threshold");
        streak_inc_threshold = Application.Properties.getValue("streak_inc_threshold");
        single_color_progress = Application.Properties.getValue("single_color_progress");

        show_time_since_last = Application.Properties.getValue("show_time_since_last");
		if (show_time_since_last == true) {
	        last_fast_data = Storage.getValue("last_fast_data");
	        if (last_fast_data != null && last_fast_data > 0) {
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
        // goal_data = 108; // 2 min
		//goal_data = 270; // 5 min
		//goal_data = 540; // 10 min

        if (goal_data == -1 || goal_data == null) {
            goal_data = -1;
        } else {
            d_goal = new Time.Duration(goal_data);
        }

        streak_reset_threshold = Application.Properties.getValue("streak_reset_threshold") / 100.0;
        streak_inc_threshold = Application.Properties.getValue("streak_inc_threshold") / 100.0;
        string_fast_streak = WatchUi.loadResource(Rez.Strings.fast_streak);
        string_elapsed = WatchUi.loadResource(Rez.Strings.elapsed);
        string_remaining = WatchUi.loadResource(Rez.Strings.remaining);
        string_fasting = WatchUi.loadResource(Rez.Strings.fasting_title);
        string_last_fast = WatchUi.loadResource(Rez.Strings.last_fast_title);
        string_not_available = WatchUi.loadResource(Rez.Strings.not_available);
        string_overtime = WatchUi.loadResource(Rez.Strings.overtime);
        time_format = Application.Properties.getValue("time_format");
        show_days = Application.Properties.getValue("show_days");
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

    function update() as Void {
        WatchUi.requestUpdate();
    }
}
