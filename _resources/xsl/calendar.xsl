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
		<div class="row">
			<div class="breadcrumbs columns small-12">
				<!-- see breadcrumbs xsl -->
				<xsl:call-template name="breadcrumb">
					<xsl:with-param name="path" select="$ou:dirname"/>								
				</xsl:call-template>
			</div>
		</div>		
		<section class="row">
			<div class="columns small-12 medium-12 main-content">
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
				
				<xsl:apply-templates select="ouc:div[@label='main-content']" />			
			</div>		
		</section>	
	</xsl:template>
		
</xsl:stylesheet>
