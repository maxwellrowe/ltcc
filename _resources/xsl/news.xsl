<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Kitchen Sink v2.4 - 2/14/2014

News 
A not so simple page type.

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
							
	<xsl:import href="common.xsl"/>	
		
	<xsl:template name="template-headcode">
		<xsl:if test="$page-type = 'news-listing'"><link type="text/css" rel="stylesheet" href="https://www.ltcc.edu/_resources/css/pagination.css"/></xsl:if>		
		<xsl:if test="not($page-type = 'news-listing')">
			<style>
				.alt-title {
				text-align: inherit !important;
				}
			</style>			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="page-content"> 		
		<div class="row">
			<div class="breadcrumbs columns small-12">
				<!-- see breadcrumbs xsl -->
				<xsl:call-template name="breadcrumb">
					<xsl:with-param name="path" select="$ou:dirname"/>								
				</xsl:call-template>
			</div>
		</div>		
		<section class="row">
			<xsl:choose>				
				<xsl:when test="$page-type = 'news-listing'">
					<div class="columns small-12 medium-10 medium-push-2 main-content">
						<h1><xsl:value-of select="if(normalize-space(ou:pcf-param('heading')) = '') then $page-title else ou:pcf-param('heading')" /></h1>
						<xsl:choose>
							<xsl:when test="$ou:action = 'pub'">
								<xsl:processing-instruction name="php">									
									$feed = "<xsl:value-of select="ou:pcf-param('feed')" />"; <!-- rss feed to be displayed -->
									$num_items = <xsl:value-of select="ou:pcf-param('items')" />; <!-- display 4 news items max -->
									include($_SERVER['DOCUMENT_ROOT'] ."/_resources/php/wnl/news_display.php"); 
								?</xsl:processing-instruction>
							</xsl:when>
							<xsl:otherwise>
								<article class="row">																
									<div class="columns small-12 medium-7 end">
										<h3>News Items will appear on publish.</h3>
										<p>Number of News Items: <xsl:value-of select="ou:pcf-param('items')" /></p>										
										<p><a href="{ou:pcf-param('feed')}" class="button" title="Read more">From this Feed</a></p>
									</div> 
								</article>
							</xsl:otherwise>							
						</xsl:choose>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div>
						<xsl:choose>
							<xsl:when test="ou:pcf-param('layout') = 'two'">
								<xsl:attribute name="class">columns small-12 medium-10 medium-push-2 main-content</xsl:attribute>
							</xsl:when>
							<xsl:when test="ou:pcf-param('layout') = 'three'">					
								<xsl:attribute name="class">columns small-12 medium-7 medium-push-2 main-content</xsl:attribute>											
							</xsl:when>
						</xsl:choose>
						<h1 class="alt-title"><xsl:value-of select="if(normalize-space(ou:pcf-param('heading')) = '') then $page-title else ou:pcf-param('heading')" /></h1>				
						<!--<xsl:choose>
							<xsl:when test="ou:pcf-param('top-media') = 'banner' ">
								<!-\- static mage http://placehold.it/900x300 -\->
								<p><img src="{ou:pcf-param('banner')}" alt="{ou:pcf-param('banner-alt')}" /></p>
							</xsl:when>
							<xsl:when test="ou:pcf-param('top-media') = 'slider' ">					
								<!-\- gallery -\->
								<xsl:apply-templates select="ouc:div[@label='gallery']" />	
							</xsl:when>
						</xsl:choose>	-->			
						<h4><xsl:value-of select="ou:display-long-date(ou:pcf-param('date'))" /></h4>
						<!-- main-content -->
						<xsl:apply-templates select="ouc:div[@label='main-content']" />			
					</div>	
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="side-navigation" />			
		</section>	
	</xsl:template>
	
	<xsl:template name="side-navigation">
		<div class="columns small-12 medium-2 medium-pull-10">
			<nav class="sidenav">				
				<xsl:choose>
					<xsl:when test="$ou:action='pub'">
						<xsl:processing-instruction name="php">												
							$currentDirectory = "<xsl:value-of select="$ou:dirname"/>";									
							include($_SERVER["DOCUMENT_ROOT"] . "/_resources/php/sitenav.php"); 																					
						?</xsl:processing-instruction>
					</xsl:when>
					<xsl:otherwise>
						<ul class="right">
							<li><a href="#">Navigation Menu will apear on publish</a></li>
							<li><xsl:value-of select="$ou:dirname"/></li>
						</ul>
					</xsl:otherwise>
				</xsl:choose>			
			</nav>
		</div>
	</xsl:template>
		
</xsl:stylesheet>
