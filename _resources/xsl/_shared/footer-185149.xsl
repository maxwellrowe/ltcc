<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"	
				xmlns:dyn="http://exslt.org/dynamic"
				exclude-result-prefixes="ou xsl xs fn ouc"
				extension-element-prefixes="dyn">

	<xsl:import href="template-matches.xsl"/>
	<xsl:import href="ouvariables.xsl"/>
	<xsl:import href="functions.xsl"/>

	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" include-content-type="no" omit-xml-declaration="yes"/>

	<xsl:template match="/document">
		<xsl:choose>
			<xsl:when test="$ou:action = 'pub'">
				<xsl:call-template name="footer-display"/>
			</xsl:when>
			<xsl:when test="$ou:action = 'prv'">                
				<html class="no-js" lang="en-us">
					<head>
						<!-- headcode include -->
						<!-- <xsl:copy-of select="ou:include-file('/_resources/includes/headcode.inc')"/> -->
						<link rel="stylesheet" href="https://www.ltcc.edu/_resources/css/bootstrap_iso.css" />
						<link href="https://www.ltcc.edu/_resources/css/academic-landing-styles-ou-edits.css" rel="stylesheet" />
						<meta charset="utf-8" />
						<meta name="viewport" content="width=device-width, initial-scale=1.0" />
						<link href="https://www.ltcc.edu/_resources/css/main2022.css" rel="stylesheet" />
						<link href="https://www.ltcc.edu/_resources/css/custom2022.css" rel="stylesheet" />
					</head>
					<body>
						<div id="galaxy">
							<xsl:call-template name="footer-display"/>
						</div>
						<!-- footcode include -->
						<!-- <xsl:copy-of select="ou:include-file('/_resources/includes/footcode.inc')"/> --> 			
					</body>
				</html>
			</xsl:when>
			<xsl:otherwise>
				<h1>Please use Multiedit to make changes.</h1>
				<ouc:div>
					<xsl:copy-of select="ouc:div[@label='maincontent']/attribute()"/>
					<xsl:copy-of select="ouc:div[@label='maincontent']/ouc:editor"/>
				</ouc:div>
				<xsl:apply-templates select="ouc:div[@label='maincontent']" mode="copy"/>
			</xsl:otherwise>           
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="footer-display">
		<footer id="main-footer">
			<div class="row">
				<div class="columns small-12 large-3">
					<h2><xsl:value-of select="ouc:div[@label='sec-1-heading']" /></h2>
					<xsl:copy-of select="ouc:div[@label='sec-1-col-1']" />
				</div>
				<div class="columns small-12 large-6">
					<h2><xsl:value-of select="ouc:div[@label='sec-2-heading']" /></h2>
					<div class="row">
						<div class="columns small-12 medium-6">
							<ul class="list-style-none">
								<xsl:for-each select="ouc:div[@label='sec-2-col-1']/descendant::ul/li">                                                  
									<xsl:copy-of select="." />                                                  
								</xsl:for-each>
							</ul>	
						</div>
						<div class="columns small-12 medium-6">
							<ul class="list-style-none">
								<xsl:for-each select="ouc:div[@label='sec-2-col-2']/descendant::ul/li">                                                  
									<xsl:copy-of select="." />                                                  
								</xsl:for-each>
							</ul>
						</div>
					</div>
				</div>
				<div class="columns small-12 large-3">
					<h2><xsl:value-of select="ouc:div[@label='sec-3-heading']" /></h2>
					<div class="social-links">
						<a href="{ouc:div[@label='link-facebook']}" title="Find us on Facebook" class="facebook" target="_blank">
							<span class="fa-stack fa-lg">
								<span class="fa fa-square fa-stack-2x"><xsl:value-of select="' '"/></span>
								<span class="fa fa-facebook fa-stack-1x fa-inverse"><xsl:value-of select="' '"/></span>
							</span>
						</a>
						<a href="{ouc:div[@label='link-youtube']}" title="Subscribe to our Youtube Channel" class="youtube" target="_blank">
							<span class="fa-stack fa-lg">
								<span class="fa fa-square fa-stack-2x"><xsl:value-of select="' '"/></span>
								<span class="fa fa-youtube-play fa-stack-1x fa-inverse"><xsl:value-of select="' '"/></span>
							</span>
						</a>
						<a href="{ouc:div[@label='link-instagram']}" title="Find us on Instagram" class="instagram" target="_blank">
							<span class="fa-stack fa-lg">
								<span class="fa fa-square fa-stack-2x"><xsl:value-of select="' '"/></span>
								<span class="fa fa-instagram fa-stack-1x fa-inverse"><xsl:value-of select="' '"/></span>
							</span>
						</a>
						<a href="{ouc:div[@label='link-twitter']}" title="Follow us on Twitter" class="twitter" target="_blank">
							<span class="fa-stack fa-lg">
								<img src="https://www.ltcc.edu/_resources/img/x_twitter_logo.svg" alt="Twitter Logo" style="max-height:100%"/>
							</span>
						</a>
					</div>
					<ul class="list-style-none secondary">
						<xsl:for-each select="ouc:div[@label='sec-3-col-1']/descendant::ul/li">                                                  
							<xsl:copy-of select="." />                                                  
						</xsl:for-each>
						<li><span id="directedit">©</span> Lake Tahoe Community College</li>
					</ul>
				</div>
			</div>
		</footer>
	</xsl:template>


</xsl:stylesheet>
