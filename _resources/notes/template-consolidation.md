# Modern Campus cleanup manifest

Scope: dependency cleanup only. The body will be rebuilt separately. No homepage
rendering was migrated into interior.xsl. Existing PCF content is preserved.

## Adjust

In `/index.pcf` and `/_calendar/index.pcf`, change the first pcf-stylesheet path
from `/_resources/xsl/home2022-calendar.xsl` to `/_resources/xsl/interior.xsl`.
Keep all other content and processing-instruction attributes unchanged.

`interior.xsl`, `common.xsl`, and `news.xsl` require no changes for this step.

## Archive

Move these from `/_resources/xsl/` into `/_resources/xsl/_archive/`:

- home.xsl
- home-38108.xsl
- home-99770.xsl
- home2022.xsl
- home2022-calendar.xsl
- common2022.xsl
- common2022-calendar.xsl

Move these from `/_resources/php/wnl/` into `/_resources/php/wnl/_archive/`:

- news_home_2022.php
- events_home_2022.php
- events_home_2022-1.php

## Order and validation

Update the two PCF references before archiving templates/helpers. Check for
additional CMS-only references, since this checkout is not the entire live site.
No references to these retired files remain in non-archived local implementation
files. Exact comparison confirms that only the two stylesheet paths changed in
the PCFs, and interior/common templates are unchanged. Full transforms require
the Modern Campus staging stylesheets/services and were not run locally.

Homepage-only source regions are preserved but are not rendered by the standard
interior template. This is intentional pending the body rebuild; preview before
publishing. Archived XSL retains historical paths and is not a runnable theme.

The independent anniversary theme and CMS support stylesheets remain unchanged.
