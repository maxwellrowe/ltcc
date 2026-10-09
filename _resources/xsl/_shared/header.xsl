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
Header

Contributors: Mackey
Last Updated: Oct 2026
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
	
    <xsl:import href="../common.xsl"/>
	
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" include-content-type="no" omit-xml-declaration="yes"/>
	
    <xsl:template match="/document">
        <xsl:choose>
            <xsl:when test="$ou:action = 'pub'">
                <xsl:call-template name="header-display"/>
            </xsl:when>
            <xsl:otherwise>
            	<html>
                    <head>
                        <!-- headcode include -->
                        <xsl:copy-of select="ou:include-file('/_resources/includes/headcode.inc')"/>	                    
                    </head>
                    <body class="">
						<xsl:call-template name="header-display"/>
                        <xsl:copy-of select="ou:include-file('/_resources/includes/footcode.inc')"/>			
                    </body>
                </html>
            </xsl:otherwise>           
        </xsl:choose>
    </xsl:template>

    <!-- Properties belong to header.pcf and apply to the shared header site-wide. -->
    <xsl:template name="header-display">
        <xsl:variable name="show-top-bar" as="xs:boolean" select="ou:pcf-param('show-top-bar') = 'true'"/>
        <xsl:variable name="show-search-button" as="xs:boolean" select="ou:pcf-param('show-search-button') = 'true'"/>
        <xsl:variable name="show-call-to-action-button" as="xs:boolean" select="ou:pcf-param('show-call-to-action-button') = 'true'"/>

        <xsl:variable name="logo-img" select="ou:pcf-param('logo-img')"/>
        <xsl:variable name="logo-img-mobile" select="ou:pcf-param('logo-img-mobile')"/>
        <xsl:variable name="logo-description" select="ou:pcf-param('logo-description')"/>
        <xsl:variable name="logo-link" select="ou:pcf-param('logo-link')"/>
        <xsl:variable name="sr-logo" select="ou:pcf-param('sr-logo')"/>
        <xsl:variable name="cta-button-text" select="normalize-space(ou:pcf-param('cta-button-text'))"/>
        <xsl:variable name="cta-button-link" select="normalize-space(ou:pcf-param('cta-button-link'))"/>

        <header class="site-header">
            <xsl:if test="$show-top-bar">
                <xsl:copy-of select="ou:include-file('/_resources/includes/header-top-bar.inc')"/>
            </xsl:if>

            <!-- Logo markup goes here. Attribute examples: href="{$logo-link}",
                 src="{$logo-img}", alt="{$logo-description}".
                 Mobile image: $logo-img-mobile; screen reader text: $sr-logo. -->

            <xsl:apply-templates select="ouc:div[@label='header-navigation']"/>

            <xsl:if test="$show-search-button">
                <!-- Search button markup goes here. -->
            </xsl:if>

            <!-- Require a label and destination to avoid an empty or broken CTA. -->
            <xsl:if test="$show-call-to-action-button and $cta-button-text != '' and $cta-button-link != ''">
                <!-- CTA markup goes here. Example:
                <a href="{$cta-button-link}" class="btn btn-primary">
                    <xsl:value-of select="$cta-button-text"/>
                </a>
                -->
            </xsl:if>
        </header>
    </xsl:template>
    
    <xsl:function name="ou:ssi">
        <xsl:param name="fullpath"/>
        <!--<xsl:comment>#include virtual="<xsl:value-of select="$fullpath" />" </xsl:comment>-->
        <xsl:processing-instruction name="php"> include($_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="$fullpath" />"); </xsl:processing-instruction>
    </xsl:function>
   
</xsl:stylesheet>
