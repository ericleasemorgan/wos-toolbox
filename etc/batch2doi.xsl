<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- batch2doi.xsl - given a batch of WoS search results, output a list of doi's -->

<!-- Eric Lease Morgan <emorgan@nd.edu> -->
<!-- (c) University of Notre Dame; distributed under a GNU License -->

<!-- Feburary 14, 2020 - first cut; not efficient but effective -->


<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:wos="http://scientific.thomsonreuters.com/schema/wok5.4/public/FullRecord"
	version="1.0">

	<xsl:strip-space elements="*"/>
	<xsl:output method="text" />
	<xsl:template match="/">
		<xsl:for-each select="//wos:identifier">
			<xsl:if test='(@type = "xref_doi") or (@type="doi")'>
				<xsl:value-of select='@value' />
				<xsl:text>&#10;</xsl:text>
			</xsl:if>	
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
