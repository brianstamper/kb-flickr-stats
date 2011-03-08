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
    <xsl:import href="date.add/date.add.xsl" />
    <xsl:output indent="no" omit-xml-declaration="yes" />
    
    <!-- This is in a partial state. The idea is to get the date accessioned, compare that
        to todays date, and use those numbers to produce a solr query for date accessioned to
        some fixed number of days later.
        
        When last I worked on this I was having issues with my XPath expression for fileID.
        Matching to mets:METS is a bit silly, this should probably be done by calling templates,
        perhaps selecting parent nodes on the way. Noting that one node will have the date accessioned,
        while a sibiling node will have a collection of bitstreams, these will need read at different points.
        
    -->
    
    <xsl:template name="mets2solr" match="itemHandle">
        <xsl:variable name="metsFile">
            <xsl:text>../metscache/</xsl:text>
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
            <xsl:value-of select="mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='date'][@qualifier='accessioned']"/>
        </xsl:variable>
        <xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CONTENT']">
            <xsl:with-param name="itemHandle" select="$itemHandle"/>
            <xsl:with-param name="dc.date.accessioned" select="$dc.date.accessioned"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="mets:file">
        <xsl:param name="dc.date.accessioned"/>
        <xsl:param name="itemHandle"/>

        <xsl:variable name="fileID">
            <xsl:value-of select="substring-after(./@ID,'_')"/>
        </xsl:variable>

        <xsl:variable name="daysAgoString">
            <xsl:call-template name="date:difference">
                <xsl:with-param name="start" select="$dc.date.accessioned" />
                <xsl:with-param name="end" select="date:date-time()" />
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="daysAgo">
            <xsl:value-of select="number(substring-before(substring-after($daysAgoString,'P'),'D'))"/>
        </xsl:variable>
        
        <xsl:variable name="dc.date.accessioned.Plus100">
            <xsl:call-template name="date:add">
                <xsl:with-param name="date-time" select="$dc.date.accessioned" />
                <xsl:with-param name="duration" select="100" />
            </xsl:call-template>
        </xsl:variable>
        

        <!--wget -O solrcache/45765_195265.xml ... -->
        <xsl:text>wget -O solrcache/</xsl:text>
        <xsl:value-of select="$itemHandle"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="$fileID"/>
        <xsl:text>.xml </xsl:text>

        <!--'http://127.0.0.1:8080/solr/statistics/select?rows=0&amp;facet.mincount=1&amp;facet.date=time&amp;facet.date.end=NOW%2FDAY-
            60
            DAYS&amp;facet.date.gap=%2B1DAY&amp;facet.date.start=NOW%2FDAY-
            260
            DAYS&amp;facet=true&amp;facet.limit=100&amp;fq=-isBot:true&amp;fq=%28time:%5B
            2010-06-14
            T00:00:00.000Z+TO+
            2010-12-31
            T00:00:00.000Z%5D%29&amp;q=type:+0+AND+id:
            195265
            '-->

        <xsl:text>'http://127.0.0.1:8080/solr/statistics/select?rows=0&amp;facet.mincount=1&amp;facet.date=time&amp;facet.date.end=NOW%2FDAY-</xsl:text>
        <xsl:value-of select="($daysAgo - 100)"/>
        <xsl:text>DAYS&amp;facet.date.gap=%2B1DAY&amp;facet.date.start=NOW%2FDAY-</xsl:text>
        <xsl:value-of select="$daysAgo"/>
        <xsl:text>DAYS&amp;facet=true&amp;facet.limit=100&amp;fq=-isBot:true&amp;fq=%28time:%5B</xsl:text>
        <xsl:value-of select="$dc.date.accessioned"/>
        <xsl:text>+TO+</xsl:text>
        <xsl:value-of select="$dc.date.accessioned.Plus100"/>
        <xsl:text>%5D%29&amp;q=type:+0+AND+id:</xsl:text>
        <xsl:value-of select="$fileID"/>
        <xsl:text>'</xsl:text>

    </xsl:template>

</xsl:stylesheet>


 
    





<!--        <xsl:value-of select="$itemHandle"/>
    <xsl:value-of select="$dc.date.accessioned"/>
    <xsl:value-of select="$fileID"/>
-->

