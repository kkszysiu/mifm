import os
import sys
import json

import requests
from transifex.api import TransifexAPI

pathname = os.path.dirname(sys.argv[0])
local_dir = os.path.abspath(pathname)

username = os.getenv('TRANSIFEX_USERNAME')
password = os.getenv('TRANSIFEX_PASSWORD')

t = TransifexAPI(username, password, 'http://transifex.com')

def get_statistics(project, resource):
    url = 'https://www.transifex.com/api/2/project/{}/resource/{}/stats/'.format(
        project, resource
    )
    response = requests.get(url, auth=(username, password))
    return json.loads(response.content)

def printProgress (iteration, total, prefix = '', suffix = '', decimals = 2, barLength = 100):
    filledLength    = int(round(barLength * iteration / float(total)))
    percents        = round(100.00 * (iteration / float(total)), decimals)
    bar             = '#' * filledLength + '-' * (barLength - filledLength)
    return '%s [%s] %s%s %s' % (prefix, bar, percents, '%', suffix)

resources = t.list_resources('mifm')
progress_data = 'Language translation progress:\n'

for resource in resources:
    fname = resource['name']
    fnamep = fname.split('.')
    languages = t.list_languages('mifm', resource['slug'])
    statistics = get_statistics('mifm', resource['slug'])

    progress_data += '-'*50
    progress_data += '\n'
    progress_data += '     {}\n'.format(resource['name'])
    progress_data += '-'*50
    progress_data += '\n'

    for lang_name in languages:
        real_name = '{}_{}.xml'.format(fnamep[0], lang_name)
        # print t.list_translation_strings('mifm', resource['slug'], lang_name)
        print t.get_translation('mifm', resource['slug'], lang_name, '{}/translation/{}'.format(local_dir, real_name))

    for lang, sdict in statistics.iteritems():
        completed = sdict.get('completed', '0%')
        completed_int = int(completed[:-1])
        progress_data += 'Language Code: {}\n'.format(lang)
        progress = printProgress(completed_int, 100, prefix = 'Progress:', suffix = 'Complete', barLength = 50)

        progress_data += '{}\n'.format(progress)

    progress_data += '\n\n'

fh = open('translation_statistics.txt', 'w')
fh.write(progress_data)
fh.close()
