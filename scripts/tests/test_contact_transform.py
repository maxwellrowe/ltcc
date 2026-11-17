"""SaxonC checks for the shared faculty/contact renderer; CMS action is stubbed."""
from pathlib import Path
import tempfile
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor
ROOT = Path(__file__).resolve().parents[2]
XSL = '{http://www.w3.org/1999/XSL/Transform}'

def run():
    tree = ET.parse(ROOT / '_resources/xsl/_shared/snippets.xsl')
    template = next(t for t in tree.getroot().findall(XSL+'template') if 'ou-faculty-list' in t.get('match', ''))
    component = '''<ouc:component name="component-contact"><ul><li class="name">America Ramirez</li><li class="title">Financial Aid Technician</li><li class="email">america@example.edu</li><li class="website">/financial-aid/</li></ul></ouc:component>'''
    table = '''<table class="ou-faculty-list extra"><tbody><tr><th>Heading Top</th><td colspan="4">Financial Aid</td></tr><tr><th>Heading Bottom</th><td colspan="4">Staff</td></tr><tr><th>Picture</th><th>Name</th><th>Title</th><th>Email</th><th>Website</th></tr><tr><td></td><td>America Ramirez</td><td>Financial Aid Technician</td><td><a href="mailto:america@example.edu">Email me</a></td><td><a href="/financial-aid/">Website</a></td></tr><tr><td><img src="old.jpg"/></td><td>Pat Example</td><td>&#160;</td><td>&#160;</td><td><a href="">&#160;</a></td></tr><tr><td/><td>&#160;</td><td/><td/><td/></tr></tbody></table>'''
    fixture='<root xmlns:ouc="http://omniupdate.com/XSL/Variables">'+table+component+component.replace('America Ramirez','&#160;')+'</root>'
    with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
        path=Path(directory)/'contact.xsl'
        path.write_text('''<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables"><xsl:import href="'''+(ROOT/'_resources/xsl/_shared/components.xsl').as_uri()+'''"/><xsl:variable name="ou:action" select="'pub'"/><xsl:output method="xml" omit-xml-declaration="yes"/><xsl:mode on-no-match="shallow-copy"/>'''+ET.tostring(template,encoding='unicode')+'</xsl:stylesheet>')
        transform=proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(path))
        output=transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=fixture))
        doc=ET.fromstring(output)
        contacts=[e for e in doc.iter('div') if 'ltcc-contact' in e.get('class','').split()]
        assert len(contacts)==3
        assert ET.tostring(contacts[0])==ET.tostring(contacts[2])
        assert not doc.findall('.//img') and not doc.findall('.//table')
        assert len(contacts[0].findall('.//a'))==2
        assert not contacts[1].findall('.//a')
        assert not contacts[1].findall('.//p[@class="ltcc-contact__title fs-8 mb-0"]')
        assert contacts[0].find('.//a').get('href')=='mailto:america@example.edu'
        assert all(a.get('href') and a.find('.//span[@class="visually-hidden"]').text for a in doc.iter('a'))
        assert doc.find('.//h2/span').text=='Financial Aid'
        # Exercise actual existing snippet authoring table too.
        original=transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=(ROOT/'_resources/snippets/faculty-listing.html').read_text()))
        original_doc=ET.fromstring(original)
        assert len(original_doc.findall('.//li'))==5 and not original_doc.findall('.//img')
        section = '<ouc:component xmlns:ouc="http://omniupdate.com/XSL/Variables" name="component-contact-section"><ul><li class="heading-top">Financial Aid</li><li class="heading-bottom">Staff</li><li class="contacts">' + component[component.index('<ul>'):component.index('</ul>') + len('</ul>')] + '<ul><li class="name">Pat Example</li><li class="title">&#160;</li><li class="email">&#160;</li><li class="website"></li></ul><ul><li class="name">&#160;</li></ul></li></ul></ouc:component>'
        rendered = transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=section))
        section_doc = ET.fromstring(rendered)
        assert ET.tostring(section_doc) == ET.tostring(doc.find('section'))
        for top, bottom in (('', ''), ('Business', ''), ('', 'Faculty')):
            variant = section.replace('>Financial Aid<', '>'+top+'<').replace('>Staff<', '>'+bottom+'<')
            result = ET.fromstring(transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=variant)))
            assert (result.find('.//h2') is not None) == bool(top or bottom)
            assert len(result.findall('.//h2/span')) == bool(top) + bool(bottom)
        empty = section.replace('America Ramirez', '&#160;').replace('Pat Example', ' ')
        assert not transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=empty)).strip()
        print('PASS: existing authoring table, no-photo rows, optional fields/NBSP, accessible actions, identical snippet/section output, optional headings, and empty-section suppression.')
        return output
if __name__=='__main__': run()
