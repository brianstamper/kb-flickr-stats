<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:kbflickr="https://github.com/brianstamper/kb-flickr-stats/tree/master/xmlns/1.0"
    exclude-result-prefixes="mets xsl">

    <!-- date functions provided by http://www.exslt.org/date/index.html -->
    <xsl:import href="date.difference/date.difference.xsl" />
    <xsl:import href="date.date-time/date.date-time.xsl" />

    <xsl:output indent="no" omit-xml-declaration="yes" />
    
    
    <xsl:template name="mets2solr" match="kbflickr:itemHandle">
        <xsl:variable name="metsFile">
            <xsl:text>metscache/</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>.xml</xsl:text>
        </xsl:variable>
        <xsl:apply-templates select="document($metsFile)">
            <xsl:with-param name="itemHandle" select="."/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="mets:METS">
        <xsl:param name="itemHandle"/>
        <xsl:variable name="dc.date.accessioned">
            <xsl:value-of select="dim:field[@element='date'][@qualifier='accessioned']"/>
        </xsl:variable>
        <xsl:variable name="fileID">
            <xsl:value-of select="substring-after(mets:fileGrp[@USE='CONTENT']/@ID,'_')"/>
        </xsl:variable>
        <xsl:text>wget -O solrcache/</xsl:text>
        <xsl:value-of select="$itemHandle"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="$fileID"/>
        <xsl:text>.xml </xsl:text>
        <xsl:variable name="daysAgo">
            <xsl:call-template name="date:difference">
                <xsl:with-param name="start" select="$dc.date.accessioned" />
                <xsl:with-param name="end" select="date:date-time()" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$daysAgo"/>

    </xsl:template>


</xsl:stylesheet>


<!--wget -O solrcache/45765_195265.xml 'http://127.0.0.1:8080/solr/statistics/select?rows=0&amp;facet.mincount=1&amp;facet.date=time&amp;facet.date.end=NOW%2FDAY-60DAYS&amp;facet.date.gap=%2B1DAY&amp;facet.date.start=NOW%2FDAY-260DAYS&amp;facet=true&amp;facet.limit=100&amp;fq=-isBot:true&amp;fq=%28time:%5B2010-06-14T00:00:00.000Z+TO+2010-12-31T00:00:00.000Z%5D%29&amp;q=type:+0+AND+id:195265'-->
