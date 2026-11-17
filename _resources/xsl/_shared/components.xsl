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
	Implementation Skeleton - 02/07/2020

	Global Components XSL
	This file contains templates and functions that control default behavior for standard OU Components
-->

<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="xs ou fn ouc">

	<!-- A template match for getting rid of the stray P element that wraps around a component when it is in Blue Pill Mode -->
	<xsl:template match="p[ouc:component][text()[normalize-space(.)] => empty()][count(element()) = 1]" mode="#all">
		<xsl:apply-templates select="element()" mode="#current"/>
	</xsl:template>

	<!-- Create a mode for working with OU standard component practices -->
	<xsl:mode name="ouc-component" on-no-match="shallow-copy"/>

	<!-- A match for ouc:component element in the unnamed namespace. This match changes the mode name to ouc-component. -->
	<xsl:template match="ouc:component">
		<xsl:apply-templates mode="ouc-component"/>
	</xsl:template>

	<!-- A match for the "data-ouc-test" attribute on elements inside an ouc component. This is for removing the attribute from the final output when elements pass the test. -->
	<xsl:template match="@data-ouc-test" mode="ouc-component"/>

	<!-- A match for elements inside ouc components that have empty "data-ouc-test" attributes. This is for removing elements that fail the test from the final output. -->
	<xsl:template match="element()[@data-ouc-test and normalize-space(@data-ouc-test) = '']" mode="ouc-component"/>
	
	<!-- Apply the same opt-in empty-attribute test to any element in the default mode. -->
	<xsl:template match="*[@data-ouc-test and normalize-space(@data-ouc-test) = '']"/>

	<!-- A match for the "data-ouc-not" attribute on elements inside an ouc component. This is for removing the attribute from the final output when elements pass the not test. -->
	<xsl:template match="@data-ouc-not" mode="ouc-component"/>

	<!-- A match for elements inside ouc components that have non-empty "data-ouc-not" attributes. This is for removing elements that fail the not test from the final output. -->
	<xsl:template match="element()[normalize-space(@data-ouc-not) != '']" mode="ouc-component"/>

	<!-- A match for elements inside ouc components that have "data-ouc-justedit" attributes. This attribute is used to show elements only inside JustEdit, so we remove all elements that have this attribute. -->
	<xsl:template match="element()[@data-ouc-justedit]" mode="ouc-component"/>
	
	<!-- Marketing links: settings are data, not output list items. -->
	<xsl:template match="ouc:component[@name='component-link-list']" mode="#all">
		<xsl:variable name="color" select="if (normalize-space(ul/li[@class='color']) = 'light') then 'light' else 'dark'"/>
		<xsl:variable name="size" select="normalize-space(ul/li[@class='size'])"/>
		<ul class="mkt-link-list list-unstyled d-flex flex-column gap-3 mb-0">
			<xsl:for-each select="ul/li[@class='icons']/ul">
				<xsl:variable name="text" select="normalize-space(li[@class='text'])"/>
				<xsl:variable name="href" select="normalize-space(if (li[@class='link']/a) then string(li[@class='link']/a[1]/@href) else string(li[@class='link']))"/>
				<xsl:variable name="style" select="normalize-space(li[@class='style'])"/>
				<xsl:variable name="icon" select="normalize-space(li[@class='icon'])"/>
				<!-- Incomplete rows must not produce empty or current-page links. -->
				<xsl:if test="$text != '' and $href != ''">
					<li>
						<a href="{$href}" class="{normalize-space(concat(if ($style = 'arrow') then concat('arrow-link arrow-link-', $color) else concat('mkt-link mkt-link-', $color), ' ', $size))}">
							<xsl:if test="$style = 'before' and $icon != ''">
								<span class="mkt-link__icon {$icon}" aria-hidden="true"><xsl:text> </xsl:text></span>
							</xsl:if>
							<span class="mkt-link__text"><xsl:value-of select="$text"/></span>
							<xsl:if test="$style = 'after' and $icon != ''">
								<span class="mkt-link__icon {$icon}" aria-hidden="true"><xsl:text> </xsl:text></span>
							</xsl:if>
						</a>
					</li>
				</xsl:if>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<!-- Placeholder for Components with no Preview-->
	<xsl:template match="ouc:component[@name='comp-placeholder']">
		<xsl:choose>
			<xsl:when test="$ou:action = 'pub'">

			</xsl:when>
			<xsl:otherwise>
				<div class="ou-preview card p-2 alert alert-info text-center">
					<span class="h6 d-block">--- Component Placeholder ----</span>
					<xsl:copy-of select="div[@class='placeholder-content']/node()" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


    <!-- One renderer for the existing faculty table and the individual CMS component. -->
    <xsl:template name="ltcc-contact">
        <xsl:param name="name" select="''"/>
        <xsl:param name="title" select="''"/>
        <xsl:param name="email" select="''"/>
        <xsl:param name="website" select="''"/>
        <xsl:variable name="contact-name" select="normalize-space(translate(string($name), '&#160;', ' '))"/>
        <xsl:variable name="contact-title" select="normalize-space(translate(string($title), '&#160;', ' '))"/>
        <xsl:variable name="contact-email" select="replace(normalize-space(translate(string($email), '&#160;', ' ')), '^mailto:\s*', '', 'i')"/>
        <xsl:variable name="contact-website" select="normalize-space(translate(string($website), '&#160;', ' '))"/>
        <xsl:if test="$contact-name != ''">
            <div class="ltcc-contact d-flex align-items-center gap-3">
                <div class="ltcc-contact__details">
                    <p class="ltcc-contact__name fw-bold mb-0"><xsl:value-of select="$contact-name"/></p>
                    <xsl:if test="$contact-title != ''"><p class="ltcc-contact__title fs-8 mb-0"><xsl:value-of select="$contact-title"/></p></xsl:if>
                </div>
                <xsl:if test="$contact-email != '' or $contact-website != ''">
                    <span class="ltcc-contact__rule flex-grow-1" aria-hidden="true"><xsl:text> </xsl:text></span>
                    <div class="ltcc-contact__links d-flex gap-2 flex-shrink-0 ms-auto">
                        <xsl:if test="$contact-email != ''">
                            <a class="btn btn-primary btn-circle" href="mailto:{$contact-email}">
                                <span class="fa-sharp fa-regular fa-envelope" aria-hidden="true"><xsl:text> </xsl:text></span>
                                <span class="visually-hidden">Email <xsl:value-of select="$contact-name"/></span>
                            </a>
                        </xsl:if>
                        <xsl:if test="$contact-website != ''">
                            <a class="btn btn-primary btn-circle" href="{$contact-website}">
                                <span class="fa-sharp fa-regular fa-globe" aria-hidden="true"><xsl:text> </xsl:text></span>
                                <span class="visually-hidden">Website for <xsl:value-of select="$contact-name"/></span>
                            </a>
                        </xsl:if>
                    </div>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ouc:component[@name='component-contact']" mode="#all">
        <xsl:for-each select="ul"><xsl:call-template name="ltcc-contact-fields"/></xsl:for-each>
    </xsl:template>

    <xsl:template name="ltcc-contact-fields">
        <xsl:call-template name="ltcc-contact">
            <xsl:with-param name="name" select="li[@class='name']"/>
            <xsl:with-param name="title" select="li[@class='title']"/>
            <xsl:with-param name="email" select="if (li[@class='email']//a) then (li[@class='email']//a)[1]/@href else li[@class='email']"/>
            <xsl:with-param name="website" select="if (li[@class='website']//a) then (li[@class='website']//a)[1]/@href else li[@class='website']"/>
        </xsl:call-template>
    </xsl:template>



    <!-- Shared section wrapper: omit empty sections and optional heading lines. -->
    <xsl:template name="ltcc-contact-section">
        <xsl:param name="heading-top" select="''"/>
        <xsl:param name="heading-bottom" select="''"/>
        <xsl:param name="items" select="()"/>
        <xsl:if test="$items">
            <section class="contact-section d-flex flex-column gap-4">
                <xsl:if test="$heading-top != '' or $heading-bottom != ''">
                    <div class="contact-section__heading d-flex align-items-center gap-3">
                        <h2 class="contact-section__title mb-0 fw-bold">
                            <xsl:if test="$heading-top != ''"><span class="contact-section__eyebrow d-block"><xsl:value-of select="$heading-top"/></span></xsl:if>
                            <xsl:if test="$heading-bottom != ''"><span class="contact-section__label d-block text-uppercase"><xsl:value-of select="$heading-bottom"/></span></xsl:if>
                        </h2>
                        <span class="contact-section__rule flex-grow-1" aria-hidden="true"><xsl:text> </xsl:text></span>
                    </div>
                </xsl:if>
                <ul class="list-unstyled d-flex flex-column gap-4 mb-0">
                    <xsl:copy-of select="$items"/>
                </ul>
            </section>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ouc:component[@name='component-contact-section']" mode="#all">
        <xsl:variable name="items">
            <xsl:for-each select="ul/li[@class='contacts']/ul[normalize-space(translate(string(li[@class='name']), '&#160;', ' ')) != '']">
                <li><xsl:call-template name="ltcc-contact-fields"/></li>
            </xsl:for-each>
        </xsl:variable>
        <xsl:call-template name="ltcc-contact-section">
            <xsl:with-param name="heading-top" select="normalize-space(translate(string(ul/li[@class='heading-top']), '&#160;', ' '))"/>
            <xsl:with-param name="heading-bottom" select="normalize-space(translate(string(ul/li[@class='heading-bottom']), '&#160;', ' '))"/>
            <xsl:with-param name="items" select="$items/li"/>
        </xsl:call-template>
    </xsl:template>

    <!-- Button groups use physical alignment settings regardless of flex direction. -->
    <xsl:template match="ouc:component[@name='component-button-group']" mode="#all">
        <xsl:variable name="vertical" select="lower-case(normalize-space(ul/li[@class='layout'])) = 'vertical'"/>
        <xsl:variable name="horizontal" select="lower-case(normalize-space(ul/li[@class='horizontal-alignment']))"/>
        <xsl:variable name="vertical-alignment" select="lower-case(normalize-space(ul/li[@class='vertical-alignment']))"/>
        <xsl:variable name="horizontal-value" select="if ($horizontal = 'center') then 'center' else if ($horizontal = 'right') then 'end' else 'start'"/>
        <xsl:variable name="vertical-value" select="if ($vertical-alignment = 'center') then 'center' else if ($vertical-alignment = 'bottom') then 'end' else 'start'"/>
        <xsl:variable name="items">
            <xsl:for-each select="ul/li[@class='buttons']/ul">
                <xsl:variable name="text" select="normalize-space(translate(string(li[@class='text']), '&#160;', ' '))"/>
                <xsl:variable name="href" select="normalize-space(translate(if (li[@class='url']/a) then string(li[@class='url']/a[1]/@href) else string(li[@class='url']), '&#160;', ' '))"/>
                <xsl:variable name="size" select="normalize-space(li[@class='size'])"/>
                <xsl:variable name="style" select="normalize-space(li[@class='style'])"/>
                <xsl:variable name="style-class" select="if ($style = ('btn-primary', 'btn-secondary', 'btn-success', 'btn-danger', 'btn-warning', 'btn-info', 'btn-light', 'btn-dark', 'btn-link', 'btn-outline-primary', 'btn-outline-secondary', 'btn-outline-success', 'btn-outline-danger', 'btn-outline-warning', 'btn-outline-info', 'btn-outline-light', 'btn-outline-dark')) then $style else 'btn-primary'"/>
                <xsl:if test="$text != '' and $href != ''">
                    <li>
                        <a href="{$href}" class="{string-join(('btn', $style-class, if ($size = ('btn-sm', 'btn-lg')) then $size else ()), ' ')}"><xsl:value-of select="$text"/></a>
                    </li>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$items/li">
            <ul class="{string-join(('list-unstyled', 'd-flex', if ($vertical) then 'flex-column' else ('flex-row', 'flex-wrap'), concat('justify-content-', if ($vertical) then $vertical-value else $horizontal-value), concat('align-items-', if ($vertical) then $horizontal-value else $vertical-value), 'gap-2', 'mb-0'), ' ')}">
                <xsl:copy-of select="$items/li"/>
            </ul>
        </xsl:if>
    </xsl:template>

    <!-- Schedule evaluation happens in PHP at request time, never at publish time. -->
    <xsl:template match="ouc:component[@name='component-alert']" mode="#all">
        <xsl:variable name="display" select="lower-case(normalize-space(ul/li[@class='display']))"/>
        <xsl:variable name="dismissible" select="lower-case(normalize-space(ul/li[@class='dismissible'])) != 'false'"/>
        <xsl:variable name="start" select="normalize-space(ul/li[@class='start'])"/>
        <xsl:variable name="end" select="normalize-space(ul/li[@class='end'])"/>
        <xsl:variable name="alert-style" select="lower-case(normalize-space(translate(string((ul/li[tokenize(normalize-space(@class), '\s+') = 'style'])[1]), '&#160;', ' ')))"/>
        <xsl:variable name="style" select="if ($alert-style = ('info', 'emergency')) then $alert-style else 'default'"/>
        <xsl:variable name="title" select="normalize-space(translate(string(ul/li[@class='title']), '&#160;', ' '))"/>
        <xsl:variable name="content" select="ul/li[@class='content']"/>
        <xsl:variable name="button-text" select="normalize-space(translate(string(ul/li[@class='button-text']), '&#160;', ' '))"/>
        <xsl:variable name="href" select="normalize-space(translate(if (ul/li[@class='button-link']/a) then string(ul/li[@class='button-link']/a[1]/@href) else string(ul/li[@class='button-link']), '&#160;', ' '))"/>
        <xsl:variable name="icon" select="if (normalize-space(ul/li[@class='icon']) = ('fa-bell', 'fa-circle-exclamation', 'fa-circle-info', 'fa-smile', 'fa-bullhorn')) then normalize-space(ul/li[@class='icon']) else 'fa-bell'"/>
        <xsl:variable name="has-content" select="normalize-space(translate(string($content), '&#160;', ' ')) != '' or exists($content//*[self::img or self::video or self::iframe or self::ouc:component])"/>
        <xsl:variable name="preview" select="$ou:action != 'pub'"/>
        <xsl:if test="($title != '' or $has-content or ($button-text != '' and $href != '')) and ($preview or $display = ('always', 'scheduled'))">
            <xsl:if test="$preview">
                <div class="small border p-2 mb-0" role="note">
                    <strong>Alert preview: </strong><xsl:value-of select="if ($display = 'always') then 'Show Always' else if ($display = 'scheduled') then 'Scheduled (America/Los_Angeles)' else 'Hidden on publish'"/>
                    <xsl:if test="$display = 'scheduled'"> — Start: <xsl:value-of select="if ($start != '') then $start else 'no limit'"/>; End: <xsl:value-of select="if ($end != '') then $end else 'no limit'"/>. Invalid dates keep the published alert hidden.</xsl:if>
                </div>
            </xsl:if>
            <xsl:if test="not($preview) and $display = 'scheduled'">
                <xsl:processing-instruction name="php"><xsl:text>if (!function_exists('ltcc_alert_visible')) { $ltccAlertHelper = $_SERVER['DOCUMENT_ROOT'] . '/_resources/php/alerts.php'; if (is_readable($ltccAlertHelper)) { require_once $ltccAlertHelper; } else { error_log('LTCC: scheduled alert hidden because /_resources/php/alerts.php is missing or unreadable.'); } } if (function_exists('ltcc_alert_visible') &amp;&amp; ltcc_alert_visible('scheduled', rawurldecode('</xsl:text><xsl:value-of select="encode-for-uri($start)"/><xsl:text>'), rawurldecode('</xsl:text><xsl:value-of select="encode-for-uri($end)"/><xsl:text>'))): ?</xsl:text></xsl:processing-instruction>
            </xsl:if>
            <div class="{concat('alert ltcc-alert ltcc-alert--', $style, ' rounded-0 border-0 mb-0', if ($dismissible) then ' alert-dismissible' else '')}" role="{if ($style = 'emergency') then 'alert' else 'status'}">
                <div class="container-xl d-flex align-items-start align-items-lg-center justify-content-lg-center gap-3">
                    <span class="ltcc-alert__icon fa-sharp fa-regular {$icon} flex-shrink-0" aria-hidden="true"><xsl:text> </xsl:text></span>
                    <div class="ltcc-alert__details d-flex flex-column flex-lg-row align-items-start align-items-lg-center gap-3 flex-grow-1 flex-lg-grow-0">
                        <xsl:if test="$title != ''"><h2 class="ltcc-alert__title fw-bold mb-0"><xsl:value-of select="$title"/></h2></xsl:if>
                        <xsl:if test="$has-content"><div class="ltcc-alert__content flex-grow-1 flex-lg-grow-0"><xsl:apply-templates select="$content/node()" mode="#current"/></div></xsl:if>
                        <xsl:if test="$button-text != '' and $href != ''"><a class="btn btn-sm {if ($style = 'default') then 'btn-secondary' else 'btn-primary'} flex-shrink-0" href="{$href}"><xsl:value-of select="$button-text"/></a></xsl:if>
                    </div>
                </div>
                <xsl:if test="$dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Dismiss alert"></button></xsl:if>
            </div>
            <xsl:if test="not($preview) and $display = 'scheduled'"><xsl:processing-instruction name="php">endif; ?</xsl:processing-instruction></xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ouc:component[@name='component-hero']" mode="#all">
        <xsl:param name="hero-breadcrumbs" select="()" tunnel="yes"/>
        <xsl:param name="hero-breadcrumb-target" select="''" tunnel="yes"/>
        <xsl:variable name="show-ctas" select="lower-case(normalize-space(translate(string(ul/li[@class='show-ctas']), '&#160;', ' '))) != 'false'"/>
        <xsl:variable name="pre-title" select="normalize-space(translate(string(ul/li[@class='pre-title']), '&#160;', ' '))"/>
        <xsl:variable name="title" select="normalize-space(translate(string(ul/li[@class='title']), '&#160;', ' '))"/>
        <xsl:variable name="subtitle" select="normalize-space(translate(string(ul/li[@class='subtitle']), '&#160;', ' '))"/>
        <xsl:variable name="cta-label" select="normalize-space(translate(string(ul/li[@class='cta-label']), '&#160;', ' '))"/>
        <xsl:variable name="hero-id" select="concat('hero-', generate-id())"/>
        <xsl:variable name="images">
            <xsl:for-each select="ul/li[@class='images']/ul">
                <xsl:variable name="image" select="li[@class='image']"/>
                <xsl:variable name="src" select="normalize-space(translate(if ($image//img) then string(($image//img)[1]/@src) else if ($image/a) then string($image/a[1]/@href) else string($image), '&#160;', ' '))"/>
                <xsl:if test="$src != ''">
                    <img src="{$src}" alt="{if (li[@class='alt']) then normalize-space(li[@class='alt']) else string(($image//img)[1]/@alt)}" class="ltcc-hero__image" decoding="async"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="ctas">
            <xsl:for-each select="ul/li[@class='ctas']/ul">
                <xsl:variable name="text" select="normalize-space(translate(string(li[@class='text']), '&#160;', ' '))"/>
                <xsl:variable name="href" select="normalize-space(translate(if (li[@class='link']/a) then string(li[@class='link']/a[1]/@href) else string(li[@class='link']), '&#160;', ' '))"/>
                <xsl:if test="$text != '' and $href != ''">
                    <li><a href="{$href}" class="mkt-link mkt-link-light ltcc-hero__link"><span class="mkt-link__text"><xsl:value-of select="$text"/></span><span class="mkt-link__icon fa-sharp fa-regular {if (starts-with($href, '#')) then 'fa-arrow-down' else 'fa-arrow-right'}" aria-hidden="true"><xsl:text> </xsl:text></span></a></li>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$title != '' or $images/img or $pre-title != '' or $subtitle != '' or ($show-ctas and $ctas/li)">
            <section class="ltcc-hero bg-blue-950 text-white" id="{$hero-id}">
                <xsl:if test="$title != ''"><xsl:attribute name="aria-labelledby" select="concat($hero-id, '-title')"/></xsl:if>
                <div class="container-xl">
                  <div class="row g-0 align-items-center">
                <div class="ltcc-hero__copy col-12 {if ($images/img) then 'col-lg-6 pe-lg-5' else ''} d-flex flex-column justify-content-center gap-4 gap-lg-5 py-4 py-lg-5 order-2 order-lg-1">
                    <xsl:if test="generate-id() = $hero-breadcrumb-target">
                        <xsl:copy-of select="$hero-breadcrumbs"/>
                    </xsl:if>
                    <div class="ltcc-hero__headings d-flex flex-column">
                        <xsl:if test="$pre-title != ''"><p class="ltcc-hero__pretitle fw-semibold mb-0"><xsl:value-of select="$pre-title"/></p></xsl:if>
                        <xsl:if test="$title != ''"><h1 class="ltcc-hero__title fw-bold mb-0" id="{$hero-id}-title"><xsl:value-of select="$title"/></h1></xsl:if>
                        <xsl:if test="$subtitle != ''"><p class="ltcc-hero__subtitle fw-semibold mb-0"><xsl:value-of select="$subtitle"/></p></xsl:if>
                    </div>
                    <xsl:if test="$show-ctas and $ctas/li">
                        <div class="ltcc-hero__ctas d-flex flex-column align-items-start gap-3">
                            <img src="/_resources/img/components/hero-mountain.svg" width="48" height="20" alt=""/>
                            <xsl:if test="$cta-label != ''"><p class="fw-semibold mb-0" id="{$hero-id}-cta-label"><xsl:value-of select="$cta-label"/></p></xsl:if>
                            <ul class="list-unstyled d-flex flex-wrap gap-4 mb-0">
                                <xsl:if test="$cta-label != ''"><xsl:attribute name="aria-labelledby" select="concat($hero-id, '-cta-label')"/></xsl:if>
                                <xsl:copy-of select="$ctas/li"/>
                            </ul>
                        </div>
                    </xsl:if>
                </div>
                <xsl:if test="$images/img">
                    <div class="ltcc-hero__media col-12 col-lg-6 order-1 order-lg-2">
                      <div class="ratio ratio-4x3 overflow-hidden">
                        <xsl:choose>
                            <xsl:when test="count($images/img) gt 1">
                                <div class="swiper ltcc-hero-swiper position-absolute top-0 start-0 w-100 h-100" aria-label="Hero images">
                                    <div class="swiper-wrapper">
                                        <xsl:for-each select="$images/img"><div class="swiper-slide"><xsl:copy-of select="."/></div></xsl:for-each>
                                    </div>
                                    <div class="ltcc-hero__controls align-items-center rounded-pill p-1" hidden="hidden">
                                        <button type="button" class="btn media-playback-toggle rounded-circle d-flex align-items-center justify-content-center text-center" data-hero-prev="" aria-label="Previous image"><span class="fa-sharp fa-regular fa-arrow-left" aria-hidden="true"><xsl:text> </xsl:text></span></button>
                                        <button type="button" class="btn media-playback-toggle rounded-circle d-flex align-items-center justify-content-center text-center" data-hero-next="" aria-label="Next image"><span class="fa-sharp fa-regular fa-arrow-right" aria-hidden="true"><xsl:text> </xsl:text></span></button>
                                        <button type="button" class="btn media-playback-toggle rounded-circle d-flex align-items-center justify-content-center text-center" data-hero-pause="" aria-label="Pause slideshow" aria-pressed="false"><span class="fa-sharp fa-regular fa-circle-pause" aria-hidden="true"><xsl:text> </xsl:text></span></button>
                                    </div>
                                </div>
                            </xsl:when>
                            <xsl:otherwise><xsl:copy-of select="$images/img"/></xsl:otherwise>
                        </xsl:choose>
                      </div>
                    </div>
                </xsl:if>
                  </div>
                </div>
            </section>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
