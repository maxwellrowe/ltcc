<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp   "&#160;">
<!ENTITY lsaquo   "&#8249;">
<!ENTITY rsaquo   "&#8250;">
<!ENTITY laquo  "&#171;">
<!ENTITY raquo  "&#187;">
<!ENTITY copy   "&#169;">
<!ENTITY apos   "&#39;">
<!ENTITY quot   "&#34;">
<!ENTITY mdash   "&#8212;">
<!ENTITY lsquo   "&#8216;">
<!ENTITY middot "&#183;">
]>
<!-- 
Implementations Skeletor v3 - 5/10/2014

Snippets

Contributors: cwilson
Last Updated: 1/2016
-->
<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:ou="http://omniupdate.com/XSL/Variables"
  xmlns:fn="http://omniupdate.com/XSL/Functions"
  xmlns:ouc="http://omniupdate.com/XSL/Variables"
  exclude-result-prefixes="xs ou fn ouc">
	
	<!-- Snippets and supporting templates (in file order)
		1. Google Map
		2. Video Iframe Ratios
		3. Gallery Slideshow
		4. Slider Banner
		5. Static Banner
		6. Green Calls to Action
		7. Two Columns (2:1)
		8. Faculty List
		9. Form Block
		10. Accordion
		11. Chevron List
		12. Homepage Icon Links
		13. Homepage Student Types
		14. Homepage Factoids
		15. Paragraph to Line Break Helper
		16. Homepage Hero Video
		17. Homepage Alert Banner
		18. LTCC Section
		19. LTCC Container
		20. LTCC Columns
	-->


	<!-- 1. Google Map -->
    <xsl:template match="table[@class='ou-ltcc-iframe']">
      <iframe class="google-map" src="{if (tbody/tr/td[1]/descendant::a) then tbody/tr/td[1]/descendant::a/@href else tbody/tr/td[1]}" width="100%" height="450" title="Lake Tahoe Community College location map" style="border:0" allowfullscreen=""></iframe>
    </xsl:template>

	<!-- 2. Video Iframe Ratios -->
	<xsl:template match="iframe">
        <!-- Apply 16:9 only to recognized video embeds; preserve other iframe dimensions.
             An existing Bootstrap ratio wrapper takes precedence over this default. -->
        <xsl:variable name="video-embed" select="matches(normalize-space(@src), '^(https?:)?//((www\.)?youtube(-nocookie)?\.com/embed/|player\.vimeo\.com/video/)', 'i')"/>
        <xsl:choose>
            <xsl:when test="$video-embed and not(parent::*[contains(concat(' ', normalize-space(@class), ' '), ' ratio ')])">
                <div class="ratio ratio-16x9">
                    <xsl:next-match/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>

	<!-- 3. Gallery Slideshow -->
	<xsl:template match="gallery[ancestor::table[@class='ou-slider-banner'] or ancestor::ouc:div[@label='gallery']]">
		<div class="slideshow">
			<xsl:for-each select="images/image">
				<xsl:variable name="slide">
					<xsl:if test="normalize-space(title)">
						<h2 class="title"><xsl:value-of select="title"/></h2>
					</xsl:if>
					<img src="{@url}" alt="{description}"/>
				</xsl:variable>
				
				<div class="slide">
					<figure>
						<xsl:choose>
							<xsl:when test="normalize-space(link)">
								<a href="{link}">
									<xsl:copy-of select="$slide"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="$slide"/>
							</xsl:otherwise>
						</xsl:choose>
					</figure>
				</div>
			</xsl:for-each>
			<div class="controls">
				<a href="#pause-play" class="pause-play" title="Pause / Play slideshow"><span class="fa fa-play"></span></a><span class="current-slide">1</span> / <span class="slide-count"></span>
			</div>
		</div>
	</xsl:template>
	

	<!-- 4. Slider Banner -->
	<xsl:template match="table[@class='ou-slider-banner']">
		<xsl:param name="gallery-asset" select="tbody/tr[1]/td[1]/descendant::gallery[1]"/>
		<xsl:apply-templates select="$gallery-asset" />
	</xsl:template>
	

	<!-- 5. Static Banner -->
	<xsl:template match="table[@class='ou-static-banner']">
		<xsl:param name="title" select="ou:textual-content(tbody/tr[1]/td[1])"/>
		<xsl:param name="img" select="tbody/tr[2]/td[1]/descendant::img[1]"/>
		
		<xsl:if test="$img">
			<div class="static-image">
				<xsl:if test="$title">
					<h2 class="title"><xsl:value-of select="$title"/></h2>
				</xsl:if>
				<img src="{$img/@src}" alt="{$img/@alt}" />
			</div>
		</xsl:if>
	</xsl:template>
		

	<!-- 6. Green Calls to Action -->
	<xsl:template match="table[@class='ou-cta-green']">
		<xsl:param name="button-1" select="tbody/tr[1]/td[1]/descendant::a[1]"/>
		<xsl:param name="button-2" select="tbody/tr[1]/td[1]/descendant::a[2]"/>
		<xsl:param name="button-3" select="tbody/tr[1]/td[1]/descendant::a[3]"/>
		<xsl:param name="buttons-td" select="tbody/tr[1]/td[descendant::a]"/>
		
		<xsl:if test="$buttons-td">
			<div class="row">
				<xsl:for-each select="$buttons-td[position() lt 4]"> <!-- Only grab the first 3 cells -->
					<xsl:variable name="a" select="descendant::a[1]"/>
					<div class="col-12 col-md-4">
						<a href="{$a/@href}" class="btn btn-primary w-100"><xsl:value-of select="$a"/></a>
					</div>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	

	<!-- 7. Two Columns (2:1) -->
	<xsl:template match="table[@class='ou-two-columns-2-1']">
		<xsl:param name="column-1" select="tbody/tr[1]/td[1]/node()"/>
		<xsl:param name="column-2" select="tbody/tr[1]/td[2]/node()"/>
		
		<div class="row">
			<div class="col-12 col-md-8">
				<xsl:apply-templates select="$column-1"/>
			</div>
			<div class="col-12 col-md-4">
				<xsl:apply-templates select="$column-2"/>
			</div>
		</div>
	</xsl:template>

	<!-- 8. Faculty List -->
	<xsl:template match="table[@class='ou-faculty-list']">
		<xsl:param name="heading-top" select="ou:textual-content(tbody/tr[1]/td[1])"/>
		<xsl:param name="heading-bottom" select="ou:textual-content(tbody/tr[2]/td[1])"/>
		<xsl:param name="valid-tr" select="tbody/tr[position() gt 3][td[1]/descendant::img and ou:textual-content(td[2]) != '']"/>
		
		<xsl:if test="$valid-tr">
            <div class="row">
				<div class="col-12">
					<div class="faculty-contact-title">
						<xsl:if test="normalize-space($heading-top)">
							<div class="top-line"><xsl:value-of select="$heading-top"/></div>
						</xsl:if>
						<xsl:if test="normalize-space($heading-bottom)">
							<div class="bottom-line"><xsl:value-of select="$heading-bottom"/></div>
						</xsl:if>
					</div>
					<ul class="faculty-contact">
						<xsl:for-each select="$valid-tr">
							<xsl:variable name="img" select="td[1]/descendant::img[1]"/>
							<xsl:variable name="name" select="ou:textual-content(td[2])"/>
							<xsl:variable name="title" select="ou:textual-content(td[3])"/>
							<xsl:variable name="email" select="ou:textual-content(td[4])"/>
							<xsl:variable name="website-a" select="td[5]/descendant::a[1]"/>
							
							<li class="faculty">
								<xsl:apply-templates select="$img"/>
								<div class="name"><xsl:value-of select="$name"/></div>
								<xsl:if test="$title != ''">
									<div class="title"><xsl:value-of select="$title"/></div>
								</xsl:if>
								<xsl:if test="$email != ''">
									<a href="mailto:{$email}" class="email"><span class="fa fa-envelope"/><span class="visually-hidden">email</span></a>
								</xsl:if>
								<xsl:if test="$website-a">
									<a href="{$website-a/@href}" class="website"><span class="fa fa-info"/><span class="visually-hidden">website</span></a>
								</xsl:if>
							</li>
						</xsl:for-each>
					</ul>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	

	<!-- 9. Form Block -->
	<xsl:template match="table[@class='ou-form-block']">
		<xsl:param name="content" select="tbody/tr[2]/td[1]/node()"/>
		<xsl:param name="ouform" select="tbody/tr[4]/td[1]/ouform[1]"/>
		
		<div class="form-block">
			<xsl:apply-templates select="$content"/>
			<xsl:apply-templates select="$ouform"/>
		</div>
		
	</xsl:template>
	

	<!-- 10. Accordion -->
    <xsl:template match="table[@class='ou_accordion_2']">
        <!-- Keep a valid author-supplied ID; use a unique fallback for blank/invalid IDs. -->
        <xsl:variable name="requested-id" select="normalize-space(string(tbody/tr[1]/td[2]))"/>
        <xsl:variable name="accordion_id" select="if (matches($requested-id, '^[A-Za-z_][A-Za-z0-9_-]*$') and not(preceding::table[@class='ou_accordion_2'][normalize-space(string(tbody/tr[1]/td[2])) = $requested-id])) then $requested-id else concat('accordion-', generate-id())"/>
        <div class="accordion" id="{$accordion_id}">
            <xsl:for-each select="tbody/tr[position() gt 1]">
                <xsl:variable name="heading_id" select="concat($accordion_id, '-heading-', generate-id())"/>
                <xsl:variable name="collapse_id" select="concat($accordion_id, '-collapse-', generate-id())"/>
                <div class="accordion-item">
                    <h3 class="accordion-header" id="{$heading_id}">
                        <button class="accordion-button collapsed" type="button"
                            data-bs-toggle="collapse" data-bs-target="#{$collapse_id}"
                            aria-expanded="false" aria-controls="{$collapse_id}">
                            <xsl:value-of select="ou:textual-content(td[1])"/>
                        </button>
                    </h3>
                    <div id="{$collapse_id}" class="accordion-collapse collapse"
                        aria-labelledby="{$heading_id}" data-bs-parent="#{$accordion_id}">
                        <div class="accordion-body">
                            <xsl:apply-templates select="td[2]/node()"/>
                        </div>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    

	<!-- 11. Chevron List -->
	<xsl:template match="table[@class='ou-chevron-list']">
		<ul class="chevron-list">
		<xsl:apply-templates select="tbody/tr/td/ul/li" />
		</ul>
	</xsl:template>
	

	<!-- 12. Homepage Icon Links -->
	<xsl:template match="table[@class='ou-homepage-icon-links']">
		<div class="col-12">
			<ul class="icon-set">
				<xsl:for-each select="tbody/tr">
					<li><a href="{td[@data-name='link']/a/@href}"><div class="icon"><img src="{td[@data-name='image']/img/@src}" alt="{td[@data-name='alt-text']/node()}" /></div><div class="icon-text"><xsl:value-of select="td[@data-name='title']" /></div></a></li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	

	<!-- 13. Homepage Student Types -->
	<xsl:template match="table[@class='ou-homepage-student-types']">
		<div class="student-type-slider custom-slider-arrows">
			<xsl:for-each select="tbody/tr">
				<div class="slide">
					<a href="{td[@data-name='link']/a/@href}">
						<div class="thumbnail"><img class="" src="{td[@data-name='image']/img/@src}" alt="{td[@data-name='alt-text']/node()}" /></div>
						<div class="rollover-wrapper">
							<h3><xsl:value-of select="td[@data-name='student-type']" /></h3>
							<p><xsl:value-of select="td[@data-name='caption']" /></p>
						</div>
					</a>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>
	

	<!-- 14. Homepage Factoids -->
	<xsl:template match="table[@class='ou-homepage-factoids']">
		<div class="row">
		<xsl:for-each select="tbody/tr">
			<div class="col-12 col-md-4">
                    <div class="factoids">
                    <div class="large-content"><xsl:value-of select="td[@data-name='statistic']" /></div>
                    <p><xsl:value-of select="td[@data-name='description']" /></p>
                    </div>
                </div>	
		</xsl:for-each>
		</div>
	</xsl:template>
	

	<!-- 15. Paragraph to Line Break Helper -->
	<xsl:template match="p" mode="p-to-br">
		<xsl:value-of select="node()" /><xsl:if test="position() != last()"><br/></xsl:if>
	</xsl:template>
	

	<!-- 16. Homepage Hero Video -->
	<xsl:template match="table[@class='ou-homepage-hero-video']">
		<xsl:param name="row1" select="tbody/tr[1]" />
		<xsl:param name="caption" select="ou:textual-content($row1/td[@data-name='caption'])"/>
		<xsl:param name="buttontext" select="ou:textual-content($row1/td[@data-name='button-text'])"/>
		<div class="video-feature" style="background-image:url('{$row1/td[@data-name='background-image']/img/@src}');">
			<div class="video-caption-overlay">
				<div class="video-caption">
					<div class="container">
						<div class="row">
							<div class="col">
								<!--<h2 tabindex="0"><xsl:value-of select="$row1/td[@data-name='heading']" /></h2>-->
								<h2 tabindex="0"><xsl:apply-templates select="$row1/td[@data-name='heading']" mode="p-to-br" /></h2>
								<xsl:choose>
								  <xsl:when test="normalize-space($caption)">
									<!--<div class="description" tabindex="0"><xsl:value-of select="$row1/td[@data-name='caption']" /></div>-->
									<div class="description" tabindex="0"><xsl:apply-templates select="$row1/td[@data-name='caption']" mode="p-to-br" /></div>
								  </xsl:when>
								  <xsl:otherwise>
									<div class="description" tabindex="0" style="visibility:hidden"></div>
								  </xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
								  <xsl:when test="normalize-space($buttontext)">
									<a href="{$row1/td[@data-name='button-link']/a/@href}" class="btn btn-primary"><xsl:value-of select="$row1/td[@data-name='button-text']" /></a>
								  </xsl:when>
								  <xsl:otherwise>
									<a href="#" class="btn btn-primary" style="visibility:hidden"></a>
								  </xsl:otherwise>
								</xsl:choose>
							</div>
						</div>
					</div>
				</div>
			</div>
			<button type="button" class="play-pause" title="play/pause" aria-label="Play/Pause Video"><span class="fa fa-pause"></span><span class="visually-hidden">Pause Video</span></button>
			<div data-video="{$row1/td[@data-name='video-file']/video/source/@src}" data-type="video/mp4" data-image="{$row1/td[@data-name='background-image']/img/@src}">
				<video id="myVideo"  autoplay="" muted="" loop="" playsinline=""><source src="{$row1/td[@data-name='video-file']/video/source/@src}" type="video/mp4" /></video>
			</div>
		</div>	
	</xsl:template>	
	

	<!-- 17. Homepage Alert Banner -->
	<xsl:template match="table[@class='ou-homepage-alert-banner']">
		<xsl:param name="row1" select="tbody/tr[1]" />
		<div class="alert alert-dismissible fade show" role="alert">
			<div class="row">
				<div class="col-12">
					<p class="heading"><xsl:value-of select="$row1/td[@data-name='heading']" /></p>
					<p><xsl:value-of select="$row1/td[@data-name='subheading']" /></p>
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
				</div>
			</div>
		</div>
	</xsl:template>

	<!-- 18. LTCC Section -->
	<xsl:template match="table[@data-snippet='ltcc-section']">
		<xsl:variable name="custom-class" select="replace(lower-case(normalize-space(thead/tr/th[@class='custom-class'])),'&nbsp;','')" />
		<xsl:variable name="bg-shorthand" select="replace(lower-case(normalize-space(thead/tr/th[@class='background-shorthand'])),'&nbsp;','')" />
		
		<section class="{$custom-class} ltcc-section" style="background: {$bg-shorthand};">
			<xsl:apply-templates select="tbody/tr/td[@class='content']/node()" />
		</section>
	
	</xsl:template>

	<!-- 19. LTCC Container -->
	<xsl:template match="table[@data-snippet='ltcc-container']">
		<xsl:variable name="custom-class" select="replace(lower-case(normalize-space(thead/tr/th[@class='custom-class'])),'&nbsp;','')" />
		
		<div class="{$custom-class} ltcc-container container">
			<xsl:apply-templates select="tbody/tr/td[@class='content']/node()" />
		</div>
	
	</xsl:template>

	<!-- 20. LTCC Columns -->
	<xsl:template match="table[@data-snippet='ltcc-columns']">
		<xsl:variable name="custom-class" select="replace(lower-case(normalize-space(thead/tr/th[@class='custom-class'])),'&nbsp;','')" />
		
		<div class="{$custom-class} row">
			<xsl:for-each select="tbody/tr">
				<div class="{lower-case(replace(td[@class='class'],'&nbsp;',''))}">
					<xsl:apply-templates select="td[@class='content']/node()" />
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

</xsl:stylesheet>
