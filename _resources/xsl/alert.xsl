<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ou="http://omniupdate.com/XSL/Variables"
    xmlns:ouc="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="ou ouc">
    <!-- Reuse the same CMS/component imports as site pages, but publish only content. -->
    <xsl:import href="common.xsl"/>

    <xsl:template match="/document">
        <xsl:choose>
            <xsl:when test="$ou:action = 'pub'">
                <xsl:call-template name="common-alert"/>
            </xsl:when>
            <xsl:otherwise>
                <html lang="en">
                    <head>
                        <meta charset="utf-8"/>
                        <meta name="viewport" content="width=device-width, initial-scale=1"/>
                        <title>Global Alert Preview</title>
                        <xsl:copy-of select="ou:include-file('/_resources/includes/headcode.inc')"/>
                    </head>
                    <body>
                        <xsl:call-template name="common-alert"/>
                        <xsl:copy-of select="ou:include-file('/_resources/includes/footcode.inc')"/>
                    </body>
                </html>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="publish-output"><xsl:call-template name="common-alert"/></xsl:template>
    <xsl:template name="common-alert">
        <xsl:apply-templates select="ouc:div[@label='main-content']"/>
    </xsl:template>
</xsl:stylesheet>
