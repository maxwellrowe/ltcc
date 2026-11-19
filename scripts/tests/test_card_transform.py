"""Exercise card fields, optional content, escaping and component dispatch with SaxonC."""
from pathlib import Path
import tempfile
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor

ROOT = Path(__file__).resolve().parents[2]


def run():
    with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
        stylesheet = Path(directory) / 'cards-test.xsl'
        stylesheet.write_text('''<xsl:stylesheet version="3.0"
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables">
          <xsl:import href="''' + (ROOT / '_resources/xsl/_shared/components.xsl').as_uri() + '''"/>
          <xsl:variable name="ou:action" select="'pub'"/>
          <xsl:mode on-no-match="shallow-copy"/>
          <xsl:output method="xml" omit-xml-declaration="yes"/>
        </xsl:stylesheet>''')
        transform = proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(stylesheet))

        def render(linked=False, extra='', title='A &amp; B', url='/apply?a=1&amp;b=2'):
            source = '''<ouc:component xmlns:ouc="http://omniupdate.com/XSL/Variables" name="component-card%s">
              <ul><li class="title">%s</li><li class="url">%s</li>%s</ul></ouc:component>''' % ('-link' if linked else '', title, url, extra)
            return transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=source))

        for style, icon in [('white','blue-700'), ('blue-100','blue-800'), ('green-100','green-900'), ('gradient','blue-800'), ('dark-blue','blue-400')]:
            doc = ET.fromstring(render(extra='<li class="style">%s</li><li class="icon">fa-house</li>' % style))
            assert {'fa-sharp', 'fa-regular', 'fa-house'} <= set(doc.find('.//span').get('class').split())
            assert 'text-' + icon in doc.find('.//span').get('class')
            assert 'h5' in doc.find('.//span').get('class').split()
            assert doc.find('.//h2').text == 'A & B'
            assert 'h5' in doc.find('.//h2').get('class')
            assert 'p-3' in doc.find('div').get('class')
            assert doc.find('img') is None

        for padding in range(1, 6):
            doc = ET.fromstring(render(True, '<li class="padding">%s</li><li class="title-size">h1</li>' % padding))
            assert 'p-%s' % padding in doc.find('div').get('class')
            assert doc.tag == 'a' and doc.get('href') == '/apply?a=1&b=2'
            assert 'h1' in doc.find('.//h2').get('class')
        for size in ('h1', 'h2', 'h3', 'h4', 'h5', 'h6'):
            doc = ET.fromstring(render(extra='<li class="title-size">%s</li><li class="icon">fa-house</li>' % size))
            assert size in doc.find('.//span').get('class').split()
            assert size in doc.find('.//h2').get('class').split()
        doc = ET.fromstring(render(True, '<li class="padding">99</li><li class="title-size">invalid</li><li class="style">dark-blue</li>'))
        assert 'p-3' in doc.find('div').get('class') and 'bg-white' in doc.get('class')
        assert not render(True, title='').strip() and not render(True, url='').strip()

        fields = '<li class="image"><img src="/test.jpg" alt="A view"/></li><li class="description"><p>Learn <strong>more</strong>.</p></li>'
        doc = ET.fromstring(render(extra=fields))
        assert doc.find('img').get('alt') == ''
        assert doc.find('.//strong').text == 'more'
        doc = ET.fromstring(render(True, fields))
        assert doc.find('img').get('alt') == ''
        assert doc.find('img').get('tabindex') is None
        assert doc.find('.//strong') is None and 'ltcc-card--has-image' in doc.get('class')
        assert 'Learn more.' in ''.join(doc.itertext())

        links = '<li class="style">dark-blue</li><li class="links">'
        for style in ('primary', 'secondary', 'arrow', 'invalid'):
            links += '<ul><li class="url"><a href="/learn">Link</a></li><li class="text">Learn</li><li class="style">%s</li></ul>' % style
        links += '<ul><li class="url">/empty</li><li class="text"></li></ul></li>'
        doc = ET.fromstring(render(extra=links))
        anchors = doc.findall('.//a')
        assert len(anchors) == 4
        assert [a.get('class') for a in anchors] == ['btn btn-primary', 'btn btn-secondary', 'arrow-link arrow-link-light', 'arrow-link arrow-link-light']
        assert all(a.get('href') == '/learn' for a in anchors)
        empty = ET.fromstring(render(extra='<li class="links"><ul><li class="url"/><li class="text"/><li class="style">arrow</li></ul></li>'))
        assert empty.find('.//ul') is None
        print('PASS: card variants, padding, optional image/icon, rich/plain text, links, escaping and defaults.')


if __name__ == '__main__':
    run()
