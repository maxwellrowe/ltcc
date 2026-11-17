"""Hero XSL tests with CMS globals stubbed; generates reusable demo markup."""
from pathlib import Path
import tempfile
import xml.etree.ElementTree as ET
from saxonche import PySaxonProcessor
ROOT=Path(__file__).resolve().parents[2]

def run():
    with tempfile.TemporaryDirectory() as directory, PySaxonProcessor(license=False) as proc:
        path=Path(directory)/'test.xsl'
        path.write_text('''<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ou="http://omniupdate.com/XSL/Variables"><xsl:import href="'''+(ROOT/'_resources/xsl/_shared/components.xsl').as_uri()+'''"/><xsl:variable name="ou:action" select="'pub'"/><xsl:mode on-no-match="shallow-copy"/><xsl:output method="xml" omit-xml-declaration="yes"/></xsl:stylesheet>''')
        t=proc.new_xslt30_processor().compile_stylesheet(stylesheet_file=str(path))
        def source(count=2,title='Academics',options=False):
            root=ET.Element('{http://omniupdate.com/XSL/Variables}component',name='component-hero');ul=ET.SubElement(root,'ul')
            for key,value in [('title',title),('pre-title','Find your path' if options else ''),('subtitle','Elevated education starts here' if options else ''),('cta-label','Explore your options' if options else '')]: ET.SubElement(ul,'li',{'class':key}).text=value
            images=ET.SubElement(ul,'li',{'class':'images'})
            for i in range(count):
                row=ET.SubElement(images,'ul'); field=ET.SubElement(row,'li',{'class':'image'})
                src='/_dev/bootstrap-theme/hero-example.png' if i==0 else '/_resources/images/homepage/gallery-2.jpg'
                if i==0: ET.SubElement(field,'img',src=src,alt='Students practice emergency care')
                else: field.text=src; ET.SubElement(row,'li',{'class':'alt'}).text='Campus life'
            row=ET.SubElement(images,'ul');ET.SubElement(row,'li',{'class':'image'}).text='\u00a0'
            ctas=ET.SubElement(ul,'li',{'class':'ctas'})
            for text,href in [('Explore','#explore'),('Ways to Learn','#learn'),('Planning','#planning'),('Support','/support/'),('Missing link','')]:
                row=ET.SubElement(ctas,'ul');ET.SubElement(row,'li',{'class':'text'}).text=text;ET.SubElement(row,'li',{'class':'link'}).text=href
            return root
        def render(node): return t.transform_to_string(xdm_node=proc.parse_xml(xml_text=ET.tostring(node,encoding='unicode')))
        previews=[]
        for count in (2,1,0):
            markup=render(source(count,options=count==0));doc=ET.fromstring(markup)
            assert len(doc.findall('.//img[@class="ltcc-hero__image"]'))==count
            assert len(doc.findall('.//button'))==(3 if count>1 else 0)
            assert ('ltcc-hero-swiper' in markup)==(count>1)
            assert len(doc.findall('.//li/a'))==4
            assert doc.get('aria-labelledby')==doc.find('.//h1').get('id')
            assert len(doc.findall('.//span[@class="mkt-link__icon fa-sharp fa-regular fa-arrow-down"]'))==3
            if count: assert doc.find('.//img[@class="ltcc-hero__image"]').get('alt')=='Students practice emergency care'
            previews.append(markup)
        for value, visible in [('true', True), ('false', False), (' FALSE ', False)]:
            node=source(options=True)
            ET.SubElement(node.find('ul'), 'li', {'class':'show-ctas'}).text=value
            output=render(node)
            assert ('ltcc-hero__ctas' in output)==visible
            assert ('hero-mountain.svg' in output)==visible
            assert ('Explore your options' in output)==visible
            assert '<h1' in output and 'ltcc-hero-swiper' in output
        wrapper=ET.Element('root');wrapper.append(source());wrapper.append(source())
        doc=ET.fromstring(render(wrapper));ids=[el.get('id') for el in doc.iter() if el.get('id')];assert len(ids)==len(set(ids))
        empty=ET.Element('{http://omniupdate.com/XSL/Variables}component',name='component-hero');assert not render(empty).strip()
        node=source(1,title='<script> & text');assert '&lt;script&gt;' in render(node)
        print('PASS: static/multiple/no images, blank rows, optional fields, CTA handling, alt text, unique IDs and escaping.')
        return previews
if __name__=='__main__': run()
