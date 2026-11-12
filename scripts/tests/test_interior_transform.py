"""Run with SaxonC installed; stub only the unavailable Modern Campus common import."""
from pathlib import Path
import tempfile
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor

ROOT = Path(__file__).resolve().parents[2]
STUB = '''<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou ouc">
<xsl:output method="xml"/>
<xsl:variable name="ou:action" select="/document/@action"/><xsl:variable name="ou:dirname" select="'/example'"/><xsl:variable name="ou:httproot" select="'https://example.edu'"/>
<xsl:variable name="input" select="/document"/>
<xsl:function name="ou:pcf-param"><xsl:param name="name"/><xsl:sequence select="string($input/parameter[@name=$name])"/></xsl:function>
<xsl:function name="ou:include-file"><xsl:param name="path"/><ul><li><a href="/example/">Section</a></li></ul></xsl:function>
<xsl:template name="breadcrumb"><xsl:param name="path"/><a href="/">Home</a><xsl:text> &gt; </xsl:text><span>Example</span></xsl:template>
<xsl:template match="/"><html><body><xsl:attribute name="class"><xsl:call-template name="page-body-class"/></xsl:attribute><header>Header</header><xsl:call-template name="page-after-header"/><main><xsl:for-each select="document"><xsl:call-template name="page-content"/></xsl:for-each></main></body></html></xsl:template>
<xsl:template match="ouc:div"><xsl:apply-templates/></xsl:template>
<xsl:template match="@*|node()"><xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy></xsl:template>
</xsl:stylesheet>'''

def run():
    with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
        folder = Path(directory)
        (folder / 'common.xsl').write_text(STUB)
        (folder / 'interior.xsl').write_text((ROOT / '_resources/xsl/interior.xsl').read_text())
        executable = proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(folder / 'interior.xsl'))
        count = 0
        for layout in ('one', 'two', 'three', 'full', ''):
            for media in ('off', 'banner', 'slider', 'hero'):
                for crumbs in ('true', 'false', ''):
                    for action in ('pub', 'edt'):
                        source = f'''<document xmlns:ouc="http://omniupdate.com/XSL/Variables" action="{action}"><parameter name="layout">{layout}</parameter><parameter name="top-media">{media}</parameter><parameter name="show-breadcrumbs">{crumbs}</parameter><parameter name="heading">Example Heading</parameter><parameter name="banner">/banner.jpg</parameter><parameter name="banner-alt">Example banner</parameter><ouc:div label="main-content"><p id="content-marker">Main content</p></ouc:div><ouc:div label="right-content"><p id="additional-marker">Additional content</p></ouc:div><ouc:div label="hero-content"><h1 id="hero-marker">Hero title</h1></ouc:div><ouc:div label="gallery"><p id="gallery-marker">Gallery</p></ouc:div></document>'''
                        node = proc.parse_xml(xml_text=source)
                        executable.set_global_context_item(xdm_item=node)
                        output = executable.transform_to_string(xdm_node=node)
                        doc = ET.fromstring(output)
                        sidebar = doc.find('.//aside')
                        assert (sidebar is not None) == (layout in ('two', 'three'))
                        additional = doc.find('.//*[@id="additional-marker"]')
                        assert (additional is not None) == (layout == 'three')
                        if additional is not None: assert sidebar.find('.//*[@id="additional-marker"]') is not None
                        assert (doc.find('.//*[@id="hero-marker"]') is not None) == (media == 'hero')
                        assert ('page-hero-enabled' in doc.find('body').get('class')) == (media == 'hero')
                        assert (doc.find('.//h1[@class="page-title"]') is not None) == (media != 'hero')
                        assert (doc.find('.//nav[@aria-label="Breadcrumb"]') is not None) == (crumbs != 'false')
                        if crumbs != 'false': assert len(doc.findall('.//ol/li')) == 2
                        assert (doc.find('.//*[@id="gallery-marker"]') is not None) == (media == 'slider')
                        if media == 'banner': assert doc.find('.//img').get('class') == 'img-fluid'
                        if layout == 'full': assert 'container-xl' not in output
                        if layout in ('one', ''): assert 'interior-reading-width' in output
                        assert doc.find('.//*[@id="content-marker"]') is not None
                        count += 1
        print(f'PASS: {count} layout/media/breadcrumb/action transformations (CMS services stubbed).')

if __name__ == '__main__': run()
