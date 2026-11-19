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


    <!-- Keep two/three compatible with existing PCFs. Missing layout defaults to one. -->
    <xsl:variable name="interior-layout" select="if (ou:pcf-param('layout') = ('two', 'three', 'full')) then ou:pcf-param('layout') else 'one'"/>
    <xsl:variable name="interior-has-sidebar" select="$interior-layout = ('two', 'three')"/>
    <xsl:variable name="interior-has-hero" select="ou:pcf-param('top-media') = 'hero'"/>

    <xsl:variable name="interior-has-banner" select="ou:pcf-param('top-media') = 'banner' and normalize-space(ou:pcf-param('banner')) != ''"/>
    <xsl:variable name="interior-has-top-media" select="$interior-has-hero or $interior-has-banner"/>

    <xsl:template name="template-headcode"/>
    <xsl:template name="page-body-class">
        <xsl:value-of select="concat('interior-page interior-layout-', $interior-layout, if ($interior-has-top-media) then ' page-hero-enabled' else '')"/>
    </xsl:template>
    <xsl:template name="page-after-header">
        <xsl:if test="$interior-has-sidebar">
            <!-- One sidebar is relocated here below lg; no duplicate CMS regions. -->
            <div class="interior-mobile-sidebar d-lg-none" data-sidebar-mobile-slot=""><xsl:text> </xsl:text></div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="page-main-attributes">
        <xsl:if test="ou:pcf-param('show-breadcrumbs') = 'false' and $interior-layout != 'full' and not($interior-has-top-media)">
            <xsl:attribute name="class">pt-5</xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xsl:template name="page-content">
        <xsl:variable name="page-breadcrumbs">
            <xsl:if test="not(ou:pcf-param('show-breadcrumbs') = 'false')">
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
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="hero-component" select="(ouc:div[@label='hero-content']//ouc:component[@name='component-hero'])[1]"/>
        <xsl:if test="$interior-has-hero">
            <div class="page-hero">
                <xsl:apply-templates select="ouc:div[@label='hero-content']">
                    <xsl:with-param name="hero-breadcrumbs" select="$page-breadcrumbs/node()" tunnel="yes"/>
                    <xsl:with-param name="hero-breadcrumb-target" select="generate-id($hero-component)" tunnel="yes"/>
                </xsl:apply-templates>
                <xsl:if test="not(ouc:div[@label='hero-content']) and $ou:action != 'pub'">
                    <p class="alert alert-info m-0">Add the hero-content editable region to this PCF to edit its hero. See the interior migration guide.</p>
                </xsl:if>
            </div>
        </xsl:if>
        <xsl:if test="$interior-has-banner">
            <!-- Feed the existing hero renderer one image and the page heading. -->
            <xsl:variable name="banner-hero">
                <ouc:component name="component-hero">
                    <ul>
                        <li class="title"><xsl:value-of select="ou:pcf-param('heading')"/></li>
                        <li class="show-ctas">false</li>
                        <li class="images"><ul>
                            <li class="image"><xsl:value-of select="ou:pcf-param('banner')"/></li>
                            <li class="alt"><xsl:value-of select="ou:pcf-param('banner-alt')"/></li>
                        </ul></li>
                    </ul>
                </ouc:component>
            </xsl:variable>
            <div class="page-hero">
                <xsl:apply-templates select="$banner-hero/ouc:component">
                    <xsl:with-param name="hero-is-banner" select="true()" tunnel="yes"/>
                    <xsl:with-param name="hero-breadcrumbs" select="$page-breadcrumbs/node()" tunnel="yes"/>
                    <xsl:with-param name="hero-breadcrumb-target" select="generate-id($banner-hero/ouc:component)" tunnel="yes"/>
                </xsl:apply-templates>
            </div>
        </xsl:if>
        <div class="interior-content-wrap">
            <xsl:if test="$interior-layout != 'full'"><xsl:attribute name="class" select="concat('interior-content-wrap container-xl', if ($interior-has-top-media) then ' pt-5' else '')"/></xsl:if>
            <xsl:if test="not($interior-has-banner or ($interior-has-hero and $hero-component))">
                <xsl:copy-of select="$page-breadcrumbs"/>
            </xsl:if>
            <div>
                <xsl:attribute name="class" select="if ($interior-has-sidebar) then 'row gy-4 flex-column-reverse flex-lg-row' else ''"/>
                <div>
                    <xsl:attribute name="class" select="concat('main-content interior-content', if ($interior-has-sidebar) then ' col-12 col-lg-9 pb-5' else if ($interior-layout = 'one') then ' interior-reading-width mx-auto' else '')"/>
                    <xsl:if test="not($interior-has-top-media) and normalize-space(ou:pcf-param('heading'))">
                        <h1 class="page-title"><xsl:value-of select="ou:pcf-param('heading')"/></h1>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="ou:pcf-param('top-media') = 'slider'"><xsl:apply-templates select="ouc:div[@label='gallery']"/></xsl:when>
                    </xsl:choose>
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


                    <xsl:apply-templates select="ouc:div[@label='main-content']"/>
                </div>
                <xsl:if test="$interior-has-sidebar">
                    <div class="col-12 col-lg-3 pb-lg-5" data-sidebar-desktop-slot="">
                        <xsl:call-template name="side-navigation"/>
                    </div>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="side-navigation">
        <aside class="interior-sidebar" data-interior-sidebar="" aria-label="Section navigation and additional content">
            <button class="btn section-menu-toggle d-lg-none w-100 d-flex align-items-center justify-content-between collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#interior-section-menu" aria-controls="interior-section-menu" aria-expanded="false">
                <span class="section-menu-open">Open Section Menu</span><span class="section-menu-close">Close Section Menu</span>
                <span class="section-menu-icon" aria-hidden="true"><xsl:text> </xsl:text></span>
            </button>
            <div class="collapse d-lg-block" id="interior-section-menu">
                <nav class="sidenav" aria-label="Section navigation"><xsl:copy-of select="ou:include-file(concat($ou:dirname, '/_nav.inc'))"/></nav>
                <xsl:if test="$interior-layout = 'three'">
                    <div class="additional-content mt-4"><xsl:apply-templates select="ouc:div[@label='right-content']"/></div>
                </xsl:if>
            </div>
        </aside>
    </xsl:template>
</xsl:stylesheet>
