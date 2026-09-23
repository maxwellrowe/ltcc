<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<!--
Implementations Skeletor v3 - 5/10/2014

Contributors: cwilson
Last Updated: 1/2016
-->

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"	
	xmlns:dyn="http://exslt.org/dynamic"
	exclude-result-prefixes="ou xsl xs fn ouc"
	extension-element-prefixes="dyn">
	
	<xsl:import href="template-matches.xsl"/>
	<xsl:import href="ouvariables.xsl"/>
	<xsl:import href="functions.xsl"/>
	
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" include-content-type="no" omit-xml-declaration="yes"/>
	
	<xsl:template match="/document">		
		<xsl:apply-templates select="ouc:div[@label='search-content']" mode="copy"/>		
	</xsl:template>
	
</xsl:stylesheet>