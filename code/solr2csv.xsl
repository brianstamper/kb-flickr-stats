<?xml version="1.0" encoding="UTF-8"?>
<!--

Having trouble matching the oai stuff..

    solr2csv.xsl
    
    This takes a list of solr responses and extracts the data to lines of a csv.

    ls solrcache > work/solrlist
    
    filenames are in the form itemHandle_bitstreamID.xml

    Command line looks like this:
    
    This would be followed by:
    
    Brian Stamper
    March 9, 2011
-->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
    >
    
    <xsl:output method="text" indent="no" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
    
    <xsl:template name="header" match="header">
        <xsl:text>set,handle,bitstreamID,day1
</xsl:text>
    </xsl:template>
   
    <xsl:template name="solr2csv" match="filename">
        <xsl:variable name="solrFile">
            <xsl:text>../solrcache/</xsl:text>
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="itemHandle">
            <xsl:value-of select="substring-before(.,'_')"/>
        </xsl:variable>
        <xsl:variable name="bitstreamID">
            <xsl:value-of select="substring-before(substring-after(.,'_'),'.')"/>
        </xsl:variable>
        <xsl:variable name="oaiFile">
            <xsl:text>../oaicache/</xsl:text>
            <xsl:value-of select="$itemHandle"/>.xml<xsl:text/>
        </xsl:variable>
        <xsl:apply-templates select="document($oaiFile)"/>  
<!--        <xsl:apply-templates select="document($solrFile)"/>-->
        <xsl:text>
</xsl:text>
    </xsl:template>
    
    <xsl:template match="/response/lst[@name='facet_counts']/lst[@name='facet_dates']/lst[@name='time']/int">
        <xsl:value-of select="."/>
        <xsl:if test="position()!=last()-2">,</xsl:if>
    </xsl:template>
    
    <xsl:template match="/response/lst[@name='facet_counts']/lst[@name='facet_dates']/lst[@name='time']/str"/>
    
    <xsl:template match="/response/lst[@name='facet_counts']/lst[@name='facet_dates']/lst[@name='time']/date"/>
    
    <xsl:template match="lst[@name='responseHeader']"/>
    
    
    <xsl:template match="//oai:record/oai:header">
        <xsl:value-of select="setSpec"/>,<xsl:text>****************************************************</xsl:text>
    </xsl:template>
    <xsl:template match="metadata" />
    
    

<!--    <xsl:template match="/"/>-->

    
    
</xsl:stylesheet>


