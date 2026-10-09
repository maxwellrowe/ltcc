<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ou="http://omniupdate.com/XSL/Variables"
    xmlns:ouc="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="xsl ou ouc">

    <xsl:import href="../common.xsl"/>
    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" include-content-type="no" omit-xml-declaration="yes"/>

    <xsl:template match="/document">
        <xsl:choose>
            <xsl:when test="$ou:action = 'pub'">
                <xsl:call-template name="footer-display"/>
            </xsl:when>
            <xsl:otherwise>
                <html class="no-js" lang="en-us">
                    <head>
                        <meta charset="utf-8"/>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                        <title>Footer preview</title>
                        <xsl:copy-of select="ou:include-file('/_resources/includes/headcode.inc')"/>
                    </head>
                    <body>
                        <xsl:call-template name="footer-display"/>
                        <xsl:copy-of select="ou:include-file('/_resources/includes/footcode.inc')"/>
                    </body>
                </html>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="footer-display">
        <footer id="main-footer" class="site-footer">
            <xsl:apply-templates select="ouc:div[@label='footer-content']"/>
        </footer>
    </xsl:template>
</xsl:stylesheet>
