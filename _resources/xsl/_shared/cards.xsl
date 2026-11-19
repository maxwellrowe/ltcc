<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ouc">

    <!-- Shared fields; linked cards deliberately render text-only descriptions. -->
    <xsl:template match="ouc:component[@name=('component-card-link', 'component-card')]" mode="#all">
        <xsl:variable name="fields" select="ul/li"/>
        <xsl:variable name="linked" select="@name = 'component-card-link'"/>
        <xsl:variable name="title" select="normalize-space($fields[@class='title'])"/>
        <xsl:variable name="url" select="normalize-space(if ($fields[@class='url']/a) then $fields[@class='url']/a[1]/@href else $fields[@class='url'])"/>
        <xsl:variable name="style-value" select="normalize-space($fields[@class='style'])"/>
        <xsl:variable name="style" select="if ($style-value = ('white', 'blue-100', 'green-100', 'gradient') or (not($linked) and $style-value = 'dark-blue')) then $style-value else 'white'"/>
        <xsl:variable name="dark" select="$style = 'dark-blue'"/>
        <xsl:variable name="background" select="if ($dark) then 'bg-blue-950 text-white' else if ($style = 'gradient') then 'bg-gradient-green-blue text-dark' else concat('bg-', $style, ' text-dark')"/>
        <xsl:variable name="padding" select="if (normalize-space($fields[@class='padding']) = ('1','2','3','4','5')) then normalize-space($fields[@class='padding']) else '3'"/>
        <xsl:variable name="size" select="if (normalize-space($fields[@class='title-size']) = ('h1','h2','h3','h4','h5','h6')) then normalize-space($fields[@class='title-size']) else 'h5'"/>
        <xsl:variable name="image" select="normalize-space(if ($fields[@class='image']/img) then $fields[@class='image']/img[1]/@src else if ($fields[@class='image']/a) then $fields[@class='image']/a[1]/@href else $fields[@class='image'])"/>
        <xsl:variable name="icon" select="normalize-space($fields[@class='icon'])"/>
        <xsl:variable name="icon-color" select="if ($dark) then 'text-blue-400' else if ($style='white') then 'text-blue-700' else if ($style='green-100') then 'text-green-900' else 'text-blue-800'"/>
        <xsl:variable name="links" select="$fields[@class='links']/ul[normalize-space(li[@class='text']) != '' and (normalize-space(li[@class='url']) != '' or normalize-space(li[@class='url']/a/@href) != '')]"/>

        <!-- Empty linked cards cannot supply an accessible name or destination. -->
        <xsl:if test="not($linked) or ($title != '' and $url != '')">
            <xsl:element name="{if ($linked) then 'a' else 'div'}">
                <xsl:attribute name="class" select="string-join(('card ltcc-card h-100 overflow-hidden', $background, if ($linked) then 'ltcc-card-link border-0 text-decoration-none' else if ($style='white') then 'border' else 'border-0', if ($image != '') then 'ltcc-card--has-image' else ()), ' ')"/>
                <xsl:if test="$linked"><xsl:attribute name="href" select="$url"/></xsl:if>
                <xsl:if test="$image != ''">
                    <img class="card-img-top ltcc-card__image" src="{$image}" alt="" loading="lazy" decoding="async"/>
                </xsl:if>
                <div class="card-body d-flex flex-column {if ($linked and $image != '') then 'align-items-center text-center' else 'align-items-start'} gap-3 p-{$padding}">
                    <xsl:if test="not($linked) and $icon != ''">
                        <span class="ltcc-card__icon {$size} mb-0 {$icon-color} fa-sharp fa-regular {$icon}" aria-hidden="true"><xsl:text> </xsl:text></span>
                    </xsl:if>
                    <xsl:if test="$title != ''"><h2 class="card-title {$size} fw-bold mb-0"><xsl:value-of select="$title"/></h2></xsl:if>
                    <xsl:if test="normalize-space($fields[@class='description']) != '' or $fields[@class='description']/*">
                        <div class="ltcc-card__description fs-7">
                            <xsl:choose>
                                <xsl:when test="$linked"><xsl:value-of select="normalize-space($fields[@class='description'])"/></xsl:when>
                                <xsl:otherwise><xsl:apply-templates select="$fields[@class='description']/node()"/></xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </xsl:if>
                    <xsl:if test="$linked">
                        <span class="ltcc-card-link__arrow rounded-circle d-inline-flex align-items-center justify-content-center flex-shrink-0" aria-hidden="true"><span class="fa-sharp fa-regular fa-arrow-up-right"><xsl:text> </xsl:text></span></span>
                    </xsl:if>
                    <xsl:if test="not($linked) and exists($links)">
                        <ul class="list-unstyled d-flex flex-row flex-wrap align-items-center gap-3 mt-auto mb-0">
                            <xsl:for-each select="$links">
                                <xsl:variable name="link-style" select="normalize-space(li[@class='style'])"/>
                                <xsl:variable name="href" select="normalize-space(if (li[@class='url']/a) then li[@class='url']/a[1]/@href else li[@class='url'])"/>
                                <li><a href="{$href}" class="{if ($link-style = ('primary','secondary')) then concat('btn btn-', $link-style) else concat('arrow-link arrow-link-', if ($dark) then 'light' else 'dark')}"><xsl:value-of select="normalize-space(li[@class='text'])"/></a></li>
                            </xsl:for-each>
                        </ul>
                    </xsl:if>
                </div>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
