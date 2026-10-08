<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Implementations Skeletor v3 - 5/10/2014

HOME PAGE 
A complex page type.

Contributors: Your Name Here
Last Updated: Enter Date Here
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
			<style type="text/css">#galaxy .ou-btn { margin: 25px 0px 0px 0px !important; /*position: absolute !important; */ z-index: 999; white-space: pre-line !important; }</style>			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="page-content"> 		
		<!-- gallery -->
		<xsl:apply-templates select="ouc:div[@label='gallery']" />	
		<div class="row home-content">
			<!-- left column -->
			<div class="columns small-12 medium-5 home-news">
				<h2><a href="{ou:pcf-param('news-link')}" title="{ou:pcf-param('news-link-article')}"><xsl:value-of select="ou:pcf-param('news-heading')" /></a></h2>				
				<xsl:choose>
					<xsl:when test="$ou:action = 'pub'">
						<xsl:processing-instruction name="php">									
									$feed = "<xsl:value-of select="ou:pcf-param('news-feed')" />"; <!-- rss feed to be displayed -->
									$num_items = <xsl:value-of select="ou:pcf-param('news-items')" />; <!-- display 4 news items max -->
									include($_SERVER['DOCUMENT_ROOT'] ."/_resources/php/wnl/news_home.php"); 
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
			</div>
			<!-- middle column -->
			<div class="columns small-12 medium-3 home-events">
				<h2><a href="{ou:pcf-param('events-link')}" title="{ou:pcf-param('events-heading-title')}"><xsl:value-of select="ou:pcf-param('events-heading')"/></a></h2>
				<ol>
				<xsl:choose>
					<xsl:when test="$ou:action = 'pub'">
						<xsl:processing-instruction name="php">
							<!-- rss feed to be displayed -->
							$cal_feed = "<xsl:value-of select="ou:pcf-param('event-feed')" />"; 
							<!-- display 4 news items max -->
							$num_cal_items = <xsl:value-of select="ou:pcf-param('event-items')" />;
							include($_SERVER['DOCUMENT_ROOT'] ."/_resources/php/wnl/events_home.php");
						?</xsl:processing-instruction>
					<!--	
					<li>
						<a href="#" title=""><time datetime="2015-09-10 14:00">Friday, October 9 @ 2:00 pm</time></a>
						<strong>Men's Soccer Game</strong>
						<span>LTCC vs. Butte</span>
					</li>					
					<li>
						<a href="#" title=""><time datetime="2015-09-10 14:00">Friday, October 9 @ 2:00 pm</time></a>
						<strong>Men's Soccer Game</strong>
						<span>LTCC vs. Butte</span>
					</li>					
					<li>
						<a href="#" title=""><time datetime="2015-09-10 14:00">Friday, October 9 @ 2:00 pm</time></a>
						<strong>Men's Soccer Game</strong>
						<span>LTCC vs. Butte</span>
					</li>					
					<li>
						<a href="#" title=""><time datetime="2015-09-10 14:00">Friday, October 9 @ 2:00 pm</time></a>
						<strong>Men's Soccer Game</strong>
						<span>LTCC vs. Butte</span>
					</li>	
					-->
					</xsl:when>
					<xsl:otherwise>
						<li>
							<p>Event Items to Appear on Publish</p>
							<p>From Feed: <a href="{concat($ou:httproot, ou:pcf-param('events-feed'))}"><xsl:value-of select="ou:pcf-param('events-feed')" /></a></p>
							<p>No of Items to Display: <xsl:value-of select="ou:pcf-param('event-items')" /></p>
							<p>Event Items to Appear on Publish</p>
						</li>
					</xsl:otherwise>
				</xsl:choose>
				</ol>				
			</div>
			<!-- right column -->
			<div class="columns small-12 medium-4 galleries-contact">
				<!-- top -->
				<div class="galleries">					
					<!-- right content one -->
					<xsl:apply-templates select="ouc:div[@label='right-content-one']" />	
				</div>
				<!-- bottom -->
				<div class="home-contact">
					<!-- right content two -->
					<xsl:apply-templates select="ouc:div[@label='right-content-two']" />
				</div>				
			</div>
		</div>		
	</xsl:template>
		
</xsl:stylesheet>
