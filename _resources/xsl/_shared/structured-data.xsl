<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs">

    <xsl:template name="webpage-structured-data">
        <xsl:param name="name" as="xs:string"/>
        <xsl:param name="url" as="xs:string"/>
        <xsl:param name="modified" as="xs:dateTime"/>
        <xsl:variable name="json" select="serialize(map {
            '@context': 'https://schema.org',
            '@type': 'WebPage',
            'name': $name,
            'url': $url,
            'dateModified': format-dateTime($modified, '[Y0001]-[M01]-[D01]')
        }, map { 'method': 'json' })"/>
        <!-- JSON escaping handles quotes and backslashes; escaping less-than also
             prevents a title from closing the script or opening a PHP tag. -->
        <script type="application/ld+json"><xsl:value-of select="replace($json, '&lt;', '\\u003c')"/></script>
    </xsl:template>
</xsl:stylesheet>
