"""Verify Typed Text output, optional fields and validated options."""
from pathlib import Path
import tempfile
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor
ROOT = Path(__file__).resolve().parents[2]
with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
    path=Path(directory)/'test.xsl'
    path.write_text('<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables"><xsl:import href="'+(ROOT/'_resources/xsl/_shared/components.xsl').as_uri()+'"/><xsl:variable name="ou:action" select="\'pub\'"/><xsl:output method="xml" omit-xml-declaration="yes"/></xsl:stylesheet>')
    t=proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(path))
    def render(fields):
        xml='<ouc:component xmlns:ouc="http://omniupdate.com/XSL/Variables" name="component-typed-text"><ul>'+fields+'</ul></ouc:component>'
        return t.transform_to_string(xdm_node=proc.parse_xml(xml_text=xml))
    phrases='<li class="phrases"><ul><li class="text">connect &amp; learn</li></ul><ul><li class="text">get outside</li></ul><ul><li class="text"/></ul></li>'
    for size in ['h'+str(n) for n in range(1,7)]+['fs-'+str(n) for n in range(1,7)]:
        doc=ET.fromstring(render(phrases+'<li class="size">'+size+'</li>'))
        assert size in doc.find('h2').get('class').split()
    doc=ET.fromstring(render(phrases+'<li class="prefix">Your place to</li><li class="suffix">.</li><li class="break-after-prefix">true</li><li class="loop">false</li><li class="speed">fast</li><li class="start-delay">-20</li><li class="phrase-delay">999999</li><li class="typed-color">secondary</li>'))
    assert doc.get('data-typed-loop')=='false' and doc.get('data-typed-speed')=='30'
    assert doc.get('data-typed-start-delay')=='0' and doc.get('data-typed-phrase-delay')=='30000'
    assert doc.find('.//br') is not None
    assert len(doc.findall('./ul/li'))==2
    assert doc.find('h2/span').text=='Your place to connect & learn.; Your place to get outside.'
    assert doc.find('.//span[@class="text-secondary"]') is not None
    plain=ET.fromstring(render(phrases))
    assert plain.find('.//br') is None and plain.find('button').get('hidden') is not None
    assert not render('<li class="prefix">No phrases</li>').strip()
    for color in ['primary','secondary','text-bright-green','text-blue-400','text-green-100','text-blue-100','white']:
        doc=ET.fromstring(render(phrases+'<li class="typed-color">'+color+'</li>'))
        assert doc.find('.//span[@class="'+(color if color.startswith('text-') else 'text-'+color)+'"]') is not None
    print('PASS: typed sizes, colors, repeaters, optional fields, accessibility text, defaults and limits.')
