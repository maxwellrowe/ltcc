<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Implementations Skeletor v3 - 5/10/2014

IDENTITY TEMPLATE MATCH
This template ensures that all content is copied, or applied to any existing template matches. Edit sparingly.

Contributors: cwilson
Last Updated: 1/2016
-->
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ou="http://omniupdate.com/XSL/Variables"
  xmlns:fn="http://omniupdate.com/XSL/Functions"
  xmlns:ouc="http://omniupdate.com/XSL/Variables"
  exclude-result-prefixes="xs ou fn ouc">
	
    <!-- 
    
    Identity Matches
    
    -->
    <!-- The following template matches all items except processing instructions, copies them, then processes any children. -->
    <xsl:template match="attribute()|text()|comment()">
        <xsl:copy />
    </xsl:template>
    
    <xsl:template match="element()">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="attribute()|node()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- The following template matches processing instructions, outputs the proper syntax with the code escaped properly. -->
    <xsl:template match="processing-instruction('php')">
        <xsl:processing-instruction name="php">
			<xsl:value-of select="." disable-output-escaping="yes" />
		?</xsl:processing-instruction>
    </xsl:template>
    
    <!--
       
    OUC Matches   
       
    -->
    
    <!-- OUC Dynamic 3rd Level Tagging -->
    <xsl:template match="ouc:div">
        <xsl:copy>
            <xsl:attribute name="wysiwyg-class"><xsl:value-of select="$body-class" /></xsl:attribute>
            <xsl:apply-templates select="attribute()|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="ouc:*[$ou:action !='edt']">
        <xsl:apply-templates />
    </xsl:template>
    
    <!--
        
    MISC 
    
    -->
    
    <!-- Visual warning for broken dependencies tags -->
    <xsl:template match="a[contains(@href,'*** Broken')]">
        <a href="{@href}" style="color: red;"><xsl:value-of select="."/></a> <span style="color: red;">[BROKEN LINK]</span>
    </xsl:template>
    
    <!-- transforms gcsesearch nodes to gcse:search -->
    <xsl:template match="gcsesearch">
        <xsl:text disable-output-escaping="yes">&lt;gcse:searchbox&gt;&lt;/gcse:searchbox&gt;</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
