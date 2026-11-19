<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ouc="http://omniupdate.com/XSL/Variables" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="ouc ou xs">
  <xsl:template match="ouc:component[@name=('component-news-carousel','component-events-carousel')]" mode="#all">
    <xsl:variable name="kind" select="if (@name='component-events-carousel') then 'events' else 'news'"/>
    <xsl:variable name="fields" select="ul/li"/>
    <xsl:variable name="feed" select="normalize-space(if ($fields[@class='feed-url']/a) then $fields[@class='feed-url']/a[1]/@href else $fields[@class='feed-url'])"/>
    <xsl:variable name="options" select="map {
      'kind': $kind, 'feed-url': $feed,
      'items-mobile': if ($fields[@class='items-mobile'] = ('1','2','3','4','5','6')) then xs:integer($fields[@class='items-mobile']) else 1,
      'items-tablet': if ($fields[@class='items-tablet'] = ('1','2','3','4','5','6')) then xs:integer($fields[@class='items-tablet']) else 2,
      'items-desktop': if ($fields[@class='items-desktop'] = ('1','2','3','4','5','6')) then xs:integer($fields[@class='items-desktop']) else 3,
      'max-items': if ($fields[@class='max-items'] castable as xs:integer) then max((1,min((50,xs:integer($fields[@class='max-items']))))) else 6,
      'featured': if (normalize-space($fields[@class='featured'])='true') then 'true' else 'false',
      'organizer': normalize-space($fields[@class='organizer'])
    }"/>
    <xsl:choose>
      <xsl:when test="$ou:action='pub'">
        <xsl:processing-instruction name="php"><xsl:text>$ltccFeedHelper = $_SERVER['DOCUMENT_ROOT'] . '/_resources/php/feed-components.php'; if (is_readable($ltccFeedHelper)) { require_once $ltccFeedHelper; ltcc_render_feed_component(json_decode(rawurldecode('</xsl:text><xsl:value-of select="encode-for-uri(serialize($options, map{'method':'json'}))"/><xsl:text>'), true)); } else { error_log('LTCC: feed-components.php is missing.'); } ?</xsl:text></xsl:processing-instruction>
      </xsl:when>
      <xsl:otherwise>
        <div class="alert alert-info mb-0">
          <strong><xsl:value-of select="if ($kind='news') then 'News Carousel' else 'Events Carousel'"/></strong>
          <p class="mb-0">Live feed cards render on the published PHP page. Items per row: <xsl:value-of select="$options('items-mobile')"/> mobile / <xsl:value-of select="$options('items-tablet')"/> tablet / <xsl:value-of select="$options('items-desktop')"/> desktop. Maximum: <xsl:value-of select="$options('max-items')"/>.</p>
          <xsl:if test="$feed != ''"><p class="mb-0 text-break">Feed: <xsl:value-of select="$feed"/></p></xsl:if>
          <xsl:if test="$kind='events'"><p class="mb-0">Featured only: <xsl:value-of select="$options('featured')"/>. Organizer: <xsl:value-of select="if ($options('organizer') != '') then $options('organizer') else 'All'"/>.</p></xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
