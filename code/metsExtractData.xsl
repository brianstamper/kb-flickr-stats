<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:kbflickr="https://github.com/brianstamper/kb-flickr-stats/tree/master/xmlns/1.0"
    exclude-result-prefixes="mets xsl">


    <xsl:output indent="no" omit-xml-declaration="yes" />
    
    <!-- Given a list of handles and a param for a metadata field, this lists that field.
        
    -->
    <xsl:strip-space elements="*" />
        <xsl:param name="qualifier" select="accessioned"/>
        <xsl:param name="element" select="date"/>
    
    <xsl:template name="metsExtractData" match="itemHandle">

        <xsl:variable name="metsFile">
            <xsl:text>../metscache/</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>.xml</xsl:text>
        </xsl:variable>
        <xsl:apply-templates select="document($metsFile)">
<!--            <xsl:with-param name="qualifier" select="$qualifier"/>
            <xsl:with-param name="element" select="$element"/>-->
        </xsl:apply-templates>
    </xsl:template>
    

    <xsl:template match="dim:field"/>
<!--    <xsl:template match="dim:field[@element='{$element}'][@qualifier='{$qualifier}']" priority="5">
        <xsl:value-of select="."/>
    </xsl:template>-->
    <xsl:template match="dim:field[@element='date'][@qualifier='accessioned']" priority="5">
        <xsl:value-of select="."/>
        <xsl:text>
</xsl:text>
    </xsl:template>
</xsl:stylesheet>


<!--wget -O solrcache/45765_195265.xml 
    'http://127.0.0.1:8080/solr/statistics/select?rows=0&amp;facet.mincount=1&amp;facet.date=time&amp;facet.date.end=NOW%2FDAY-60DAYS&amp;facet.date.gap=%2B1DAY&amp;facet.date.start=NOW%2FDAY-260DAYS&amp;facet=true&amp;facet.limit=100&amp;fq=-isBot:true&amp;fq=%28time:%5B2010-06-14T00:00:00.000Z+TO+2010-12-31T00:00:00.000Z%5D%29&amp;q=type:+0+AND+id:195265'-->
