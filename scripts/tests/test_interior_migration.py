import importlib.util
from pathlib import Path
import re
from html.entities import name2codepoint
import unittest
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('migration', ROOT / 'scripts/migrate-interior.py')
migration = importlib.util.module_from_spec(spec)
spec.loader.exec_module(migration)

class MigrationTests(unittest.TestCase):
    def test_preserves_existing_selections_content_and_is_idempotent(self):
        for layout in ('two', 'three'):
            for media in ('off', 'banner', 'slider'):
                source = f'''<?pcf-stylesheet path="/_resources/xsl/interior.xsl"?><document xmlns:ouc="http://omniupdate.com/XSL/Variables"><ouc:properties label="config"><parameter name="layout"><option value="{layout}" selected="true">Old Label</option></parameter><parameter name="top-media"><option value="{media}" selected="true">Old Media</option></parameter></ouc:properties><ouc:div label="right-content" button-text="Right Column Content"><p>Preserve this &amp; that</p></ouc:div></document>'''
                result = migration.migrate(source)
                doc = ET.fromstring(result)
                self.assertEqual(doc.find('.//parameter[@name="layout"]/option[@selected="true"]').get('value'), layout)
                self.assertEqual(doc.find('.//parameter[@name="top-media"]/option[@selected="true"]').get('value'), media)
                self.assertIn('<p>Preserve this &amp; that</p>', result)
                self.assertIn('button-text="Additional Content"', result)
                self.assertEqual(migration.migrate(result), result)
    def test_other_templates_unchanged(self):
        source = '<?pcf-stylesheet path="/_resources/xsl/other.xsl"?><document/>'
        self.assertEqual(migration.migrate(source), source)
    def test_new_template_default(self):
        source = (ROOT / '_resources/ou/templates/interior.tmpl').read_text()
        source = re.sub(r'<!--%.*?-->', 'Example', source)
        doc = ET.fromstring(source)
        self.assertEqual(doc.find('.//parameter[@name="layout"]/option[@selected="true"]').get('value'), 'one')
    def test_repository_exports_parse_and_keep_region_content(self):
        count = 0
        ns = {'ouc': 'http://omniupdate.com/XSL/Variables'}
        for path in ROOT.rglob('*.pcf'):
            if '_archive' in path.parts: continue
            source = path.read_text()
            result = migration.migrate(source)
            if result == source: continue
            decode = lambda text: re.sub(r'&([a-zA-Z]+);', lambda m: '&#{};'.format(name2codepoint[m[1]]) if m[1] in name2codepoint else m[0], text)
            before, after = ET.fromstring(decode(source)), ET.fromstring(decode(result))
            for label in ('main-content', 'right-content', 'gallery'):
                a = before.find(f"ouc:div[@label='{label}']", ns)
                b = after.find(f"ouc:div[@label='{label}']", ns)
                if a is not None:
                    self.assertEqual(''.join(a.itertext()), ''.join(b.itertext()), str(path))
            self.assertEqual(migration.migrate(result), result)
            count += 1
        self.assertGreater(count, 0)

if __name__ == '__main__': unittest.main()
