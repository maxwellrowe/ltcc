<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!--
Implementations Skeletor v3 - 5/10/2014

COMMMON STYLESHEET 
Imported by all page type-specific stylesheets, and imports utility stylesheets.
Defines html, xsl templates and functions used globally throughout the implementation
Defines outer html structure and common include content.

Contributors: cwilson
Last Updated: 1/2016
-->
<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="xsl xs ou fn ouc">
	
	<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/variables.xsl"/> <!-- global variables -->
<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/functions.xsl"/> <!-- global functions -->
<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/standard-outputs.xsl"/> <!-- global standard outputs -->
<xsl:import href="/var/staging/OMNI-INF/stylesheets/snippet-helper/v1/snippet-helper.xsl"/> <!-- global snippet helper code -->
<xsl:import href="/var/staging/OMNI-INF/stylesheets/implementation/v1/components.xsl"/> <!-- global component code -->

	<xsl:import href="_shared/template-matches.xsl"/>
	<xsl:import href="_shared/ouvariables.xsl"/>
	<xsl:import href="_shared/functions.xsl"/>
	<xsl:import href="_shared/breadcrumb.xsl"/>
	<xsl:import href="_shared/galleries.xsl"/>
	<xsl:import href="_shared/forms.xsl"/>
	<xsl:import href="_shared/snippets.xsl"/>
	<xsl:import href="_shared/components.xsl"/>
	<xsl:import href="_shared/transformations.xsl"/>
	<!-- Default: for HTML5 use below output declaration -->
	<xsl:output method="html" version="5.0" indent="yes" encoding="UTF-8" include-content-type="no"/>

	<!-- If using xml or xhtml output, add in the below attribute to your xsl:output statement -->
	<!-- omit-xml-declaration="yes" -->

	<!-- If your output is not HTML5 -->
	<!-- 
<xsl:output method="html" version="4.01"     
doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd" 
indent="yes" encoding="UTF-8" include-content-type="no" /> 
-->

	<xsl:template match="/document"> 		
		<xsl:text disable-output-escaping="yes">&lt;</xsl:text>!--[if IE 8]<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>html class="no-js lt-ie9" lang="en-us"<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>![endif]--<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;</xsl:text>!--[if gt IE 8]<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>!--<xsl:text disable-output-escaping="yes">&gt;</xsl:text> 
		<xsl:text disable-output-escaping="yes">&lt;</xsl:text>!-- begin html --<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
		<html class="no-js" lang="en-us">
			<xsl:text disable-output-escaping="yes">&lt;</xsl:text>!--<xsl:text disable-output-escaping="yes">&lt;</xsl:text>![endif]--<xsl:text disable-output-escaping="yes">&gt;</xsl:text>	
			<head>
				<link rel="stylesheet" href="https://www.ltcc.edu/_resources/css/bootstrap_iso.css"/>
				<link href="https://www.ltcc.edu/_resources/css/academic-landing-styles-ou-edits.css" rel="stylesheet" /> <!-- Would be a good idea to move this to headcode.inc file -->
				<xsl:call-template name="common-headcode"/> <!-- common headcode -->
				<xsl:call-template name="template-headcode"/> <!-- each page type may have a version of this template -->				
				<xsl:apply-templates select="headcode/node()"/> <!-- pcf -->			
				<!-- copy meta tags from pcf, but only those with content -->				
				<xsl:apply-templates select="/document/ouc:properties[@label='metadata']/meta[string-length(@content)>0]"/>
				<script type="text/javascript">
					var page_url="<xsl:value-of select="concat(string-join(remove(tokenize(substring($ou:httproot, 1), '/'), count(tokenize(substring($ou:httproot, 1), '/'))), '/'),$ou:path)"/>";
				</script>
				
				<!-- Fiftieth Anniversary CSS -->
				<xsl:copy-of select="ou:include-file('/_resources/fiftieth-anniversary/css.inc')"/>
				
				<xsl:call-template name="form-headcode"/>
			</head>
			<body>
				<xsl:attribute name="class">
					fifty-landing-page
					<xsl:if test="ou:pcf-param('mkt-header') = 'global-header' ">
						<xsl:text> fifty-global-header</xsl:text>
					</xsl:if>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="ou:pcf-param('page-id')" />
				</xsl:attribute>

				<xsl:apply-templates select="bodycode/node()"/> <!-- pcf -->		

				<xsl:call-template name="common-bodycode"/> 
				
				<xsl:choose>
					<xsl:when test="$ou:action = 'pub'">
						<xsl:copy-of select="ou:include-file('/_resources/includes/alert.php')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="unparsed-text-available(concat($domain, '/_resources/includes/alert.php'),'utf-8')">
							<xsl:value-of select="unparsed-text(concat($domain, '/_resources/includes/alert.php'),'utf-8')" disable-output-escaping="yes"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>	

				<div id="galaxy">
					<xsl:call-template name="common-header"/>
					<!-- page-content -->
					<xsl:call-template name="page-content"/> <!-- each page type has a unique version of this template --> 																	
					<xsl:apply-templates select="footcode/node()"/> <!-- pcf -->						
					<footer id="main-footer">
						<xsl:call-template name="common-footer"/>
					</footer>					
														
				</div>
				
				<xsl:copy-of select="ou:include-file('/_resources/includes/search-results.inc')" />
				<!-- </div>  / universe -->
				<!-- footcode include -->
				<xsl:copy-of select="ou:include-file('/_resources/includes/footcode.inc')"/>			
				<!-- OU Style -->
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/css/oustyles.css" />
				<xsl:if test="descendant::gallery">								
					<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script> 		
					<script src="http://code.jquery.com/jquery-migrate-1.1.0.min.js"></script>
					<script type="text/javascript">
						jQuery.noConflict();
					</script>
					<xsl:copy-of select="ou:gallery-footcode(ou:pcf-param('gallery-type'))"/>
				</xsl:if>  				

				<xsl:if test="descendant::ouform ">									
					<script type="text/javascript" src="https://www.ltcc.edu/_resources/js/ldp/ouforms.js"></script>
					<link rel="stylesheet" href="https://www.ltcc.edu/_resources/css/ldp/ouforms-bootstrap.css"/>
				</xsl:if>
				<!-- analytics include -->
				<xsl:copy-of select="ou:include-file('/_resources/includes/analytics.inc')"/>
				<div id="hidden" style='display:none;'><xsl:comment> com.omniupdate.ob </xsl:comment><xsl:comment> /com.omniupdate.ob </xsl:comment></div>				
				<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>		
