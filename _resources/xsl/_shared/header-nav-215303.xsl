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
        <xsl:choose>
            <xsl:when test="$ou:action = 'pub'">
                <xsl:call-template name="mega-nav-display"/>
            </xsl:when>
            <xsl:when test="$ou:action = 'prv'">                
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>!--[if IE 8]<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>html class="no-js lt-ie9" lang="en-us"<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>![endif]--<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>!--[if gt IE 8]<xsl:text disable-output-escaping="yes">&gt;</xsl:text><xsl:text disable-output-escaping="yes">&lt;</xsl:text>!--<xsl:text disable-output-escaping="yes">&gt;</xsl:text> 
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>!-- begin html --<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <html class="no-js" lang="en-us">
                    <xsl:text disable-output-escaping="yes">&lt;</xsl:text>!--<xsl:text disable-output-escaping="yes">&lt;</xsl:text>![endif]--<xsl:text disable-output-escaping="yes">&gt;</xsl:text>	
                    <head>
                        <!-- headcode include -->
                        <xsl:copy-of select="ou:include-file('/_resources/includes/headcode.inc')"/>	                    
                    </head>
                    <body class="">
                        <div id="universe">
                            <div id="galaxy">
                                <header class="logo-banner">
                                    <div class="row">				
                                        <!-- header include -->		                                        
                                        <xsl:copy-of select="ou:include-file('/_resources/includes/header.inc')"/>
                                    </div>
                                </header>
                                <footer id="main-footer">
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
                                </footer>
                                <xsl:call-template name="mega-nav-display"/>
                            </div>
                        </div>
                        <!-- footcode include -->
                        <xsl:copy-of select="ou:include-file('/_resources/includes/footcode.inc')"/>				
                    </body>
                </html>
            </xsl:when>
            <xsl:otherwise>
                <h1>Please use Multiedit to make changes.</h1>
                <ouc:div>
                    <xsl:copy-of select="ouc:div[@label='maincontent']/attribute()"/>
                    <xsl:copy-of select="ouc:div[@label='maincontent']/ouc:editor"/>
                </ouc:div>
                <xsl:apply-templates select="ouc:div[@label='maincontent']" mode="copy"/>
            </xsl:otherwise>           
        </xsl:choose>
    </xsl:template>
	
	 <!-- display navigation -->
	<xsl:template name="mega-nav-display">
	    <div id="nav-container">
	        <a href="#close-main-nav" class="close-nav" title="Close Main Navigation"><em class="fa fa-angle-double-right"><xsl:comment> </xsl:comment></em></a>
	        <nav id="main-nav">
	            <div class="row">
	                <ul>
	                    <xsl:if test="menu-1/ouc:div[@label='nav-toggle-1']/text() = 'true'">
	                        <li>
	                            <a href="{menu-1/ouc:div[@label='nav-heading-link-1']}" title="{menu-1/ouc:div[@label='nav-heading-link-title-1']}">
	                                <strong><xsl:value-of select="menu-1/ouc:div[@label='nav-heading-1']"/></strong>
	                                <span><xsl:value-of select="menu-1/ouc:div[@label='nav-sub-heading-1']"/></span>
	                            </a>
	                            <div>
	                                <xsl:call-template name="column-builder"> 
	                                    <xsl:with-param name="column-layout" select="menu-1/ouc:div[@label='nav-layout-1']"/>		
	                                    <xsl:with-param name="region" select="'1'"/>
	                                    <xsl:with-param name="menu-num" select="menu-1" />
	                                </xsl:call-template>
	                            </div>	                            
	                        </li>	                       
	                    </xsl:if>
	                    <xsl:if test="menu-2/ouc:div[@label='nav-toggle-2']/text() = 'true'">
	                        <li>
	                            <a href="{menu-2/ouc:div[@label='nav-heading-link-2']}" title="{menu-2/ouc:div[@label='nav-heading-link-title-2']}">
	                                <strong><xsl:value-of select="menu-2/ouc:div[@label='nav-heading-2']"/></strong>
	                                <span><xsl:value-of select="menu-2/ouc:div[@label='nav-sub-heading-2']"/></span>
	                            </a>
	                            <div>
	                                <xsl:call-template name="column-builder"> 
	                                    <xsl:with-param name="column-layout" select="menu-2/ouc:div[@label='nav-layout-2']"/>		
	                                    <xsl:with-param name="region" select="'2'"/>
	                                    <xsl:with-param name="menu-num" select="menu-2" />
	                                </xsl:call-template>                          
	                            </div>	                            
	                        </li>	 
	                    </xsl:if>
	                    <xsl:if test="menu-3/ouc:div[@label='nav-toggle-3']/text() = 'true'">
	                        <li>
	                            <a href="{menu-3/ouc:div[@label='nav-heading-link-3']}" title="{menu-3/ouc:div[@label='nav-heading-link-title-3']}">
	                                <strong><xsl:value-of select="menu-3/ouc:div[@label='nav-heading-3']"/></strong>
	                                <span><xsl:value-of select="menu-3/ouc:div[@label='nav-sub-heading-3']"/></span>
	                            </a>
	                            <div>
	                                <xsl:call-template name="column-builder"> 
	                                    <xsl:with-param name="column-layout" select="menu-3/ouc:div[@label='nav-layout-3']"/>		
	                                    <xsl:with-param name="region" select="'3'"/>
	                                    <xsl:with-param name="menu-num" select="menu-3" />
	                                </xsl:call-template>	                               
	                            </div>	                            
	                        </li>	 
	                    </xsl:if>
	                    <xsl:if test="menu-4/ouc:div[@label='nav-toggle-4']/text() = 'true'">
	                        <li>
	                            <a href="{menu-4/ouc:div[@label='nav-heading-link-4']}" title="{menu-4/ouc:div[@label='nav-heading-link-title-4']}">
	                                <strong><xsl:value-of select="menu-4/ouc:div[@label='nav-heading-4']"/></strong>
	                                <span><xsl:value-of select="menu-4/ouc:div[@label='nav-sub-heading-4']"/></span>
	                            </a>
	                            <div>
	                                <xsl:call-template name="column-builder"> 
	                                    <xsl:with-param name="column-layout" select="menu-4/ouc:div[@label='nav-layout-4']"/>
	                                    <xsl:with-param name="region" select="'4'"/>
	                                    <xsl:with-param name="menu-num" select="menu-4" />
	                                </xsl:call-template>	                               
	                            </div>	                            
	                        </li>	 
	                    </xsl:if>
	                    <xsl:if test="menu-5/ouc:div[@label='nav-toggle-5']/text() = 'true'">
	                        <li>
	                            <a href="{menu-5/ouc:div[@label='nav-heading-link-5']}" title="{menu-5/ouc:div[@label='nav-heading-link-title-5']}">
	                                <strong><xsl:value-of select="menu-5/ouc:div[@label='nav-heading-5']"/></strong>
	                                <span><xsl:value-of select="menu-5/ouc:div[@label='nav-sub-heading-5']"/></span>
	                            </a>
	                            <div>
	                                <xsl:call-template name="column-builder"> 
	                                    <xsl:with-param name="column-layout" select="menu-5/ouc:div[@label='nav-layout-5']"/>	
	                                    <xsl:with-param name="region" select="'5'"/>
	                                    <xsl:with-param name="menu-num" select="menu-5" />
	                                </xsl:call-template>	                               
	                            </div>	                            
	                        </li>
	                    </xsl:if>
	                    <xsl:if test="menu-6/ouc:div[@label='nav-toggle-6']/text() = 'true'">
	                        <li>
	                            <a href="{menu-6/ouc:div[@label='nav-heading-link-6']}" title="{menu-6/ouc:div[@label='nav-heading-link-title-6']}">
	                                <strong><xsl:value-of select="menu-6/ouc:div[@label='nav-heading-6']"/></strong>
	                                <span><xsl:value-of select="menu-6/ouc:div[@label='nav-sub-heading-6']"/></span>
	                            </a>
	                            <div>
	                                <xsl:call-template name="column-builder"> 
	                                    <xsl:with-param name="column-layout" select="menu-6/ouc:div[@label='nav-layout-6']"/>
	                                    <xsl:with-param name="region" select="'6'"/>
	                                    <xsl:with-param name="menu-num" select="menu-6" />
	                                </xsl:call-template>	                               
	                            </div>	                            
	                        </li>
	                    </xsl:if>        
	                    <xsl:if test="menu-7/ouc:div[@label='nav-toggle-7']/text() = 'true'">
	                        <li>
	                            <a href="{menu-7/ouc:div[@label='nav-heading-link-7']}" title="{menu-7/ouc:div[@label='nav-heading-link-title-7']}">
	                                <strong><xsl:value-of select="menu-7/ouc:div[@label='nav-heading-7']"/></strong>
	                                <span><xsl:value-of select="menu-7/ouc:div[@label='nav-sub-heading-7']"/></span>
	                            </a>
	                            <div>
	                                <xsl:call-template name="column-builder"> 
	                                    <xsl:with-param name="column-layout" select="menu-7/ouc:div[@label='nav-layout-7']"/>
	                                    <xsl:with-param name="region" select="'7'"/>
	                                    <xsl:with-param name="menu-num" select="menu-7" />
	                                </xsl:call-template>	                               
	                            </div>	                            
	                        </li>
	                    </xsl:if>
						<xsl:if test="menu-8/ouc:div[@label='nav-toggle-8']/text() = 'true'">
	                        <li>
	                            <a href="{menu-8/ouc:div[@label='nav-heading-link-8']}" title="{menu-8/ouc:div[@label='nav-heading-link-title-8']}">
	                                <strong><xsl:value-of select="menu-8/ouc:div[@label='nav-heading-8']"/></strong>
	                                <span><xsl:value-of select="menu-8/ouc:div[@label='nav-sub-heading-8']"/></span>
	                            </a>
	                            <div>
	                                <xsl:call-template name="column-builder"> 
	                                    <xsl:with-param name="column-layout" select="menu-8/ouc:div[@label='nav-layout-8']"/>
	                                    <xsl:with-param name="region" select="'8'"/>
	                                    <xsl:with-param name="menu-num" select="menu-8" />
	                                </xsl:call-template>	                               
	                            </div>	                            
	                        </li>
	                    </xsl:if>
	                </ul>
	            </div>
	        </nav>
	        <xsl:call-template name="top-nav-display"/>
	    </div>	
	</xsl:template>
	
    <xsl:template name="column-builder">
        <xsl:param name="column-layout" select="."/>
        <xsl:param name="region" select="."/>
        <xsl:param name="menu-num" select="."/>        
        <xsl:variable name="current-column-1" select="$menu-num/ouc:div[@label=(concat('nav-', $region, '-column-1'))]" />
        <xsl:variable name="current-column-2" select="$menu-num/ouc:div[@label=(concat('nav-', $region, '-column-2'))]" />
        <xsl:variable name="current-column-3" select="$menu-num/ouc:div[@label=(concat('nav-', $region, '-column-3'))]" />
        <xsl:variable name="current-column-4" select="$menu-num/ouc:div[@label=(concat('nav-', $region, '-column-4'))]" />    
        <xsl:choose>
            <!-- two-columns -->
            <xsl:when test="$column-layout = '2'">  
                <xsl:choose>
                    <xsl:when test="$current-column-1/descendant::ul">
                        <ul class="columns large-6">
                            <xsl:for-each select="$current-column-1/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-1/descendant::img">
                        <div class="columns large-6">
                            <img src="{$current-column-1/descendant::img/@src}" alt="{$current-column-1/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-6">
                            <xsl:apply-templates select="$current-column-1" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$current-column-2/descendant::ul">
                        <ul class="columns large-6">
                            <xsl:for-each select="$current-column-2/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-2/descendant::img">
                        <div class="columns large-6">
                            <img src="{$current-column-2/descendant::img/@src}" alt="{$current-column-2/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-6">
                            <xsl:apply-templates select="$current-column-2" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- three-columns -->
            <xsl:when test="$column-layout = '3'">
                <xsl:choose>
                    <xsl:when test="$current-column-1/descendant::ul">
                        <ul class="columns large-4">
                            <xsl:for-each select="$current-column-1/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-1/descendant::img">
                        <div class="columns large-4">
                            <img src="{$current-column-1/descendant::img/@src}" alt="{$current-column-1/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-4">
                            <xsl:apply-templates select="$current-column-1" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$current-column-2/descendant::ul">
                        <ul class="columns large-4">
                            <xsl:for-each select="$current-column-2/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-2/descendant::img">
                        <div class="columns large-4">
                            <img src="{$current-column-2/descendant::img/@src}" alt="{$current-column-2/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-4">
                            <xsl:apply-templates select="$current-column-2" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$current-column-3/descendant::ul">
                        <ul class="columns large-4">
                            <xsl:for-each select="$current-column-3/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-3/descendant::img">
                        <div class="columns large-4">
                            <img src="{$current-column-3/descendant::img/@src}" alt="{$current-column-3/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-4">
                            <xsl:apply-templates select="$current-column-3" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:when>
            <!-- four columns -->
            <xsl:when test="$column-layout = '4'">                 
                <xsl:choose>
                    <xsl:when test="$current-column-1/descendant::ul">
                        <ul class="columns large-3">
                            <xsl:for-each select="$current-column-1/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-1/descendant::img">
                        <div class="columns large-3">
                            <img src="{$current-column-1/descendant::img/@src}" alt="{$current-column-1/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-3">
                            <xsl:apply-templates select="$current-column-1" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$current-column-2/descendant::ul">
                        <ul class="columns large-3">
                            <xsl:for-each select="$current-column-2/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-2/descendant::img">
                        <div class="columns large-3">
                            <img src="{$current-column-2/descendant::img/@src}" alt="{$current-column-2/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-3">
                            <xsl:apply-templates select="$current-column-2" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$current-column-3/descendant::ul">
                        <ul class="columns large-3">
                            <xsl:for-each select="$current-column-3/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-3/descendant::img">
                        <div class="columns large-3">
                            <img src="{$current-column-3/descendant::img/@src}" alt="{$current-column-3/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-3">
                            <xsl:apply-templates select="$current-column-3" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$current-column-4/descendant::ul">
                        <ul class="columns large-3">
                            <xsl:for-each select="$current-column-4/descendant::ul/li">                                                  
                                <xsl:apply-templates select="."/>                                                  
                            </xsl:for-each>
                        </ul>
                    </xsl:when>                    
                    <xsl:when test="$current-column-4/descendant::img">
                        <div class="columns large-3">
                            <img src="{$current-column-4/descendant::img/@src}" alt="{$current-column-4/descendant::img/@alt}" />
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="columns large-3">
                            <xsl:apply-templates select="$current-column-4" />
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>       
	</xsl:template>
	
	<!-- display utility navigation -->
    <xsl:template name="top-nav-display">        
        <div class="top-nav">
            <div class="site-search search-container">                
                <!--<xsl:if test="unparsed-text-available(concat($domain, '/_resources/includes/search-content.php'),'utf-8')">
                    <xsl:value-of select="unparsed-text(concat($domain, '/_resources/includes/search-content.php'),'utf-8')" disable-output-escaping="yes"/>
                </xsl:if>-->
                <xsl:copy-of select="ou:include-file('/_resources/includes/search-215303.inc')"/>
            </div>
			<xsl:copy-of select="ou:include-file('/_resources/includes/google-translate.inc')"/>
        </div>        
    </xsl:template>
    
    <xsl:function name="ou:ssi">
        <xsl:param name="fullpath"/>
        <!--<xsl:comment>#include virtual="<xsl:value-of select="$fullpath" />" </xsl:comment>-->
        <xsl:processing-instruction name="php"> include($_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="$fullpath" />"); </xsl:processing-instruction>
    </xsl:function>
   
</xsl:stylesheet>
