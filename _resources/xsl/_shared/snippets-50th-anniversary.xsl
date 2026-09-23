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
				exclude-result-prefixes="xs ou fn ouc"
				expand-text="yes">

	<!--Dev Start - 50th Anniversary Snippets-->

	<!--50th Anniversary Hero-->
	<xsl:template match="table[@class='ou-50th-hero']">
		<section class="hero-banner">
			<div class="container">
				<div class="hero-content" role="banner">
					<h1>
						<xsl:if test="tbody/tr[@data-name='image']/td/img/@src != ''">
							<span class="dot-icon dot-icon--c-adj"><img src="{tbody/tr[@data-name='image']/td/img/@src}" alt="{tbody/tr[@data-name='image']/td/img/@alt}" /></span>
						</xsl:if>
						<xsl:apply-templates select="tbody/tr[@data-name='heading']/td/node()"/>
					</h1>
				</div>
			</div>
		</section>
	</xsl:template>

	<!--Header Top Links-->
	<xsl:template match="table[@class='ou-50th-header-top-links']">
		<ul class="navbar-list">
			<xsl:for-each select="tbody/tr[@data-name='links']/td/ul/li">
				<li>
					<a class="navbar-link"><xsl:apply-templates select="./a/attribute()[name() != 'class']"/><xsl:attribute name="aria-label">{ou:textual-content(./a)}</xsl:attribute>{ou:textual-content(./a)}</a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<!--Header Button Links-->
	<xsl:template match="table[@class='ou-50th-header-button-links']" mode="desktop">
		<ul class="navbar-btn-wrap">
			<xsl:for-each select="tbody/tr[@data-name='links']/td/ul/li">
				<li>
					<a><xsl:apply-templates select="./a/attribute()"/><xsl:attribute name="aria-label">{ou:textual-content(./a)}</xsl:attribute>{ou:textual-content(./a)}</a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="table[@class='ou-50th-header-button-links']" mode="mobile">
		<ul class="mobile-btn-wrap">
			<xsl:for-each select="tbody/tr[@data-name='links']/td/ul/li">
				<li>
					<a><xsl:apply-templates select="./a/attribute()"/><xsl:attribute name="aria-label">{ou:textual-content(./a)}</xsl:attribute>{ou:textual-content(./a)}</a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<!--Footer Links-->
	<xsl:template match="table[@class='ou-50th-footer-links']">
		<div class="footer-col">
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='heading']/td) != ''">
				<h4 class="nav-title">{ou:textual-content(tbody/tr[@data-name='heading']/td)}</h4>
			</xsl:if>		
			<ul class="list-wrap">
				<xsl:for-each select="tbody/tr[@data-name='links']/td/ul/li">
					<li>
						<a><xsl:apply-templates select="./a/attribute()[name() != 'class']"/>{ou:textual-content(./a)}</a>
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>

	<!--Featured Section-->
	<xsl:template match="table[@class='ou-50th-featured-section']">
		<section class="spotlight-heading bg-img padd-adj" role="region">
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='aria-label']/td) != ''">
				<xsl:attribute name="aria-label">{ou:textual-content(tbody/tr[@data-name='aria-label']/td)}</xsl:attribute>
			</xsl:if>
			<div class="container">
				<xsl:if test="ou:textual-content(tbody/tr[@data-name='subtitle']/td) != ''">
					<span class="sub-title yellow-color">{ou:textual-content(tbody/tr[@data-name='subtitle']/td)}</span>
				</xsl:if>
				<xsl:if test="ou:not-empty(tbody/tr[@data-name='heading']/td)">
					<h2 class="title"><span class="dot-icon"><img src="/_resources/images/50th-anniversary/circleelement.png" alt=""/></span><xsl:apply-templates select="tbody/tr[@data-name='heading']/td/node()"/></h2>
				</xsl:if>
				<xsl:apply-templates select="tbody/tr[@data-name='content']/td/node()"/>
			</div>
		</section>
	</xsl:template>

	<!--Introduction Section-->
	<xsl:template match="table[@class='ou-50th-introduction-section']">
		<section class="fifty-faces spotlight-heading bg-black" role="region">
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='aria-label']/td) != ''">
				<xsl:attribute name="aria-label">{ou:textual-content(tbody/tr[@data-name='aria-label']/td)}</xsl:attribute>
			</xsl:if>
			<div class="container">
				<xsl:if test="ou:not-empty(tbody/tr[@data-name='heading']/td)">
					<h2 class="title yellow-color mb40"><span class="dot-icon"><img src="/_resources/images/50th-anniversary/circleelement.png" alt=""/></span><xsl:apply-templates select="tbody/tr[@data-name='heading']/td/node()"/></h2>
				</xsl:if>
				<xsl:apply-templates select="tbody/tr[@data-name='content']/td/node()"/>
			</div>
		</section>
	</xsl:template>

	<!--Form and Gallery Container-->
	<xsl:template match="table[@class='ou-50th-form-gallery']">
		<section class="form-information bg-img" role="region">
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='aria-label']/td) != ''">
				<xsl:attribute name="aria-label">{ou:textual-content(tbody/tr[@data-name='aria-label']/td)}</xsl:attribute>
			</xsl:if>
			
			
			<div class="container">
				<div class="form-info-wrap">
					<xsl:apply-templates select="tbody/tr[@data-name='content']/td[@data-name='content-1']/node()"/>
					
					<!--
					<div class="form-wrapper left-adjust">
						<h2 class="form-title">Nominate an Influential Individual</h2>
						<div class="error icon-error pl-5">There was a problem with your submission. Please review the fields below.
						</div>
						<h3 class="form-sub-title yellow-color">Your Information</h3>
						<form action="/">
							<div>
								<label for="fname">First Name<span class="asterisk">*</span></label>
								<input type="text" id="fname" name="fname" aria-label="First Name"/>
								<div class="error">This field is required.</div>
							</div>
							<div>
								<label for="lname">Last Name<span class="asterisk">*</span></label><br/>
								<input type="text" id="lname" name="lname" aria-label="Last Name"/>
								<div class="error">This field is required.</div>
							</div>
							<div>
								<label for="relationship-to-ltcc">Relationship to LTCC</label>
								<input type="text" id="relationship-to-ltcc" name="relationship-to-ltcc" aria-label="Relationship to LTCC"/>
							</div>
							<div>
								<label for="email">Email<span class="asterisk">*</span></label>
								<input type="email" id="email" name="email" aria-label="Email"/>
								<div class="error">This field is required.</div>
							</div>
							<div>
								<label for="phone">Phone Number</label>
								<input type="tel" id="phone" name="phone" aria-label="Phone Number"/>
							</div>
							<button type="submit" class="btn btn-primary bg-hover btn-h" aria-label="Next">Next</button>
						</form>
					</div>
					-->
					<xsl:apply-templates select="tbody/tr[@data-name='content']/td[@data-name='content-2']/node()"/>
				</div>
			</div>
		</section>
	</xsl:template>
	
	<!--Gallery Snippet-->
	<xsl:template match="table[@class='ou-50th-gallery']">
		<div role="region">
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="(count(tbody/tr[@data-name='row']) = 1) and (count(tbody/tr[@data-name='row']/td[1]/img) = 1)">gallery-wrapper full</xsl:when>
					<xsl:otherwise>gallery-wrapper</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='aria-label']/td) != ''">
				<xsl:attribute name="aria-label">{ou:textual-content(tbody/tr[@data-name='aria-label']/td)}</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="tbody/tr[@data-name='row']">
				<div class="img-main">
					<xsl:for-each select="td[@data-name='images']/img">
						<div class="image-wrap">
							<img src="{ou:textual-content(./@src)}" alt="{ou:textual-content(./@alt)}"/>
						</div>
					</xsl:for-each>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<!--Info Section-->
	<xsl:template match="table[@class='ou-50th-info-section']">
		<section class="spotlight-heading bg-black" role="region">
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='aria-label']/td) != ''">
				<xsl:attribute name="aria-label">{ou:textual-content(tbody/tr[@data-name='aria-label']/td)}</xsl:attribute>
			</xsl:if>
			<div class="container">
				<xsl:if test="ou:not-empty(tbody/tr[@data-name='heading']/td)">
					<h2 class="title yellow-color lg mb40"><span class="dot-icon"><img src="/_resources/images/50th-anniversary/circleelement.png" alt=""/></span><xsl:apply-templates select="tbody/tr[@data-name='heading']/td/node()"/></h2>
				</xsl:if>
				<xsl:apply-templates select="tbody/tr[@data-name='content']/td/node()"/>
			</div>
		</section>
	</xsl:template>
	
	<!--Spotlight Section-->
	<xsl:template match="table[@class='ou-50th-spotlight-section']">
		<section class="spotlight-heading bg-black" role="region">
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='aria-label']/td) != ''">
				<xsl:attribute name="aria-label">{ou:textual-content(tbody/tr[@data-name='aria-label']/td)}</xsl:attribute>
			</xsl:if>
			<div class="container">
				<xsl:if test="ou:not-empty(tbody/tr[@data-name='heading']/td)">
					<h2 class="title yellow-color lg"><span class="dot-icon"><img src="/_resources/images/50th-anniversary/circleelement.png" alt=""/></span><xsl:apply-templates select="tbody/tr[@data-name='heading']/td/node()"/></h2>
				</xsl:if>
				<xsl:apply-templates select="tbody/tr[@data-name='content']/td/node()"/>
			</div>
		</section>
	</xsl:template>
	
	<!--Form Section-->
	<xsl:template match="table[@class='ou-50th-form-section']">
		<section class="form-information bg-img" role="region">
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='aria-label']/td) != ''">
				<xsl:attribute name="aria-label">{ou:textual-content(tbody/tr[@data-name='aria-label']/td)}</xsl:attribute>
			</xsl:if>
			<div class="container">
				<div class="form-info-wrap">
					<xsl:apply-templates select="tbody/tr[@data-name='form-wrapper']/td/node()"/>
					<!--
					<div class="form-wrapper">
						<div class="error icon-error pl-5">There was a problem with your submission. Please review the fields below.
						</div>
						<h3 class="form-sub-title yellow-color">Your Information</h3>
					
						<form action="/">
							<div>
								<label for="fullname_2">Name<span class="asterisk">*</span></label>
								<input type="text" id="fullname_2" name="fullname_2" aria-label="Name 2"/>
								<div class="error">This field is required.</div>
							</div>
							<div>
								<label for="email_2">Email<span class="asterisk">*</span></label>
								<input type="email" id="email_2" name="email_2" aria-label="Email 2"/>
								<div class="error">This field is required.</div>
							</div>
							<div>
								<label for="phone_2">Phone Number</label>
								<input type="tel" id="phone_2" name="phone_2" aria-label="Phone Number 2"/>
							</div>
							<div>
								<label for="relationship-to-ltcc_2">Relationship to LTCC</label>
								<input type="text" id="relationship-to-ltcc_2" name="relationship-to-ltcc_2" aria-label="Relationship to LTCC 2"/>
							</div>
							<button type="submit" class="btn btn-primary bg-hover btn-h" aria-label="Submit">Submit</button>
						</form>
						
					</div>
					-->
				</div>
			</div>
		</section>
	</xsl:template>
	
	<!--Form-->
	<xsl:template match="table[@class='ou-50th-form']">
		<div>
			<xsl:attribute name="class">{ou:textual-content(tbody/tr[@data-name='form-class']/td)}</xsl:attribute>
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='title']/td) != ''">
				<h2 class="form-title">{ou:textual-content(tbody/tr[@data-name='title']/td)}</h2>
			</xsl:if>
			<div class="error icon-error pl-5">There was a problem with your submission. Please review the fields below.</div>
			<xsl:if test="ou:textual-content(tbody/tr[@data-name='subtitle']/td) != ''">
				<h3 class="form-sub-title yellow-color">{ou:textual-content(tbody/tr[@data-name='subtitle']/td)}</h3>
			</xsl:if>
			<xsl:apply-templates select="tbody/tr[@data-name='form-asset']/td/node()"/>
			<!--
			<form action="/">
				<div>
					<label for="fullname_2">Name<span class="asterisk">*</span></label>
					<input type="text" id="fullname_2" name="fullname_2" aria-label="Name 2"/>
					<div class="error">This field is required.</div>
				</div>
				<div>
					<label for="email_2">Email<span class="asterisk">*</span></label>
					<input type="email" id="email_2" name="email_2" aria-label="Email 2"/>
					<div class="error">This field is required.</div>
				</div>
				<div>
					<label for="phone_2">Phone Number</label>
					<input type="tel" id="phone_2" name="phone_2" aria-label="Phone Number 2"/>
				</div>
				<div>
					<label for="relationship-to-ltcc_2">Relationship to LTCC</label>
					<input type="text" id="relationship-to-ltcc_2" name="relationship-to-ltcc_2" aria-label="Relationship to LTCC 2"/>
				</div>
				<button type="submit" class="btn btn-primary bg-hover btn-h" aria-label="Submit">Submit</button>
			</form>
			-->
		</div>
	</xsl:template>

</xsl:stylesheet>
