import os
import sys

pathname = os.path.dirname(sys.argv[0])        
local_dir = os.path.abspath(pathname)

from transifex.api import TransifexAPI

username = os.getenv('TRANSIFEX_USERNAME')
password = os.getenv('TRANSIFEX_PASSWORD')

t = TransifexAPI(username, password, 'http://transifex.com')

resources = t.list_resources('mifm')

print resources

for resource in resources:
    fname = resource['name']
    fnamep = fname.split('.')
    languages = t.list_languages('mifm', resource['slug'])
    print languages
    for lang_name in languages:
        real_name = '{}_{}.xml'.format(fnamep[0], lang_name)
        print t.get_translation('mifm', resource['slug'], lang_name, '{}/translation/{}'.format(local_dir, real_name))
