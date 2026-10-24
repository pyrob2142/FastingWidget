using Toybox.Graphics;

class FastingView extends FastingViewBase {
    function initialize() {
        FastingViewBase.initialize();
        configureLayout();
    }

    function configureLayout() {
        FastingViewBase.configureLayout();
        layout[:streak_increment_current] = [30, Graphics.FONT_NUMBER_HOT];
        layout[:streak_increment_previous] = [90, Graphics.FONT_NUMBER_MILD];
        layout[:calories_value] = [10, Graphics.FONT_NUMBER_HOT];
        pen_width_regular = 9;
        pen_width_overtime = 20;
        pen_width_streak_goal = 9;
        calories_icon_offset_x = -32;
        calories_icon_offset_y = -100;
    }
}
