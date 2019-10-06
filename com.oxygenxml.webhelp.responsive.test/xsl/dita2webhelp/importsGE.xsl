<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
				xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
				xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
				xmlns:oxygen="http://www.oxygenxml.com/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
				exclude-result-prefixes="ditamsg dita2html related-links xs oxygen" version="2.0">

	<xsl:import href="dita2htmlImpl.xsl"/>
    <xsl:import href="notes_hazards.xsl"/>
	<xsl:import href="tables.xsl"/>
	<xsl:import href="taskdisplay.xsl"/>

	<xsl:import href="customGE.xsl"/>
	<xsl:import href="imageMapGE.xsl"/>
	<xsl:import href="rel-links.xsl"/>

</xsl:stylesheet>