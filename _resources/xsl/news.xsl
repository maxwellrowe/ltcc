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

	<xsl:template name="template-headcode"/>

	<xsl:template name="page-content">
		<div class="container-xl">
                <nav class="interior-breadcrumbs" aria-label="Breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <xsl:variable name="crumbs"><xsl:call-template name="breadcrumb"><xsl:with-param name="path" select="$ou:dirname"/></xsl:call-template></xsl:variable>
                        <!-- Reuse the existing recursive trail without changing other templates. -->
                        <xsl:for-each select="$crumbs/*[self::a or self::span]">
                            <li class="breadcrumb-item">
                                <xsl:choose>
                                    <xsl:when test="self::span"><xsl:attribute name="class">breadcrumb-item active</xsl:attribute><xsl:attribute name="aria-current">page</xsl:attribute><xsl:value-of select="."/></xsl:when>
                                    <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
                                </xsl:choose>
                            </li>
                        </xsl:for-each>
                    </ol>
                </nav>
		<section class="row gy-4">
			<xsl:choose>
				<xsl:when test="$page-type = 'news-listing'">
					<div class="main-content interior-content col-12 col-lg-9 pb-5">
						<h1 class="page-title"><xsl:value-of select="if(normalize-space(ou:pcf-param('heading')) = '') then $page-title else ou:pcf-param('heading')" /></h1>
						<xsl:choose>
							<xsl:when test="$ou:action = 'pub'">
								<xsl:processing-instruction name="php">
									$feed = "<xsl:value-of select="ou:pcf-param('feed')" />"; <!-- rss feed to be displayed -->
									$num_items = <xsl:value-of select="if (ou:pcf-param('items') castable as xs:positiveInteger) then ou:pcf-param('items') else 10" />; <!-- display 4 news items max -->
									include($_SERVER['DOCUMENT_ROOT'] ."/_resources/php/wnl/news_display.php");
								?</xsl:processing-instruction>
							</xsl:when>
							<xsl:otherwise>
								<article class="row">
									<div class="col-12">
										<h3>News Items will appear on publish.</h3>
										<p>Number of News Items: <xsl:value-of select="ou:pcf-param('items')" /></p>
										<p><a href="{ou:pcf-param('feed')}" class="arrow-link" title="Read more">From this Feed</a></p>
									</div>
								</article>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="main-content interior-content col-12 col-lg-9 pb-5">
						<h1 class="page-title"><xsl:value-of select="if(normalize-space(ou:pcf-param('heading')) = '') then $page-title else ou:pcf-param('heading')" /></h1>
						<p class="text-body-secondary"><xsl:value-of select="ou:display-long-date(ou:pcf-param('date'))" /></p>
						<!-- main-content -->
						<xsl:apply-templates select="ouc:div[@label='main-content']" />
					</div>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="side-navigation" />
		</section>
        </div>
	</xsl:template>

	<xsl:template name="side-navigation">
		<div class="col-12 col-lg-3 pb-5">
			<nav class="sidenav" aria-label="News navigation">
				<xsl:choose>
					<xsl:when test="$ou:action='pub'">
						<xsl:processing-instruction name="php">
							$currentDirectory = "<xsl:value-of select="$ou:dirname"/>";
							include($_SERVER["DOCUMENT_ROOT"] . "/_resources/php/sitenav.php");
						?</xsl:processing-instruction>
					</xsl:when>
					<xsl:otherwise>
						<ul class="right">
							<li><a href="#">Navigation Menu will appear on publish</a></li>
							<li><xsl:value-of select="$ou:dirname"/></li>
						</ul>
					</xsl:otherwise>
				</xsl:choose>
			</nav>
            <xsl:if test="ou:pcf-param('layout') = 'three'">
                <div class="additional-content mt-4"><xsl:apply-templates select="ouc:div[@label='right-content']"/></div>
            </xsl:if>
		</div>
	</xsl:template>

</xsl:stylesheet>
