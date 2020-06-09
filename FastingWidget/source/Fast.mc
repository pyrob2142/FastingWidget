using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi;

//! Hold data and does calculations regarding the fast
class Fast {
    var fast_manager;
    var resource_manager;

    //! Time.Moment of when the fast was started
    var m_start;

    //! Time.Duration of the goal duration
    var d_goal;

    var m_now;

    //! Time.Duration since m_start
    var d_elapsed;
    var is_complete;
    var has_goal;
    var progress;
    var calories;
    var weight;
    var height;
    var age;
    var gender;
    var activity_level;
    var bmi;
    var is_active;
    var timer;
    var last_fast;

    function initialize() {
        resource_manager = Application.getApp().resource_manager;
        timer = new Timer.Timer();
        reset();
    }

    //! Starts a new fast.
    //! If goal is set to anything else than -1 the fast will have a goal.
    //! @param [Number] goal The target duration of the fast in hours
    function start(goal) {
        if (goal != -1) {
            d_goal = new Time.Duration(goal * 3600);
            has_goal = true;
        } else {
            is_complete = true;
        }

        me.m_start = Time.now();
        timer.start(me.method(:update), resource_manager.update_rate, true);
        is_active = true;
        resource_manager.save();
        update();
    }

    //! Adds a goal to the active open fast.
    function addGoal(hours) {
        d_goal = new Time.Duration(hours * 3600);
        has_goal = true;
        is_complete = false;
        resource_manager.save();
        calculateProgress();
    }

    //! Resumes a previously saved fast.
    //! Same as start expect that it starts from a specific moment.
    //! @param [Number] start UNIX Epoch of when the fast was started.
    //! @param [Number] goal  target duration of the fast in seconds.
    function resume(start, goal) {
        if (goal != -1) {
            d_goal = new Time.Duration(goal);
            has_goal = true;
        } else {
            is_complete = true;
        }

        m_start = new Time.Moment(start);
        timer.start(me.method(:update), resource_manager.update_rate, true);
        is_active = true;
        update();
    }

    //! Ends the current fast, by setting it inactive and stopping the auto-refresh.
    function end() {
        is_active = false;
        timer.stop();
    }

    //! Resets the fast object in order to begin a new fast.
    function reset() {
        weight = resource_manager.weight;
        height = resource_manager.height;
        age = resource_manager.age;
        gender = resource_manager.gender;
        activity_level = resource_manager.activity_level;
        bmi = resource_manager.bmi;

        m_start = Time.now();
        m_now = Time.now();
        d_goal = new Time.Duration(0);
        d_elapsed = new Time.Duration(0);
        is_complete = false;
        has_goal = false;
        progress = 0.0;
        calories = 0;
        is_active = false;
        last_fast = Time.now();
    }

    //! Calculates the current progress of the fast in percent of goal completion.
    function calculateProgress() {
        var m_goal = m_start.add(d_goal);

        if (m_now.greaterThan(m_goal)) {
            is_complete = true;
        }

        var goal_val = d_goal.value();
        var elapsed_val = d_elapsed.value();

        progress = elapsed_val / goal_val.toFloat();
    }

    //! Calculates kcal burned per second using different formulas selected by the user.
    //! Mifflin-St Jeor Equation:
    //! Men:    BMR = 10 * W + 6.25 * H - 5 * A + 5
    //! Women:  BMR = 10 * W + 6.25 * H - 5 * A - 161
    //!
    //! Revised Harris-Benedict Equation:
    //! Men:    BMR = 13.397 * W + 4.799 * H - 5.677 * A + 88.362
    //! Women:  BMR = 9.247 * W + 3.098 * H - 4.330 * A + 447.593
    //!
    //! Katch-McArdle Formula (requires body fat in percent):
    //! Unisex: BMR = 370 + 21.6 * (1 - F) * W
    function calculateCalories() {
        var bmr = resource_manager.custom_bmr;

        if (bmr == 0) {
            if (resource_manager.bmr_formula == resource_manager.MIFFLIN) {
                if (gender == 0) {
                    bmr = 10 * weight + 6.25 * height - 5 * age - 161;
                } else {
                    bmr = 10 * weight + 6.25 * height - 5 * age + 5;
                }
            }

            if (resource_manager.bmr_formula == resource_manager.HARRIS) {
                if (gender == 0) {
                    bmr = 9.247 * weight + 3.098 * height - 4.330 * age + 447.593;
                } else {
                    bmr = 13.397 * weight + 4.799 * height - 5.677 * age + 88.362;
                }
            }

            if (resource_manager.bmr_formula == resource_manager.KATCH) {
                var body_fat = resource_manager.body_fat / 100.0;
                bmr = 370 + 21.6 * (1 - body_fat) * weight;
            }
        }

        var calories_per_second = bmr * activity_level / 86400.0;

        calories = calories_per_second * d_elapsed.value().toDouble();
    }

    //! Updates the fast and requests a screen refresh.
    //! Target refresh: Once per second.
    function update() {
        m_now = Time.now();
        d_elapsed = m_now.subtract(m_start);

        calculateCalories();

        if (has_goal == true) {
            calculateProgress();
        }

        WatchUi.requestUpdate();
    }
}