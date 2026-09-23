<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="ou xsl xs fn ouc">

	<xsl:import href="common2022-calendar.xsl"/>

	<xsl:template name="page-content">
		<xsl:param name="hero-content" select="ou:pcf-param('hero-content')"/>

		<!-- HERO CONTENT -->
		<xsl:choose>
			<xsl:when test="$hero-content='slider'">
				<xsl:apply-templates select="ouc:div[@label='gallery']" />
			</xsl:when>
			<xsl:when test="$hero-content='video'">
				<div class="hero-video-wrapper">
					<xsl:apply-templates select="ouc:div[@label='hero-video']" />
				</div>
			</xsl:when>
		</xsl:choose>		

		<div class="section bg-light-gray-gradient torn-edge">
			<div class="row">
				<xsl:apply-templates select="ouc:div[@label='maincontent-1']" />
			</div>
		</div>

		<div class="section section-with-background parallax-bg" style="background-image:url('{ou:pcf-param('parallax-bg')}');">
			<div class="overlay"></div>
			<div class="row featued-news">
				<div class="columns small-12">
					<div class="news-header">
						<h2><strong><xsl:value-of select="upper-case(ou:pcf-param('news-heading'))" /></strong></h2> <a href="{ou:pcf-param('news-link')}" class="news-right"><xsl:value-of select="ou:pcf-param('news-link-title')" /></a>
					</div>
				</div>

				<xsl:choose>
					<xsl:when test="$ou:action = 'pub'">
						<xsl:processing-instruction name="php">									
							$feed = "<xsl:value-of select="ou:pcf-param('news-feed')" />"; <!-- rss feed to be displayed -->
							$num_items = <xsl:value-of select="ou:pcf-param('news-items')" />; <!-- display 4 news items max -->
							include($_SERVER['DOCUMENT_ROOT'] ."/_resources/php/wnl/news_home_2022.php"); 
							?</xsl:processing-instruction>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="unparsed-text-available(concat($domain, '/_resources/php/wnl/news_home_2022.php'),'utf-8')">
							<xsl:value-of select="unparsed-text(concat($domain, '/_resources/php/wnl/news_home_2022.php?feed=', encode-for-uri(ou:pcf-param('news-feed')), '&amp;num_items=', ou:pcf-param('news-items')),'utf-8')" disable-output-escaping="yes"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>

				<div class="columns small-12">
					<h2 class="text-center tagline"><xsl:value-of select="ou:pcf-param('tagline')" /></h2>
				</div>

				<xsl:apply-templates select="ouc:div[@label='factoids']" />

			</div>
		</div>

		<div class="section torn-edge pb-0">
			<xsl:apply-templates select="ouc:div[@label='maincontent-2']" />

			<div class="row">
				<div class="columns small-12">
					<div class="events">
						<div class="events-header">
							<h2><strong><xsl:value-of select="upper-case(ou:pcf-param('events-heading'))" /></strong></h2> <a href="{ou:pcf-param('events-link')}" class="events-right"><xsl:value-of select="ou:pcf-param('events-link-title')" /></a>
						</div>
						
						<xsl:variable name="events-featured" select="ou:pcf-param('events-featured')"/>
						
						<xsl:variable name="events-tags" select="tokenize(ou:pcf-param('events-tag'), ';')"/>
							
							
						<xsl:variable name="events-filter" select="ou:pcf-param('events-filter')"/>
						
												
 						<xsl:variable name="path">
							item
							<xsl:if test="($events-featured = 'featured') or ($events-tags != '' )">
								[
								<xsl:if test="$events-featured = 'featured'">
									featured='true'
								</xsl:if>

								<xsl:if test="$events-tags != '' ">
									
									<xsl:if test="$events-featured = 'featured'"> or </xsl:if>

									<xsl:for-each select="$events-tags">
										tags/tag='<xsl:value-of select="."/>'
										<xsl:if test="position() != last()"> 
											<xsl:choose>
												<xsl:when test="$events-filter = 'and'">
													and
												</xsl:when>
												<xsl:otherwise>
													or
												</xsl:otherwise>
											</xsl:choose>
										</xsl:if>

									</xsl:for-each>

								</xsl:if>  
								]
							</xsl:if>

						</xsl:variable> 

						<xsl:call-template name="dmc">
							<xsl:with-param name="options">
								<datasource>events</datasource>
								<xpath><xsl:value-of select="$path"/></xpath>
								<type>homepage_events</type>
								<items_per_page><xsl:value-of select="ou:pcf-param('events-items')" /></items_per_page>
							</xsl:with-param>

							<xsl:with-param name="script-name">events</xsl:with-param>
							<xsl:with-param name="debug" select="false()" />
						</xsl:call-template>
					</div>
				</div>
			</div>
		</div>		
	</xsl:template>

</xsl:stylesheet>
