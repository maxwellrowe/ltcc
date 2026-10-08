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

	<!--Modern Global Variables and Functions-->
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
	<!-- 	<xsl:import href="_shared/forms.xsl"/> -->
	<xsl:import href="_shared/ouforms.xsl"/>
	<xsl:import href="_shared/snippets.xsl"/>
	<xsl:import href="_shared/components.xsl"/>
	<xsl:import href="_shared/snippets-50th-anniversary.xsl"/>
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
		<html lang="en">
			<head>
				<meta charset="UTF-8"/>
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<title><xsl:value-of select="$page-title"/></title>
				<!-- copy meta tags from pcf, but only those with content -->				
				<xsl:apply-templates select="/document/ouc:properties[@label='metadata']/meta[string-length(@content)>0]"/>
				<xsl:call-template name="common-headcode"/>
				<xsl:call-template name="template-headcode"/> <!-- each page type may have a version of this template -->				
				<xsl:apply-templates select="headcode/node()"/> <!-- pcf -->	
				<!-- 				<xsl:call-template name="form-headcode"/> -->
			</head>
			<body>
				<xsl:call-template name="common-bodycode"/> 
				<xsl:apply-templates select="bodycode/node()"/> <!-- pcf -->				
				<xsl:call-template name="common-header"/>
				<xsl:call-template name="page-content"/>		
				<xsl:call-template name="common-footer"/>
				<script src="/_resources/js/scripts-50th-anniversary.js"></script>			  
				<xsl:call-template name="common-footcode"/>
				<xsl:call-template name="direct-edit"/> <!-- outputs the direct edit OU Campus object and direct-edit js -->
				<xsl:call-template name="template-footcode"/> <!-- each page type may have a version of this template -->
				<xsl:apply-templates select="footcode/node()"/> <!-- pcf -->	
				<!-- analytics include -->
				<xsl:copy-of select="ou:include-file('/_resources/includes/analytics.inc')"/>
				<xsl:if test="descendant::ouform ">	
					<script type="text/javascript" src="https://www.ltcc.edu/_resources/js/ldp/ouforms.js"></script>
					<!--Comment out this stylesheet to not interfere with 50th anniversary designs-->
<!-- 					<link rel="stylesheet" href="https://www.ltcc.edu/_resources/css/ldp/ouforms-bootstrap.css"/> -->
				</xsl:if>
				<!-- 				<xsl:call-template name="form-footcode" /> -->
			</body>
		</html>
	</xsl:template>		

	<xsl:template name="common-headcode">
		<!-- headcode include -->
		<xsl:copy-of select="ou:include-file('/_resources/includes/headcode-50th-anniversary.inc')"/>
		<xsl:if test="$is-edt">
			<link rel="stylesheet" href="//cdn.omniupdate.com/select-lists/v1/select-lists.min.css" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="common-footcode">
		<xsl:if test="$is-edt">
			<!-- jQuery is provided by headcode-50th-anniversary.inc. -->
			<script src="//cdn.omniupdate.com/select-lists/v1/select-lists.min.js" defer="defer"></script>
		</xsl:if>
	</xsl:template>

	<xsl:template name="common-bodycode">
		<xsl:copy-of select="ou:include-file('/_resources/includes/bodycode.inc')"/>
	</xsl:template>

	<xsl:template name="common-header">
		<xsl:call-template name="output-include">
			<xsl:with-param name="path">/_resources/includes/50th-anniversary-header.php</xsl:with-param>
			<xsl:with-param name="from-prod" select="true()" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="common-footer">
		<xsl:call-template name="output-include">
			<xsl:with-param name="path">/_resources/includes/50th-anniversary-footer.php</xsl:with-param>
			<xsl:with-param name="from-prod" select="true()" />
		</xsl:call-template>
	</xsl:template>

	<!-- in case not defined in page type xsl -->
	<xsl:template name="page-content"><p>No template defined.</p></xsl:template><!-- leave for debugging purposes -->			

	<xsl:template name="template-headcode"/> <!-- defined in each page type -->

	<xsl:template name="template-footcode"/> <!-- defined in each page type -->

</xsl:stylesheet>
