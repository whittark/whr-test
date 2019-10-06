<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2017 Syncro Soft SRL, Romania.  All rights reserved.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all"
    xmlns:oxy="http://www.oxygenxml.com/functions"
    xmlns:relpath="http://dita2indesign/functions/relpath"
    xmlns:whc="http://www.oxygenxml.com/webhelp/components"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:oxygen="http://www.oxygenxml.com/functions"
    xpath-default-namespace="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml"
    version="2.0">
  <!--  <xsl:include href="plugin:com.oxygenxml.webhelp.responsive:xsl/template/topicComponentsExpander.xsl"/>-->

    <xsl:import href="commonComponentsExpander.xsl"/>
    <xsl:param name="TEMPDIR"/>
    <xsl:param name="INPUTDIR"/>
    <xsl:param name="tempDir">
        <xsl:value-of select="$TEMPDIR"/>
    </xsl:param>
    <xsl:param name="LANGUAGE"/>
    <xsl:param name="DEFAULTLANG"/>
    <xsl:param name="FTR"/>
    <xsl:param name="geInputMap"/>
    <xsl:param name="windows_inputMap">
        <xsl:value-of select="concat('file:///', $geInputMap)"/>
    </xsl:param>

    <xsl:param name="DRAFT"/>
    <!-- <xsl:param name="DEFAULTLANG">en-us</xsl:param>-->
    <!-- GEHC-105 -->
    <!-- Rally ID US312 -->
    <!-- 2017-10-20: added new parameters for watermark, draft comments, profiling values -->
    <xsl:param name="PRM_OUTPUT_DRAFT_WATERMARK"/>
    <xsl:param name="PRM_OUTPUT_DRAFT_COMMENTS"/>
    <xsl:param name="PRM_OUTPUT_PROFILING_VALUES"/>
    <xsl:param name="PRM_OUTPUT_HAZARD_LABEL"/>
    <xsl:param name="PRM_SUPPORT_BUTTON"/>
    <xsl:param name="DRAFT.TOPICHEAD"/>
    <xsl:variable name="hazIcon"
        select="'img/hazard_triangle_inline_2.png'"/>
    <!-- link to support -->
    <xsl:variable name="SUPPORT_LINK" select="normalize-space(document($windows_inputMap)
        //descendant::*[contains(@class, ' bookmap/bookmeta ')][1]
        /child::*[contains(@class, ' topic/metadata ')]
        /child::*[contains(@class, ' topic/data ')][lower-case(@id) = 'support_url'][1]
        /descendant::*[contains(@class, ' topic/xref ')][1]/@href)" />

    <xsl:template match="body" mode="copy_template">
        <xsl:param name="ditaot_topicContent" tunnel="yes"/>

        <xsl:copy>
            <xsl:choose>
                <xsl:when test="exists($ditaot_topicContent)">
                    <!-- body element from dita-ot document -->
                    <xsl:variable name="ditaot_body" select="($ditaot_topicContent//body)[1]"/>
                    <!-- Merge the attributes from the template body element with attributes from the body element produced by DITA-OT-->
                    <xsl:variable name="mergedAttributes"
                                  select="oxy:mergeHTMLAttributes('body', @*, $ditaot_body/@*)"/>
                    <xsl:copy-of select="$mergedAttributes"/>

                    <xsl:apply-templates select="node()" mode="#current"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Copy template body content -->
                    <xsl:apply-templates select="@* | node()" mode="#current"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="upper-case($PRM_OUTPUT_DRAFT_WATERMARK) = 'YES'">
                <img src="oxygen-webhelp/resources/img/draft.png" style="position:absolute;top:400pt;left:200pt;z-index:-1"/>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <!-- customization to add email page link to biz_email address, and support button if parameter is used  -->
    <xsl:template match="whc:webhelp_print_link" mode="copy_template">
	    <!-- EXM-36737 - Context node used for messages localization -->
        <xsl:param name="i18n_context" tunnel="yes" as="element()*"/>
