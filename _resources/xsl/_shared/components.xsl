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
	
	<xsl:template match="div[@data-ouc-test='']"></xsl:template>

	<!-- A match for the "data-ouc-not" attribute on elements inside an ouc component. This is for removing the attribute from the final output when elements pass the not test. -->
	<xsl:template match="@data-ouc-not" mode="ouc-component"/>

	<!-- A match for elements inside ouc components that have non-empty "data-ouc-not" attributes. This is for removing elements that fail the not test from the final output. -->
	<xsl:template match="element()[normalize-space(@data-ouc-not) != '']" mode="ouc-component"/>

	<!-- A match for elements inside ouc components that have "data-ouc-justedit" attributes. This attribute is used to show elements only inside JustEdit, so we remove all elements that have this attribute. -->
	<xsl:template match="element()[@data-ouc-justedit]" mode="ouc-component"/>
	
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

</xsl:stylesheet>