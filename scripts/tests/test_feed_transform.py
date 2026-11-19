"""Check the XSL-to-PHP boundary and CMS preview with SaxonC."""
from pathlib import Path
import tempfile, re, json, urllib.parse, subprocess
from saxonche import PySaxonProcessor
ROOT = Path(__file__).resolve().parents[2]
with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
    path = Path(directory) / 'test.xsl'
    path.write_text('<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables"><xsl:import href="'+(ROOT/'_resources/xsl/_shared/components.xsl').as_uri()+'"/><xsl:param name="ou:action" select="\'pub\'"/><xsl:output method="html"/></xsl:stylesheet>')
    t = proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(path))
    xml = '''<ouc:component xmlns:ouc="http://omniupdate.com/XSL/Variables" name="component-events-carousel"><ul><li class="feed-url">https://api.calendar.moderncampus.net/feed?category=a&amp;category=b</li><li class="max-items">999</li><li class="items-mobile">invalid</li><li class="featured">true</li><li class="organizer">Gallery's &lt;?php nope ?&gt;</li></ul></ouc:component>'''
    node = proc.parse_xml(xml_text=xml)
    output = t.transform_to_string(xdm_node=node)
    encoded = re.search("rawurldecode\\('([^']*)'\\)", output).group(1)
    options = json.loads(urllib.parse.unquote(encoded))
    assert options['max-items']==50 and options['items-mobile']==1
    assert options['organizer']=="Gallery's <?php nope ?>" and options['featured']=='true'
    assert '&category=b' in options['feed-url']
    php = Path(directory)/'output.php'; php.write_text(output)
    subprocess.run(['php','-l',str(php)],check=True,capture_output=True)
    t.set_parameter('{http://omniupdate.com/XSL/Variables}action',proc.make_string_value('edt'))
    preview=t.transform_to_string(xdm_node=node)
    assert 'Live feed cards' in preview and '<?php' not in preview
    print('PASS: generated PHP syntax, encoded settings, defaults, limits and preview output.')
