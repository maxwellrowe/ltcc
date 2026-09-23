<?xml version="1.0" encoding="utf-8"?>
<!--
OU GALLERIES

Transforms gallery asset XML into a dynamic gallery on the web page. 
Type of gallery is determined by page property.

Dependencies: 
- ou:pcfparams (See kitchensink functions.xsl)
- $domain  	<xsl:param name="domain" select="substring($ou:httproot,1,string-length($ou:httproot)-1)" /> 				

Contributors: cwilson
Last Updated: 1/2016
-->
<!DOCTYPE xsl:stylesheet SYSTEM "http://commons.omniupdate.com/dtd/standard.dtd">
<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="ou xsl xs fn ouc">

	<!-- custom provided gallery -->
	<xsl:template match="ouc:div[@label='gallery']/gallery">

		<!-- added for ticket #35603 -->

		<!-- 
Advanced Box Syntax:
fontsize=40px;
fontcolor=333333;
description-fontsize=40px;
description-fontcolor=fefefe
-->

		<!-- advanced field : 'fontsize' -->
		<xsl:variable name="font-size">
			<xsl:if test="contains(advanced/text(), 'fontsize')">
				<xsl:value-of select="ou:get-adv(advanced,'fontsize')"/>
			</xsl:if>
		</xsl:variable>
		<!-- advanced field : 'fontcolor' -->
		<xsl:variable name="font-color">
			<xsl:if test="contains(advanced/text(), 'fontcolor')">
				<xsl:value-of select="ou:get-adv(advanced,'fontcolor')"/>
			</xsl:if>
		</xsl:variable>

		<!-- advanced field : 'description-fontsize' -->
		<xsl:variable name="desc-font-size">
			<xsl:if test="contains(advanced/text(), 'description-fontsize')">
				<xsl:value-of select="ou:get-adv(advanced,'description-fontsize')"/>
			</xsl:if>
		</xsl:variable>		

		<!-- advanced field : 'description-fontcolor' -->
		<xsl:variable name="desc-font-color">
			<xsl:if test="contains(advanced/text(), 'description-fontcolor')">
				<xsl:value-of select="ou:get-adv(advanced,'description-fontcolor')"/>
			</xsl:if>
		</xsl:variable>		
		<!-- end #35603  -->

		<!-- Slideshow -->
		<div class="slideshow">
			<xsl:for-each select="images/image">
				<div class="slide">
					<figure>
						<img src="{@url}" alt="{title}" />
						<xsl:if test="normalize-space(caption) != ''">
							<figcaption>
								<span class="caption-title" style="font-size:{$font-size}; color:#{$font-color};"><xsl:value-of select="title" /></span>
								<p style="font-size:{$desc-font-size}; color:#{$desc-font-color};">
									<xsl:value-of select="description" />									
									<xsl:choose>
										<xsl:when test="link != ''"> 
											<!-- Not empty, create a link -->
											<a href="{link}">
												<xsl:value-of select="caption" />
											</a>
										</xsl:when>
										<xsl:otherwise>	
										</xsl:otherwise>
									</xsl:choose>
								</p>
							</figcaption>
						</xsl:if>
					</figure>
				</div>				
			</xsl:for-each>
			<div class="controls">
				<a href="#pause-play" class="pause-play" title="Pause / Play slideshow"><i class="fa fa-play"/></a>
				<span class="current-slide">1</span> / <span class="slide-count"/>
			</div>
		</div> 
	</xsl:template>

	<!--	
The following template matches the LDP gallery nodes and outputs the proper HTML Code based on a specified parameter. 
This will work with existing apply-templates. 
-->
	<xsl:template match="gallery">
		<xsl:param name="gallery-type" select="/document/ouc:properties[@label='config']/parameter[@name='gallery-type']/option[@selected='true']/@value" />		
		<xsl:variable name="gallery-id" select="@asset_id"/>
		<xsl:choose>
			<!-- bx slider / removed conflicts with custom gallery -->
			<xsl:when test="$gallery-type = 'bx-slider'">
				<ul class="bx-slider" style="margin:0;padding:0;">
					<xsl:for-each select="images/image">
						<li>
							<img src="{@url}" title="{title}" alt="{description}" style="width:100%; height: auto;"/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<!-- flex slider -->
			<xsl:when test="$gallery-type = 'flex-slider'">
				<div class="flex-nav-container">
					<div class="flexslider">
						<ul class="slides"> 
							<xsl:for-each select="images/image">
								<li data-thumb="{@url}">
									<xsl:choose>
										<!-- Determine if caption field is empty -->
										<xsl:when test="link != ''"> 
											<!-- Not empty, create a link -->
											<a href="{link}">
												<img src="{@url}" alt="{title}" title="{title}" />
											</a>
										</xsl:when>
										<xsl:otherwise>	
											<img src="{@url}" alt="{title}" title="{title}" />                 
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="title != '' or description != ''">
										<!-- Only create a div caption for a div one that has a title or description -->
										<p class="flex-caption">
											<xsl:choose>
												<!-- Determine if caption field is empty -->
												<xsl:when test="link != ''"> 
													<!-- Not empty, create a link -->
													<a href="{link}">
														<xsl:value-of select="title" />
														<xsl:if test="description != ''">
															- <xsl:value-of select="description" />
														</xsl:if>
													</a>
												</xsl:when>
												<xsl:otherwise>	
													<!-- Just output caption, no link -->
													<xsl:value-of select="title" /> 
													<xsl:if test="description != ''">
														- <xsl:value-of select="description" />
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:comment> Do not allow div to self close </xsl:comment>
										</p>
									</xsl:if>							
								</li>
							</xsl:for-each>
						</ul>
					</div>
				</div>
			</xsl:when>
			<!-- magnific popup -->
			<xsl:when test="$gallery-type = 'magnific-popup'">
				<div class="grid-of-images">
					<div class="popup-gallery">
						<ul class="thumbnails">
							<xsl:for-each select="images/image">
								<li>
									<a class="thumbnail" href="{@url}" title="{title}">
										<img src="{thumbnail/@url}" width="{thumbnail/width}" height="{thumbnail/height}" alt="{title}"/></a>
								</li>
							</xsl:for-each>	
						</ul>
					</div>
				</div>
			</xsl:when>	
			<!-- pretty photo -->
			<xsl:when test="$gallery-type = 'pretty-photo'">
				<ul class="thumbnails">
					<xsl:for-each select="images/image">
						<li>
							<a href="{@url}" rel="prettyPhoto[{$gallery-id}]" title="{title}"  class="thumbnail">
								<img src="{thumbnail/@url}" alt="{title}" style="height:{thumbnail/height}px; width:{thumbnail/width}px;"/>
							</a>
						</li>
					</xsl:for-each>	
				</ul>
			</xsl:when>	
			<!-- fancy box -->
			<xsl:when test="$gallery-type = 'fancy-box'">	
				<ul class="thumbnails">
					<xsl:for-each select="images/image">
						<li>
							<a class="thumbnail fancybox-button" rel="group{$gallery-id}" title="{./description}" href="{@url}">
								<img src="{./thumbnail/@url}" alt="{./title}" />
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<!-- optionally, set a fallback output -->
			<xsl:otherwise>
				<xsl:comment>Undefined parameter for gallery match.</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!--

