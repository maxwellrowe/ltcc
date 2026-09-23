<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY amp   "&#38;">
<!ENTITY copy   "&#169;">
<!ENTITY gt   "&#62;">
<!ENTITY hellip "&#8230;">
<!ENTITY laquo  "&#171;">
<!ENTITY lsaquo   "&#8249;">
<!ENTITY lsquo   "&#8216;">
<!ENTITY lt   "&#60;">
<!ENTITY nbsp   "&#160;">
<!ENTITY quot   "&#34;">
<!ENTITY raquo  "&#187;">
<!ENTITY rsaquo   "&#8250;">
<!ENTITY rsquo   "&#8217;">
]>
<!-- 
Widget Example: Global Header Widget

This is an example widget that shows the usage of widget.xsl for the standard PCF to Include Global Header solution.

In some implementations, it may be unnecessary to override the page-content template. when applicable, override a template that is called within the page-content template.
Override <xsl:template name="publish-output"/> to output just the widget content.

Contributors: Akifumi Yamamoto
Last Updated: 2017/10/10
-->
<xsl:stylesheet version="3.0" expand-text="yes"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				xmlns:xlink="https://www.w3.org/1999/xlink"
				xmlns:map="http://www.w3.org/2005/xpath-functions/map"
				xmlns:func="http://www.w3.org/2005/xpath-functions"
				exclude-result-prefixes="xs ou fn ouc xlink map func">

	<xsl:import href="50th-anniversary-widget.xsl"/>

	<xsl:template name="template-footcode"/>

	<!--
The mobile version of the header has a different publish output.
Create a new template match in addition to using the default publish-output template for the main header.
-->
	<xsl:template name="publish-output">
		<xsl:call-template name="common-header"/>
	</xsl:template>

	<xsl:template name="common-footer" />

	<xsl:template name="page-content">
		<xsl:apply-templates select="ouc:div[@label = 'top-links'][$is-edt]" mode="edt-btn" />
		<xsl:apply-templates select="ouc:div[@label = 'button-links'][$is-edt]" mode="edt-btn" />		
	</xsl:template>

	<xsl:template name="common-header">
		<header class="header">
			<div class="container">
				<xsl:apply-templates select="ouc:div[@label='button-links']/node()" mode="mobile"/>
				<div class="navbar-warpper">
					<div class="logo"><a href="{ou:pcf-param('logo-link')}"><img src="{ou:pcf-param('logo-img')}" alt="{ou:pcf-param('logo-alt')}" aria-label="{ou:pcf-param('logo-alt')}"/></a></div>
					<nav class="navbar">
						<xsl:apply-templates select="ouc:div[@label='top-links']/node()"/>
						<xsl:apply-templates select="ouc:div[@label='button-links']/node()" mode="desktop"/>
					</nav>
					<div class="mobile-navbar-btn">
						<div name="menu-outline" class="mobile-nav-icon" role="button" aria-label="Open Menu">
							<svg aria-hidden="true" class="e-font-icon-svg e-fas-align-justify" viewBox="0 0 448 512"
								 xmlns="http://www.w3.org/2000/svg">
								<path
									  d="M432 416H16a16 16 0 0 0-16 16v32a16 16 0 0 0 16 16h416a16 16 0 0 0 16-16v-32a16 16 0 0 0-16-16zm0-128H16a16 16 0 0 0-16 16v32a16 16 0 0 0 16 16h416a16 16 0 0 0 16-16v-32a16 16 0 0 0-16-16zm0-128H16a16 16 0 0 0-16 16v32a16 16 0 0 0 16 16h416a16 16 0 0 0 16-16v-32a16 16 0 0 0-16-16zm0-128H16A16 16 0 0 0 0 48v32a16 16 0 0 0 16 16h416a16 16 0 0 0 16-16V48a16 16 0 0 0-16-16z">
								</path>
							</svg>
						</div>
						<div name="close-outline" class="mobile-nav-icon" aria-label="Close Menu">
							<svg aria-hidden="true" tabindex="0" class="e-font-icon-svg e-far-window-close" viewBox="0 0 512 512"
								 xmlns="http://www.w3.org/2000/svg">
								<path
									  d="M464 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h416c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zm0 394c0 3.3-2.7 6-6 6H54c-3.3 0-6-2.7-6-6V86c0-3.3 2.7-6 6-6h404c3.3 0 6 2.7 6 6v340zM356.5 194.6L295.1 256l61.4 61.4c4.6 4.6 4.6 12.1 0 16.8l-22.3 22.3c-4.6 4.6-12.1 4.6-16.8 0L256 295.1l-61.4 61.4c-4.6 4.6-12.1 4.6-16.8 0l-22.3-22.3c-4.6-4.6-4.6-12.1 0-16.8l61.4-61.4-61.4-61.4c-4.6-4.6-4.6-12.1 0-16.8l22.3-22.3c4.6-4.6 12.1-4.6 16.8 0l61.4 61.4 61.4-61.4c4.6-4.6 12.1-4.6 16.8 0l22.3 22.3c4.7 4.6 4.7 12.1 0 16.8z">
								</path>
							</svg>
						</div>
					</div>
				</div>
			</div>
		</header>
	</xsl:template>

</xsl:stylesheet>