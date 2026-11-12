#!/usr/bin/env python3
"""Update exported Interior Page PCFs. Dry-run by default; --write saves .bak copies."""
import argparse
from pathlib import Path
import re

PARAM = re.compile(r'<parameter\b(?P<attrs>[^>]*)>(?P<body>.*?)</parameter>', re.S)
def attr(text, name):
    match = re.search(r'\b' + re.escape(name) + r'\s*=\s*([\'"])(.*?)\1', text, re.S)
    return match.group(2) if match else None

def migrate(text):
    if not re.search(r'<\?pcf-stylesheet\b[^?]*path=[\'"]/_resources/xsl/interior\.xsl[\'"]', text):
        return text
    changes = []
    for match in PARAM.finditer(text):
        name = attr(match['attrs'], 'name')
        if name not in ('layout', 'top-media'):
            continue
        options = re.findall(r'<option\b([^>]*)>(.*?)</option>', match['body'], re.S)
        selected = [attr(attrs, 'value') for attrs, _ in options if attr(attrs, 'selected') == 'true']
        if len(selected) > 1:
            raise ValueError('Multiple selected options in ' + name)
        value = selected[0] if selected else re.sub('<[^>]+>', '', match['body']).strip()
        choices = [('one', '1 Column'), ('two', '2 Columns Nav'), ('three', '2 Columns with Additional Content'), ('full', 'Full Width')] if name == 'layout' else [('slider', 'Slider'), ('banner', 'Banner'), ('hero', 'Hero'), ('off', 'Off')]
        value = value or ('one' if name == 'layout' else 'off')
        if value not in dict(choices):
            raise ValueError('Unknown ' + name + ' value: ' + value)
        attrs = match['attrs']
        prompt = 'Number of Columns' if name == 'layout' else 'Top of Page Media'
        description = 'Choose a reading-width column, navigation, additional content, or full browser width.' if name == 'layout' else 'Hero is full width and replaces the page heading; Banner and Slider remain in the content area.'
        for key, val in [('prompt', prompt), ('alt', description)]:
            attrs, count = re.subn(r'\b' + key + r'\s*=\s*([\'"]).*?\1', key + '="' + val + '"', attrs, flags=re.S)
            if not count: attrs += ' ' + key + '="' + val + '"'
        body = '\n' + '\n'.join('    <option value="{}" selected="{}">{}</option>'.format(k, str(k == value).lower(), label) for k, label in choices) + '\n'
        changes.append((match.start(), match.end(), '<parameter' + attrs + '>' + body + '</parameter>'))
    for start, end, replacement in reversed(changes):
        text = text[:start] + replacement + text[end:]
    if not re.search(r'<parameter\b[^>]*name=[\'"]show-breadcrumbs[\'"]', text):
        region = re.search(r'<ouc:properties\b[^>]*label=[\'"]config[\'"][^>]*>', text)
        if not region: raise ValueError('No config properties region')
        text = text[:region.end()] + '''
        <parameter name="show-breadcrumbs" type="select" group="Everyone" prompt="Show Breadcrumbs" alt="Show or hide the breadcrumb trail.">
            <option value="true" selected="true">Show</option>
            <option value="false" selected="false">Hide</option>
        </parameter>''' + text[region.end():]
    if not re.search(r'<ouc:div\b[^>]*label=[\'"]hero-content[\'"]', text):
        region = '''    <ouc:div label="hero-content" group="Everyone" button-text="Hero Content">
        <ouc:editor csspath="/_resources/ou/editor/wysiwyg.css" cssmenu="/_resources/ou/editor/styles.txt" wysiwyg-class="hero-content"/>
    </ouc:div>
'''
        text = text.replace('</document>', region + '</document>', 1)
    text = re.sub(r'(<ouc:div\b[^>]*label=[\'"]right-content[\'"][^>]*\bbutton-text=)([\'"])Right Column Content\2', r'\1"Additional Content"', text)
    return text

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('root', type=Path, help='Exported PCF directory or single PCF')
    parser.add_argument('--write', action='store_true')
    args = parser.parse_args()
    paths = [args.root] if args.root.is_file() else sorted(args.root.rglob('*.pcf'))
    changed = 0
    for path in paths:
        if '_archive' in path.parts: continue
        original = path.read_text()
        try: updated = migrate(original)
        except ValueError as error:
            print('REVIEW', path, error)
            continue
        if updated == original: continue
        changed += 1
        print('UPDATE' if args.write else 'WOULD UPDATE', path)
        if args.write:
            backup = path.with_suffix(path.suffix + '.bak')
            if backup.exists(): raise SystemExit('Refusing to overwrite backup: ' + str(backup))
            backup.write_text(original)
            path.write_text(updated)
    print('{} file(s) {}.'.format(changed, 'updated' if args.write else 'would change; no files written'))

if __name__ == '__main__': main()
