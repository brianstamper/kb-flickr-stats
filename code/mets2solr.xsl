<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:mets="http://www.loc.gov/METS/"
    exclude-result-prefixes="mets xsl">

    <xsl:template name="mets2solr">
        <xsl:param name="handle"/>
        <xsl:variable name="metsFile">
            <xsl:text>metscache/</xsl:text>
            <xsl:value-of select="$handle"/>
            <xsl:text>.xml</xsl:text>
        </xsl:variable>
    </xsl:template>

</xsl:stylesheet>
