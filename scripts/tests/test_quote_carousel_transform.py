"""Verify quote repeater output with SaxonC."""
from pathlib import Path
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor

ROOT = Path(__file__).resolve().parents[2]
with PySaxonProcessor(license=False) as proc:
    transform = proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(ROOT / '_resources/xsl/_shared/quote-carousel.xsl'))
    def render(style, quotes):
        xml = '<ouc:component xmlns:ouc="http://omniupdate.com/XSL/Variables" name="component-quote-carousel"><ul><li class="style">%s</li><li class="quotes">%s</li></ul></ouc:component>' % (style, quotes)
        return transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=xml))
    quote = '<ul><li class="quote">Learn &amp; grow.</li><li class="name">Jane</li><li class="title">Student</li><li class="image"/></ul>'
    for style, cls in [('white','bg-white'), ('blue-100','bg-blue-100'), ('green-100','bg-green-100'), ('gradient','bg-gradient-green-blue'), ('invalid','bg-blue-100')]:
        doc = ET.fromstring(render(style, quote))
        assert cls in doc.get('class').split()
        assert doc.find('.//button') is None
        assert doc.find('.//figure/figcaption/strong').text == 'Jane'
        assert doc.find('.//blockquote/p').text == 'Learn & grow.'
        assert 'col-lg-8' not in doc.find('.//figure').get('class')
    doc = ET.fromstring(render('white', quote + quote.replace('<li class="image"/>', '<li class="image"><img src="/portrait.jpg"/></li>')))
    assert len(doc.findall('.//button')) == 3
    assert doc.find('.//img').get('alt') == ''
    assert len(doc.findall('.//figure')) == 2
    assert not render('white', '').strip().replace('<?xml version="1.0" encoding="UTF-8"?>', '').strip()
    assert len(ET.fromstring(render('white', quote + '<ul><li class="quote"/></ul>')).findall('.//figure')) == 1
    print('PASS: styles, repeaters, optional images, captions, escaping, empty quotes and single-quote controls.')
