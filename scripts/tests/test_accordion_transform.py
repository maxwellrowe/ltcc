"""Exercise the accordion template with SaxonC; CMS text extraction is stubbed."""
from pathlib import Path
import tempfile
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor

ROOT = Path(__file__).resolve().parents[2]
XSL = '{http://www.w3.org/1999/XSL/Transform}'

def run():
    tree = ET.parse(ROOT / '_resources/xsl/_shared/snippets.xsl')
    template = next(t for t in tree.getroot().findall(XSL + 'template') if 'ou_accordion' in t.get('match', ''))
    legacy = '<table class="ou_accordion extra"><tbody><tr><td>ID</td><td>same</td></tr><tr><td><p>Legacy heading</p></td><td><p>Body</p></td></tr></tbody></table>'
    second = legacy.replace('ou_accordion extra', 'ou_accordion_2')
    existing = (ROOT / '_resources/snippets/accordian.inc').read_text()
    nested = legacy.replace('<p>Body</p>', second)
    source = '<root>' + legacy + second + existing + nested + legacy.replace('same', 'bad id') + '</root>'
    with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
        path = Path(directory) / 'test.xsl'
        path.write_text('''<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou">
<xsl:import href="''' + (ROOT / '_resources/xsl/_shared/transformations.xsl').as_uri() + '''"/>
<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:function name="ou:textual-content"><xsl:param name="node"/><xsl:sequence select="normalize-space(string($node))"/></xsl:function>
<xsl:mode on-no-match="shallow-copy"/>''' + ET.tostring(template, encoding='unicode') + '</xsl:stylesheet>')
        executable = proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(path))
        output = executable.transform_to_string(xdm_node=proc.parse_xml(xml_text=source))
        doc = ET.fromstring(output)
        accordions = [e for e in doc.iter('div') if 'ltcc-accordion' in e.get('class', '').split()]
        assert len(accordions) == 6
        ids = [e.get('id') for e in doc.iter() if e.get('id')]
        assert len(ids) == len(set(ids))
        assert accordions[0].get('id') == 'same'
        assert not doc.findall('.//table')
        assert not doc.findall('.//*[@data-toggle]')
        assert not doc.findall('.//h6')
        for accordion in accordions:
            for item in accordion.findall('./div'):
                button = item.find('./h3/button')
                panel = item.find('./div')
                assert button.get('data-bs-target') == '#' + panel.get('id')
                assert button.get('aria-controls') == panel.get('id')
                assert button.get('aria-expanded') == 'false'
                assert panel.get('data-bs-parent') == '#' + accordion.get('id')
                assert panel.get('aria-labelledby') == item.find('h3').get('id')
        assert len(accordions[2].findall('./div')) == 2
        assert doc.find('.//button').text == 'Legacy heading'
        print('PASS: both existing authoring formats, nested/repeated/invalid IDs, Bootstrap 5 ARIA, rich content and spacer removal.')
        return output

if __name__ == '__main__': run()
