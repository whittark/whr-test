<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp Plugin
Copyright (c) 1998-2017 Syncro Soft SRL, Romania.  All rights reserved.

-->
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	xmlns:mappull="http://dita-ot.sourceforge.net/ns/200704/mappull"
	xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
	xmlns:saxon="http://saxon.sf.net/"
	exclude-result-prefixes="xs dita-ot mappull ditamsg saxon">
	
	<xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
	<xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
	<xsl:import href="plugin:org.dita.base:xsl/common/dita-textonly.xsl"/>
    <xsl:include href="addResourceIDGE.xsl"/>
<!--	<xsl:include href="addSectionNumbers.xsl"/>-->
	
	<xsl:param name="PRM_CHAPTERNUM"/>
	
	<xsl:template match="*[contains(@class, ' map/topicref ')]">
		<xsl:param name="relative-path" as="xs:string">#none#</xsl:param>
		<!-- used for mapref source ditamap to retain the relative path information of the target ditamap -->
		<xsl:param name="parent-linking" as="xs:string">#none#</xsl:param>
		<!-- used for mapref target to see whether @linking should be override by the source of mapref -->
		<xsl:param name="parent-toc" as="xs:string">#none#</xsl:param>
		<!-- used for mapref target to see whether @toc should be override by the source of mapref -->
		<xsl:param name="parent-processing-role" as="xs:string">#none#</xsl:param>
		
		<!--need to create these variables regardless, for passing as a parameter to get-stuff template-->
		<xsl:variable name="type" as="xs:string">
			<xsl:call-template name="inherit"><xsl:with-param name="attrib">type</xsl:with-param></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="print" as="xs:string">
			<xsl:call-template name="inherit"><xsl:with-param name="attrib">print</xsl:with-param></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="format" as="xs:string">
			<xsl:call-template name="inherit"><xsl:with-param name="attrib">format</xsl:with-param></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="scope" as="xs:string">
			<xsl:call-template name="inherit"><xsl:with-param name="attrib">scope</xsl:with-param></xsl:call-template>
		</xsl:variable>
		
		<!--copy self-->
		<xsl:copy>
			<!--copy existing explicit attributes-->
			<xsl:apply-templates select="@* except @href"/>
			
			<xsl:apply-templates select="." mode="mappull:set-href-attribute">
				<xsl:with-param name="relative-path" select="$relative-path"/>
			</xsl:apply-templates>
			
			<!--copy inheritable attributes that aren't already explicitly defined-->
			<!--@type|@importance|@linking|@toc|@print|@search|@format|@scope-->
			<!--need to create type variable regardless, for passing as a parameter to getstuff template-->
			<xsl:if test="(:not(@type) and :)$type!='#none#'">
				<xsl:attribute name="type"><xsl:value-of select="$type"/></xsl:attribute>
			</xsl:if>
			<!-- FIXME: importance is not inheretable per http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/cascading-in-a-ditamap.html -->
			<!--xsl:if test="not(@importance)"-->
			<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">importance</xsl:with-param></xsl:apply-templates>
			<!--/xsl:if-->
			<!-- if it's in target of mapref override the current linking attribute when parent linking is none -->
			<xsl:if test="$parent-linking='none'">
				<xsl:attribute name="linking">none</xsl:attribute>
			</xsl:if>
			<xsl:if test="(:not(@linking) and :)not($parent-linking='none')">
				<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">linking</xsl:with-param></xsl:apply-templates>
			</xsl:if>
			<!-- if it's in target of mapref override the current toc attribute when parent toc is no -->
			<xsl:if test="$parent-toc='no'">
				<xsl:attribute name="toc">no</xsl:attribute>
			</xsl:if>
			<xsl:if test="(:not(@toc) and :)not($parent-toc='no')">
				<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">toc</xsl:with-param></xsl:apply-templates>
			</xsl:if>
			<xsl:if test="$parent-processing-role='resource-only'">
				<xsl:attribute name="processing-role">resource-only</xsl:attribute>
			</xsl:if>
			<xsl:if test="(:not(@processing-role) and :)not($parent-processing-role='resource-only')">
				<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">processing-role</xsl:with-param></xsl:apply-templates>
			</xsl:if>
			<xsl:if test="(:not(@print) and :)$print!='#none#'">
				<xsl:attribute name="print"><xsl:value-of select="$print"/></xsl:attribute>
			</xsl:if>
			<!--xsl:if test="not(@search)"-->
			<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">search</xsl:with-param></xsl:apply-templates>
			<!--/xsl:if-->
			<xsl:if test="(:not(@format) and :)$format!='#none#'">
				<xsl:attribute name="format"><xsl:value-of select="$format"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="(:not(@scope) and :)$scope!='#none#'">
				<xsl:attribute name="scope"><xsl:value-of select="$scope"/></xsl:attribute>
			</xsl:if>
			<!--xsl:if test="not(@audience)"-->
			<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">audience</xsl:with-param></xsl:apply-templates>
			<!--/xsl:if-->
			<!--xsl:if test="not(@platform)"-->
			<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">platform</xsl:with-param></xsl:apply-templates>
			<!--/xsl:if-->
			<!--xsl:if test="not(@product)"-->
			<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">product</xsl:with-param></xsl:apply-templates>
			<!--/xsl:if-->
			<!--xsl:if test="not(@rev)"-->
			<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">rev</xsl:with-param></xsl:apply-templates>
			<!--/xsl:if-->
			<!--xsl:if test="not(@otherprops)"-->
			<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">otherprops</xsl:with-param></xsl:apply-templates>
			<!--/xsl:if-->
			<!--xsl:if test="not(@props)"-->
			<xsl:apply-templates select="." mode="mappull:inherit-and-set-attribute"><xsl:with-param name="attrib">props</xsl:with-param></xsl:apply-templates>
			<!--/xsl:if-->
			<!--grab type, text and metadata, as long there's an href to grab from, and it's not inaccessible-->
			<xsl:choose>
				<xsl:when test="@href=''">
					<xsl:apply-templates select="." mode="ditamsg:empty-href"/>
				</xsl:when>
				<xsl:when test="$print='no' and ($FINALOUTPUTTYPE='PDF' or $FINALOUTPUTTYPE='IDD')"/>
				<xsl:when test="@href">
					<xsl:call-template name="get-stuff-ge">
						<xsl:with-param name="type" select="$type"/>
						<xsl:with-param name="scope" select="$scope"/>
						<xsl:with-param name="format" select="$format"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<!--apply templates to children-->
			<xsl:apply-templates  select="*|comment()|processing-instruction()">
				<xsl:with-param name="parent-linking" select="$parent-linking"/>
				<xsl:with-param name="parent-toc" select="$parent-toc"/>
				<xsl:with-param name="relative-path" select="$relative-path"/>
			</xsl:apply-templates>
		</xsl:copy>
		
	</xsl:template>
	
	<xsl:template name="get-stuff-ge">
		<xsl:param name="type" as="xs:string">#none#</xsl:param>
		<xsl:param name="scope" as="xs:string">#none#</xsl:param>
		<xsl:param name="format" as="xs:string">#none#</xsl:param>
		<xsl:param name="WORKDIR" as="xs:string">
			<xsl:apply-templates select="/processing-instruction('workdir-uri')[1]" mode="get-work-dir"/>
		</xsl:param>
		<xsl:variable name="locktitle" as="xs:string">
			<xsl:call-template name="inherit">
				<xsl:with-param name="attrib">locktitle</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<!--figure out what portion of the href is the path to the file-->
		<xsl:variable name="file-origin" as="xs:string">
			<xsl:apply-templates select="." mode="mappull:get-stuff_file">
				<xsl:with-param name="WORKDIR" select="$WORKDIR"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="file" as="xs:string">
			<xsl:call-template name="replace-blank">
				<xsl:with-param name="file-origin">
					<xsl:value-of select="$file-origin"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="topicpos" as="xs:string">
			<xsl:apply-templates select="." mode="mappull:get-stuff_topic-position"/>
		</xsl:variable>
		<xsl:variable name="topicid" as="xs:string">
			<xsl:apply-templates select="." mode="mappull:get-stuff_topic-id"/>
		</xsl:variable>
		
		<xsl:variable name="classval" as="xs:string">
			<xsl:apply-templates select="." mode="mappull:get-stuff_target-classval"><xsl:with-param name="type" select="$type"/></xsl:apply-templates>
		</xsl:variable>
		
		<xsl:variable name="doc"
			select="if (($format = ('dita', '#none#')) and
			($scope = ('local', '#none#')))
			then dita-ot:document($file, /)
			else ()"
			as="document-node()?"/>
		
		<!--type-->
		<xsl:apply-templates select="." mode="mappull:get-stuff_get-type">
			<xsl:with-param name="type" select="$type"/>
			<xsl:with-param name="scope" select="$scope"/>
			<xsl:with-param name="topicpos" select="$topicpos"/>
			<xsl:with-param name="format" select="$format"/>
			<xsl:with-param name="file" select="$file"/>
			<xsl:with-param name="classval" select="$classval"/>
			<xsl:with-param name="topicid" select="$topicid"/>
			<xsl:with-param name="doc" select="$doc"/>
		</xsl:apply-templates>
		
		<!--navtitle-->
		<xsl:variable name="navtitle" as="item()*">
			<xsl:choose>
				<xsl:when test="(not(*/*[contains(@class,' topic/navtitle ')]) and not(@navtitle)) or not($locktitle='yes')">
					<xsl:apply-templates select="." mode="mappull:get-stuff_get-navtitle">
						<xsl:with-param name="type" select="$type"/>
						<xsl:with-param name="scope" select="$scope"/>
						<xsl:with-param name="topicpos" select="$topicpos"/>
						<xsl:with-param name="format" select="$format"/>
						<xsl:with-param name="file" select="$file"/>
						<xsl:with-param name="classval" select="$classval"/>
						<xsl:with-param name="topicid" select="$topicid"/>
						<xsl:with-param name="doc" select="$doc"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>#none#</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Process the topicmeta, or create a topicmeta container if one does not exist -->
		<xsl:choose>
			<xsl:when test="*[contains(@class,' map/topicmeta ')]">
				<xsl:for-each select="*[contains(@class,' map/topicmeta ')]">
					<xsl:copy>
						<xsl:copy-of select="@class"/>
						<xsl:for-each select="parent::*">
							<xsl:call-template name="getmetadata-ge">
								<xsl:with-param name="type" select="$type"/>
								<xsl:with-param name="file" select="$file"/>
								<xsl:with-param name="topicpos" select="$topicpos"/>
								<xsl:with-param name="topicid" select="$topicid"/>
								<xsl:with-param name="classval" select="$classval"/>
								<xsl:with-param name="scope" select="$scope"/>
								<xsl:with-param name="format" select="$format"/>
								<xsl:with-param name="navtitle" select="$navtitle"/>
								<xsl:with-param name="doc" select="$doc"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:copy>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<topicmeta class="- map/topicmeta ">
					<xsl:call-template name="getmetadata-ge">
						<xsl:with-param name="type" select="$type"/>
						<xsl:with-param name="file" select="$file"/>
						<xsl:with-param name="topicpos" select="$topicpos"/>
						<xsl:with-param name="topicid" select="$topicid"/>
						<xsl:with-param name="classval" select="$classval"/>
						<xsl:with-param name="scope" select="$scope"/>
						<xsl:with-param name="format" select="$format"/>
						<xsl:with-param name="navtitle" select="$navtitle"/>
						<xsl:with-param name="doc" select="$doc"/>
					</xsl:call-template>
				</topicmeta>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="getmetadata-ge" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
		<xsl:param name="type" as="xs:string"/>
		<xsl:param name="scope" as="xs:string">#none#</xsl:param>
		<xsl:param name="format" as="xs:string">#none#</xsl:param>
		<xsl:param name="file" as="xs:string"/>
		<xsl:param name="topicpos" as="xs:string"/>
		<xsl:param name="topicid" as="xs:string"/>
		<xsl:param name="classval" as="xs:string"/>
		<xsl:param name="navtitle" as="item()*"/>
		<xsl:param name="doc" as="document-node()?"/>
		
		<!-- OXYGEN PATCH START  EXM-27369 -->
		<xsl:if test="$format='#none#' or $format='' or $format='dita'">
			<xsl:call-template name="addResourceID">
				<xsl:with-param name="doc" select="$doc"/>
				<xsl:with-param name="topicid" select="$topicid"/>
			</xsl:call-template>
		</xsl:if>
		<!-- OXYGEN PATCH END  EXM-27369 -->
	

		
		<!--navtitle-->
		<xsl:choose>
			<xsl:when test="not($navtitle='#none#')">
				<navtitle class="- topic/navtitle ">
