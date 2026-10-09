<!DOCTYPE html>

<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta charset="utf-8">
  <link href="https://markable.in/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://markable.in//static/css/style.css" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="https://markable.in/static/editor/css/view_file.css">
  <link rel="stylesheet" type="text/css" href="https://markable.in/static/css/code.css">
</head>
<body>
  <div class="container">
    <div id="content">
      <h1 id="lake-tahoe-community-college-development-notes">Lake Tahoe Community College Development Notes</h1>
<hr />
<h3 id="templates">Templates</h3>
<hr />
<p>Clicking the "New" button in OUCampus gives you the option to create one of the following page types, sections and/or widgets.</p>
<ol>
<li>
<p>New Section</p>
<ul>
<li>Creates a new section with a _nav.inc and _props.pcf files. <ul>
<li>
<p>TCF Properties</p>
<ul>
<li>Directory Name: Name of the directory. Refer to alt-text under the field of entry.</li>
<li>Friendly Name: Visual name of the directory. Refer to alt-text under the field of entry.</li>
<li>Page Title: Page title used in Meta tags and page content. Refer to alt-text under the field of entry.</li>
<li>Description: Meta tag description.</li>
<li>Add Navigation Item: Automatically add the page to the local navigation of the current directory where the new section was created in. The link will display in _nav.inc file. For nested navigation it is best practice to let the add navigation maintain the creation of new links. Links text and actions can still be updated in the WYSIWYG. </li>
<li>Overwrite existing: This will overwrite any files with the same name.</li>
<li>Access Group: Select a group for access to this directory and its contents.</li>
</ul>
<p>**** Note: New section will create a new interior page with default values of an interior page type.</p>
</li>
</ul>
</li>
</ul>
</li>
<li>
<p>New Interior Page   </p>
<ul>
<li>
<p>Creates a new interior page. This is a content page. This is not a section template.   </p>
<ul>
<li>TCF Properties<ul>
<li>Page Title: Page title used in Meta tags and page content. Refer to alt-text under the field of entry.</li>
<li>Description: Meta tag description.</li>
<li>Add Navigation Item: Automatically add the page to the local navigation of the current directory where the new section was created in. The link will display in _nav.inc file. For nested navigation it is best practice to let the add navigation maintain the creation of new links. Links text and actions can still be updated in the WYSIWYG. </li>
<li>Filename: Enter the file name. Refer to alt text for naming conventions. </li>
<li>Overwrite existing: This will overwrite any files with the same name.</li>
<li>Access Group: Select a group for access to this file.</li>
</ul>
</li>
<li>Page Properties (Available for all pages unless stated as template specific)<ul>
<li>Title (Meta Tags): Separate title that is for Meta tags. </li>
<li>Description (Meta Tags): Description information for Meta tags.</li>
<li>Page Heading: Page title by default from TCF but can be changed after page creation. The heading will be displayed above either the banner image or the slider. </li>
<li>Breadcrumb: Page title by default from TCF but can be changed after page creation. Leave blank to use title as breadcrumb text.</li>
<li>Banner / Slider: Choose between "Slider" and "Banner".</li>
<li>Banner Image: File chooser page property for "Banner" option. This property can be used if the Banner / Slider property is set to "Banner"</li>
<li>Banner Alt-Text: Text field for Banner alternate text. </li>
<li>Number of Columns: "Two Column" and "Three Column"</li>
<li>LDP Gallery: Select which gallery will be used for editable regions. Galleries available: Flex Slider, Magnific PopUp Pretty Photo, and Fancy Box.</li>
</ul>
</li>
</ul>
</li>
<li>
<p>Editable Regions</p>
<ul>
<li>Select Slider: This is a gallery asset chooser, will only appear if Top of Page Media is set to "Slider".</li>
<li>Main Content: This is the main content region and will appear if the layout is set to two or three column.</li>
<li>Right Column Content: This is the right content region. This region will only appear if the "Number of Columns" property is set to "Three Column". </li>
</ul>
</li>
</ul>
</li>
<li>
<p>New Article Page</p>
<ul>
<li>Creates a new article page. This is a content page. This is not a section template.   <ul>
<li>TCF Properties<ul>
<li>Page Title: Page title used in Meta tags and page content. Refer to alt-text under the field of entry.</li>
<li>Description: Meta tag description.</li>
<li>Date of Article: Date picker to select an RSS date. Parsing script takes into account that the user sets the article date in the TCF. OU Campus does not update the Date property upon changes if the date has been modified after the initial page creation. To perform an update to the publish date after the page has been created, additional RSS editing is required. If editing / modifying the date property, any changes made will have to be applied to the RSS page properties. (Refer to OU Support site for editing RSS page properties).</li>
<li>Thumbnail: File chooser for a thumbnail. Path is not defined. The thumbnail property is required when parsing the feed. The main news landing page displays a thumbnail. The thumbnail has to be defined upon page creation. If editing / modifying the thumbnail, any changes made will have to be applied to the RSS page properties. (Refer to OU Support site for editing RSS page properties).</li>
<li>Image: File chooser for an image. Path is not defined. For RSS parsing and news snippet display functionality, the image has to be defined upon page creation. If editing / modifying the image, any changes made will have to be applied to the RSS page properties. (Refer to OU Support site for editing RSS page properties).</li>
<li>Filename: Enter the file name. Refer to alt text for naming conventions. </li>
<li>Add Navigation Item: Automatically add the page to the local navigation of the current directory where the new section was created in. The link will display in _nav.inc file. For nested navigation it is best practice to let the add navigation maintain the creation of new links. Links text and actions can still be updated in the WYSIWYG.  </li>
<li>Overwrite existing: This will overwrite any files with the same name.</li>
<li>Access Group: Select a group for access to this file.</li>
</ul>
</li>
<li>Page Properties (Available for all pages unless stated as template specific)<ul>
<li>Same as Interior Plus<ul>
<li>News Template Specific Variables<ul>
<li>Article Date: Date picker property to edit the date of the article. If this is edited/changed the RSS properties for this article item will have to be changed as well. </li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
<li>
<p>New File</p>
</li>
<li>
<p>Creates an empty file with .inc extension that can be changed. </p>
</li>
</ul>
</li>
<li>
<p>News Section</p>
<ul>
<li>Creates a new article page. This is a content page. This is not a section template.   <ul>
<li>TCF Properties (Same as new section) this will create a news-listing page type.<ul>
<li>The news listing page type will contain the following page properties</li>
</ul>
</li>
<li>Page Properties<ul>
<li>Heading (Same as interior)</li>
<li>Breadcrumb (Same as interior)</li>
<li>RSS Specific Property - Feed: This is a file chooser set to /rss folder that will contain all OU Campus RSS Feeds.</li>
<li>RSS Specific Property - Items: This is a text field property that requires a numerical value input, e.g. 1,2, up to N. This will determine how many news items (articles) to display on one page. (Default pagination)</li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
</ol>
<h3 id="template-home-page">Template - Home Page</h3>
<pre><code>*   No TCF Available
*   Page Properties:
    *   Title: Meta title property.
    *   Description: Meta description property.
    *   Column One
        *   News Heading: This will be the heading of the column one section. This is a text field.
        *   News Link: This is a file chooser to the news landing / news section page that will be created later.
        * News Link Title Attribute: This is the text value for the news link title attribute.
        *   RSS Property - News Feed: This is a file chooser to the /rss folder. Select news feed to enact the parsing script.
        *   RSS Property - No. of News Items: This is a numerical text field property similar to the news section list page. This filed requires a number to be entered, e.g. 1,2, up to three. More than three items will cause display results / errors from the design.
    *   Column Two
        *   Events Heading: This will be the heading of the column two section. This is a text field.
        *   Events Link: This is a text field. Copy and paste the calendar link or leave as /calendar.
        Events Link Title Attribute: This is the text value for the events link title attribute.
        *   RSS Property - Events Feed: A text field, copy and paste the url from the Helios tools RSS link builder from "/calendar" to the end of the link generated. 
            *   Note: Change feed.php to wnl.php to have the parsing correctly display event items.
        *   RSS Property - No. Of Event Items: This is a numerical text field property similar to the news items and news listing numerical properties. This field requires number values, e.g. 1,2, N. Up to four items. More than four items will render different display results / errors from the design.
    *   Column Three
        *   Gallery Type: Select which gallery will be used for the third column region. Galleries available: Flex Slider, Magnific PopUp Pretty Photo, and Fancy Box.

