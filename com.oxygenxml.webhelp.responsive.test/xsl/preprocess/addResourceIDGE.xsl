<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp Plugin
Copyright (c) 1998-2017 Syncro Soft SRL, Romania.  All rights reserved.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template name="getPubNumber">
        <xsl:param name="doc"/>
        <xsl:param name="topicid"/>
        
        <xsl:variable name="currentTopicId" as="xs:string">
            <xsl:choose>
                <!-- In case of stand-alone topics (non-chunked) the $topicid is '#none#' -->
                <xsl:when test="$topicid = '#none#'">
                    <xsl:value-of select="$doc/*[contains(@class, ' topic/topic ')]/@id"/>
                </xsl:when>
                <!-- In case of chunked topics the $topicid hold the id of the current subtopic (the one corresponding to the topicref context node) -->
                <xsl:otherwise>
                    <xsl:value-of select="$topicid"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        
        <xsl:choose>
            <xsl:when test="self::*[contains(@class, ' bookmap/chapter ')]">
                <!-- numbering will be added on the chapter element -->
             <!--   <xsl:number format="1" 
                    count="chapter" grouping-separator="."/>-->
            </xsl:when>
            <xsl:when test="self::*[contains(@class, ' map/topicref ')][not(contains(@class, ' bookmap/chapter '))][not(ancestor::*[contains(@class, ' bookmap/frontmatter ')])][not(ancestor::*[contains(@class, ' bookmap/appendix ')])]">
                <xsl:number format="1" 
                    count="chapter|topicref" level="multiple" grouping-separator="."/> 
                <!--<xsl:choose>
                    <xsl:when test="parent::topichead | parent::map | parent::submap">
                        <!-\-     <xsl:text>pt-level1</xsl:text>-\->
                        <xsl:number format="1" 
                            count="topicref" grouping-separator="."/> 
                    </xsl:when>
                    <xsl:when test="ancestor::*[contains(@class, ' map/topicref ')][not(contains(@class, ' bookmap/chapter '))][not(contains(@class, ' bookmap/frontmatter '))]">
                        <!-\-  <xsl:text>pt-level2</xsl:text>-\->
                        <xsl:number format="1" 
                            count="topicref" level="multiple" grouping-separator="."/> 
                    </xsl:when>
                    <xsl:when test="ancestor::*[contains(@class, ' bookmap/chapter ')]">
                        <!-\-  <xsl:text>pt-level1-chapter</xsl:text>-\->
                        <xsl:number format="1" 
                            count="chapter" level="multiple" grouping-separator="."/> 
                    </xsl:when>
                    <xsl:otherwise>
                        <!-\-  <xsl:value-of select="local-name(./parent::*)"/>-\->
                     <!-\-  <xsl:comment>no numbering</xsl:comment>-\->
                    </xsl:otherwise>
                </xsl:choose>-->					
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <!-- <xsl:text>Section number issue</xsl:text>-->
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="addResourceIDGE">
        <xsl:param name="doc"/>
        <xsl:param name="topicid"/>
        
        <!-- Fix the value for the $topicid. It is "#none#" for non-chunked topics. -->
        <xsl:variable name="currentTopicId" as="xs:string">
            <xsl:choose>
                <!-- In case of stand-alone topics (non-chunked) the $topicid is '#none#' -->
                <xsl:when test="$topicid = '#none#'">
                    <xsl:value-of select="$doc/*[contains(@class, ' topic/topic ')]/@id"/>
                </xsl:when>
                <!-- In case of chunked topics the $topicid hold the id of the current subtopic (the one corresponding to the topicref context node) -->
                <xsl:otherwise>
                    <xsl:value-of select="$topicid"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
   
        
        <!-- Generate an attribute containig the topic id. -->
        <xsl:attribute name="data-topic-id" select="$currentTopicId"/>
        
        <!-- The URI of the document where the resource ID was declared. -->
        <!-- Used to distinguish between resource IDs declared in the topic or in the DITA map. -->
        <xsl:variable name="sourceUri" as="xs:string">
            <xsl:value-of select="$doc//*[contains(@class, ' topic/topic ')][@id=$currentTopicId]/@xtrf"/>
        </xsl:variable>
        
                <!-- If there is no resource ID declared in the DITA Map or in the current topic, fallback to the topic ID.  -->
                <resourceid class="- topic/resourceid " oxy-source="topic">
                    <xsl:attribute name="appid" select="$currentTopicId"/>
                </resourceid>
               
                        <!-- GE customization to add section numbering -->
                            <data class="- topic/data " oxy-source="topic">
                                <xsl:attribute name="name" select="'sectionnum'"/>
                                <!--<xsl:attribute name="value" select="count(preceding-sibling::*[contains(@class, ' map/topicref ')])+1"></xsl:attribute>  -->  
                                <xsl:attribute name="value">
                                    <xsl:choose>
                                        <xsl:when test="self::*[contains(@class, ' bookmap/chapter ')]">
                                            <xsl:number format="1" 
                                                count="chapter" grouping-separator="."/> 
                                        </xsl:when>
                                        <xsl:when test="self::*[contains(@class, ' map/topicref ')][not(contains(@class, ' bookmap/chapter '))][not(ancestor::*[contains(@class, ' bookmap/frontmatter ')])][not(ancestor::*[contains(@class, ' bookmap/appendix ')])]">
                                            <xsl:number format="1" 
                                                count="chapter|topicref" level="multiple" grouping-separator="."/> 
                                            <!--<xsl:choose>
                                                <xsl:when test="parent::topichead | parent::map | parent::submap">
                                               <!-\-     <xsl:text>pt-level1</xsl:text>-\->
                                                    <xsl:number format="1" 
                                                        count="chapter|topicref" grouping-separator="."/> 
                                                </xsl:when>
                                                <xsl:when test="ancestor::*[contains(@class, ' map/topicref ')][not(contains(@class, ' bookmap/chapter '))][not(contains(@class, ' bookmap/frontmatter '))]">
                                                  <!-\-  <xsl:text>pt-level2</xsl:text>-\->
                                                    <xsl:number format="1" 
                                                        count="chapter|topicref" level="multiple" grouping-separator="."/> 
                                                </xsl:when>
                                                <xsl:when test="ancestor::*[contains(@class, ' bookmap/chapter ')]">
                                                  <!-\-  <xsl:text>pt-level1-chapter</xsl:text>-\->
                                                    <xsl:number format="1" 
                                                        count="chapter|topicref" level="multiple" grouping-separator="."/> 
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <!-\-  <xsl:value-of select="local-name(./parent::*)"/>-\->
                                                   <!-\- <xsl:text>section number issue</xsl:text>-\->
                                               
                                                </xsl:otherwise>
                                            </xsl:choose>-->
                                    
                                        
                                    </xsl:when>
                                    <xsl:otherwise>
                                     <!--   <xsl:text>Section number issue</xsl:text>-->
                                    </xsl:otherwise>
                                </xsl:choose>
                                </xsl:attribute>  
                            </data>    
        
    </xsl:template>
    
    <!-- Copy templates -->
    <xsl:template match="*[contains(@class, ' topic/resourceid ')]" mode="copy-resourceID" priority="10">
        <xsl:copy>
            <xsl:attribute name="oxy-source">topic</xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*" mode="copy-resourceID">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>