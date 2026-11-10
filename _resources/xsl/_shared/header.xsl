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

        <header class="site-header position-relative bg-white">
            <xsl:if test="$show-top-bar">
                <div class="d-none d-lg-block">
                    <xsl:copy-of select="ou:include-file('/_resources/includes/header-top-bar.inc')"/>
                </div>
            </xsl:if>
            <div class="primary-header shadow-sm">
                <div class="container-xl">
                    <div class="d-flex align-items-center align-items-lg-stretch justify-content-between">
                        <div class="d-flex align-items-center align-items-lg-stretch justify-content-start gap-4">
                            <!-- Logo -->
                            <a href="{$logo-link}" class="my-3 my-lg-4 d-inline-block align-self-center">
                                <img src="{$logo-img}" alt="{$logo-description}" class="d-none d-lg-block"/>
                                <img src="{$logo-img-mobile}" alt="{$logo-description}" class="d-block d-lg-none"/>
                            </a>

                            <!-- Main Navigation -->
                            <div id="primary-navigation" class="primary-navigation collapse d-lg-flex">
                                <!-- Mobile Quicklinks -->
                                <div class="primary-navigation-utilities d-block d-lg-none">
                                    <xsl:if test="$show-call-to-action-button and $cta-button-text != '' and $cta-button-link != ''">
                                        <div class="d-grid gap-2 mb-4">
                                            <a href="{$cta-button-link}" class="btn btn-primary py-3">
                                                <xsl:value-of select="$cta-button-text"/>
                                            </a>
                                        </div>
                                    </xsl:if>
                                    <xsl:copy-of select="ou:include-file('/_resources/includes/header-top-bar.inc')"/>
                                </div>
                                <xsl:apply-templates select="ouc:div[@label='header-navigation']"/>
                            </div>
                        </div>

                        <div class="d-flex align-items-center justify-content-end gap-3">
                            <!-- Search -->
                            <xsl:if test="$show-search-button">
                                <button type="button" class="btn btn-light btn-circle" data-bs-toggle="modal" data-bs-target="#site-search" aria-label="Open site search">
                                    <span class="visually-hidden">Search the LTCC Website</span>
                                    <span class="fa-sharp fa-search"></span>
                                </button>
                            </xsl:if>

                            <!-- Require a label and destination to avoid an empty or broken CTA. -->
                            <xsl:if test="$show-call-to-action-button and $cta-button-text != '' and $cta-button-link != ''">
                                <a href="{$cta-button-link}" class="btn btn-primary d-none d-lg-inline-block">
                                    <xsl:value-of select="$cta-button-text"/>
                                </a>
                            </xsl:if>

                            <!-- Mobile Menu Trigger -->
                            <button type="button" class="btn btn-link btn-circle d-lg-none primary-navigation-toggle collapsed"
                                data-bs-toggle="collapse" data-bs-target="#primary-navigation"
                                aria-expanded="false" aria-controls="primary-navigation" aria-label="Toggle main navigation">
                                <span class="primary-navigation-toggle-icon" aria-hidden="true">
                                    <span><xsl:text> </xsl:text></span>
                                    <span><xsl:text> </xsl:text></span>
                                    <span><xsl:text> </xsl:text></span>
                                </span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </header>
    </xsl:template>
    
    <!-- Each authoring row becomes a Bootstrap dropdown in the main navigation. -->
    <xsl:template match="table[@data-snippet='ltcc-header-main-navigation']">
        <nav aria-label="Main navigation" class="d-lg-flex">
            <ul class="nav flex-column flex-lg-row flex-lg-nowrap">
                <xsl:for-each select="tbody/tr">
                    <xsl:variable name="menu-id" select="concat('header-menu-', generate-id())"/>
                    <li class="nav-item dropdown d-lg-flex">
                        <button type="button" id="{$menu-id}" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" data-bs-display="static" data-primary-menu="true" data-bs-target="#{concat($menu-id, '-panel')}" aria-controls="{concat($menu-id, '-panel')}" aria-expanded="false">
                            <xsl:value-of select="normalize-space(td[1])"/>
                        </button>
                        <div id="{concat($menu-id, '-panel')}" class="dropdown-menu primary-menu-panel" aria-labelledby="{$menu-id}">
                            <div class="container-xl">
                                <xsl:apply-templates select="td[2]/node()"/>
                            </div>
                        </div>
                    </li>
                </xsl:for-each>
            </ul>
        </nav>
    </xsl:template>

    <xsl:function name="ou:ssi">
        <xsl:param name="fullpath"/>
        <!--<xsl:comment>#include virtual="<xsl:value-of select="$fullpath" />" </xsl:comment>-->
        <xsl:processing-instruction name="php"> include($_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="$fullpath" />"); </xsl:processing-instruction>
    </xsl:function>
   
</xsl:stylesheet>