*   Editable Regions:
    *   Select Slider: Gallery asset chooser for the home page main gallery.
    *   Right Column Content 1: This is the top of the third column that has the page property for the gallery.
    *   Right Column Content 2: This is the bottom / second half of the third column that can be general content or have the google map snippet added.
</code></pre>
<h3 id="section-files">Section Files</h3>
<hr />
<ul>
<li>
<p>_nav.inc</p>
<p>Nested navigation is used for all page types (news, interior, etc.). This is an automatically generated file. This file must be  published. Note that this file should only contain <li> elements. Avoid linking to an index/default page.  </p>
</li>
<li>
<p>_props.pcf</p>
<p>Resources file for directory name, first navigation menu item, and breadcrumbs. </p>
</li>
</ul>
<h3 id="directory-variables">Directory Variables</h3>
<hr />
<ul>
<li>None</li>
</ul>
<h3 id="includes">Includes</h3>
<hr />
<ul>
<li>
<p>address.inc</p>
<p>Contains the college address.. </p>
</li>
<li>
<p>analytics.inc</p>
<p>Google-analytics code in this file. Make changes as necessary for analytics, save and publish out when done. Google analytics code is included on all pages. </p>
</li>
<li>
<p>calendar-links.inc</p>
<p>This is a navigation include similar to the “_nav.inc” file, that will allow a user to add additional links to the calendar navigation menu thru OU Campus. Remove all links in this file to not have any additional calendar menu links. File should only contain 'li' and 'a' html. No other additional content / code.</p>
</li>
<li>
<p>copyright.inc</p>
<p>Contains the copy right and direct edit button. Please be careful when editing this file.</p>
</li>
<li>
<p>footcode-cal.inc</p>
<p>Includes a copy of scripts that are inserted after the footer for calendar pages which doesn't include the direct edit ou script.</p>
</li>
<li>
<p>footcode.inc</p>
<p>Includes a copy of scripts that are inserted after the footer for pages including direct edit ou script.</p>
</li>
<li>
<p>headcode.inc</p>
<p>Headcode scripts for pages that does include oustyles.css. </p>
</li>
<li>
<p>header-navigation.pcf (to php)</p>
<p>Menu navigation builder file, user can have up to seven sub/navigational menus. Each menu navigation has properties that will change the content of each menu. This file also contains the top navigation items. When changes are made a publish is required.</p>
</li>
<li>
<p>header-brand.inc</p>
</li>
</ul>
<p>Contains the top logo and with the university name and slogan.</p>
<ul>
<li>
<p>ltcc-alert.inc</p>
<p>Includes the ltcc alert image / logo.</p>
</li>
<li>
<p>scorecard.inc</p>
<p>Includes the scorecard image / logo.</p>
</li>
<li>
<p>search.inc</p>
<p>Contains the search-results node that is used for the search.    </p>
</li>
<li>
<p>search-results.inc</p>
<p>Contains the form for the GCSE code for searching the college pages.    .</p>
</li>
<li>
<p>social.inc</p>
<p>Contains the social media icons and links. Edit this file in source tab. Only the href's will need to be edited as the CSS renders the icons from the span and i classes.</p>
</li>
</ul>
<h3 id="snippets">Snippets</h3>
<hr />
<ul>
<li>
<p>Google Maps iFrame</p>
<ul>
<li>File: /_resources/snippets/iframe.html  </li>
<li>Info: This is a table transformation, that requires the user to edit the URL for the iframe. An example is provided in the table.</li>
</ul>
</li>
</ul>
    </div>
  </div>
<!-- ouc:button --><a id="de" href="https://a.cms.omniupdate.com/11/?skin=oucampus&amp;account=ltcc&amp;site=www&amp;action=de&amp;path=/var/staging/oucampus/ltcc/www/_resources/notes/ltcc_dev_doc.php" >©</a><!-- /ouc:button --></body>
</html>
