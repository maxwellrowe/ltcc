<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ouc">
  <xsl:template match="ouc:component[@name='component-home-hero']" mode="#all">
    <xsl:variable name="fields" select="ul/li"/>
    <xsl:variable name="id" select="concat('home-hero-', generate-id())"/>
    <xsl:variable name="title" select="normalize-space($fields[@class='title'])"/>
    <xsl:variable name="subtitle" select="normalize-space($fields[@class='subtitle'])"/>
    <xsl:variable name="page-heading" select="normalize-space(string((/document/ouc:properties[@label='metadata']/title[normalize-space()], /document/ouc:properties/parameter[@name='heading'][normalize-space()])[1]))"/>
    <xsl:variable name="video-field" select="$fields[@class='video']"/>
    <xsl:variable name="video" select="normalize-space(if ($video-field/a) then $video-field/a[1]/@href else $video-field)"/>
    <xsl:variable name="video-mode" select="lower-case(normalize-space($fields[@class='type'])) = 'video' and $video != ''"/>
    <xsl:variable name="poster-field" select="$fields[@class='poster']"/>
    <xsl:variable name="poster" select="normalize-space(if ($poster-field//img) then ($poster-field//img)[1]/@src else $poster-field)"/>
    <xsl:variable name="images">
      <xsl:for-each select="$fields[@class='images']/ul/li[@class='image']">
        <xsl:variable name="src" select="normalize-space(if (.//img) then (.//img)[1]/@src else if (a) then a[1]/@href else .)"/>
        <xsl:if test="$src != ''"><img src="{$src}" alt="" decoding="async"/></xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="alert-content" select="$fields[@class='alert-content']"/>
    <xsl:variable name="alert-title" select="normalize-space($fields[@class='alert-title'])"/>
    <xsl:variable name="alert-text" select="normalize-space($fields[@class='alert-button-text'])"/>
    <xsl:variable name="alert-link" select="$fields[@class='alert-button-url']"/>
    <xsl:variable name="alert-url" select="normalize-space(if ($alert-link/a) then $alert-link/a[1]/@href else $alert-link)"/>
    <xsl:variable name="show-alert" select="lower-case(normalize-space($fields[@class='show-alert'])) != 'false' and ($alert-title != '' or normalize-space($alert-content) != '' or ($alert-text != '' and $alert-url != ''))"/>
    <section class="home-hero position-relative text-white" data-home-hero="" id="{$id}" aria-labelledby="{$id}-heading">
      <h1 class="visually-hidden" id="{$id}-heading"><xsl:value-of select="if ($page-heading != '') then $page-heading else $title"/></h1>
      <xsl:choose>
        <xsl:when test="$video-mode">
          <!-- Playback starts via JS, allowing reduced-motion users to start paused. -->
          <video class="hero-video" muted="muted" loop="loop" playsinline="playsinline" preload="metadata" aria-hidden="true" tabindex="-1">
            <xsl:if test="$poster != ''"><xsl:attribute name="poster" select="$poster"/></xsl:if>
            <source src="{$video}" type="video/mp4"/>
          </video>
        </xsl:when>
        <xsl:when test="count($images/img) gt 1"><div class="swiper hero-media" aria-hidden="true"><div class="swiper-wrapper"><xsl:for-each select="$images/img"><div class="swiper-slide"><xsl:copy-of select="."/></div></xsl:for-each></div></div></xsl:when>
        <xsl:when test="$images/img"><div class="hero-media" aria-hidden="true"><xsl:copy-of select="$images/img[1]"/></div></xsl:when>
      </xsl:choose>
      <div class="hero-shade" aria-hidden="true"><xsl:text> </xsl:text></div>
      <div class="container-xl hero-content position-relative"><div class="row g-0"><div class="col-12 {if ($show-alert) then 'col-lg-8 pe-lg-4' else 'col-lg-10'}">
        <xsl:if test="$title != ''"><span class="home-hero__title d-block fw-semibold mb-2"><xsl:call-template name="home-hero-inline-field"><xsl:with-param name="field" select="$fields[@class='title']"/></xsl:call-template></span></xsl:if>
        <xsl:if test="$subtitle != ''"><span class="home-hero__subtitle d-block fw-bold lh-sm mb-3"><xsl:call-template name="home-hero-inline-field"><xsl:with-param name="field" select="$fields[@class='subtitle']"/></xsl:call-template></span></xsl:if>
        <xsl:if test="$fields[@class='buttons']/ul[normalize-space(li[@class='text']) != '' and normalize-space(li[@class='url']) != '']">
          <ul class="list-unstyled d-flex flex-wrap gap-2 mb-0"><xsl:for-each select="$fields[@class='buttons']/ul">
            <xsl:variable name="text" select="normalize-space(li[@class='text'])"/>
            <xsl:variable name="url" select="normalize-space(if (li[@class='url']/a) then li[@class='url']/a[1]/@href else li[@class='url'])"/>
            <xsl:if test="$text != '' and $url != ''"><li><a href="{$url}" class="btn btn-primary"><xsl:value-of select="$text"/></a></li></xsl:if>
          </xsl:for-each></ul>
        </xsl:if>
      </div></div></div>
      <xsl:if test="$video-mode or count($images/img) gt 1"><button class="btn btn-circle media-playback-toggle" type="button" data-home-hero-playback="" aria-label="Pause background media" aria-pressed="false" hidden="hidden"><span class="fa-sharp fa-regular fa-pause" aria-hidden="true"><xsl:text> </xsl:text></span></button></xsl:if>
      <xsl:if test="$show-alert">
        <aside class="hero-alert rounded-4 shadow p-3 p-lg-4" aria-labelledby="{$id}-alert-title">
          <span class="d-block fs-6 fw-bold mb-0" id="{$id}-alert-title"><xsl:value-of select="if ($alert-title != '') then $alert-title else 'LTCC information'"/></span>
          <div class="collapse" id="{$id}-alert-content">
            <div class="fs-7 mt-2 mb-3"><xsl:apply-templates select="$alert-content/node()"/></div>
            <xsl:if test="$alert-text != '' and $alert-url != ''"><a class="btn btn-primary btn-sm" href="{$alert-url}"><xsl:value-of select="$alert-text"/></a></xsl:if>
          </div>
          <button type="button" class="btn btn-circle hero-alert-toggle" data-bs-toggle="collapse" data-bs-target="#{$id}-alert-content" aria-controls="{$id}-alert-content" aria-expanded="false" aria-label="Toggle hero information"><span class="fa-sharp fa-regular fa-plus" aria-hidden="true"><xsl:text> </xsl:text></span></button>
        </aside>
      </xsl:if>
    </section>
  </xsl:template>
  <!-- Preserve inline formatting while unwrapping editor-added paragraphs. -->
  <xsl:mode name="home-hero-inline" on-no-match="shallow-skip"/>
  <xsl:template name="home-hero-inline-field">
    <xsl:param name="field"/>
    <xsl:choose>
      <xsl:when test="$field/*"><xsl:apply-templates select="$field/node()" mode="home-hero-inline"/></xsl:when>
      <xsl:otherwise>
        <xsl:try>
          <xsl:apply-templates select="parse-xml-fragment(string($field))/node()" mode="home-hero-inline"/>
          <xsl:catch><xsl:value-of select="$field"/></xsl:catch>
        </xsl:try>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="text()" mode="home-hero-inline"><xsl:value-of select="."/></xsl:template>
  <xsl:template match="span|em|strong|b|i|u|s|small|br|sub|sup|mark|abbr|cite|q|code" mode="home-hero-inline">
    <xsl:copy>
      <xsl:copy-of select="@class|@style|@title|@lang|@dir|@aria-label"/>
      <xsl:apply-templates mode="home-hero-inline"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="script|style" mode="home-hero-inline"/>
</xsl:stylesheet>
