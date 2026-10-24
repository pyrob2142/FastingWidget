(:glance)
class FastingGlanceView extends FastingGlanceViewBase {
    function initialize() {
        FastingGlanceViewBase.initialize();
        configureLayout();
        startUpdates();
    }

    function configureLayout() {
        FastingGlanceViewBase.configureLayout();
    }
}
