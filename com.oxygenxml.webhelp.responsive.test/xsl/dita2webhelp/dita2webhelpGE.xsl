<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="2.0">    
    <!--
     Import the original stylesheet used to produce an HTML file for each topic.
   -->

  
  <xsl:import href="plugin:com.oxygenxml.webhelp.responsive:xsl/dita2webhelp/dita2webhelp.xsl"/>
  <xsl:import href="../template/topicComponentsExpander.xsl"/>
<!--  <xsl:import href="../template/commonComponentsExpander.xsl"/>-->
    <!--
     Please add your customization templates here.
   -->
  <xsl:import href="importsGE.xsl"/>
  <xsl:import href="../mainFiles/customFooter.xsl"/>
  
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

</xsl:stylesheet>