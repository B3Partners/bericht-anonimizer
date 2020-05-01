<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:GbaPersoon="http://www.kadaster.nl/schemas/brk-levering/snapshot/imkad-gba-persoon/v20120901"
                xmlns:Persoon="http://www.kadaster.nl/schemas/brk-levering/snapshot/imkad-persoon/v20120201"
                xmlns:StUFBG0204="http://www.egem.nl/StUF/sector/bg/0204"
                xmlns:StUF0204="http://www.egem.nl/StUF/StUF0204"
                xmlns:cat="http://schemas.kvk.nl/schemas/hrip/catalogus/2013/01"
                xmlns:cat25="http://schemas.kvk.nl/schemas/hrip/catalogus/2015/01"
                xmlns:cat30="http://schemas.kvk.nl/schemas/hrip/catalogus/2015/02"
                xmlns:digest="org.apache.commons.codec.digest.DigestUtils"
                xmlns:b="http://www.b3p.nl/func">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
    <!-- usage: java -cp "./saxon9.jar;./commons-codec-1.11.jar" net.sf.saxon.Transform -s:bron.xml -xsl:copy_xml.xsl -o:output.xml -->

    <!--
    het anonimiseren van PL formaat is nog niet compleet, mogelijk nog te doen:

    geslacht (maar dan probleem met codelijsten)

    rubriek[nummer='0410']/waarde |
    rubriek[nummer='0410']/omschrijving |

    plaatsen (maar dan probleem met verwijzingen naar BAG)

    rubriek[nummer='0320']/waarde |
    rubriek[nummer='0320']/omschrijving |
    rubriek[nummer='0330']/waarde |
    rubriek[nummer='0330']/omschrijving |

    Mogelijk zijn er meer.. maar die heb ik nog niet gezien
    -->
    <xsl:template match="/">
        <xsl:comment select="concat ('Geanonimiseerd door B3Partners BV op ', current-date(), ', zie commentaar in bericht.')" />
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates />
    </xsl:template>

    <!-- Identity template : copy all text nodes, elements and attributes -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="cat:natuurlijkPersoon/cat:bsn |
                         cat25:natuurlijkPersoon/cat25:bsn |
                         cat30:natuurlijkPersoon/cat30:bsn">
        <xsl:call-template name="replace_hash_element">
            <xsl:with-param name="e" select="." />
            <xsl:with-param name="mode" select="'number'" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="cat:natuurlijkPersoon/cat:volledigeNaam |
                         cat:natuurlijkPersoon/cat:geslachtsnaam |
                         cat:natuurlijkPersoon/cat:geslachtsnaamPartner |
                         cat:natuurlijkPersoon/cat:voornamen |
                         cat:natuurlijkPersoon/cat:geboorteplaats |
                         cat25:natuurlijkPersoon/cat25:volledigeNaam |
                         cat25:natuurlijkPersoon/cat25:geslachtsnaam |
                         cat25:natuurlijkPersoon/cat25:geslachtsnaamPartner |
                         cat25:natuurlijkPersoon/cat25:voornamen |
                         cat25:natuurlijkPersoon/cat25:geboorteplaats |
                         cat30:natuurlijkPersoon/cat30:volledigeNaam |
                         cat30:natuurlijkPersoon/cat30:geslachtsnaam |
                         cat30:natuurlijkPersoon/cat30:geslachtsnaamPartner |
                         cat30:natuurlijkPersoon/cat30:voorvoegselGeslachtsnaam |
                         cat30:natuurlijkPersoon/cat30:voorvoegselGeslachtsnaamPartner |
                         cat30:natuurlijkPersoon/cat30:voornamen |
                         cat30:natuurlijkPersoon/cat30:geboorteplaats |
                         cat30:naamPersoon/cat30:naam |
                         rubriek[nummer='0210']/waarde |
                         rubriek[nummer='0210']/omschrijving |
                         rubriek[nummer='0220']/waarde |
                         rubriek[nummer='0220']/omschrijving |
                         rubriek[nummer='0230']/waarde |
                         rubriek[nummer='0230']/omschrijving |
                         rubriek[nummer='0240']/waarde |
                         rubriek[nummer='0240']/omschrijving">
        <xsl:call-template name="replace_hash_element">
            <xsl:with-param name="e" select="." />
            <xsl:with-param name="mode" select="'restoreWhitespace'" />
        </xsl:call-template>
    </xsl:template>

    <!-- Anonimisatie uitzonderingen voor HR natuurlijkPersoon,
         cat:natuurlijkPersoon/cat:registratie/cat:datumAanvang is (meestal?) geb. datum
    -->
    <xsl:template match="cat:natuurlijkPersoon/cat:registratie/cat:datumAanvang |
                         cat25:natuurlijkPersoon/cat25:registratie/cat25:datumAanvang |
                         cat30:natuurlijkPersoon/cat30:registratie/cat30:datumAanvang |
                         cat30:geboortedatum |
                         cat30:overlijdensdatum |
                         cat30:datumGeemigreerd |
                         cat30:datumEersteHuwelijk |
                         rubriek[nummer='0310']/waarde |
                         rubriek[nummer='0310']/omschrijving |
                         rubriek[nummer='6210']/waarde |
                         rubriek[nummer='6210']/omschrijving">
        <xsl:call-template name="replace_hash_element">
            <xsl:with-param name="e" select="." />
            <xsl:with-param name="mode" select="'date'" />
            <xsl:with-param name="withdash" select="''" />
        </xsl:call-template>
    </xsl:template>

    <!-- Anonimisatie uitzonderingen voor GBA Persoon en Persoon en StUFBG0204/StUF0204 PRS -->
    <xsl:template match="GbaPersoon:BSN |
                         StUFBG0204:a-nummer |
                         StUFBG0204:bsn-nummer |
                         StUFBG0204:bankgiroRekeningnummer |
                         StUFBG0204:nummerIdentiteitsbewijs |
                         StUF0204:extraElement[@naam='lengteHouder'] |
                         rubriek[nummer='0110']/waarde |
                         rubriek[nummer='0110']/omschrijving |
                         rubriek[nummer='0120']/waarde |
                         rubriek[nummer='0120']/omschrijving">
        <xsl:call-template name="replace_hash_element">
            <xsl:with-param name="e" select="." />
            <xsl:with-param name="mode" select="'number'" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="GbaPersoon:voornamen |
                         Persoon:voornamen |
                         StUFBG0204:voornamen |
                         StUFBG0204:voorletters |
                         GbaPersoon:geboorteplaats |
                         Persoon:geboorteplaats |
                         StUFBG0204:geboorteplaats |
                         GbaPersoon:geslachtsnaam |
                         Persoon:geslachtsnaam |
                         StUFBG0204:geslachtsnaam |
                         GbaPersoon:voorvoegselsGeslachtsnaam |
                         GbaPersoon:voorvoegselsgeslachtsnaam |
                         Persoon:voorvoegselsGeslachtsnaam |
                         StUFBG0204:voorvoegselGeslachtsnaam |
                         StUFBG0204:indicatieGezagMinderjarige |
                         StUFBG0204:indicatieCuratelestelling |
                         StUFBG0204:aanduidingBijzonderNederlanderschap |
                         StUF0204:extraElement[@naam='iban'] |
                         StUF0204:extraElement[@naam='geslachtsNaamEchtgenoot'] |
                         rubriek[nummer='0906']/waarde |
                         rubriek[nummer='0906']/omschrijving">
        <xsl:call-template name="replace_hash_element">
            <xsl:with-param name="e" select="." />
            <xsl:with-param name="mode" select="'restoreWhitespace'" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="GbaPersoon:geboortedatum | 
                         Persoon:geboortedatum |
                         GbaPersoon:datumOverlijden |
                         Persoon:datumOverlijden |
                         StUFBG0204:geboortedatum |
                         StUFBG0204:datumOverlijden">
        <xsl:call-template name="replace_hash_element">
            <xsl:with-param name="e" select="." />
            <xsl:with-param name="mode" select="'date'" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="replace_hash_element">
        <xsl:param name="e" />
        <xsl:param name="mode" select="'string'" />
        <xsl:param name="withdash" select="'-'" />

        <xsl:element name="{name($e)}" namespace="{namespace-uri($e)}">
            <!-- kopieer ook de attributen -->
            <xsl:apply-templates select="@*" />
            <!-- bereken hash met de zelfde lengte als origineel -->
            <xsl:call-template name="hashed_length">
                <xsl:with-param name="o" select="$e" />
                <xsl:with-param name="mode" select="$mode" />
                <xsl:with-param name="withdash" select="$withdash" />
            </xsl:call-template>
        </xsl:element>

        <xsl:choose>
            <xsl:when test="$mode eq 'date'">
                <xsl:comment select="concat ('Anonimisatie ''', name($e), ''': datum is met behoud van vorm vervangen door een hash van de oorspronkelijke datum.')" />
            </xsl:when>
            <xsl:when test="$mode eq 'number'">
                <xsl:comment select="concat ('Anonimisatie ''', name($e), ''': getal is met behoud van vorm vervangen door een hash van van het oorspronkelijke getal.')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment select="concat ('Anonimisatie ''', name($e), ''': waarde is vervangen door een hash van de oorspronkelijke waarde met de zelfde lengte.')" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="hashed_length" as="xs:string">
        <xsl:param name="o" as="xs:string" />
        <xsl:param name="mode" as="xs:string" />
        <xsl:param name="withdash" select="'-'" />

        <xsl:variable name="o_length">
            <xsl:value-of select="string-length($o)" />
        </xsl:variable>
        <xsl:variable name="o_hashed">
            <!-- bereken sha256 hash -->
            <xsl:call-template name="hash">
                <xsl:with-param name="o" select="." />
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$mode eq 'date'">
                <xsl:variable name="d_hashed">
                    <xsl:value-of select="translate($o_hashed, 'abcdef', '')" />
                </xsl:variable>
                <xsl:variable name="d_jaar" as="xs:integer">
                    <xsl:value-of select="ceiling(number(substring($d_hashed, 1, 2)) + 1930)" />
                </xsl:variable>
                <xsl:variable name="d_maand" as="xs:integer">
                    <xsl:value-of select="ceiling(number(substring($d_hashed, 3, 2)) div 100*11)" />
                </xsl:variable>
                <xsl:variable name="d_dag" as="xs:integer">
                    <xsl:value-of select="ceiling(number(substring($d_hashed, 5, 2)) div 100*30)" />
                </xsl:variable>
                <xsl:variable name="ds_maand" as="xs:string">
                    <xsl:choose>
                        <xsl:when test="$d_maand lt 10">
                            <xsl:value-of select="concat('0', string($d_maand))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="string($d_maand)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="ds_dag" as="xs:string">
                    <xsl:choose>
                        <xsl:when test="$d_dag lt 10">
                            <xsl:value-of select="concat('0', string($d_dag))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="string($d_dag)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat($d_jaar, $withdash, $ds_maand, $withdash , $ds_dag)" />
            </xsl:when>
            <xsl:when test="$mode eq 'number'">
                <xsl:variable name="d_hashed" select="translate($o_hashed,translate($o_hashed, '0123456789',''),'')" />
                <xsl:value-of select="substring($d_hashed, 1, $o_length)" />
            </xsl:when>
            <xsl:when test="$mode eq 'restoreWhitespace'">
                <xsl:call-template name="restoreOriginalWhitespace">
                    <xsl:with-param name="o_input" select="."/>
                    <xsl:with-param name="o_hashed" select="$o_hashed"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring($o_hashed, 1, $o_length)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="hash" as="xs:string">
        <xsl:param name="o" as="xs:string" />
        <!-- zet commons-codec op classpath -->
        <xsl:sequence select="digest:sha256Hex(string($o))" />
    </xsl:template>

    <xsl:template name="restoreOriginalWhitespace" as="xs:string">
        <xsl:param name="o_input" as="xs:string" />
        <xsl:param name="o_hashed" as="xs:string" />

        <xsl:variable name="words" select="tokenize($o_input, '\s+')"/>
        <xsl:variable name="withwhitespace">
            <xsl:for-each select="$words[position()]">
                <xsl:variable name="pos" select="position()" as="xs:integer"/>
                <!--lengte van originele woord-->
                <xsl:variable name="wordlength" as="xs:integer">
                    <xsl:value-of select="string-length(.)"/>
                </xsl:variable>
                <xsl:variable name="subwords" select="subsequence($words, 1, $pos - 1)" />
                <xsl:variable name="a">
                    <xsl:call-template name="concatwords">
                        <xsl:with-param name="wordSeq" select="$subwords"/>
                        <xsl:with-param name="count" select="$pos"/>
                    </xsl:call-template>
                </xsl:variable>
                <!--lengte van woorden tot originele woord-->
                <xsl:variable name="startpos" as="xs:integer">
                    <xsl:choose>
                        <xsl:when test="string-length($a) lt 1">
                            <xsl:value-of select="1" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="string-length($a)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat(substring($o_hashed, $startpos, $wordlength), ' ')" />
            </xsl:for-each>
        </xsl:variable>
        <!--trim resultaat-->
        <xsl:value-of select="replace(replace($withwhitespace,'\s+$',''),'^\s+','')" />
    </xsl:template>

    <xsl:template name="concatwords" as="xs:string">
        <xsl:param name="wordSeq" />
        <xsl:param name="count" />
        <xsl:variable name="a">
            <xsl:for-each select="1 to $count" >
                <xsl:value-of select="concat($wordSeq[current()],'')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="concat($a,'1')" />
    </xsl:template>

</xsl:stylesheet>
