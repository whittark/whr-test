<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="2.0">    
    <!--
        Import the original stylesheet used to produce the search HTML file.
    -->

    <xsl:import href="plugin:com.oxygenxml.webhelp.responsive:xsl/mainFiles/createSearchPage.xsl"/>
    <xsl:import href="customFooter.xsl"/>
    <xsl:import href="../template/commonComponentsExpander.xsl"/>
    <xsl:param name="FTR"/>
    <xsl:param name="windows_inputMap"/>
    
    <!--
        Please add your customization templates here.
    -->
    
</xsl:stylesheet>