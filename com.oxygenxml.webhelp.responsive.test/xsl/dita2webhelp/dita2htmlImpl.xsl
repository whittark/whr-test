<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                exclude-result-prefixes="xs dita-ot dita2html ditamsg">

    <xsl:param name="SHOW_SHORTDESC" select="'YES'"/>

    <xsl:template match="*[contains(@class, ' topic/p ')][contains(@outputclass, 'show_hide_expanded')]" priority="30">
        <p>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="generate-twisty"/>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:element name="div">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </p>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')][contains(@outputclass, 'show_hide')]" priority="20">
        <p>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="generate-twisty"/>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:element name="div">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="hide-twisty"/>
        </p>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]
												[.//*[contains(@class, ' topic/pre ')]
			 										or .//*[contains(@class, ' topic/ul ')]
			 										 or .//*[contains(@class, ' topic/sl ')]
			 										  or .//*[contains(@class, ' topic/ol ')]
			 										   or .//*[contains(@class, ' topic/lq ')]
			 										    or .//*[contains(@class, ' topic/dl ')]
			 										     or .//*[contains(@class, ' topic/note ')]
			 										      or .//*[contains(@class, ' topic/lines ')]
			 										       or .//*[contains(@class, ' topic/fig ')]
			 										        or .//*[contains(@class, ' topic/table ')]
			 										         or .//*[contains(@class, ' topic/simpletable ')]]"
                  priority="10">
        <div class="p">
            <xsl:call-template name="setid"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </div>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]">
        <p>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </p>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/shortdesc ')][upper-case($SHOW_SHORTDESC) eq 'NO']"
                  mode="outofline">
        <div class="hide">
            <p>
                <xsl:call-template name="commonattributes"/>
                <xsl:if test="not(upper-case($SHOW_SHORTDESC) eq 'NO')">
                    <xsl:attribute name="class" select="'shortdesc hide'"/>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
        </div>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')][contains(@class, ' task/steps ')]" priority="50">
        <xsl:apply-templates select="." mode="generate-task-label">
            <xsl:with-param name="use-label">
                <xsl:choose>
                    <xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
                    </xsl:when>
                    <xsl:when
                            test="$GENERATE-TASK-LABELS = 'mr-labels' or $GENERATE-TASK-LABELS = 'imaging-labels'">
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName" select="'Steps Open_MR'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$GENERATE-TASK-LABELS = 'basic-labels'">
                        <xsl:call-template name="getWebhelpString">
                            <xsl:with-param name="stringName" select="'Steps Open_BASIC'"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:with-param>
        </xsl:apply-templates>

        <xsl:next-match/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/ol ')][contains(@outputclass, 'show_hide_expanded')]" priority="30">
        <p>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="generate-twisty">
                <xsl:with-param name="id" select="(@id, generate-id())[1]"/>
            </xsl:call-template>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="(@id, generate-id())[1]"/>
                </xsl:attribute>
                <xsl:variable name="olcount" select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
                                     mode="out-of-line"/>
                <xsl:call-template name="setaname"/>
                <ol>
                    <xsl:apply-templates select="@compact"/>
                    <xsl:choose>
                        <xsl:when test="$olcount mod 3 = 1"/>
                        <xsl:when test="$olcount mod 3 = 2">
                            <xsl:attribute name="type">a</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="type">i</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="setid"/>
                    <xsl:apply-templates/>
                </ol>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
                                     mode="out-of-line"/>
                <xsl:value-of select="$newline"/>
            </xsl:element>
        </p>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')][contains(@outputclass, 'show_hide')]" priority="20">
        <p>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="generate-twisty">
                <xsl:with-param name="id" select="(@id, generate-id())[1]"/>
            </xsl:call-template>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="(@id, generate-id())[1]"/>
                </xsl:attribute>
                <xsl:variable name="olcount" select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
                                     mode="out-of-line"/>
                <xsl:call-template name="setaname"/>
                <ol>
                    <xsl:apply-templates select="@compact"/>
                    <xsl:choose>
                        <xsl:when test="$olcount mod 3 = 1"/>
                        <xsl:when test="$olcount mod 3 = 2">
                            <xsl:attribute name="type">a</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="type">i</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="setid"/>
                    <xsl:apply-templates/>
                </ol>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
                                     mode="out-of-line"/>
                <xsl:value-of select="$newline"/>
            </xsl:element>
        </p>
        <xsl:call-template name="hide-twisty">
            <xsl:with-param name="id" select="(@id, generate-id())[1]"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/ol ')]" priority="10">
        <xsl:variable name="calloutCount">
            <xsl:value-of select="count(child::*[contains(@class, ' topic/li ')])"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$calloutCount > 3">
                <xsl:choose>
                    <xsl:when test="count(child::*[contains(@class, ' topic/li ')]) mod 2">
                        <xsl:variable name="calloutCountSplit">
                            <xsl:value-of select="(count(child::*[contains(@class, ' topic/li ')]) - 1) div 2"/>
                        </xsl:variable>
                        <table class="callout">
                            <xsl:for-each select="child::*[position() &lt;= $calloutCountSplit + 1]">
                                <tr>
                                    <td style="margin-right:24pt;">
                                        <span>
                                            <xsl:value-of select="count(preceding-sibling::*) + 1"/>.
                                        </span>
                                        <span>
                                            <xsl:apply-templates/>
                                        </span>
                                    </td>
                                    <td>
                                        <xsl:if test="following-sibling::*[number($calloutCountSplit) + 1]">
                                            <span>
                                                <xsl:value-of
                                                    select="count(preceding-sibling::*) + 2 + $calloutCountSplit"/>.
                                            </span>
                                            <span>
                                                <xsl:apply-templates
                                                        select="following-sibling::*[number($calloutCountSplit) + 1]/node()"/>
                                            </span>
                                        </xsl:if>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="calloutCountSplit">
                            <xsl:value-of select="count(child::*[contains(@class, ' topic/li ')]) div 2"/>
                        </xsl:variable>
                        <table style="width:50%;margin-top:20px;">
                            <xsl:for-each select="child::*[position() &lt;= $calloutCountSplit]">
                                <tr>
                                    <td style="margin-right:24pt;">
                                        <span><xsl:value-of
                                                select="count(preceding-sibling::*) + 1"/>.
                                        </span>
                                        <span>
                                            <xsl:apply-templates/>
                                        </span>
                                    </td>
                                    <td>
                                        <span><xsl:value-of
                                                select="count(preceding-sibling::*) + 1 + $calloutCountSplit"/>.
                                        </span>
                                        <span>
                                            <xsl:apply-templates select="following-sibling::*[number($calloutCountSplit)]"/>
                                        </span>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="olcount" select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
                                     mode="out-of-line"/>
                <xsl:call-template name="setaname"/>
                <ol class="callout">
                    <xsl:apply-templates select="@compact"/>
                    <xsl:choose>
                        <xsl:when test="$olcount mod 3 = 1"/>
                        <xsl:when test="$olcount mod 3 = 2">
                            <xsl:attribute name="type">1</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="type">1</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="setid"/>
                    <xsl:apply-templates/>
                </ol>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
                                     mode="out-of-line"/>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')]">
        <xsl:variable name="olcount" select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
                             mode="out-of-line"/>
        <xsl:call-template name="setaname"/>
        <ol>
            <xsl:apply-templates select="@compact"/>
            <xsl:choose>
                <xsl:when test="$olcount mod 3 = 1"/>
                <xsl:when test="$olcount mod 3 = 2">
                    <xsl:attribute name="type">a</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="type">i</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setid"/>
            <xsl:apply-templates/>
        </ol>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
                             mode="out-of-line"/>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ul ')][contains(@outputclass, 'show_hide_expanded')]" priority="20">
        <p>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="generate-twisty">
                <xsl:with-param name="id" select="(@id, generate-id())[1]"/>
            </xsl:call-template>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="(@id, generate-id())[1]"/>
                </xsl:attribute>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
                                     mode="out-of-line"/>
                <xsl:call-template name="setaname"/>
                <ul>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="@compact"/>
                    <xsl:call-template name="setid"/>
                    <xsl:apply-templates/>
                </ul>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
                                     mode="out-of-line"/>
                <xsl:value-of select="$newline"/>
            </xsl:element>
        </p>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ul ')][contains(@outputclass, 'show_hide')]" priority="10">
        <p>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="generate-twisty">
                <xsl:with-param name="id" select="(@id, generate-id())[1]"/>
            </xsl:call-template>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="(@id, generate-id())[1]"/>
                </xsl:attribute>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
                <xsl:call-template name="setaname"/>
                <ul>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="@compact"/>
                    <xsl:call-template name="setid"/>
                    <xsl:apply-templates/>
                </ul>
                <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
                <xsl:value-of select="$newline"/>
            </xsl:element>
        </p>
        <xsl:call-template name="hide-twisty">
            <xsl:with-param name="id" select="(@id, generate-id())[1]"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ul ')]">
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
                             mode="out-of-line"/>
        <xsl:call-template name="setaname"/>
        <ul>
            <xsl:apply-templates select="@compact"/>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </ul>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
                             mode="out-of-line"/>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')][contains(@outputclass, 'show_hide_expanded')][@id]"
                  priority="20">
        <p>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="place-fig-lbl"/>
            <xsl:text>  </xsl:text>
            <xsl:element name="a">
                <xsl:attribute name="onclick">
                    <xsl:text>javascript:toggleTwisty('</xsl:text>
                    <xsl:value-of select="generate-id(@id)"/>
                    <xsl:text>');</xsl:text>
                </xsl:attribute>
                <xsl:element name="img">
                    <xsl:attribute name="class">show_hide_expanded</xsl:attribute>
                    <xsl:attribute name="src">
                        <xsl:value-of select="concat('oxygen-webhelp/resources/img/', 'expanded.gif')"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(@id)"/>
                </xsl:attribute>
                <xsl:apply-templates select="." mode="fig-fmt"/>
            </xsl:element>
        </p>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')][contains(@outputclass, 'show_hide')][@id]" priority="10">
        <p>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="place-fig-lbl"/>
            <xsl:text>  </xsl:text>
            <xsl:call-template name="generate-twisty">
                <xsl:with-param name="id" select="generate-id(@id)"/>
            </xsl:call-template>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(@id)"/>
                </xsl:attribute>
                <xsl:apply-templates select="." mode="fig-fmt"/>
            </xsl:element>
        </p>
        <xsl:call-template name="hide-twisty">
            <xsl:with-param name="id" select="generate-id(@id)"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')]">
        <xsl:apply-templates select="." mode="fig-fmt"/>
    </xsl:template>

    <xsl:template name="generate-twisty">
        <xsl:param name="id" select="generate-id()"/>

        <xsl:element name="a">
            <xsl:attribute name="onclick">
                <xsl:text>javascript:toggleTwisty('</xsl:text>
                <xsl:value-of select="$id"/>
                <xsl:text>');</xsl:text>
            </xsl:attribute>
            <xsl:element name="img">
                <xsl:attribute name="class">show_hide_expanded</xsl:attribute>
                <xsl:attribute name="src">
                    <xsl:value-of select="concat('img/', 'collapse.gif')"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="hide-twisty">
        <xsl:param name="id" select="generate-id()"/>
        <script type="text/javascript">
            <xsl:text>hideTwisty('</xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text>');</xsl:text>
        </script>
    </xsl:template>

</xsl:stylesheet>
