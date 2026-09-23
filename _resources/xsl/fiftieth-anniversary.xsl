<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Kitchen Sink v2.4 - 2/14/2014

Fiftieth Anniversary Page 

Contributors: Mackey
Last Updated: 4/2025
-->
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ou="http://omniupdate.com/XSL/Variables"
    xmlns:fn="http://omniupdate.com/XSL/Functions"
    xmlns:ouc="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="ou xsl xs fn ouc">
							
	<xsl:import href="fiftieth-anniversary-common.xsl"/>	
		
	<xsl:template name="template-headcode">
		<xsl:if test="$ou:action = 'edt'">
			<style type="text/css">#galaxy .ou-btn { margin: 25px 0px 0px 0px !important; z-index: 999; white-space: pre-line !important; }</style>			
		</xsl:if>	
	</xsl:template>
	
	<xsl:template name="page-content"> 
		<xsl:variable name="page-id" select="ou:pcf-param('page-id')" />
		<div id="fa-page-content-{$page-id}" class="fify-page-content">
			<xsl:apply-templates select="ouc:div[@label='main-content']" />	
		</div>
	</xsl:template>
</xsl:stylesheet>
