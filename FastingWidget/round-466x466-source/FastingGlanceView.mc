using Toybox.Graphics;

(:glance)
class FastingGlanceView extends FastingGlanceViewBase {
    function initialize() {
        FastingGlanceViewBase.initialize();
        configureLayout();
        startUpdates();
    }

    function configureLayout() {
        FastingGlanceViewBase.configureLayout();
        layout[:active_top_text] = [8, Graphics.FONT_SYSTEM_TINY];
        layout[:idle_top_text_font] = Graphics.FONT_SYSTEM_MEDIUM;
        layout[:regular_bar_height] = 15;
        layout[:bar_offset] = 2;
        layout[:overtime_bar_height] = 25;
    }
}
