<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
   

    <xsl:param name="webhelp.footer.add.generation.time" select="'no'"/>
    <xsl:param name="FTR"/>
    <xsl:param name="geInputMap"/>
    <xsl:param name="windows_inputMap">
        <xsl:value-of select="concat('file:///', $geInputMap)"/>
    </xsl:param>
    
 

    <xsl:template match="*:div[contains(@class, 'footer-container')]" mode="copy_template">
     
        <!-- Apply the default processing -->
        <xsl:next-match/>

        <!-- Add a div containing the copyright information -->
        <div class="copyright_info">
            <xsl:choose>
                <xsl:when test="$FTR = 'internet'">
                    <div class="ftrcustom">
                        <p>
                            <!--<xsl:call-template name="getWebhelpString">
                                <xsl:with-param name="stringName" select="'Footer Text'"/>
                            </xsl:call-template>-->
                            <xsl:apply-templates
                                select="document($toc)/*:topicmeta/*:data/*:data-about/*:data[@id = 'footer_string']/*:ph" mode="footer-custom"
                            />
                        </p>
                        <p align="center"><a href="legal.html"><xsl:call-template
                            name="getWebhelpString">
                            <xsl:with-param name="stringName" select="'Legal Notice'"/>
                        </xsl:call-template></a> | <a target="_blank">
                            <xsl:attribute name="href">
                                <xsl:call-template name="getWebhelpString">
                                    <xsl:with-param name="stringName"
                                        select="'Web URL Internet'"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:call-template name="getWebhelpString">
                                <xsl:with-param name="stringName"
                                    select="'Web Display Internet'"/>
                            </xsl:call-template></a>
                        </p>
                        <!--<img src="oxygen-webhelp/resources/img/GEmeatball.png" alt="GE Logo"
                            width="50pt" height="50pt"/>-->
                    </div>
                    
                </xsl:when>
                <xsl:otherwise>
                    <div class="ftrcustom">
                       
                        <p>
                            <xsl:apply-templates
                                select="$toc/*:topicmeta[1]/*:data/*:data-about/*:data[@id = 'footer_string']/*:ph" mode="footer-custom"/>
                        </p>
                        <p align="center">
                            <xsl:if
                                test="$toc/*:topicmeta[1]/bookid/bookpartno">
                                <span>
                                    <xsl:value-of
                                        select="$toc/*:topicmeta[1]/bookid/bookpartno"
                                    />
                                </span>
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="$toc/*:topicmeta[1]/publisherinformation/published/revisionid[1]">
                                <span>
                                    <xsl:apply-templates
                                        select="$toc/*:topicmeta[1]/publisherinformation/published/revisionid[1]"
                                        mode="cover"/>
                                </span>
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                            <xsl:if test="$toc/@xml:lang">
                                <span>
                                    <xsl:value-of
                                        select="$toc/@xml:lang"/>
                                </span>
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                            <span>
                                <a href="legal.html"><xsl:call-template name="getWebhelpString">
                                    <xsl:with-param name="stringName" select="'Legal Notice'"/>
                                </xsl:call-template></a> | <a target="_blank">
                                    <xsl:attribute name="href">
                                        <xsl:call-template name="getWebhelpString">
                                            <xsl:with-param name="stringName" select="'Web URL'"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:call-template name="getWebhelpString">
                                        <xsl:with-param name="stringName" select="'Web Display'"/>
                                    </xsl:call-template></a>
                            </span>
                            <!--<a HREF="javascript:window.print()">
                                <img src="oxygen-webhelp/resources/img/print.gif" border="0" alt="botom"/>
                            </a> |
                            <script>
                                document.write('<a href="mailto:ge@ge-support.com?subject=URL of Help Page&amp;body='+top.location.href+'"><img src="oxygen-webhelp/resources/img/email.gif" border="0" align="top"/></a>');
                            </script>-->
                        </p>
                       <!-- <img src="oxygen-webhelp/resources/img/GEmeatball.png" alt="GE Logo"
                            width="50pt" height="50pt"/>-->
                    </div>
                    
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
                <!-- Adds the start-end years if they are defined -->
                <xsl:when test="exists($toc/*:topicmeta/*:bookrights/*:copyrfirst) and exists($toc/*:topicmeta/*:bookrights/*:copyrlast)">
                    <span class="copyright_years">
                        &#xa9;<xsl:value-of select="$toc/*:topicmeta/*:bookrights/*:copyrfirst"/>-<xsl:value-of select="$toc/*:topicmeta/*:bookrights/*:copyrlast"/>
                    </span>
                </xsl:when>

                <!-- Adds only the first year if last is not defined. -->
                <xsl:when test="exists($toc/*:topicmeta/*:bookrights/*:copyrfirst)">
                    <span class="copyright_years">
                        &#xa9;<xsl:value-of select="$toc/*:topicmeta/*:bookrights/*:copyrfirst"/>
                    </span>
                </xsl:when>
            </xsl:choose>

            <xsl:if test="exists($toc/*:topicmeta/*:bookrights/*:bookowner/*:organization)">
                <span class="organization">
                    <xsl:text> </xsl:text><xsl:value-of select="$toc/*:topicmeta/*:bookrights/*:bookowner/*:organization"/>
                    <xsl:text>. All rights reserved.</xsl:text>
                </span>
            </xsl:if>

            <xsl:if test="$webhelp.footer.add.generation.time = 'yes'">
                <div class="generation_time">
                    Generation date: <xsl:value-of select="format-dateTime(current-dateTime(), '[h1]:[m01] [P] on [M01]/[D01]/[Y0001].')"/>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="*" mode="footer-custom">
        <span>
            <xsl:apply-templates mode="footer-custom"/>
        </span>
    </xsl:template>
    
 
    
    <!--<xsl:template match="/|node()|@*" mode="gen-user-footer" priority="10">
        <div class="navfooter">
            <xsl:choose>
                <xsl:when test="$FTR = 'internet'">
                    <div class="ftrcustom">
                        <p>
                            <!-\-<xsl:call-template name="getWebhelpString">
                <xsl:with-param name="stringName" select="'Footer Text'"/>
              </xsl:call-template>-\->
                            <xsl:apply-templates
                                select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'footer_string']/ph"
                            />
                        </p>
                        <p align="center"><a href="legal.html"><xsl:call-template
                            name="getWebhelpString">
                            <xsl:with-param name="stringName" select="'Legal Notice'"/>
                        </xsl:call-template></a> | <a target="_blank">
                            <xsl:attribute name="href">
                                <xsl:call-template name="getWebhelpString">
                                    <xsl:with-param name="stringName"
                                        select="'Web URL Internet'"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:call-template name="getWebhelpString">
                                <xsl:with-param name="stringName"
                                    select="'Web Display Internet'"/>
                            </xsl:call-template></a>
                        </p>
                        <img src="oxygen-webhelp/resources/img/GEmeatball.png" alt="GE Logo"
                            width="50pt" height="50pt"/>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="ftrcustom">
                        <p>
                            <xsl:apply-templates
                                select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'footer_string']/ph"
                            />
                        </p>
                        <p align="center">
                            <xsl:if
                                test="document($windows_inputMap)/bookmap/bookmeta[1]/bookid/bookpartno">
                                <span>
                                    <xsl:value-of
                                        select="document($windows_inputMap)/bookmap/bookmeta[1]/bookid/bookpartno"
                                    />
                                </span>
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="document($windows_inputMap)/bookmap/bookmeta[1]/publisherinformation/published/revisionid[1]">
                                <span>
                                    <xsl:apply-templates
                                        select="document($windows_inputMap)/bookmap/bookmeta[1]/publisherinformation/published/revisionid[1]"
                                        mode="cover"/>
                                </span>
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                            <xsl:if test="document($windows_inputMap)/bookmap/@xml:lang">
                                <span>
                                    <xsl:value-of
                                        select="document($windows_inputMap)/bookmap/@xml:lang"/>
                                </span>
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                            <span>
                                <a href="legal.html"><xsl:call-template name="getWebhelpString">
                                    <xsl:with-param name="stringName" select="'Legal Notice'"/>
                                </xsl:call-template></a> | <a target="_blank">
                                    <xsl:attribute name="href">
                                        <xsl:call-template name="getWebhelpString">
                                            <xsl:with-param name="stringName" select="'Web URL'"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:call-template name="getWebhelpString">
                                        <xsl:with-param name="stringName" select="'Web Display'"/>
                                    </xsl:call-template></a>
                            </span>
                            <!-\-<a HREF="javascript:window.print()">
            <img src="oxygen-webhelp/resources/img/print.gif" border="0" alt="botom"/>
          </a> |
          <script>
              document.write('<a href="mailto:ge@ge-support.com?subject=URL of Help Page&amp;body='+top.location.href+'"><img src="oxygen-webhelp/resources/img/email.gif" border="0" align="top"/></a>');
            </script>-\->
                        </p>
                        <img src="oxygen-webhelp/resources/img/GEmeatball.png" alt="GE Logo"
                            width="50pt" height="50pt"/>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>-->
</xsl:stylesheet>
