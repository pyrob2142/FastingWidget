# Converts a csv-file into a working strings.xml file
# It's not pretty, but it gets the job done.
# Requires pandas

import os
import sys
import argparse
import pandas

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
app_name = column[1]

long_press_threshold_title = column[2]

default_page_goal_title = column[3]
default_page_no_goal_title = column[4]
page_streak = column[5]
page_elapsed = column[6]
page_remaining = column[7]
page_calories = column[8]

default_goal_title = column[9]
custom_goal_title = column[10]

activity_level_title = column[11]
activity_level_0 = column[12]
activity_level_1 = column[13]
activity_level_2 = column[14]
activity_level_3 = column[15]
activity_level_4 = column[16]

birthday_title = column[17]
bmr_formula_title = column[18]
bmr_mifflin = column[19]
bmr_harris = column[20]
bmr_katch = column[21]
body_fat_title = column[22]

streak_reset_threshold_title = column[23]
streak_inc_threshold_title = column[24]
streak_title = column[25]
overwrite_date_format_title = column[26]
time_format_title = column[27]
show_days_title = column[28]

summary = column[29]
duration = column[30]
calories = column[31]
streak = column[32]
fast_sg = column[33]
fast_pl = column[34]
nominalization = column[35]
fasting_title = column[36]
elapsed = column[37]
remaining = column[38]
since = column[39]
until = column[40]
kcal = column[41]
overtime = column[42]

fast_type_menu_title = column[43]
fast_set_goal = column[44]
fast_no_goal  = column[45]
end_fast_title = column[46]
cancel_fast_title = column[47]
goal_menu_title = column[48]
options_title = column[49]
sure_title = column[50]
yes = column[51]
no = column[52]

string_hour = column[53]
string_hours = column[54]
string_day = column[55]
string_days = column[56]
string_week = column[57]
string_weeks = column[58]
symbol_days = column[59]
symbol_hours = column[60]
symbol_minutes = column[61]
symbol_seconds = column[62]
default_date_format = column[63]

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
