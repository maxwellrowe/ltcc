<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ouc="http://omniupdate.com/XSL/Variables" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ltcc="urn:ltcc:typed-text" exclude-result-prefixes="ouc xs ltcc">
  <xsl:function name="ltcc:typed-color" as="xs:string">
    <xsl:param name="value"/>
    <xsl:variable name="class" select="if (starts-with(normalize-space($value),'text-')) then normalize-space($value) else concat('text-',normalize-space($value))"/>
    <xsl:sequence select="if ($class=('text-primary','text-secondary','text-bright-green','text-blue-400','text-green-100','text-blue-100','text-white')) then $class else 'text-primary'"/>
  </xsl:function>
  <xsl:template match="ouc:component[@name='component-typed-text']" mode="#all">
    <xsl:variable name="fields" select="ul/li"/>
    <xsl:variable name="phrases" select="$fields[@class='phrases']/ul/li[@class='text'][normalize-space(.) != '']"/>
    <xsl:variable name="prefix" select="normalize-space($fields[@class='prefix'])"/>
    <xsl:variable name="suffix" select="string($fields[@class='suffix'])"/>
    <xsl:variable name="size" select="normalize-space($fields[@class='size'])"/>
    <xsl:variable name="speed" select="normalize-space($fields[@class='speed'])"/>
    <xsl:variable name="delay" select="if ($fields[@class='start-delay'] castable as xs:integer) then max((0,min((10000,xs:integer($fields[@class='start-delay']))))) else 0"/>
    <xsl:variable name="hold" select="if ($fields[@class='phrase-delay'] castable as xs:integer) then max((0,min((30000,xs:integer($fields[@class='phrase-delay']))))) else 2000"/>
    <xsl:if test="exists($phrases)">
      <div class="ltcc-typed-text" data-typed-text="" data-typed-loop="{normalize-space($fields[@class='loop']) != 'false'}" data-typed-speed="{if ($speed='slow') then 100 else if ($speed='fast') then 30 else 60}" data-typed-back-speed="{if ($speed='slow') then 50 else if ($speed='fast') then 15 else 30}" data-typed-start-delay="{$delay}" data-typed-phrase-delay="{$hold}" data-typed-cursor="{normalize-space($fields[@class='show-cursor']) != 'false'}">
        <h2 class="mb-0 {if ($size=('h1','h2','h3','h4','h5','h6','fs-1','fs-2','fs-3','fs-4','fs-5','fs-6')) then $size else 'h2'}">
          <span class="visually-hidden"><xsl:value-of select="string-join(for $phrase in $phrases return concat(if ($prefix != '') then concat($prefix,' ') else '', normalize-space($phrase), $suffix), '; ')"/></span>
          <span aria-hidden="true">
            <xsl:if test="$prefix != ''"><span class="{ltcc:typed-color($fields[@class='prefix-color'])}"><xsl:value-of select="$prefix"/></span><xsl:choose><xsl:when test="normalize-space($fields[@class='break-after-prefix'])='true'"><br/></xsl:when><xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise></xsl:choose></xsl:if>
            <span class="{ltcc:typed-color($fields[@class='typed-color'])}"><span data-typed-output=""><xsl:value-of select="normalize-space($phrases[1])"/></span></span>
            <xsl:if test="normalize-space($suffix) != ''"><span class="{ltcc:typed-color($fields[@class='suffix-color'])}"><xsl:value-of select="$suffix"/></span></xsl:if>
          </span>
        </h2>
        <ul data-typed-phrases="" hidden="hidden"><xsl:for-each select="$phrases"><li><xsl:value-of select="normalize-space(.)"/></li></xsl:for-each></ul>
        <button type="button" class="btn media-playback-toggle ltcc-typed-text__pause rounded-circle mt-2" data-typed-pause="" aria-label="Pause typing animation" aria-pressed="false" hidden="hidden"><span class="fa-sharp fa-regular fa-circle-pause" aria-hidden="true"><xsl:text> </xsl:text></span><span class="visually-hidden" data-typed-pause-label="">Pause animation</span></button>
      </div>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