<!--					<xsl:if test="$PRM_CHAPTERNUM='yes'">
					<xsl:call-template name="getPubNumber">
						<xsl:with-param name="doc" select="$doc"/>
						<xsl:with-param name="topicid" select="$topicid"/>
					</xsl:call-template>
					</xsl:if>-->
					<xsl:copy-of select="$navtitle"/>
				</navtitle>
			</xsl:when>
			<xsl:otherwise>
<!--				<xsl:if test="$PRM_CHAPTERNUM='yes'">
					<xsl:message>PRMCN 2 <xsl:value-of select="$PRM_CHAPTERNUM"/></xsl:message>
					<xsl:call-template name="getPubNumber">
						<xsl:with-param name="doc" select="$doc"/>
						<xsl:with-param name="topicid" select="$topicid"/>
					</xsl:call-template>
				</xsl:if>-->
				<xsl:apply-templates
					select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]"
				/>
			</xsl:otherwise>
		</xsl:choose>
		<!--linktext-->
		<xsl:apply-templates select="." mode="mappull:getmetadata_linktext">
			<xsl:with-param name="type" select="$type"/>
			<xsl:with-param name="scope" select="$scope"/>
			<xsl:with-param name="format" select="$format"/>
			<xsl:with-param name="file" select="$file"/>
			<xsl:with-param name="topicpos" select="$topicpos"/>
			<xsl:with-param name="topicid" select="$topicid"/>
			<xsl:with-param name="classval" select="$classval"/>
			<xsl:with-param name="doc" select="$doc"/>
		</xsl:apply-templates>
		<!--shortdesc-->
		<xsl:apply-templates select="." mode="mappull:getmetadata_shortdesc">
			<xsl:with-param name="type" select="$type"/>
			<xsl:with-param name="scope" select="$scope"/>
			<xsl:with-param name="format" select="$format"/>
			<xsl:with-param name="file" select="$file"/>
			<xsl:with-param name="topicpos" select="$topicpos"/>
			<xsl:with-param name="topicid" select="$topicid"/>
			<xsl:with-param name="classval" select="$classval"/>
			<xsl:with-param name="doc" select="$doc"/>
		</xsl:apply-templates>
		<!--metadata to be written - if we add logic at some point to pull metadata from topics into the map-->
		<xsl:apply-templates
			select="*[contains(@class, ' map/topicmeta ')]/*[not(contains(@class, ' map/linktext '))][not(contains(@class, ' map/shortdesc '))][not(contains(@class, ' topic/navtitle '))]|
			*[contains(@class, ' map/topicmeta ')]/processing-instruction()"
		/>
	</xsl:template>
	
	<xsl:template match="*" mode="mappull:getmetadata_linktext" as="node()*">
		<xsl:param name="type" as="xs:string"/>
		<xsl:param name="scope" as="xs:string">#none#</xsl:param>
		<xsl:param name="format" as="xs:string">#none#</xsl:param>
		<xsl:param name="file" as="xs:string"/>
		<xsl:param name="topicpos" as="xs:string"/>
		<xsl:param name="topicid" as="xs:string"/>
		<xsl:param name="classval" as="xs:string"/>
		<xsl:param name="doc" as="document-node()?"/>
		<xsl:choose>
			<!-- If linktext is already specified, use that -->
			<xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">
				<xsl:apply-templates select="." mode="mappull:add-usertext-PI"/>
				<xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="linktext" as="xs:string?">
					<xsl:choose>
						<!--if it's external and not dita, use the href as fallback-->
						<xsl:when test="$scope='external' and not($format='dita')">
							<xsl:apply-templates select="." mode="mappull:get-linktext_external-and-non-dita"/>
						</xsl:when>
						<!--if it's external and dita, leave empty as fallback, so that the final output process can handle file extension-->
						<xsl:when test="$scope='external'">
							<xsl:apply-templates select="." mode="mappull:get-linktext_external-dita"/>
						</xsl:when>
						<xsl:when test="$scope='peer'">
							<xsl:apply-templates select="." mode="mappull:get-linktext_peer-dita"/>
						</xsl:when>
						<!-- skip resource-only image files -->
						<xsl:when test="not($format = 'dita' or $format = '#none#') and 
							ancestor-or-self::*[@processing-role][1][@processing-role = 'resource-only']"/>
						<xsl:when test="not($format='#none#' or $format='dita')">
							<xsl:apply-templates select="." mode="mappull:get-linktext-for-non-dita"/>
						</xsl:when>
						<xsl:when test="@href=''">#none#</xsl:when>
						
						<!--grabbing text from a particular topic in another file-->
						<xsl:when test="$topicpos='otherfile'">
							<xsl:variable name="target" select="if (exists($doc)) then (key('topic-by-id', $topicid, $doc)[1]) else ()" as="element()?"/>
							<xsl:choose>
								<xsl:when test="$target[contains(@class, $classval)]/*[contains(@class, ' topic/title ')]">
									<xsl:variable name="grabbed-value" as="xs:string">
										<xsl:value-of>
											<xsl:apply-templates select="($target[contains(@class, $classval)])[1]/*[contains(@class, ' topic/title ')]" mode="text-only"/>
										</xsl:value-of>
									</xsl:variable>
									<xsl:value-of select="normalize-space($grabbed-value)"/>
								</xsl:when>
								<xsl:when test="$target[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]">
									<xsl:variable name="grabbed-value" as="xs:string">
										<xsl:value-of>
											<xsl:apply-templates select="($target[contains(@class, ' topic/topic ')])[1]/*[contains(@class, ' topic/title ')]" mode="text-only"/>
										</xsl:value-of>
									</xsl:variable>
									<xsl:value-of select="normalize-space($grabbed-value)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="linktext-fallback"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--grabbing text from the first topic in another file-->
						<xsl:when test="$topicpos='firstinfile'">
							<xsl:choose>
								<xsl:when test="$doc//*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]">
									<xsl:variable name="grabbed-value" as="xs:string">
										<xsl:value-of>
											<xsl:apply-templates select="($doc//*[contains(@class, ' topic/topic ')])[1]/*[contains(@class, ' topic/title ')]" mode="text-only"/>
										</xsl:value-of>
									</xsl:variable>
									<xsl:value-of select="normalize-space($grabbed-value)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="linktext-fallback"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>#none#<!--never happens - both possible values for topicpos are tested--></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="not($linktext='#none#')">
					<xsl:apply-templates select="." mode="mappull:add-gentext-PI"/>
					<linktext class="- map/linktext ">
<!--						<xsl:if test="$PRM_CHAPTERNUM='yes'">
							<xsl:message>PRMCN 3<xsl:value-of select="$PRM_CHAPTERNUM"/></xsl:message>
						<xsl:call-template name="getPubNumber">
							<xsl:with-param name="doc" select="$doc"/>
							<xsl:with-param name="topicid" select="$topicid"/>
						</xsl:call-template>
						</xsl:if>-->
						<xsl:copy-of select="$linktext"/>
					</linktext>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>