#!/usr/bin/env python
import os
import sys
import subprocess
from xml.dom import minidom
import xml.etree.ElementTree as ET
from xml.etree.ElementTree import fromstring, ElementTree, Element

tree = ET.parse('./translation/strings_en.xml')
root = tree.getroot()

base_tags = {}

for child in root:
    print child.tag, child.attrib, child.text
    if child.attrib.get('name'):
        base_tags[child.attrib['name']] = child.text

for filename in os.listdir('./translation/'):
    if filename.startswith('strings_') and not filename.endswith('en.xml'):
        path = './translation/{}'.format(filename)
        print 'opening', path
        old_tags = {}
        tree2 = ET.parse(path)
        root = tree2.getroot()

        for child in root:
            print child.tag, child.attrib, child.text
            if child.attrib.get('name'):
                old_tags[child.attrib['name']] = child.text

        print base_tags
        print old_tags

        missing_tags = list(set(base_tags.keys()) - set(old_tags.keys()))
        print missing_tags
        for missing_tag in missing_tags:
            elem = Element('string', {'name': missing_tag})
            elem.text = base_tags[missing_tag]
            root.append(elem)

        xmlstr = minidom.parseString(ET.tostring(root, encoding='utf-8')).toprettyxml(indent='    ', newl='', encoding='utf-8')
        fh = open(path, 'w')
        fh.write(xmlstr)
        fh.close()

        # xmllint --format translation/strings_pl.xml --output translation/strings_pl.xml
        subprocess.call('xmllint --format {} --output {}'.format(path, path), shell=True)
