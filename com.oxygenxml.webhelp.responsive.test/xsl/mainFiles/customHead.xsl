<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="geInputMap"/>
    <xsl:param name="windows_inputMap">
        <xsl:value-of select="concat('file:///', $geInputMap)"/>
    </xsl:param>
    
    <xsl:template match="/">

            <html>
                <head>
                    <!-- -->
                </head>
            <body>
            <meta name="description" content="&#160;"/>
            <meta name="keywords" content="&#160;"/>
            <meta name="author" content="&#160;"/>
            <!--<xsl:message>TESTMETA <xsl:copy-of select="document($windows_inputMap)/bookmap/bookmeta[1]/data[1]/data-about[1]/data[1][@id = 'header_prop']/ph/text"/></xsl:message>-->
            <meta name="header_prop">
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_prop']/ph/text"
                    />
                </xsl:attribute>
            </meta>
            <meta name="header_marketing">
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_marketing']/ph/text"
                    />
                </xsl:attribute>
            </meta>
            <meta name="header_field">
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_field']/ph/text"
                    />
                </xsl:attribute>
            </meta>
            <meta name="header_platform">
                <xsl:attribute name="content">
                    <xsl:value-of
                        select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_platform']/ph/text"
                    />
                </xsl:attribute>
            </meta>
            <meta name="header_topic">
                <xsl:attribute name="content">
                    <!--  <xsl:value-of select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id='header_topic']/ph/text"/>-->
                    <xsl:choose>
                        <xsl:when
                            test="starts-with(ancestor-or-self::*[contains(@class, ' topic/topic ')]/@id, '_')">
                            <xsl:value-of
                                select="substring-after(ancestor-or-self::*[contains(@class, ' topic/topic ')]/@id, '_')"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="ancestor-or-self::*[contains(@class, ' topic/topic ')]/@id"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </meta>
                <script src="ddddd"/>
            </body>
            </html>
    </xsl:template>
</xsl:stylesheet>