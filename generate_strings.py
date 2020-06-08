# Converts a csv-file into a working strings.xml file
# It's not pretty, but it gets the job done.
# Requires pandas

import os
import sys
import argparse
import pandas

index = 0

def inc_i():
    global index
    index = index + 1
    return index

def get_options(args=sys.argv[1:]):
    parser = argparse.ArgumentParser(description="Parses command.")
    parser.add_argument("-i", "--input", help="The csv file to convert.")
    parser.add_argument("-l", "--language", help="The language you want to generate.")
    options = parser.parse_args(args)
    return options

def get_short(language):
    return {
        'Arabic': 'ara',
        'Bulgarian': 'bul',
        'Chinese (Simplified)': 'zhs',
        'Chinese (Traditional)': 'zht',
        'Croatian': 'hrv',
        'Czech': 'ces',
        'Danish': 'dan',
        'Dutch': 'dut',
        'English': 'eng',
        'Estonian': 'est',
        'Finnish': 'fin',
        'French': 'fre',
        'German': 'deu',
        'Greek': 'gre',
        'Hebrew': 'heb',
        'Hungarian': 'hun',
        'Indonesian': 'ind',
        'Italian': 'ita',
        'Japanese': 'jpn',
        'Korean': 'kor',
        'Latvian': 'lav',
        'Lithuanian': 'lit',
        'Norwegian': 'nob',
        'Polish': 'pol',
        'Portuguese': 'por',
        'Romanian': 'ron',
        'Russian': 'rus',
        'Slovak': 'slo',
        'Slovenian': 'slv',
        'Spanish': 'spa',
        'Standard (Bahasa) Malay': 'zsm',
        'Swedish': 'swe',
        'Thai': 'tha',
        'Turkish': 'tur',
        'Ukrainian': 'ukr',
        'Vietnamese': 'vie'
    }[language]

options = get_options()

directory = 'FastingWidget'
csv_file = options.input
pandas.set_option('display.max_rows', None)
data_frame = pandas.read_csv(csv_file)
language = options.language
lang_short = get_short(language)

print(data_frame[['String', language]])

column = data_frame['%s' % (language)]
column.tolist()

translator = column[0]
app_name = column[inc_i()]

long_press_threshold_title = column[inc_i()]
show_seconds_title = column[inc_i()]

default_page_goal_title = column[inc_i()]
default_page_no_goal_title = column[inc_i()]
page_streak = column[inc_i()]
page_elapsed = column[inc_i()]
page_remaining = column[inc_i()]
page_calories = column[inc_i()]

default_goal_title = column[inc_i()]
custom_goal_title = column[inc_i()]

activity_level_title = column[inc_i()]
activity_level_0 = column[inc_i()]
activity_level_1 = column[inc_i()]
activity_level_2 = column[inc_i()]
activity_level_3 = column[inc_i()]
activity_level_4 = column[inc_i()]

birthday_title = column[inc_i()]
bmr_formula_title = column[inc_i()]
bmr_mifflin = column[inc_i()]
bmr_harris = column[inc_i()]
bmr_katch = column[inc_i()]
body_fat_title = column[inc_i()]

streak_reset_threshold_title = column[inc_i()]
streak_inc_threshold_title = column[inc_i()]
streak_title = column[inc_i()]
overwrite_date_format_title = column[inc_i()]
time_format_title = column[inc_i()]
show_days_title = column[inc_i()]

summary = column[inc_i()]
duration = column[inc_i()]
calories = column[inc_i()]
streak = column[inc_i()]
fast_sg = column[inc_i()]
fast_pl = column[inc_i()]
nominalization = column[inc_i()]
fasting_title = column[inc_i()]
elapsed = column[inc_i()]
remaining = column[inc_i()]
since = column[inc_i()]
until = column[inc_i()]
kcal = column[inc_i()]
overtime = column[inc_i()]