<xsl:call-template name="form-footcode" />
				
				<!-- Fiftieth Anniversary Scripts -->
				<xsl:copy-of select="ou:include-file('/_resources/fiftieth-anniversary/scripts.inc')"/>
				

			</body>	
		</html>	
		<!-- end html -->
	</xsl:template>		

	<xsl:template name="common-headcode">
		<meta charset="utf-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/> 
		<title><xsl:value-of select="$page-title"/></title>
		<!-- headcode include -->
		<xsl:copy-of select="ou:include-file('/_resources/includes/headcode.inc')"/>
	</xsl:template>

	<xsl:template name="common-bodycode">
		<xsl:copy-of select="ou:include-file('/_resources/includes/bodycode.inc')"/>
		
	</xsl:template>

	<xsl:template name="common-header">
		<xsl:choose>
			<xsl:when test="ou:pcf-param('mkt-header') = 'global-header' ">
				<header class="logo-banner">
					<div class="row">				
						<!-- header include -->				
						<xsl:copy-of select="ou:include-file('/_resources/includes/header.inc')"/>
						<!-- navigation include -->
							<xsl:choose>
								<xsl:when test="$ou:action = 'pub'">
									<xsl:copy-of select="ou:include-file('/_resources/includes/header-navigation.php')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="unparsed-text-available(concat($domain, '/_resources/includes/header-navigation.php'),'utf-8')">
										<xsl:value-of select="unparsed-text(concat($domain, '/_resources/includes/header-navigation.php'),'utf-8')" disable-output-escaping="yes"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
					</div>
				</header>
			</xsl:when>
			<xsl:otherwise>
				<div class="ltcc-fifty-header py-4">
					<div class="container">
						<div class="d-flex justify-content-between align-items-center">
							<xsl:copy-of select="ou:include-file('/_resources/fiftieth-anniversary/header.inc')"/>
							<xsl:copy-of select="ou:include-file('/_resources/fiftieth-anniversary/navigation.inc')"/>
						</div>
					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="common-footer">
		<div class="row">
			<!-- scorecard image hidden at the moment -->
			<xsl:copy-of select="ou:include-file('/_resources/includes/scorecard.inc')"/>
			<!-- ltcc alert -->
			<xsl:copy-of select="ou:include-file('/_resources/includes/ltcc-alert.inc')"/>					
			<div class="social-links">
				<!-- social media icons -->
				<xsl:copy-of select="ou:include-file('/_resources/includes/social.inc')"/>
			</div>			
			<address>
				<!-- copyright symbol / direct edit -->
				<xsl:copy-of select="ou:include-file('/_resources/includes/copyright.inc')"/>
				<!-- physical address -->
				<xsl:copy-of select="ou:include-file('/_resources/includes/address.inc')"/>
			</address>
		</div>		
	</xsl:template>	

	<!-- in case not defined in page type xsl -->
	<xsl:template name="page-content"><p>No template defined.</p></xsl:template><!-- leave for debugging purposes -->			

	<xsl:template name="template-headcode"/> <!-- defined in each page type -->

	<xsl:template name="template-footcode"/> <!-- defined in each page type -->

</xsl:stylesheet>
