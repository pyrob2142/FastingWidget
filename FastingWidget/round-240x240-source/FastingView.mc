using Toybox.Graphics;

class FastingView extends FastingViewBase {
    function initialize() {
        FastingViewBase.initialize();
        configureLayout();
    }

    function configureLayout() {
        FastingViewBase.configureLayout();
        layout[:streak_increment_next] = [-33, Graphics.FONT_NUMBER_MILD];
        layout[:streak_reset_zero] = [-8, Graphics.FONT_NUMBER_THAI_HOT];
        layout[:calories_value] = [10, Graphics.FONT_NUMBER_HOT];
        pen_width_regular = 9;
        pen_width_overtime = 20;
        pen_width_streak_goal = 9;
        calories_icon_offset_y = -100;
    }
}
