"""Compile alert components and execute generated PHP; stub CMS globals only."""
from pathlib import Path
import tempfile
import subprocess
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor
ROOT = Path(__file__).resolve().parents[2]

def run():
    previews=[]
    with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
        path=Path(directory)/'test.xsl'
        path.write_text('''<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables"><xsl:import href="'''+(ROOT/'_resources/xsl/_shared/components.xsl').as_uri()+'''"/><xsl:param name="ou:action" select="'pub'"/><xsl:output method="html" omit-xml-declaration="yes"/><xsl:mode on-no-match="shallow-copy"/></xsl:stylesheet>''')
        transform=proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(path))
        def render(display='always', start='', end='', style='default', action='pub', title='Register for Fall Classes', icon='fa-bell', dismissible='true'):
            root=ET.Element('{http://omniupdate.com/XSL/Variables}component',name='component-alert'); ul=ET.SubElement(root,'ul')
            for field,value in [('dismissible',dismissible),('start',start),('end',end),('display',display),('style',style),('title',title),('button-text','Register Now'),('button-link','/register/?a=1&b=2'),('icon',icon)]:
                ET.SubElement(ul,'li',{'class':field}).text=value
            content=ET.SubElement(ul,'li',{'class':'content'});p=ET.SubElement(content,'p');p.text='Fall classes begin on August 24. Search the online schedule for ';ET.SubElement(p,'strong').text='in-person, hybrid & online classes.'
            transform.set_parameter('{http://omniupdate.com/XSL/Variables}action',proc.make_string_value(action))
            return transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=ET.tostring(root,encoding='unicode')))
        def execute(output, document_root=ROOT):
            php=Path(directory)/'output.php';php.write_text("<?php $_SERVER['DOCUMENT_ROOT'] = "+repr(str(document_root))+"; ?>"+output)
            subprocess.run(['php','-l',str(php)],check=True,capture_output=True)
            return subprocess.run(['php',str(php)],check=True,capture_output=True,text=True).stdout
        for style in ('default','info','emergency'):
            output=render(style=style)
            assert 'ltcc-alert--'+style in output
            assert 'data-bs-dismiss="alert"' in output and 'aria-label="Dismiss alert"' in output
            assert '<strong>' in output and 'fa-sharp fa-regular fa-bell' in output
            assert 'role="alert"' in output if style=='emergency' else 'role="status"' in output
            assert 'a=1&amp;b=2' in output
            previews.append(output)
        for value, expected in [('Info', 'info'), (' EMERGENCY ', 'emergency'), ('\u00a0info\u00a0', 'info')]:
            assert 'ltcc-alert--'+expected in render(style=value)
        for icon in ('fa-bell','fa-circle-exclamation','fa-circle-info','fa-smile','fa-bullhorn'):
            assert 'fa-sharp fa-regular '+icon in render(icon=icon)
        assert 'btn-close' not in render(dismissible='false')
        assert 'alert-dismissible' not in render(dismissible='false')
        assert not render(display='hide').strip()
        assert not render(display='invalid').strip()
        assert 'ltcc-alert' in execute(render(display='scheduled',start='2000-01-01T00:00',end='2999-01-01T00:00'))
        assert not execute(render(display='scheduled',start='2999-01-01T00:00')).strip()
        assert execute(render(display='scheduled') + '<p>Page still renders</p>', Path(directory)).strip() == '<p>Page still renders</p>'
        assert not execute(render(display='scheduled',end='2000-01-01T00:00')).strip()
        assert not execute(render(display='scheduled',start="'); echo 'injected'; //")).strip()
        assert execute(render(display='scheduled')) .count('ltcc-alert--default')==1
        assert execute(render(display='scheduled')+render(display='scheduled')).count('ltcc-alert--default')==2
        preview=render(display='hide',action='prv')
        assert 'Hidden on publish' in preview and 'ltcc-alert' in preview and '<?php' not in preview
        assert '&lt;script&gt;' in render(title='<script>')
        assert 'ltcc-alert--default' in render(style='invalid',icon='invalid')
        # Check alert.pcf -> alert.xsl with only the unavailable CMS common layer stubbed.
        (Path(directory)/'common.xsl').write_text(path.read_text().replace('<xsl:mode on-no-match="shallow-copy"/>', """<xsl:mode on-no-match="shallow-copy"/><xsl:function name="ou:include-file"><xsl:param name="path"/><xsl:comment>include <xsl:value-of select="$path"/></xsl:comment></xsl:function><xsl:template match="ou:div"><xsl:apply-templates/></xsl:template><xsl:template match="ou:editor"/><xsl:template match="/"><xsl:apply-templates select="document"/></xsl:template>"""))
        alert_path=Path(directory)/'alert.xsl'
        alert_path.write_text((ROOT/'_resources/xsl/alert.xsl').read_text())
        alert_transform=proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(alert_path))
        pcf=(ROOT/'_resources/includes/alert.pcf').read_text()
        import re
        pcf=re.sub(r'<!DOCTYPE[^>]+>', '', pcf)
        assert 'show-alert' not in pcf
        assert not alert_transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=pcf)).strip()
        published=alert_transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=pcf.replace('>hide<','>always<')))
        assert 'ltcc-alert--default' in published and '<html' not in published
        alert_transform.set_parameter('{http://omniupdate.com/XSL/Variables}action',proc.make_string_value('prv'))
        preview=alert_transform.transform_to_string(xdm_node=proc.parse_xml(xml_text=pcf))
        assert '<html' in preview and 'Hidden on publish' in preview
        print('PASS: styles/icons, WYSIWYG/escaping, preview states, PHP scheduling, multiple alerts and injection-safe dates.')
    return previews
if __name__=='__main__': run()
