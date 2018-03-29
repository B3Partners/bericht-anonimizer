<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--verwijder comments en whitespace, output op 1 regel-->
    <xsl:output indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="node()|@*" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="comment()"/>
</xsl:stylesheet>