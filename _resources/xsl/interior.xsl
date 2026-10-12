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
							
	<xsl:import href="common.xsl"/>	
		
	<xsl:template name="template-headcode">
		<xsl:if test="$ou:action = 'edt'">
			<style type="text/css">#galaxy .ou-btn { margin: 25px 0px 0px 0px !important; z-index: 999; white-space: pre-line !important; }</style>			
		</xsl:if>	
	</xsl:template>
	
	<xsl:template name="page-content"> 		
		<div class="container-xl">
			<div class="row">
				<div class="breadcrumbs col-12">
					<!-- see breadcrumbs xsl -->
					<xsl:call-template name="breadcrumb">
						<xsl:with-param name="path" select="$ou:dirname"/>								
					</xsl:call-template>
				</div>
			</div>		
		</div>
		<section class="container-xl">
			<div class="row">
				<div class="col-12 col-md-8 col-lg-9 main-content">
					<xsl:if test="ou:pcf-param('layout') = 'three'">					
						<xsl:attribute name="class">columns small-12 medium-7 medium-push-2 main-content</xsl:attribute>											
					</xsl:if>
					<xsl:if test="normalize-space(ou:pcf-param('heading'))">
						<h1 class="alt-title"><xsl:value-of select="ou:pcf-param('heading')" /></h1>				
					</xsl:if>
					<xsl:choose>
						<xsl:when test="ou:pcf-param('top-media') = 'banner' ">
							<xsl:if test="normalize-space(ou:pcf-param('banner')) != ''">
								<!-- static mage http://placehold.it/900x300 -->
								<p><img src="{ou:pcf-param('banner')}" alt="{ou:pcf-param('banner-alt')}" /></p>
							</xsl:if>
						</xsl:when>
						<xsl:when test="ou:pcf-param('top-media') = 'slider' ">					
							<!-- gallery -->
							<xsl:apply-templates select="ouc:div[@label='gallery']" />	
						</xsl:when>
					</xsl:choose>
					<!-- main-content -->

					<xsl:if test="ou:pcf-param('pageType') = 'InTheNews'">

						<h2><a href="{ou:pcf-param('news-link')}" title="{ou:pcf-param('news-link-article')}"><xsl:value-of select="ou:pcf-param('news-heading')" /></a></h2>				
						<xsl:choose>
							<xsl:when test="$ou:action = 'pub'">
								<xsl:processing-instruction name="php">									
									$feed = "<xsl:value-of select="ou:pcf-param('news-feed')" />"; <!-- rss feed to be displayed -->
									$num_items = <xsl:value-of select="ou:pcf-param('news-items')" />; <!-- display 4 news items max -->
									include($_SERVER['DOCUMENT_ROOT'] ."/_resources/php/wnl/news_display.php"); 
									?</xsl:processing-instruction>
							</xsl:when>
							<xsl:otherwise>
								<article class="row">
									<p>News Items to Appear on Publish</p>
									<p>From Feed: <a href="{concat($ou:httproot, ou:pcf-param('news-feed'))}"><xsl:value-of select="ou:pcf-param('news-feed')" /></a></p>
									<p>No of Items to Display: <xsl:value-of select="ou:pcf-param('news-items')" /></p>
									<p>News Items to Appear on Publish</p>
								</article>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:if>

					<xsl:apply-templates select="ouc:div[@label='main-content']" />			
				</div>
					<!-- three columns -->
					<xsl:choose>
						<xsl:when test="ou:pcf-param('layout') = 'three'">
							<aside class="col-12 col-md-4 col-lg-3">
								<!-- right-content -->
								<xsl:apply-templates select="ouc:div[@label='right-content']" />	
							</aside>
						</xsl:when>
						<xsl:otherwise><!-- do nothing --></xsl:otherwise>
					</xsl:choose>
				<xsl:call-template name="side-navigation" />			
			</div>
		</section>
	</xsl:template>
	
	<xsl:template name="side-navigation">
		<div class="col-12 col-md-4 col-lg-3">
			<nav class="sidenav">				
				
				<xsl:copy-of select="ou:include-file(concat($ou:dirname, '/_nav.inc'))" />								
				
			</nav>
		</div>
	</xsl:template>
		
</xsl:stylesheet>
