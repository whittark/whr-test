<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
    xmlns:oxygen="http://www.oxygenxml.com/functions"
    exclude-result-prefixes="xs math toc oxygen"
    version="2.0">    
    <!--
        Import the original stylesheet used to produce the main HTML file.
    -->
    <xsl:import href="plugin:com.oxygenxml.webhelp.responsive:xsl/mainFiles/createMainPage.xsl"/>
  <!--  <xsl:import href="createMainPage.xsl"/>-->

    <xsl:import href="../template/commonComponentsExpander.xsl"/>
    <xsl:import href="customFooter.xsl"/>
    <!--
        Please add your customization templates here.
    -->
    
    <!-- The path of toc.xml -->
    <xsl:param name="TOC_XML_FILEPATH" select="'in/toc.xml'"/>
    
    <xsl:param name="DRAFT"/>
    <xsl:param name="DRAFT.TOPICHEAD"/>
    
    
    <!-- GEHC-105 -->
    <!-- Rally ID US312 -->
    <!-- 2017-10-20: added new parameters for watermark, draft comments, profiling values -->
    <xsl:param name="PRM_OUTPUT_DRAFT_WATERMARK" />
    <xsl:param name="PRM_OUTPUT_DRAFT_COMMENTS" />
    <xsl:param name="PRM_OUTPUT_PROFILING_VALUES" />
    <xsl:param name="FTR"/>
    <xsl:param name="windows_inputMap"/>
    
    <xsl:variable name="toc" select="document(oxygen:makeURL($TOC_XML_FILEPATH))/toc:toc"/>
    
    <!-- 
    Creates the index.html 
  -->
    <xsl:template match="/">
        <xsl:variable name="mainPageTemplate">
            <xsl:apply-templates select="." mode="fixup_XHTML_NS"/>
        </xsl:variable>
        
       <!-- <xsl:message>this is prm1 <xsl:value-of select="$PRM_OUTPUT_DRAFT_COMMENTS"/></xsl:message>-->
        
        <xsl:apply-templates select="$mainPageTemplate" mode="copy_template">
            <!-- EXM-36737 - Context node used for messages localization -->
            <xsl:with-param name="i18n_context" select="$i18n_context/*" tunnel="yes" as="element()"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template name="create-legal-section">
        <xsl:if
            test="
            $WEBHELP_COPYRIGHT != '' or
            string-length($toc/toc:copyright) > 0 or
            string-length($toc/toc:legalnotice) > 0
            ">
            <div class="legal">
                <div class="legalCopyright">
                    <xsl:value-of select="$WEBHELP_COPYRIGHT"/>
                    <xsl:if test="string-length($toc/toc:copyright) > 0">
                        <br/>
                        <xsl:copy-of select="$toc/toc:copyright/*"/>
                    </xsl:if>
                </div>
                <xsl:if test="string-length($toc/toc:legalnotice) > 0">
                    <div class="legalnotice">
                        <xsl:copy-of select="$toc/toc:legalnotice/*"/>
                    </div>
                </xsl:if>
            </div>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>