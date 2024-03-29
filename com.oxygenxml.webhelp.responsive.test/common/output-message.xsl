<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
  Sourceforge.net. See the accompanying license.txt file for 
  applicable licenses.-->
  <!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->
  
  <!--
    Standard error message template for DITA processing in XSL. This
    file should be included by any XSL program that uses the standard
    message template. To include this file, you will need the following
    two commands in your XSL:
    
    <xsl:include href="output-message.xsl"/>           - Place with other included files
    
    <xsl:variable name="msgprefix">DOTX</xsl:variable> - Place with other variables
    
    
    The template takes in the following parameters:
    - msg    = the message to print in the log; default=***
    - msgnum = the message number (3 digits); default=000
    - msgsev = the severity (I, W, E, or F); default=I (Informational)
  -->
  
  
  <xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:log="org.dita.dost.util.LogUtils" 
    exclude-result-prefixes="log">
    <xsl:template name="output-message">
      <xsl:param name="msg" select="'***'"/>
      <xsl:param name="msgnum" select="'000'"/>
      <xsl:param name="msgsev" select="'I'"/>
      <xsl:param name="msgparams" select="''"/>
      
      <xsl:variable name="msgid">
        <xsl:value-of select="$msgprefix"/>
        <xsl:value-of select="$msgnum"/>
        <xsl:value-of select="$msgsev"/>
      </xsl:variable>
      <xsl:variable name="msgdoc" select="document('../../resource/messages.xml')"/>
      <xsl:variable name="msgcontent">
        <xsl:choose>
          <xsl:when test="$msg!='***'">
            <xsl:value-of select="$msg"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$msgdoc/messages/message[@id=$msgid]" mode="get-message-content">    
              <xsl:with-param name="params" select="$msgparams"/>    
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="localclass"><xsl:value-of select="@class"/></xsl:variable>
      <xsl:variable name="debugloc">
        <!-- Information on how to find the error; file name, followed by element counter: -->
        <!-- (File = filename.dita, Element = searchtitle:1) -->
        <xsl:if test="@xtrf|@xtrc">
          <xsl:text>(</xsl:text>
          <xsl:if test="@xtrf">
            <xsl:text>File = </xsl:text><xsl:value-of select="@xtrf"/>
            <xsl:if test="@xtrc"><xsl:text>, </xsl:text></xsl:if>
          </xsl:if>
          <xsl:if test="@xtrc"><xsl:text>Element = </xsl:text><xsl:value-of select="@xtrc"/></xsl:if>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:variable>
      
      <xsl:message>
        <!-- Debug location,Error message-->
 		<xsl:value-of select="concat($msgcontent,'The location of this problem was at ',$debugloc)"/>
      </xsl:message>
    </xsl:template>
    
    <xsl:template match="message" mode="get-message-content">
      <xsl:param name="params"/>
      <xsl:variable name="reason" select="reason/text()"/>
      <xsl:variable name="response" select="response/text()"/>    
      <xsl:variable name="messageType"><xsl:value-of select="@type"/></xsl:variable>  <!--record this messageType as Information in the log file  when parsing the xml  add by wxzhang 20070515 -->
      <xsl:text>[</xsl:text><xsl:value-of select="@id"/><xsl:text>]</xsl:text>
      <xsl:text>[</xsl:text><xsl:value-of select="@type"/><xsl:text>]</xsl:text>
      <xsl:text>: </xsl:text>
      <!--record this messageType as Information in the log file  when parsing the xml  add by wxzhang 20070515 -->
      <xsl:call-template name="LogUtils">
        <xsl:with-param name="messageType" select="$messageType"></xsl:with-param>
      </xsl:call-template> 
      <xsl:call-template name="replaceParams">
        <xsl:with-param name="string" select="$reason"/>
        <xsl:with-param name="params" select="$params"/>    
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:call-template name="replaceParams">
        <xsl:with-param name="string" select="$response"/>
        <xsl:with-param name="params" select="$params"/>    
      </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="replaceParams">
      <xsl:param name="string"/>
      <xsl:param name="params"/>
      <xsl:choose>
        <xsl:when test="contains($params,';')">
          <xsl:variable name="param" select="substring-before($params,';')"/>
          <xsl:variable name="newString">
            <xsl:call-template name="replaceString">
              <xsl:with-param name="string" select="$string"/>
              <xsl:with-param name="match" select="substring-before($param,'=')"/>
              <xsl:with-param name="replacement" select="substring-after($param,'=')"/>            
            </xsl:call-template>          
          </xsl:variable>
          <xsl:call-template name="replaceParams">
            <xsl:with-param name="string" select="$newString"/>
            <xsl:with-param name="params" select="substring-after($params,';')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($params,'=')">
          <xsl:call-template name="replaceString">
            <xsl:with-param name="string" select="$string"/>
            <xsl:with-param name="match" select="substring-before($params,'=')"/>
            <xsl:with-param name="replacement" select="substring-after($params,'=')"/>            
          </xsl:call-template>   
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$string"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
    <xsl:template name="replaceString">
      <xsl:param name="string"/>
      <xsl:param name="match"/>
      <xsl:param name="replacement"/>
      <xsl:choose>
        <xsl:when test="contains($string,$match)">
          <xsl:value-of select="substring-before($string,$match)"/>
          <xsl:value-of select="$replacement"/>
          <xsl:call-template name="replaceString">
            <xsl:with-param name="string"
              select="substring-after($string,$match)"/>
            <xsl:with-param name="replacement" select="$replacement"/>
            <xsl:with-param name="match" select="$match"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$string"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
    
    <!-- This is LogUtils module  -->
    <xsl:template name="LogUtils">
      <xsl:param name="messageType"/>
      <xsl:variable name="messageTypeLower">
        <!-- ensure lowercase for comparisons -->
        <!--  <xsl:call-template name="convert-to-lower">
          <xsl:with-param name="inputval" select="@messageType"/>
          </xsl:call-template> -->
        <xsl:value-of select="$messageType"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$messageTypeLower='FATAL'">
          <xsl:call-template name="fatalIncrease"/>
        </xsl:when>
        <xsl:when test="$messageTypeLower='ERROR'">
          <xsl:call-template name="errorIncrease"></xsl:call-template>
        </xsl:when>
        <xsl:when test="$messageTypeLower='WARN'">
          <xsl:call-template name="warnIncrease"></xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
        </xsl:otherwise> 
      </xsl:choose>
    </xsl:template>
    <xsl:template name="fatalIncrease">
    	<xsl:if test="function-available('log:increaseNumOfFatals')">
      		<xsl:value-of select="log:increaseNumOfFatals()"/>
      	</xsl:if>
    </xsl:template>         
    <xsl:template name="errorIncrease">
    	<xsl:if test="function-available('log:increaseNumOfErrors')">
      		<xsl:value-of select="log:increaseNumOfErrors()"/>
      	</xsl:if>
    </xsl:template>     
    <xsl:template name="warnIncrease">  	      		
    	<xsl:if test="function-available('log:increaseNumOfWarnings')">
      		<xsl:value-of select="log:increaseNumOfWarnings()"/>
      	</xsl:if>
    </xsl:template>     
    
  </xsl:stylesheet>
  
