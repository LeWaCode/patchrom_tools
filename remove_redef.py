#! /usr/bin/env python
"""
This script is very specific for framework-res/res/values/drawables.xml and framework-res/res/values/dimens.xml.
Currently ResValuesModify can't process <item name="screen_background_light" type="drawable" />
                                        <item name="dialog_fixed_height_major" type="dimen">80%</item>
                                        <item name="dialog_fixed_height_minor" type="dimen">100%</item>.
use this script to remove multiple definitions
"""
import sys
import xml
import xml.dom
from xml.dom import minidom

fdir=sys.argv[1]
drawables=fdir +"/res/values/drawables.xml"
dimens=fdir +"/res/values/dimens.xml"
filnames=[ drawables, dimens ]
for filename in filnames:
	xmldoc = minidom.parse(filename)
	root = xmldoc.firstChild
	elements = [ e for e in root.childNodes if e.nodeType == e.ELEMENT_NODE ]
	elem_defs = {}
	for elem in elements:
		name = elem.attributes["name"].value
		elem_defs[name] = elem_defs.get(name, 0) + 1

	repeat_defs = [ name for name in elem_defs.keys() if elem_defs[name] > 1]
	xmldoc.unlink()

	f = open(filename, "r")
	lines = f.readlines()
	f.close()

	for line in lines:
		for rdef in repeat_defs:
			if rdef in line:
				lines.remove(line)
				repeat_defs.remove(rdef)

	f = open(filename, "w")
	f.writelines(lines)
	f.close()
