using Toybox.Graphics;

class FastingView extends FastingViewBase {
    function initialize() {
        FastingViewBase.initialize();
        configureLayout();
    }

    function configureLayout() {
        FastingViewBase.configureLayout();
        layout[:summary_title] = [-120, Graphics.FONT_SMALL];
        layout[:summary_duration] = [-60, Graphics.FONT_TINY];
        layout[:summary_duration_value] = [-15, Graphics.FONT_MEDIUM];
        layout[:summary_calories] = [50, Graphics.FONT_TINY];
        layout[:summary_calories_value] = [95, Graphics.FONT_MEDIUM];
        layout[:streak_increment_title] = [-120, Graphics.FONT_SMALL];
        layout[:streak_increment_next] = [-60, Graphics.FONT_NUMBER_MILD];
        layout[:streak_increment_current] = [30, Graphics.FONT_NUMBER_HOT];
        layout[:streak_increment_previous] = [124, Graphics.FONT_NUMBER_MILD];
        layout[:streak_reset_title] = [-120, Graphics.FONT_SMALL];
        layout[:streak_reset_previous] = [115, Graphics.FONT_NUMBER_MEDIUM];
        layout[:streak_title] = [-40, Graphics.FONT_MEDIUM];
        layout[:streak_last_fast] = [95, Graphics.FONT_SMALL];
        layout[:streak_fast_label] = [95, Graphics.FONT_MEDIUM];
        layout[:open_mode] = [-120, Graphics.FONT_TINY];
        layout[:open_time] = [-60, Graphics.FONT_MEDIUM];
        layout[:open_start] = [90, Graphics.FONT_MEDIUM];
        layout[:goal_mode] = [-120, Graphics.FONT_TINY];
        layout[:goal_time] = [-60, Graphics.FONT_MEDIUM];
        layout[:goal_date] = [60, Graphics.FONT_MEDIUM];
        layout[:goal_progress] = [124, Graphics.FONT_MEDIUM];
        layout[:calories_value] = [29, Graphics.FONT_NUMBER_HOT];
        layout[:calories_units] = [115, Graphics.FONT_MEDIUM];
        pen_width_regular = 12;
        pen_width_overtime = 25;
        pen_width_streak_goal = 12;
        calories_icon_offset_x = -52;
        calories_icon_offset_y = -140;
    }
}