<!--        <xsl:message>this is i18n content = <xsl:value-of select="$i18n_context"/></xsl:message>-->
       <!-- <xsl:message>this is the inputMap/email = <xsl:value-of select="$windows_inputMap/bookmap/bookmeta[1]/data/data-about/data[@id = 'biz_email']/ph"/></xsl:message>-->
        <xsl:if test="oxy:getParameter('webhelp.show.print.link') = 'yes'">
            <xsl:variable name="printThisPage">
                <xsl:choose>
                    <xsl:when test="exists($i18n_context)">
                        <xsl:for-each select="$i18n_context[1]">
                            <xsl:call-template name="getWebhelpString">
                                <xsl:with-param name="stringName" select="'printThisPage'"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>Print this page</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="emailThisPage">
                <xsl:choose>
                    <xsl:when test="exists($i18n_context)">
                        <xsl:for-each select="$i18n_context[1]">
                            <xsl:call-template name="getWebhelpString">
                                <xsl:with-param name="stringName" select="'emailThisPage'"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>Email this page</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="mailtoSubject">
                <!--<xsl:value-of select="*[contains(@class, ' topic/title ')]"/>-->
                <xsl:value-of select="$i18n_context/*[contains(@class, ' topic/title ')]"/>
            </xsl:variable>
            <xsl:variable name="emailaddress">
                <xsl:choose>
                    <xsl:when
                        test="document($windows_inputMap)//descendant::*[contains(@class, ' bookmap/bookmeta ')][1]/child::*[contains(@class, ' topic/data ')]/child::*[contains(@class, ' topic/data-about ')]/child::*[contains(@class, ' topic/data ')][@id = 'biz_email']/*[contains(@class, ' topic/ph ')]">
                        <xsl:choose>
                            <xsl:when
                                test="document($windows_inputMap)//descendant::*[contains(@class, ' bookmap/bookmeta ')][1]/child::*[contains(@class, ' topic/data ')]/child::*[contains(@class, ' topic/data-about ')]/child::*[contains(@class, ' topic/data ')][@id = 'biz_email']/*[contains(@class, ' topic/ph ')]/*[contains(@class, ' topic/xref ')]">
                                <xsl:value-of
                                    select="document($windows_inputMap)//descendant::*[contains(@class, ' bookmap/bookmeta ')][1]/child::*[contains(@class, ' topic/data ')]/child::*[contains(@class, ' topic/data-about ')]/child::*[contains(@class, ' topic/data ')][@id = 'biz_email']/*[contains(@class, ' topic/ph ')]/*[contains(@class, ' topic/xref ')]/substring-after(@href, 'mailto:')"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="document($windows_inputMap)//descendant::*[contains(@class, ' bookmap/bookmeta ')][1]/child::*[contains(@class, ' topic/data ')]/child::*[contains(@class, ' topic/data-about ')]/child::*[contains(@class, ' topic/data ')][@id = 'biz_email']/*[contains(@class, ' topic/ph ')]"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>help.feedback@ge.com</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <div>
      
                <xsl:call-template name="generateComponentClassAttribute">
                    <xsl:with-param name="compClass">wh_print_link</xsl:with-param>
                </xsl:call-template>
                <!-- Copy attributes -->
                <xsl:copy-of select="@* except @class"/>
                
                <a href="javascript:window.print();" title="{$printThisPage}"/>
          
            </div>
            
            <div>
                <xsl:call-template name="generateComponentClassAttribute">
                    <xsl:with-param name="compClass">wh_email_link</xsl:with-param>
                </xsl:call-template>
                <!-- Copy attributes -->
                <xsl:copy-of select="@* except @class"/>
                <script>
                    document.write('<a href="mailto:{$emailaddress}?subject={$mailtoSubject}&amp;body='+window.location.href+'" title="{$emailThisPage}" class="mail" target="_blank">
                    </a>');
                </script>
               <!-- <a href="mailto:{$emailaddress}?subject={$mailtoSubject}&amp;body=window.location.href" title="{$emailThisPage}"/>-->
            </div>
            <!-- Rally ID US344 -->
            <!-- 2018-01-20: add support link -->
            
            <!--<xsl:if test="$PRM_SUPPORT_BUTTON = 'yes'">-->
            <xsl:if test="$PRM_SUPPORT_BUTTON='yes' and string-length($SUPPORT_LINK) gt 0">
                
                <!-- get the support title -->
                <xsl:variable name="support">
                    <xsl:call-template name="getWebhelpString">
                        <xsl:with-param name="stringName" select="'Support'"/>
                    </xsl:call-template>
                </xsl:variable>
                <div>
                    <xsl:call-template name="generateComponentClassAttribute">
                        <xsl:with-param name="compClass">wh_support_link</xsl:with-param>
                    </xsl:call-template>
                <xsl:text> </xsl:text>
                <button class="support" title="{$support}" onclick="window.open('{$SUPPORT_LINK}', '_blank')"><xsl:value-of select="$support" /></button>
                </div>
            </xsl:if>
            
            
            
        </xsl:if>
    </xsl:template>

    <!-- WH-1405 - Toggle Highlight on a search result -->
    <xsl:template match="whc:webhelp_toggle_highlight" mode="copy_template">
        <xsl:param name="i18n_context" tunnel="yes" as="element()*"/>
        <xsl:if test="oxy:getParameter('webhelp.show.toggle.highlights') = 'yes'">
            <xsl:variable name="toggleHighlights">
                <xsl:choose>
                    <xsl:when test="exists($i18n_context)">
                        <xsl:for-each select="$i18n_context[1]">
                            <xsl:call-template name="getWebhelpString">
                                <xsl:with-param name="stringName" select="'toggleHighlights'"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>Show/Hide the highlight</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <button class="wh_hide_highlight" title="{$toggleHighlights}"></button>
        </xsl:if>        
    </xsl:template>

    <!-- Expand 'webhelp_breadcrumb' place holder. -->
    <xsl:template match="whc:webhelp_breadcrumb" mode="copy_template">
        <xsl:param name="ditaot_topicContent" tunnel="yes"/>
        <xsl:param name="i18n_context" tunnel="yes" as="element()*"/>
        
        <xsl:if test="oxy:getParameter('webhelp.show.breadcrumb') = 'yes'">
            <xsl:variable name="breadcrumb">
                <div data-tooltip-position="bottom">
                    <xsl:call-template name="generateComponentClassAttribute">
                        <xsl:with-param name="compClass">wh_breadcrumb</xsl:with-param>
                    </xsl:call-template>
                    <!-- Copy attributes -->
                    <xsl:copy-of select="@* except @class"/>
                    
                    <!-- Generate the breadcrumb -->
                    <xsl:call-template name="generateBreadcrumb">
                        <xsl:with-param name="i18n_context" select="$i18n_context"/>
                    </xsl:call-template>
                </div>
            </xsl:variable>
            
            <xsl:call-template name="outputComponentContent">
                <xsl:with-param name="compContent" select="$breadcrumb"/>
                <xsl:with-param name="compName" select="local-name()"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="html:html" mode="copy_template">
        <xsl:param name="ditaot_topicContent" tunnel="yes"/>
        
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="exists($ditaot_topicContent/html:html)">
                    <!-- EXM-36308 - Merge attributes -->
                    <xsl:copy-of select="oxygen:mergeHTMLAttributes(
                        'html', 
                        ./@*, 
                        $ditaot_topicContent/html:html/@*)"/>          
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@*" mode="#current"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Copy elements -->
            <xsl:apply-templates select="node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <!-- Expand 'webhelp_feedback' place holder. -->
    <xsl:template match="whc:webhelp_feedback" mode="copy_template">
        <xsl:if test="string-length($WEBHELP_PRODUCT_ID)>0 and string-length($WEBHELP_PRODUCT_VERSION)>0">
            <xsl:variable name="feedbackFile" select="doc('../../oxygen-webhelp/feedback.xml')"/>
            <xsl:apply-templates select="$feedbackFile" mode="#current" />
        </xsl:if>
    </xsl:template>

    <!-- Filter the link to parent -->
    <xsl:template match="span[@id = 'topic_navigation_links']/span[contains(@class, 'navparent')]"
        mode="copyNavigationLinks"/>

    <!-- Filter any child nodes of next/prev links -->
    <xsl:template
        match="span[@id = 'topic_navigation_links']/span[contains(@class, 'navprev')]/a/node()"
        mode="copyNavigationLinks"/>
    <xsl:template
        match="span[@id = 'topic_navigation_links']/span[contains(@class, 'navnext')]/a/node()"
        mode="copyNavigationLinks"/>

    <xsl:template match="node() | @*" mode="copyNavigationLinks">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
