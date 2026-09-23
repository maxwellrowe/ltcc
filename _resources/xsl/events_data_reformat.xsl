<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>

<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ou="http://omniupdate.com/XSL/Variables"
    xmlns:fn="http://omniupdate.com/XSL/Functions"
    xmlns:ouc="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="ou xsl xs fn ouc">
			
<!-- 	<xsl:import href="common.xsl"/> -->
	
<xsl:output method="xml" version="1.0" include-content-type="yes" />

	<xsl:template match="/document">
	
		<xsl:copy-of select="doc('https://www.ltcc.edu/calendar/rss/wnl.php')/rss"/>		
	</xsl:template>
		
</xsl:stylesheet>