Gallery Headcode

To use, include in the appropriate area of the page (after jQuery is loaded).
You can conditionally call this function as such: 

<xsl:if test="content/descendant::gallery"> 
<xsl:copy-of select="ou:gallery-headcode($gallery-type)"/>
</xsl:if>	

-->
	<!-- optionally, remove  -->
	<xsl:function name="ou:gallery-footcode">
		<xsl:param name="gallery-type" />		
		<xsl:choose>		
			<!-- bx-slider -->
			<xsl:when test="$gallery-type = 'bx-slider'">
				<script src="https://www.ltcc.edu/_resources/galleries/bx-slider/jquery.bxslider.js"></script>
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/galleries/bx-slider/jquery.bxslider.css" type="text/css" />
				<script type="text/javascript">
					jQuery(document).ready(function(){
					jQuery('.bx-slider').bx-slider({
					mode: 'fade',
					captions: true
					});
					});	
				</script>
			</xsl:when>
			<!-- flex-slider -->
			<xsl:when test="$gallery-type = 'flex-slider'">
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/galleries/flex-slider/flexslider.css" type="text/css"/>
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/galleries/flex-slider/flex-caption.css" type="text/css"/>
				<script src="https://www.ltcc.edu/_resources/galleries/flex-slider/jquery.flexslider.js"></script>
				<script type="text/javascript">
					jQuery(document).ready(function() {
					jQuery('.flexslider').flexslider({
					animation: "slide"
					});
					});
				</script>		
			</xsl:when>	
			<!-- magnific-popup -->
			<xsl:when test="$gallery-type = 'magnific-popup'">
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/galleries/bootstrap-thumbnails.css"/> 
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/galleries/magnific-popup/magnific-popup.css"/> 
				<script src="https://www.ltcc.edu/_resources/galleries/magnific-popup/jquery.magnific-popup.js"></script> 	
				<script type="text/javascript">
					jQuery(document).ready(function() {
					jQuery('.popup-gallery').magnificPopup({
					delegate: 'a', // the selector for gallery item
					type: 'image',
					fixedContentPos: true, // for long pages in mobile, this will make sure lightbox is centered correctly
					gallery:{
					enabled:true,
					preload: [0,1] // Will preload 0 - before current, and 1 after the current image		
					}
					});
					});
				</script>
			</xsl:when>
			<!-- pretty-photo -->
			<xsl:when test="$gallery-type = 'pretty-photo'">			
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/galleries/bootstrap-thumbnails.css"/> 			
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/galleries/pretty-photo/prettyPhoto.css" type="text/css" media="screen" title="prettyPhoto main stylesheet" charset="utf-8" />
				<script src="https://www.ltcc.edu/_resources/galleries/pretty-photo/jquery.prettyPhoto.js" type="text/javascript" charset="utf-8"></script>
				<script type="text/javascript">
					jQuery(document).ready(function() {
					jQuery("a[rel^='prettyPhoto']").prettyPhoto();
					});
				</script>
			</xsl:when>
			<!-- fancy-box -->
			<xsl:when test="$gallery-type = 'fancy-box'">
				<link rel="stylesheet" property="stylesheet" href="https://www.ltcc.edu/_resources/galleries/bootstrap-thumbnails.css" media="screen" /> 
				<link rel="stylesheet" property="stylesheet" type="text/css" href="https://www.ltcc.edu/_resources/galleries/fancy-box/jquery.fancybox.css" media="screen" />
				<script type="text/javascript" src="https://www.ltcc.edu/_resources/galleries/fancy-box/jquery.fancybox.pack.js"></script>
				<script type="text/javascript">
					jQuery(document).ready(function() {
					jQuery(".fancybox-button").fancybox({
					prevEffect		: 'none',
					nextEffect		: 'none',
					closeBtn		: false,
					helpers		: {
					title	: { type : 'inside' },
					buttons	: {}
					}	
					});
					});
				</script>
			</xsl:when>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>	
