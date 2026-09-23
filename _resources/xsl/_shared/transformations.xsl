<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp   "&#160;">
<!ENTITY lsaquo   "&#8249;">
<!ENTITY rsaquo   "&#8250;">
<!ENTITY laquo  "&#171;">
<!ENTITY raquo  "&#187;">
<!ENTITY copy   "&#169;">
<!ENTITY rsquo   "&#8217;">
]>
<!-- 
TABLE TRANSFORMATIONS
-->

<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:xs="http://www.w3.org/2001/XMLSchema" 
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions" 
				xmlns:ouc="http://omniupdate.com/XSL/Variables" 
				exclude-result-prefixes="ou xsl xs fn ouc">

<!--
<div class="bootstrap-iso">
	<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
		<div class="panel panel-default">
			<div class="panel-heading" role="tab" id="headingOne">
				<h4 class="panel-title">
					<a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
					Collapsible Group Item #1
					</a>
				</h4>
			</div>
			<div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
				<div class="panel-body">
					Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
				</div>
			</div>
		</div>				
	</div>
</div>

-->
	
	<xsl:template match="h6[@class='snippet-spacer']" />
	
	<xsl:template match="//descendant::table[@class='ou_accordion']">
		<xsl:variable name="accordion_id" select="tbody/tr[1]/td[2]/node()" />				
        <div class="bootstrap-iso">
			<div class="panel-group" id="{$accordion_id}" role="tablist" aria-multiselectable="true">
				<xsl:for-each select="tbody/tr">										
					<xsl:if test="position() != 1">
						<xsl:variable name="heading_id" select="concat('heading', position())"/>
						<xsl:variable name="collapse_id" select="concat($accordion_id, concat('collapse', position()))"/>						
						<div class="panel panel-default">
							<div class="panel-heading" role="tab" id="{$heading_id}">
								<h4 class="panel-title">
									<a role="button" data-toggle="collapse" data-parent="#{$accordion_id}" href="#{$collapse_id}" aria-expanded="true" aria-controls="{$heading_id}">
									<xsl:copy-of select="td[1]/node()" />
									</a>
								</h4>
							</div>
							<div id="{$collapse_id}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="{$heading_id}">
								<div class="panel-body">
								<xsl:copy-of select="td[2]/node()" />
								</div>						
						</div>
						</div>			
					</xsl:if>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>
  
	
</xsl:stylesheet>