fast_type_menu_title = column[inc_i()]
fast_set_goal = column[inc_i()]
fast_no_goal  = column[inc_i()]
end_fast_title = column[inc_i()]
cancel_fast_title = column[inc_i()]
goal_menu_title = column[inc_i()]
options_title = column[inc_i()]
sure_title = column[inc_i()]
yes = column[inc_i()]
no = column[inc_i()]

string_hour = column[inc_i()]
string_hours = column[inc_i()]
string_day = column[inc_i()]
string_days = column[inc_i()]
string_week = column[inc_i()]
string_weeks = column[inc_i()]
symbol_days = column[inc_i()]
symbol_hours = column[inc_i()]
symbol_minutes = column[inc_i()]
symbol_seconds = column[inc_i()]
default_date_format = column[inc_i()]

time_format_1 = "x" + symbol_days + " x" + symbol_hours + " x" + symbol_minutes
time_format_2 = symbol_days + ":" + symbol_hours + ":" + symbol_minutes 

# Write the new strings.xml file in the corresponding resources folder
file_name = directory + os.path.sep + 'resources-%s' % (lang_short) + os.path.sep + 'strings.xml'
os.makedirs(os.path.dirname(file_name), exist_ok = True)

with open(file_name, "w+", encoding='utf-8') as f:
    f.write('<!-- TRANSLATOR: %s -->\n' % (translator))
    f.write('<resources>\n')
    f.write('\t<!-- APP NAME -->\n')
    f.write('\t<string id="AppName">%s</string>\n' % (app_name))
    f.write('\n')
    f.write('\t<!-- USER SETTINGS -->\n')
    f.write('\t<string id="longpress_threshold_title">%s</string>\n' % (long_press_threshold_title))
    f.write('\t<string id="show_seconds_title">%s</string>\n' % (show_seconds_title))
    f.write('\n')
    f.write('\t<string id="default_page_goal_title">%s</string>\n' % (default_page_goal_title))
    f.write('\t<string id="default_page_no_goal_title">%s</string>\n' % (default_page_no_goal_title))
    f.write('\t<string id="page_streak">%s</string>\n' % (page_streak))
    f.write('\t<string id="page_elapsed">%s</string>\n' % (page_elapsed))
    f.write('\t<string id="page_remaining">%s</string>\n' % (page_remaining))
    f.write('\t<string id="page_calories">%s</string>\n' % (page_calories))
    f.write('\n')
    f.write('\t<string id="default_goal_title">%s</string>\n' % (default_goal_title))
    f.write('\t<string id="custom_goal_title_1">%s</string>\n' % (custom_goal_title + " 1"))
    f.write('\t<string id="custom_goal_title_2">%s</string>\n' % (custom_goal_title + " 2"))
    f.write('\t<string id="custom_goal_title_3">%s</string>\n' % (custom_goal_title + " 3"))
    f.write('\n')
    f.write('\t<string id="activity_level_title">%s</string>\n' % (activity_level_title))
    f.write('\t<string id="activity_level_0">%s</string>\n' % (activity_level_0))
    f.write('\t<string id="activity_level_1">%s</string>\n' % (activity_level_1))
    f.write('\t<string id="activity_level_2">%s</string>\n' % (activity_level_2))
    f.write('\t<string id="activity_level_3">%s</string>\n' % (activity_level_3))
    f.write('\t<string id="activity_level_4">%s</string>\n' % (activity_level_4))
    f.write('\n')
    f.write('\t<string id="birthday_title">%s</string>\n' % (birthday_title))
    f.write('\t<string id="bmr_formula_title">%s</string>\n' % (bmr_formula_title))
    f.write('\t<string id="bmr_mifflin">%s</string>\n' % (bmr_mifflin))
    f.write('\t<string id="bmr_harris">%s</string>\n' % (bmr_harris))
    f.write('\t<string id="bmr_katch">%s</string>\n' % (bmr_katch))
    f.write('\t<string id="body_fat_title">%s</string>\n' % (body_fat_title))
    f.write('\n')
    f.write('\t<string id="streak_reset_threshold_title">%s</string>\n' % (streak_reset_threshold_title))
    f.write('\t<string id="streak_inc_threshold_title">%s</string>\n' % (streak_inc_threshold_title))
    f.write('\t<string id="streak_title">%s</string>\n' % (streak_title))
    f.write('\t<string id="overwrite_date_format_title">%s</string>\n' % (overwrite_date_format_title))
    f.write('\t<string id="time_format_title">%s</string>\n' % (time_format_title))
    f.write('\t<string id="show_days_title">%s</string>\n' % (show_days_title))
    f.write('\n')
    f.write('\t<!-- FastingView.mc -->\n')
    f.write('\t<string id="summary">%s</string>\n' % (summary))
    f.write('\t<string id="duration">%s</string>\n' % (duration))
    f.write('\t<string id="calories">%s</string>\n' % (calories))
    f.write('\t<string id="streak" scope="glance">%s</string>\n' % (streak))
    f.write('\t<string id="fast_sg">%s</string>\n' % (fast_sg))
    f.write('\t<string id="fast_pl">%s</string>\n' % (fast_pl))
    f.write('\t<string id="nominalization">%s</string>\n' % (nominalization))
    f.write('\t<string id="fasting_title" scope="glance">%s</string>\n' % (fasting_title))
    f.write('\t<string id="elapsed" scope="glance">%s</string>\n' % (elapsed))
    f.write('\t<string id="remaining" scope="glance">%s</string>\n' % (remaining))
    f.write('\t<string id="since">%s</string>\n' % (since))
    f.write('\t<string id="until">%s</string>\n' % (until))
    f.write('\t<string id="kcal">%s</string>\n' % (kcal))
    f.write('\t<string id="overtime" scope="glance">%s</string>\n' % (overtime))
    f.write('\n')
    f.write('\t<!-- MenuHandler.mc -->\n')
    f.write('\t<string id="fast_type_menu_title">%s</string>\n' % (fast_type_menu_title))
    f.write('\t<string id="fast_set_goal">%s</string>\n' % (fast_set_goal))
    f.write('\t<string id="fast_no_goal">%s</string>\n' % (fast_no_goal))
    f.write('\t<string id="end_fast_title">%s</string>\n' % (end_fast_title))
    f.write('\t<string id="cancel_fast_title">%s</string>\n' % (cancel_fast_title))
    f.write('\t<string id="goal_menu_title">%s</string>\n' % (goal_menu_title))
    f.write('\t<string id="options_title">%s</string>\n' % (options_title))
    f.write('\t<string id="sure_title">%s</string>\n' % (sure_title))
    f.write('\t<string id="yes">%s</string>\n' % (yes))
    f.write('\t<string id="no">%s</string>\n' % (no))
    f.write('\n')
    f.write('\t<!-- Toolbox.mc -->\n')
    f.write('\t<string id="string_hour">%s</string>\n' % (string_hour))
    f.write('\t<string id="string_hours">%s</string>\n' % (string_hours))
    f.write('\t<string id="string_day">%s</string>\n' % (string_day))
    f.write('\t<string id="string_days">%s</string>\n' % (string_days))
    f.write('\t<string id="string_week">%s</string>\n' % (string_week))
    f.write('\t<string id="string_weeks">%s</string>\n' % (string_weeks))
    f.write('\t<string id="symbol_days" scope="glance">%s</string>\n' % (symbol_days))
    f.write('\t<string id="symbol_hours" scope="glance">%s</string>\n' % (symbol_hours))
    f.write('\t<string id="symbol_minutes" scope="glance">%s</string>\n' % (symbol_minutes))
    f.write('\t<string id="symbol_seconds" scope="glance">%s</string>\n' % (symbol_seconds))
    f.write('\t<string id="default_date_format">%s</string>\n' % (default_date_format))
    f.write('\t<string id="time_format_1">%s</string>\n' % (time_format_1))
    f.write('\t<string id="time_format_2">%s</string>\n' % (time_format_2))
    f.write('</resources>')
    f.close()
