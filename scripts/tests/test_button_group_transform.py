"""SaxonC tests for button group alignment, fields and escaping."""
from pathlib import Path
import tempfile
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor
ROOT = Path(__file__).resolve().parents[2]

def run():
    with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
        path = Path(directory) / 'test.xsl'
        path.write_text('''<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables"><xsl:import href="'''+(ROOT/'_resources/xsl/_shared/components.xsl').as_uri()+'''"/><xsl:variable name="ou:action" select="'pub'"/><xsl:output method="xml" omit-xml-declaration="yes"/></xsl:stylesheet>''')
        transform = proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(path))
        def render(layout='', horizontal='', vertical='', buttons=''):
            source=f'''<ouc:component xmlns:ouc="http://omniupdate.com/XSL/Variables" name="component-button-group"><ul><li class="layout">{layout}</li><li class="horizontal-alignment">{horizontal}</li><li class="vertical-alignment">{vertical}</li><li class="buttons">{buttons}</li></ul></ouc:component>'''
            return transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=source))
        button='<ul><li class="text">Apply &amp; Learn &lt;more&gt;</li><li class="url"><a href="/apply?a=1&amp;b=2">Apply</a></li><li class="size">btn-lg</li><li class="style">btn-outline-secondary</li></ul>'
        for layout in ('Horizontal','Vertical'):
            for h,hval in (('Left','start'),('Center','center'),('Right','end')):
                for v,vval in (('Top','start'),('Center','center'),('Bottom','end')):
                    doc=ET.fromstring(render(layout,h,v,button))
                    classes=doc.get('class').split()
                    assert 'justify-content-'+(vval if layout=='Vertical' else hval) in classes
                    assert 'align-items-'+(hval if layout=='Vertical' else vval) in classes
                    assert ('flex-column' if layout=='Vertical' else 'flex-row') in classes
                    assert 'gap-2' in classes and doc.tag=='ul'
                    a=doc.find('./li/a')
                    assert a.text=='Apply & Learn <more>' and a.get('href')=='/apply?a=1&b=2'
                    assert a.get('class')=='btn btn-outline-secondary btn-lg'
        default=ET.fromstring(render(buttons=button.replace('btn-lg','invalid').replace('btn-outline-secondary','invalid')))
        assert default.find('./li/a').get('class')=='btn btn-primary'
        assert 'justify-content-start align-items-start' in default.get('class')
        assert not render(buttons=button.replace('Apply &amp; Learn &lt;more&gt;','&#160;')).strip()
        assert not render(buttons=button.replace('/apply?a=1&amp;b=2','')).strip()
        assert not render().strip()
        plain=button.replace('<a href="/apply?a=1&amp;b=2">Apply</a>','/apply').replace('btn-lg','btn-sm')
        assert len(ET.fromstring(render(buttons=button+plain)).findall('./li/a'))==2
        assert ET.fromstring(render(buttons=plain)).find('./li/a').get('href')=='/apply'
        print('PASS: 18 alignment combinations, repeatable buttons, URL formats, escaping, defaults and empty-value suppression.')
if __name__=='__main__': run()
