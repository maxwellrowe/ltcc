<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Kitchen Sink v2.4 - 2/14/2014

INTERIOR PAGE 
A simple page type.

Contributors: cwilson
Last Updated: 1/2016
-->
<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="ou xsl xs fn ouc">

	<xsl:import href="50th-anniversary-common.xsl"/>	

	<xsl:template name="template-headcode"/>

	<xsl:template name="page-content"> 		
		<xsl:apply-templates select="ouc:div[@label='hero']"/>
		<xsl:apply-templates select="ouc:div[@label='main-content']"/>
	</xsl:template>

</xsl:stylesheet>
