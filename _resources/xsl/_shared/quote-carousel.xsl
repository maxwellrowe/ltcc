<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ouc">
  <xsl:template match="ouc:component[@name='component-quote-carousel']" mode="#all">
    <xsl:variable name="style" select="normalize-space(ul/li[@class='style'])"/>
    <xsl:variable name="background" select="if ($style='gradient') then 'bg-gradient-green-blue' else if ($style=('blue-100','green-100','white')) then concat('bg-', $style) else 'bg-blue-100'"/>
    <xsl:variable name="quotes" select="ul/li[@class='quotes']/ul[normalize-space(li[@class='quote']) != '']"/>
    <xsl:if test="exists($quotes)">
      <section class="quote-carousel ltcc-quote-carousel rounded p-4 p-lg-5 {$background}" data-quote-carousel="" aria-label="Quotes">
        <div class="swiper">
          <div class="swiper-wrapper">
            <xsl:for-each select="$quotes">
              <xsl:variable name="image" select="normalize-space(if (li[@class='image']/img) then li[@class='image']/img[1]/@src else if (li[@class='image']/a) then li[@class='image']/a[1]/@href else li[@class='image'])"/>
              <div class="swiper-slide">
                <div class="row align-items-center g-4 g-lg-5">
                  <figure class="mb-0 {if ($image != '') then 'col-12 col-lg-8' else 'col-12'}">
                    <blockquote class="ltcc-quote-carousel__quote mb-4"><p class="mb-0"><xsl:value-of select="normalize-space(li[@class='quote'])"/></p></blockquote>
                    <xsl:if test="normalize-space(li[@class='name']) != '' or normalize-space(li[@class='title']) != ''">
                      <figcaption>
                        <xsl:if test="normalize-space(li[@class='name']) != ''"><strong class="d-block"><xsl:value-of select="normalize-space(li[@class='name'])"/></strong></xsl:if>
                        <xsl:if test="normalize-space(li[@class='title']) != ''"><span class="fs-7"><xsl:value-of select="normalize-space(li[@class='title'])"/></span></xsl:if>
                      </figcaption>
                    </xsl:if>
                  </figure>
                  <xsl:if test="$image != ''"><div class="col-12 col-lg-4"><img src="{$image}" alt="" class="ltcc-quote-carousel__photo rounded w-100" loading="lazy" decoding="async"/></div></xsl:if>
                </div>
              </div>
            </xsl:for-each>
          </div>
        </div>
        <xsl:if test="count($quotes) gt 1">
          <div class="ltcc-quote-carousel__controls mt-4 text-end" hidden="hidden">
            <div class="media-controls align-items-center rounded-pill p-1" role="group" aria-label="Quote controls">
              <button type="button" class="btn media-playback-toggle rounded-circle" data-quote-prev="" aria-label="Previous quote"><span class="fa-sharp fa-regular fa-arrow-left" aria-hidden="true"><xsl:text> </xsl:text></span></button>
              <button type="button" class="btn media-playback-toggle rounded-circle" data-quote-next="" aria-label="Next quote"><span class="fa-sharp fa-regular fa-arrow-right" aria-hidden="true"><xsl:text> </xsl:text></span></button>
              <button type="button" class="btn media-playback-toggle rounded-circle" data-quote-pause="" aria-label="Pause slideshow" aria-pressed="false"><span class="fa-sharp fa-regular fa-circle-pause" aria-hidden="true"><xsl:text> </xsl:text></span></button>
            </div>
          </div>
        </xsl:if>
      </section>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
