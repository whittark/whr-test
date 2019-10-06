<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:oxygen="http://www.oxygenxml.com/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ditamsg dita2html related-links xs oxygen" version="2.0">
    
    <xsl:import href="notes_hazards.xsl"/>
	<xsl:import href="tables.xsl"/>
	<xsl:import href="imageMap.xsl"/>
	<xsl:import href="taskdisplay.xsl"/>
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

    <!-- Define a newline character -->
    <xsl:variable name="newline">
        <xsl:text>
</xsl:text>
    </xsl:variable>
	

    

	<!-- NESTED TOPIC TITLES (sensitive to nesting depth, but are still processed for contained markup) -->
	<!-- 1st level - topic/title -->
	<!-- Condensed topic title into single template without priorities; use $headinglevel to set heading.
     If desired, somebody could pass in the value to manually set the heading level -->
	<xsl:template
		match="*[contains(@class, ' topic/topic ')][not(parent::*[contains(@class, ' topic/topic ')])]/*[contains(@class, ' topic/title ')]">
		<xsl:param name="headinglevel">
			<xsl:choose>
				<xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 6"
					>6</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count(ancestor::*[contains(@class, ' topic/topic ')])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:if test="$TRANSTYPE = 'webhelp-single'">
			<a href="#topPage">
				<xsl:call-template name="getWebhelpString">
					<xsl:with-param name="stringName" select="'BacktoTop'"/>
				</xsl:call-template>
			</a>
		</xsl:if>
		<!-- Comtech 07/18/2013 wrap h1 and shortdesc in header HTML5 tag -->
		<xsl:element name="header">
			<!--  <xsl:attribute name="style">border:0.1pt solid white;</xsl:attribute>-->
			<xsl:attribute name="class">contentHead</xsl:attribute>
			<xsl:value-of select="$newline"/>
			<!-- FMC 04/2015, topic header block -->
			<!-- US292 topic meta placement, handling for topic ID (with string manipulation - remove initial underscore MJT:FMC 7/24/2016 -->
			<xsl:message>Value of draft.topichead <xsl:value-of select="$DRAFT.TOPICHEAD"
			/></xsl:message>
			<xsl:if test="upper-case($DRAFT.TOPICHEAD) = 'YES'">
				<div class="topicMeta">
					<!-- <p>Draft Metadata</p>-->
					<ul>
						<xsl:call-template name="commonattributes"/>
						<li style="text-align: justify;">
							<!--<span style="color:#1F4998;font-weight:bold;">Proprietary statement: </span> -->
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_prop']/ph"
								mode="meta-info"/>
						</li>
						<li>
							<!--<span style="color:#1F4998;font-weight:bold;">Marketing name: </span> -->
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_marketing']/ph"
								mode="meta-info"/>
							<xsl:text> </xsl:text>
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_sys']/ph"
								mode="meta-info"/>
						</li>
						<!--              <li><!-\-<span style="color:#1F4998;font-weight:bold;">System: </span>-\->
                <xsl:apply-templates select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id='header_sys']/ph"/>
              </li>-->
						<li>
							<!--<span style="color:#1F4998;font-weight:bold;">Field Strength: </span>-->
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_field']/ph"
								mode="meta-info"/>
						</li>
						<li>
							<!--<span style="color:#1F4998;font-weight:bold;">Platform: </span>-->
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_platform']/ph"
								mode="meta-info"/>
						</li>
						<li>
							<span class="metalabel">Topic ID: </span>
							<!-- <xsl:variable name="topicID" select="ancestor-or-self::*[contains(@class, ' topic/topic ')]/@id"/>-->
							<xsl:choose>
								<xsl:when
									test="starts-with(ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id, '_')">
									<xsl:value-of
										select="substring-after(ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id, '_')"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="ancestor-or-self::*[contains(@class, ' topic/topic ')]/@id"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</li>
						<!--<li>
            <span style="color:#1F4998;font-weight:bold;">Topic ID, version x.0 (no date): </span>
            <xsl:apply-templates select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id='header_topic']/ph"/>
          </li>-->
					</ul>
				</div>
			</xsl:if>
			<xsl:element name="h{$headinglevel}">
				<xsl:attribute name="class">topictitle<xsl:value-of select="$headinglevel"
				/></xsl:attribute>
				<xsl:attribute name="id">emailsubject</xsl:attribute>
				<!-- <xsl:attribute name="style">margin-top:5%;</xsl:attribute>-->
				<xsl:call-template name="commonattributes">
					<xsl:with-param name="default-output-class">topictitle<xsl:value-of
						select="$headinglevel"/></xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates/>
			</xsl:element>
			<!-- Comtech 07/18/2013 add shortdesc to header HTML5 tag -->
			<xsl:apply-templates select="//*[contains(@class, ' topic/abstract ')]" mode="outofline"/>
			<!-- Insert pre-req links - after shortdesc - unless there is a prereq section about -->
			<xsl:apply-templates select="//*[contains(@class, ' topic/related-links ')]"
				mode="prereqs"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>


<!--
	<xsl:template match="*[contains(@class, ' topic/ol ')]" name="topic.ol">
		<xsl:if test="contains(@class, ' task/steps ')">
			<xsl:apply-templates select="." mode="generate-task-label">
				<xsl:with-param name="use-label">
					<xsl:choose>
						<xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
							&lt;!&ndash;<xsl:call-template name="getWebhelpString">
              <xsl:with-param name="stringName" select="'Steps Open'"/>
            </xsl:call-template>&ndash;&gt;
						</xsl:when>
						<xsl:when
							test="$GENERATE-TASK-LABELS = 'mr-labels' or $GENERATE-TASK-LABELS = 'imaging-labels'">
							<xsl:call-template name="getString">
								<xsl:with-param name="stringName" select="'Steps Open_MR'"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$GENERATE-TASK-LABELS = 'basic-labels'">
							<xsl:call-template name="getWebhelpString">
								<xsl:with-param name="stringName" select="'Steps Open_BASIC'"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="contains(@outputclass, 'show_hide') and @id">
				<p>
					&lt;!&ndash;<div class="p collapsible">&ndash;&gt;
					<xsl:call-template name="commonattributes"/>
					<xsl:call-template name="setid"/>
					<xsl:element name="a">
						<xsl:attribute name="onclick">
							<xsl:text>javascript:toggleTwisty('</xsl:text>
							<xsl:value-of select="@id"/>
							<xsl:text>');</xsl:text>
						</xsl:attribute>
						<xsl:element name="img">
							<xsl:attribute name="class">show_hide_expanded</xsl:attribute>
							<xsl:attribute name="src">
								<xsl:value-of
									select="concat('oxygen-webhelp/resources/img/', 'collapse.gif')"
								/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
						<xsl:variable name="olcount"
							select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
							mode="out-of-line"/>
						<xsl:call-template name="setaname"/>
						<ol>
							<xsl:apply-templates select="@compact"/>
							<xsl:choose>
								<xsl:when test="$olcount mod 3 = 1"/>
								<xsl:when test="$olcount mod 3 = 2">
									<xsl:attribute name="type">a</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="type">i</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:call-template name="commonattributes"/>
							<xsl:call-template name="setid"/>
							<xsl:apply-templates/>
						</ol>
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
							mode="out-of-line"/>
						<xsl:value-of select="$newline"/>
					</xsl:element>
					&lt;!&ndash;</div>&ndash;&gt;
				</p>
				<script type="text/javascript">
          <xsl:text>hideTwisty('</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>');</xsl:text>
        </script>
			</xsl:when>
			<xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
				<p>
					&lt;!&ndash;<div class="p collapsible">&ndash;&gt;
					<xsl:call-template name="commonattributes"/>
					<xsl:call-template name="setid"/>
					<xsl:element name="a">
						<xsl:attribute name="onclick">
							<xsl:text>javascript:toggleTwisty('</xsl:text>
							<xsl:value-of select="@id"/>
							<xsl:text>');</xsl:text>
						</xsl:attribute>
						<xsl:element name="img">
							<xsl:attribute name="class">show_hide_expanded</xsl:attribute>
							<xsl:attribute name="src">
								<xsl:value-of
									select="concat('oxygen-webhelp/resources/img/', 'expanded.gif')"
								/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
						<xsl:variable name="olcount"
							select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
							mode="out-of-line"/>
						<xsl:call-template name="setaname"/>
						<ol>
							<xsl:apply-templates select="@compact"/>
							<xsl:choose>
								<xsl:when test="$olcount mod 3 = 1"/>
								<xsl:when test="$olcount mod 3 = 2">
									<xsl:attribute name="type">a</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="type">i</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:call-template name="commonattributes"/>
							<xsl:call-template name="setid"/>
							<xsl:apply-templates/>
						</ol>
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
							mode="out-of-line"/>
						<xsl:value-of select="$newline"/>
					</xsl:element>
					&lt;!&ndash;</div>&ndash;&gt;
				</p>
			</xsl:when>
			<xsl:when test="parent::*[contains(@class, ' topic/fig ')]">
				<xsl:variable name="calloutCount">
					<xsl:value-of select="count(child::*[contains(@class, ' topic/li ')])"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$calloutCount > 3">
						<xsl:choose>
							<xsl:when test="count(child::*[contains(@class, ' topic/li ')]) mod 2">
								<xsl:variable name="calloutCountSplit">
									<xsl:value-of
										select="(count(child::*[contains(@class, ' topic/li ')]) - 1) div 2"
									/>
								</xsl:variable>
								<table class="callout">
									&lt;!&ndash;<table style="border:1pt solid grey;width:50%;margin-top:6pt;">&ndash;&gt;
									&lt;!&ndash; start-indent="-.0625in" &ndash;&gt;
									<xsl:for-each
										select="child::*[position() &lt;= $calloutCountSplit + 1]">
										<tr class="">
											<td class="callout" style="margin-right:24pt;">
												<span><xsl:value-of
												select="count(preceding-sibling::*) + 1"/>. </span>
												<span>
												<xsl:apply-templates/>
												</span>
											</td>
											<td class="callout" >
												<xsl:if
												test="following-sibling::*[number($calloutCountSplit) + 1]">
												<span><xsl:value-of
												select="count(preceding-sibling::*) + 2 + $calloutCountSplit"
												/>. </span>
												<span>
												<xsl:apply-templates
												select="following-sibling::*[number($calloutCountSplit) + 1]/node()"
												/>
												</span>
												</xsl:if>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="calloutCountSplit">
									<xsl:value-of
										select="count(child::*[contains(@class, ' topic/li ')]) div 2"
									/>
								</xsl:variable>
								<table style="width:50%;margin-top:20px;">
									&lt;!&ndash; start-indent="-.0625in" &ndash;&gt;
									<xsl:for-each
										select="child::*[position() &lt;= $calloutCountSplit]">
										<tr>
											<td style="margin-right:24pt;">
												<span><xsl:value-of
												select="count(preceding-sibling::*) + 1"/>. </span>
												<span>
												<xsl:value-of select="."/>
												</span>
											</td>
											<td>
												<span><xsl:value-of
												select="count(preceding-sibling::*) + 1 + $calloutCountSplit"
												/>. </span>
												<span>
												<xsl:value-of
												select="following-sibling::*[number($calloutCountSplit)]"
												/>
												</span>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="olcount"
							select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
							mode="out-of-line"/>
						<xsl:call-template name="setaname"/>
						<ol class="callout">
							<xsl:apply-templates select="@compact"/>
							<xsl:choose>
								<xsl:when test="$olcount mod 3 = 1"/>
								<xsl:when test="$olcount mod 3 = 2">
									<xsl:attribute name="type">1</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="type">1</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:call-template name="commonattributes"/>
							<xsl:call-template name="setid"/>
							<xsl:apply-templates/>
						</ol>
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
							mode="out-of-line"/>
						<xsl:value-of select="$newline"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="olcount"
					select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
				<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
					mode="out-of-line"/>
				<xsl:call-template name="setaname"/>
				<ol>
					<xsl:apply-templates select="@compact"/>
					<xsl:choose>
						<xsl:when test="$olcount mod 3 = 1"/>
						<xsl:when test="$olcount mod 3 = 2">
							<xsl:attribute name="type">a</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="type">i</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="commonattributes"/>
					<xsl:call-template name="setid"/>
					<xsl:apply-templates/>
				</ol>
				<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
					mode="out-of-line"/>
				<xsl:value-of select="$newline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
-->
	<!-- US261 checkbox list MJT:FMC 8/31/2016 -->
	<!-- list item -->
	<xsl:template match="*[contains(@class, ' topic/li ')]" name="topic.li">
		<xsl:choose>
			<xsl:when test="ancestor-or-self::*[contains(@class, ' hazard-d/messagepanel ')]">
				<li>
					<xsl:if test="ancestor-or-self::*[contains(@class, 'hazardstatement')]">
						<xsl:attribute name="style">list-style:none;</xsl:attribute>
					</xsl:if>
					<!--<xsl:choose>
            <xsl:when test="parent::*/@compact='no'">
              <xsl:attribute name="class">liexpand</xsl:attribute>
              <!-\- handle non-compact list items -\->
              <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'liexpand'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="commonattributes"/>
            </xsl:otherwise>
          </xsl:choose>-->
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>
				</li>
				<xsl:value-of select="$newline"/>
			</xsl:when>
			<xsl:when
				test="*[contains(@class, ' hazard-d/hazardstatement')][ancestor-or-self::*[contains(@class, ' task/step')]]">
				<!-- FMC 03/16/2015 move hazardstatement above cmd -->
				<!-- GEHC-86 / Ryffine-MJT- Move hazardstatement ONLY when step list-->
				<div>
					<xsl:attribute name="style">padding-left:16px;</xsl:attribute>
					<xsl:apply-templates select="*[contains(@class, ' hazard-d/hazardstatement ')]"
					/>
				</div>
				<li>
					<xsl:if test="ancestor-or-self::*[contains(@class, ' topic/fig ')]">
						<xsl:attribute name="style">margin-left:-18pt;</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates
						select="*[not(contains(@class, ' hazard-d/hazardstatement '))]"/>
				</li>
				<xsl:value-of select="$newline"/>
			</xsl:when>
			<xsl:when test="parent::*[contains(@class, ' task/steps ')]">
				<xsl:choose>
					<!-- NMM 04/23/2017: Move note content above cmd -->
					<xsl:when test="*[contains(@class, ' topic/note ')]">
						<div>
							<xsl:attribute name="style">padding-left:16px;</xsl:attribute>
							<xsl:apply-templates select="*[contains(@class, ' topic/note ')]"/>
						</div>
						<li>
							<xsl:if test="ancestor-or-self::*[contains(@class, ' topic/fig ')]">
								<xsl:attribute name="style">margin-left:-18pt;</xsl:attribute>
							</xsl:if>
							<xsl:call-template name="setidaname"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates/>
						</li>
						<xsl:value-of select="$newline"/>
					</xsl:when>
					<xsl:otherwise>
						<li>
							<xsl:if test="ancestor-or-self::*[contains(@class, ' topic/fig ')]">
								<xsl:attribute name="style">margin-left:-18pt;</xsl:attribute>
							</xsl:if>
							<xsl:call-template name="setidaname"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates/>
						</li>
						<xsl:value-of select="$newline"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="ancestor-or-self::*[contains(@outputclass, 'checkbox')]">
				<li>
					<!-- this is to process callout list -->
					<xsl:if test="ancestor-or-self::*[contains(@class, ' topic/fig ')]">
						<!--<xsl:attribute name="style">margin-left:-5pt;</xsl:attribute>-->
					</xsl:if>
					<!--<xsl:choose>
            <xsl:when test="parent::*/@compact='no'">
              <xsl:attribute name="class">liexpand</xsl:attribute>
              <!-\- handle non-compact list items -\->
              <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'liexpand'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="commonattributes"/>
            </xsl:otherwise>
          </xsl:choose>-->
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="commonattributes"/>
					<input type="checkbox" name="check">
						<xsl:attribute name="value"
							select="count(preceding-sibling::*[contains(@class, ' topic/li ')]) + 1"
						/>
					</input>
					<xsl:apply-templates/>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<!-- this is to process callout list -->
					<xsl:if test="ancestor-or-self::*[contains(@class, ' topic/fig ')]">
						<!--<xsl:attribute name="style">margin-left:-5pt;</xsl:attribute>-->
					</xsl:if>
					<!--<xsl:choose>
            <xsl:when test="parent::*/@compact='no'">
              <xsl:attribute name="class">liexpand</xsl:attribute>
              <!-\- handle non-compact list items -\->
              <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'liexpand'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="commonattributes"/>
            </xsl:otherwise>
          </xsl:choose>-->
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>
				</li>
				<xsl:value-of select="$newline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Simple List -->
	<!-- handle all levels thru browser processing -->
	<xsl:template match="*[contains(@class, ' topic/sl ')]" name="topic.sl">
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<xsl:call-template name="setaname"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[contains(@class, ' hazard-d/howtoavoid ')]">
				<ul style="list-style-type:disc">
					<xsl:call-template name="commonattributes"> </xsl:call-template>
					<xsl:apply-templates select="@compact"/>
					<xsl:call-template name="setid"/>
					<xsl:apply-templates/>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<ul class="simple">
					<xsl:call-template name="commonattributes">
						<xsl:with-param name="default-output-class" select="'simple'"/>
					</xsl:call-template>
					<xsl:apply-templates select="@compact"/>
					<xsl:call-template name="setid"/>
					<xsl:apply-templates/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' hazard-d/messagepanel ')]">
		<!-- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -->
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<xsl:call-template name="setaname"/>
		<ul>
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates select="@compact"/>
			<xsl:call-template name="setid"/>
			<xsl:apply-templates/>
		</ul>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	
<!--
	<xsl:template match="*[contains(@class, ' topic/ul ')]" mode="ul-fmt">
		<xsl:choose>
			<xsl:when test="contains(@outputclass, 'show_hide') and @id">
				<p>
					&lt;!&ndash;<div class="p collapsible">&ndash;&gt;
					<xsl:call-template name="commonattributes"/>
					<xsl:call-template name="setid"/>
					<xsl:element name="a">
					&lt;!&ndash;	<xsl:attribute name="onclick">
							<xsl:text>javascript:toggleTwisty('</xsl:text>
							<xsl:value-of select="@id"/>
							<xsl:text>');</xsl:text>
						</xsl:attribute>&ndash;&gt;
						<xsl:element name="img">
							<xsl:attribute name="class">show_hide_expanded</xsl:attribute>
							<xsl:attribute name="src">
								<xsl:value-of
									select="concat('oxygen-webhelp/resources/img/', 'collapse.gif')"
								/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
						&lt;!&ndash; This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. &ndash;&gt;
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
							mode="out-of-line"/>
						<xsl:call-template name="setaname"/>
						<ul>
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates select="@compact"/>
							<xsl:call-template name="setid"/>
							<xsl:apply-templates/>
						</ul>
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
							mode="out-of-line"/>
						<xsl:value-of select="$newline"/>
					</xsl:element>
					&lt;!&ndash;</div>&ndash;&gt;
				</p>
				&lt;!&ndash;<script type="text/javascript">
					<xsl:text>hideTwisty('</xsl:text>
					<xsl:value-of select="@id"/>
					<xsl:text>');</xsl:text>
				</script>&ndash;&gt;
			</xsl:when>
			<xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
				<p>
					&lt;!&ndash;<div class="p collapsible">&ndash;&gt;
					<xsl:call-template name="commonattributes"/>
					<xsl:call-template name="setid"/>
					<xsl:element name="a">
						&lt;!&ndash;<xsl:attribute name="onclick">
							<xsl:text>javascript:toggleTwisty('</xsl:text>
							<xsl:value-of select="@id"/>
							<xsl:text>');</xsl:text>
						</xsl:attribute>&ndash;&gt;
						<xsl:element name="img">
							<xsl:attribute name="class">show_hide_expanded</xsl:attribute>
							<xsl:attribute name="src">
								<xsl:value-of
									select="concat('oxygen-webhelp/resources/img/', 'expanded.gif')"
								/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">
							<xsl:value-of select="@id"/>
						</xsl:attribute>
						&lt;!&ndash; This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. &ndash;&gt;
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
							mode="out-of-line"/>
						<xsl:call-template name="setaname"/>
						<ul>
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates select="@compact"/>
							<xsl:call-template name="setid"/>
							<xsl:apply-templates/>
						</ul>
						<xsl:apply-templates
							select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
							mode="out-of-line"/>
						<xsl:value-of select="$newline"/>
					</xsl:element>
					&lt;!&ndash;</div>&ndash;&gt;
				</p>
			</xsl:when>
			<xsl:otherwise>
				&lt;!&ndash; This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. &ndash;&gt;
				<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
					mode="out-of-line"/>
				<xsl:call-template name="setaname"/>
				<ul>
					<xsl:apply-templates select="@compact"/>
					<xsl:call-template name="setid"/>
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>
				</ul>
				<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
					mode="out-of-line"/>
				<xsl:value-of select="$newline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
-->

	
<!--
	<xsl:template match="*[contains(@class, ' topic/fig ')]" name="topic.fig">
		&lt;!&ndash; OXYGEN PATCH START  EXM-18109 - moved image caption below. &ndash;&gt;
		&lt;!&ndash;<xsl:apply-templates
        select="*[not(contains(@class,' topic/title '))][not(contains(@class,' topic/desc '))] |text()|comment()|processing-instruction()"/>&ndash;&gt;
		&lt;!&ndash;<xsl:call-template name="place-fig-lbl"/>&ndash;&gt;
		&lt;!&ndash; OXYGEN PATCH END  EXM-18109 &ndash;&gt;
		<xsl:choose>
			<xsl:when test="contains(@outputclass, 'show_hide') and @id">
				<p>
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					&lt;!&ndash;<div class="p collapsible">&ndash;&gt;
					<xsl:call-template name="commonattributes"/>
					&lt;!&ndash;<xsl:call-template name="setid"/>&ndash;&gt;
					<xsl:call-template name="place-fig-lbl"/>
					<xsl:text>  </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="style">padding-left:6pt;</xsl:attribute>
						&lt;!&ndash;<xsl:attribute name="onclick">
							<xsl:text>javascript:toggleTwisty('</xsl:text>
							<xsl:value-of select="generate-id(@id)"/>
							<xsl:text>');</xsl:text>
						</xsl:attribute>&ndash;&gt;
						<xsl:element name="img">
							<xsl:attribute name="class">show_hide_expanded</xsl:attribute>
							<xsl:attribute name="src">
								<xsl:value-of
									select="concat('oxygen-webhelp/resources/img/', 'collapse.gif')"
								/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(@id)"/>
						</xsl:attribute>
						<xsl:apply-templates select="." mode="fig-fmt"/>
					</xsl:element>
					&lt;!&ndash;</div>&ndash;&gt;
				</p>
				&lt;!&ndash;<script type="text/javascript">
					<xsl:text>hideTwisty('</xsl:text>
					<xsl:value-of select="generate-id(@id)"/>
					<xsl:text>');</xsl:text>
				</script>&ndash;&gt;
			</xsl:when>
			<xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
				<p>
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					&lt;!&ndash;<div class="p collapsible">&ndash;&gt;
					<xsl:call-template name="commonattributes"/>
					&lt;!&ndash;<xsl:call-template name="setid"/>&ndash;&gt;
					<xsl:call-template name="place-fig-lbl"/>
					<xsl:text>  </xsl:text>
					<xsl:element name="a">
						&lt;!&ndash;<xsl:attribute name="onclick">
							<xsl:text>javascript:toggleTwisty('</xsl:text>
							<xsl:value-of select="generate-id(@id)"/>
							<xsl:text>');</xsl:text>
						</xsl:attribute>&ndash;&gt;
						<xsl:element name="img">
							<xsl:attribute name="class">show_hide_expanded</xsl:attribute>
							<xsl:attribute name="src">
								<xsl:value-of
									select="concat('oxygen-webhelp/resources/img/', 'expanded.gif')"
								/>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					<xsl:element name="div">
						<xsl:attribute name="id">
							<xsl:value-of select="generate-id(@id)"/>
						</xsl:attribute>
						<xsl:apply-templates select="." mode="fig-fmt"/>
					</xsl:element>
					&lt;!&ndash;</div>&ndash;&gt;
				</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="fig-fmt"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
-->

	
	<xsl:template name="topic-image">
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<img>
			<xsl:call-template name="commonattributes">
				<xsl:with-param name="default-output-class">
					<xsl:choose>
						<xsl:when test="@placement = 'break' or not(@placement)">
							<!--Align only works for break-->
							<xsl:choose>
								<xsl:when test="@align = 'left'">imageleft</xsl:when>
								<xsl:when test="@align = 'right'">imageright</xsl:when>
								<xsl:when test="@align = 'center'">imagecenter</xsl:when>
								<xsl:otherwise>break</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="@placement = 'inline'">inline</xsl:when>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="setid"/>
			<xsl:choose>
				<xsl:when test="*[contains(@class, ' topic/longdescref ')]">
					<xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="@longdescref"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@href | @height | @width"/>
			<xsl:apply-templates select="@scale | @scalefit"/>
			<xsl:choose>
				<xsl:when test="*[contains(@class, ' topic/alt ')]">
					<xsl:variable name="alt-content">
						<xsl:apply-templates select="*[contains(@class, ' topic/alt ')]"
							mode="text-only"/>
					</xsl:variable>
					<xsl:attribute name="alt" select="normalize-space($alt-content)"/>
				</xsl:when>
				<xsl:when test="@alt">
					<xsl:attribute name="alt" select="@alt"/>
				</xsl:when>
			</xsl:choose>
		</img>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/image ')]/@scalefit">
		<xsl:attribute name="width">
			<xsl:text>100%</xsl:text>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/image ')]/@width">
		<xsl:variable name="width-in-pixel">
			<xsl:call-template name="length-to-pixels">
				<xsl:with-param name="dimen" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="not($width-in-pixel = '100%')">
			<xsl:attribute name="width">
				<xsl:choose>
					<xsl:when test="../@scalefit">
						<xsl:text>100%</xsl:text>
					</xsl:when>
					<!--xsl:when test="../@scale and string(number(../@scale))!='NaN'">
            <xsl:value-of select="number($width-in-pixel) * number(../@scale)"/>
          </xsl:when>-->
					<xsl:otherwise>
						<xsl:value-of select="number($width-in-pixel)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="width">
				<!--xsl:choose>
        <xsl:when test="../@scale and string(number(../@scale))!='NaN'">
          <xsl:value-of select="number($width-in-pixel) * number(../@scale)"/>
        </xsl:when>
        <xsl:otherwise-->
				<xsl:value-of select="number($width-in-pixel)"/>
				<!--/xsl:otherwise>
      </xsl:choose-->
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<!-- Figure title below image US278 MJT:FMC 6/27/2016 -->
	<xsl:template match="*[contains(@class, ' topic/fig ')]" mode="fig-fmt">
		<!-- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -->
		<xsl:variable name="default-fig-class">
			<xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
		</xsl:variable>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<!-- Comtech 07/18/2013 change <div> to <figure> -->
		<!-- US285 List alignment MJT:FMC 8/19/2016 -->
		<xsl:choose>
			<xsl:when test="(@expanse = 'page' or @pgwide = '1')">
				<div>
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="ancestor::*[contains(@class, ' topic/li ')]">
								<xsl:value-of select="'page-wide-list-'"/>
								<xsl:value-of
									select="count(ancestor::*[contains(@class, ' topic/li ')])"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'page-wide'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<figure>
						<xsl:if test="$default-fig-class != ''">
							<xsl:attribute name="class">
								<xsl:value-of select="$default-fig-class"/>
							</xsl:attribute>
						</xsl:if>
						<!-- US61 honor @expanse for figures in lists, etc. MJT:FMC 7/24/2016 -->
						<xsl:choose>
							<xsl:when test="(@expanse = 'page' or @pgwide = '1')">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:choose>
									<xsl:when
										test="ancestor::*[contains(@class, ' topic/ol ')] | ancestor::*[contains(@class, ' topic/ul ')]">
										<xsl:variable name="indentDecrement">
											<xsl:value-of
												select="count(ancestor::*[contains(@class, ' topic/ol ')] | ancestor::*[contains(@class, ' topic/ul ')])"
											/>
										</xsl:variable>
										<xsl:attribute name="style">
											<!--   <xsl:value-of select="concat('margin-left: -', $indentDecrement * 40, 'px;')"/>-->
											<!-- not working now that I introduced list margins -->
											<xsl:text>margin-right: 0; padding-left: 0; padding-right: 0;</xsl:text>
										</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<!--<xsl:attribute name="style">margin-left: -40px; margin-right: 0; padding-left: 0; padding-right: 0;</xsl:attribute>-->
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="(@expanse = 'column' or @pgwide = '0')">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="style">margin-left: 0; margin-right: 0;
									padding-left: 0; padding-right: 0;</xsl:attribute>
							</xsl:when>
						</xsl:choose>
						<xsl:call-template name="setscale"/>
						<xsl:call-template name="setidaname"/>
						<xsl:call-template name="setid"/>
						<xsl:call-template name="commonattributes">
							<xsl:with-param name="default-output-class" select="$default-fig-class"
							/>
						</xsl:call-template>
						<xsl:if test="not(ancestor-or-self::*[contains(@outputclass, 'show_hide')])">
							<xsl:call-template name="place-fig-lbl"/>
						</xsl:if>
						<!-- OXYGEN PATCH START  EXM-18109 -->
						<xsl:apply-templates
							select="*[not(contains(@class, ' topic/title '))][not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"/>
						<!-- OXYGEN PATCH END  EXM-18109 -->
					</figure>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<figure>
					<xsl:if test="$default-fig-class != ''">
						<xsl:attribute name="class">
							<xsl:value-of select="$default-fig-class"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="setscale"/>
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="setid"/>
					<xsl:call-template name="commonattributes">
						<xsl:with-param name="default-output-class" select="$default-fig-class"/>
					</xsl:call-template>
					<xsl:if test="not(ancestor-or-self::*[contains(@outputclass, 'show_hide')])">
						<xsl:call-template name="place-fig-lbl"/>
					</xsl:if>
					<!-- OXYGEN PATCH START  EXM-18109 -->
					<xsl:apply-templates
						select="*[not(contains(@class, ' topic/title '))][not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"/>
					<!-- OXYGEN PATCH END  EXM-18109 -->
				</figure>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<xsl:template name="place-fig-lbl">
		<xsl:param name="id"/>
		<!-- Number of fig/title's including this one -->
		<xsl:variable name="fig-count-actual"
			select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]) + 1"/>
		<xsl:variable name="ancestorlang">
			<xsl:call-template name="getLowerCaseLang"/>
		</xsl:variable>
		<xsl:choose>
			<!-- title -or- title & desc -->
			<xsl:when test="*[contains(@class, ' topic/title ')]">
				<!-- OXYGEN PATCH START  EXM-18109 -->
				<!--<span class="figcap">-->
				<xsl:choose>
					<xsl:when test="ancestor-or-self::*[contains(@outputclass, 'show_hide')]">
						<xsl:apply-templates select="*[contains(@class, ' topic/title ')]"
							mode="figtitle"/>
					</xsl:when>
					<xsl:otherwise>
						<p style="font-weight:bold">
							<xsl:choose>
								<xsl:when
									test="*[contains(@class, ' topic/image ')][@placement = 'break'][@align = 'center']">
									<xsl:attribute name="class">figcapcenter</xsl:attribute>
								</xsl:when>
								<xsl:when
									test="*[contains(@class, ' topic/image ')][@placement = 'break'][@align = 'right']">
									<xsl:attribute name="class">figcapright</xsl:attribute>
								</xsl:when>
								<xsl:when
									test="*[contains(@class, ' topic/image ')][@placement = 'break'][@align = 'justify']">
									<xsl:attribute name="class">figcapjustify</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="class">figcap</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<!-- FMC 03/10/2015 Add Figure gentext from the Table titles -->
							<xsl:choose>
								<!-- Hungarian: "1. Figure " -->
								<xsl:when
									test="((string-length($ancestorlang) = 5 and contains($ancestorlang, 'hu-hu')) or (string-length($ancestorlang) = 2 and contains($ancestorlang, 'hu')))">
									<xsl:value-of select="$fig-count-actual"/>
									<xsl:text>. </xsl:text>
									<xsl:call-template name="getWebhelpString">
										<xsl:with-param name="stringName" select="'Figure'"/>
									</xsl:call-template>
									<xsl:text> </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getWebhelpString">
										<xsl:with-param name="stringName" select="'Figure'"/>
									</xsl:call-template>
									<xsl:text> </xsl:text>
									<xsl:value-of select="$fig-count-actual"/>
									<xsl:text>. </xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							<!-- OXYGEN PATCH END  EXM-18109 -->
							<xsl:apply-templates select="*[contains(@class, ' topic/title ')]"
								mode="figtitle"/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="*[contains(@class, ' topic/desc ')]">
					<p class="figdesc">
						<xsl:for-each select="*[contains(@class, ' topic/desc ')]">
							<xsl:call-template name="commonattributes"/>
						</xsl:for-each>
						<xsl:apply-templates select="*[contains(@class, ' topic/desc ')]"
							mode="figdesc"/>
					</p>
				</xsl:if>
			</xsl:when>
			<!-- desc -->
			<xsl:when test="*[contains(@class, ' topic/desc ')]">
				<p class="figdesc">
					<xsl:for-each select="*[contains(@class, ' topic/desc ')]">
						<xsl:call-template name="commonattributes"/>
					</xsl:for-each>
					<xsl:apply-templates select="*[contains(@class, ' topic/desc ')]" mode="figdesc"
					/>
				</p>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')]"
		mode="figdesc">
		<!-- Comtech 07/18/2013 added <figurecaption> -->
		<figurecaption>
			<xsl:apply-templates/>
		</figurecaption>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/example ')]" name="topic.example">
		<div class="example">
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="gen-toc-id"/>
			<xsl:call-template name="setidaname"/>
			<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
				mode="out-of-line"/>
			<xsl:apply-templates select="." mode="dita2html:section-heading"/>
			<xsl:apply-templates
				select="*[not(contains(@class, ' topic/title '))] | text() | comment() | processing-instruction()"/>
			<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
				mode="out-of-line"/>
		</div>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]"
		mode="figtitle">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="/|node()|@*" mode="gen-user-footer" priority="10">
		<div class="navfooter">
			<xsl:choose>
				<xsl:when test="$FTR = 'internet'">
					<div class="ftrcustom">
						<p>
							<!--<xsl:call-template name="getWebhelpString">
                <xsl:with-param name="stringName" select="'Footer Text'"/>
              </xsl:call-template>-->
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
							<!--<a HREF="javascript:window.print()">
            <img src="oxygen-webhelp/resources/img/print.gif" border="0" alt="botom"/>
          </a> |
          <script>
              document.write('<a href="mailto:ge@ge-support.com?subject=URL of Help Page&amp;body='+top.location.href+'"><img src="oxygen-webhelp/resources/img/email.gif" border="0" align="top"/></a>');
            </script>-->
						</p>
						<img src="oxygen-webhelp/resources/img/GEmeatball.png" alt="GE Logo"
							width="50pt" height="50pt"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/data ')]">
		<xsl:element name="span">
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/data ')]" mode="meta-info">
		<xsl:element name="span">
			<!--   <xsl:call-template name="commonattributes-meta"/>-->
			<xsl:apply-templates mode="meta-info"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' sw-d/msgph ')]">
		<samp class="msgph">
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="setidaname"/>
			<xsl:text>(</xsl:text>
			<xsl:call-template name="getWebhelpString">
				<xsl:with-param name="stringName" select="'msgph-For'"/>
			</xsl:call-template>
			<xsl:value-of select="' '"/>
			<xsl:apply-templates/>
			<!--      <xsl:call-template name="getWebhelpString">
        <xsl:with-param name="stringName" select="'ColonSymbol'"/>
      </xsl:call-template>-->
			<xsl:text>) </xsl:text>
		</samp>
	</xsl:template>
	
	<xsl:template name="profiling-atts">
		<xsl:choose>
			<xsl:when test="upper-case($PRM_OUTPUT_PROFILING_VALUES) = 'YES'">
				<xsl:if test="not(@href)">
					<xsl:for-each select="@*">
						<xsl:if
							test="local-name() = 'audience' or local-name() = 'platform' or local-name() = 'rev' or local-name() = 'otherprops' or local-name() = 'product'">
							<!--<xsl:attribute name="data-{local-name()}"><xsl:value-of select="."/></xsl:attribute>-->
							<span style="background-color:pink;font-weight:bold;display: block;">
								<xsl:text>[</xsl:text>
								<xsl:value-of select="local-name()"/>
								<xsl:text>: </xsl:text>
								<xsl:value-of select="."/>
								<xsl:text>]</xsl:text>
							</span>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>
	

	
	<!-- Comtech Services 09/09/2013 added to conditionalize the footnotes for tables -->
	<!-- render any contained footnotes as endnotes.  Links back to reference point -->
	<xsl:template name="gen-endnotes">
		<!-- Skip any footnotes that are in draft elements when draft = no -->
		<xsl:apply-templates
			select="//*[contains(@class, ' topic/fn ')][not((ancestor::*[contains(@class, ' topic/draft-comment ')] or ancestor::*[contains(@class, ' topic/required-cleanup ')] or ancestor::*[contains(@class, ' topic/table ')] or ancestor::*[contains(@class, ' task/choicetable ')] or ancestor::*[contains(@class, ' topic/simpletable ')]))]"
			mode="genEndnote"/>
	</xsl:template>
	<xsl:template name="gen-endnotes-tablefooter">
		<!-- Skip any footnotes that are in draft elements when draft = no -->
		<xsl:apply-templates select="descendant-or-self::*[contains(@class, ' topic/fn ')]"
			mode="genEndnote"/>
	</xsl:template>
	<!-- Comtech Services 09/09/2013 added to conditionalize the footnotes for tables with letter callouts and other callouts with number callouts -->
	<!-- Footnote source and target not working in tables US271 Defect MJT:FMC 7/12/2016 -->
	<xsl:template match="*[contains(@class, ' topic/fn ')]" name="topic.fn">
		<xsl:param name="xref"/>
		<!-- when FN has an ID, it can only be referenced, otherwise, output an a-name & a counter -->
		<!--<xsl:if test="not(@id) or $xref='yes'">-->
		<xsl:variable name="fnid">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*[contains(@class, ' task/choicetable ')]">
					<xsl:number
						value="count(preceding::fn[ancestor-or-self::choicetable]) + 1 - count(preceding::choicetable/descendant-or-self::fn)"
						format="a"/>
				</xsl:when>
				<xsl:when test="ancestor-or-self::*[contains(@class, ' topic/simpletable ')]">
					<xsl:number
						value="count(preceding::fn[ancestor-or-self::simpletable]) + 1 - count(preceding::simpletable/descendant-or-self::fn)"
						format="a"/>
				</xsl:when>
				<xsl:when test="ancestor-or-self::*[contains(@class, ' topic/table ')]">
					<xsl:number
						value="count(preceding::fn[ancestor-or-self::table]) + 1 - count(preceding::table/descendant-or-self::fn)"
						format="a"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:number
						value="count(preceding::*[contains(@class, ' topic/fn ')][not(ancestor-or-self::*[contains(@class, ' topic/table ')] or ancestor-or-self::*[contains(@class, ' topic/simpletable ')])]) + 1"
						format="1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="callout">
			<xsl:value-of select="@callout"/>
		</xsl:variable>
		<xsl:variable name="convergedcallout">
			<xsl:choose>
				<xsl:when test="string-length($callout) > 0">
					<xsl:value-of select="$callout"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$fnid"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@id">
				<xsl:variable name="idValue">
					<xsl:value-of select="@id"/>
				</xsl:variable>
				<a id="{$idValue}" href="#fntarg_{$fnid}"
					style="display:inline-block;           border:none;           padding-bottom:2px;text-decoration:none;vertical-align:top;">
					<sup style="border-bottom:1px solid blue;">
						<xsl:value-of select="$convergedcallout"/>
					</sup>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ancestor-or-self::*[contains(@class, ' task/choicetable ')]">
						<a id="fnsrc_{$fnid}" href="#fntarg_{$fnid}"
							style="display:inline-block;               border:none;               padding-bottom:2px;text-decoration:none;vertical-align:top;">
							<sup style="border-bottom:1px solid blue;">
								<xsl:value-of select="$convergedcallout"/>
							</sup>
						</a>
					</xsl:when>
					<xsl:when test="ancestor-or-self::*[contains(@class, ' topic/simpletable ')]">
						<a id="fnsrc_{$fnid}" href="#fntarg_{$fnid}"
							style="display:inline-block;               border:none;               padding-bottom:2px;text-decoration:none;vertical-align:top;">
							<sup style="border-bottom:1px solid blue;">
								<xsl:value-of select="$convergedcallout"/>
							</sup>
						</a>
					</xsl:when>
					<xsl:when test="ancestor-or-self::*[contains(@class, ' topic/table ')]">
						<a id="fnsrc_{$fnid}" href="#fntarg_{$fnid}"
							style="display:inline-block;               border:none;               padding-bottom:2px;text-decoration:none;vertical-align:top;">
							<sup style="border-bottom:1px solid blue;">
								<xsl:value-of select="$convergedcallout"/>
							</sup>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a id="fnsrc_{$fnid}" href="#fntarg_{$fnid}"
							style="display:inline-block;               border:none;               padding-bottom:2px;text-decoration:none;vertical-align:top;">
							<sup style="border-bottom:1px solid blue;">
								<xsl:value-of select="$convergedcallout"/>
							</sup>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<!--</xsl:if>-->
	</xsl:template>
	
	
	<!-- Comtech Services 09/09/2013 added to conditionalize the footnotes for tables with letter callouts and other callouts with number callouts -->
	<xsl:template match="*[contains(@class, ' topic/fn ')]" mode="genEndnote">
		<div class="p">
			<xsl:variable name="fnid">
				<xsl:choose>
					<xsl:when test="ancestor-or-self::*[contains(@class, ' task/choicetable ')]">
						<xsl:number
							value="count(preceding::fn[ancestor-or-self::choicetable]) + 1 - count(preceding::choicetable/descendant-or-self::fn)"
							format="a"/>
					</xsl:when>
					<xsl:when test="ancestor-or-self::*[contains(@class, ' topic/simpletable ')]">
						<xsl:number
							value="count(preceding::fn[ancestor-or-self::simpletable]) + 1 - count(preceding::simpletable/descendant-or-self::fn)"
							format="a"/>
					</xsl:when>
					<xsl:when test="ancestor-or-self::*[contains(@class, ' topic/table ')]">
						<xsl:number
							value="count(preceding::fn[ancestor-or-self::table]) + 1 - count(preceding::table/descendant-or-self::fn)"
							format="a"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number
							value="count(preceding::*[contains(@class, ' topic/fn ')][not(ancestor-or-self::*[contains(@class, ' topic/table ')] or ancestor-or-self::*[contains(@class, ' topic/simpletable ')])]) + 1"
							format="1"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="callout">
				<xsl:value-of select="@callout"/>
			</xsl:variable>
			<xsl:variable name="convergedcallout">
				<xsl:choose>
					<xsl:when test="string-length($callout) > 0">
						<xsl:value-of select="$callout"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$fnid"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="commonattributes"/>
			<!--<xsl:choose>
        <xsl:when test="@id and not(@id='')">
          <xsl:variable name="topicid">
            <xsl:value-of select="ancestor::*[contains(@class,' topic/topic ')][1]/@id"/>
          </xsl:variable>
          <xsl:variable name="refid">
            <xsl:value-of select="$topicid"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@id"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="key('xref',$refid)">
              <a>
                <xsl:call-template name="setid"/>
                <sup>
                  <xsl:value-of select="$convergedcallout"/>
                </sup>
              </a>
              <xsl:text>  </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <sup>
                <xsl:value-of select="$convergedcallout"/>
              </sup>
              <xsl:text>  </xsl:text>
            </xsl:otherwise>
          </xsl:choose>

        </xsl:when>
        <xsl:otherwise>-->
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*[contains(@class, ' task/choicetable ')]">
					<a
						style="display:inline-block;             border:none;             padding-bottom:2px;text-decoration:none;vertical-align:top;">
						<xsl:attribute name="id">
							<xsl:text>fntarg_</xsl:text>
							<xsl:value-of select="$fnid"/>
						</xsl:attribute>
						<xsl:attribute name="href">
							<xsl:text>#fnsrc_</xsl:text>
							<xsl:value-of select="$fnid"/>
						</xsl:attribute>
						<sup style="border-bottom:1px solid blue;">
							<xsl:value-of select="$convergedcallout"/>
						</sup>
					</a>
					<xsl:text>  </xsl:text>
					<!--        </xsl:otherwise>
      </xsl:choose>-->
				</xsl:when>
				<xsl:when test="ancestor-or-self::*[contains(@class, ' topic/simpletable ')]">
					<a
						style="display:inline-block;             border:none;             padding-bottom:2px;text-decoration:none;vertical-align:top;">
						<xsl:attribute name="id">
							<xsl:text>fntarg_</xsl:text>
							<xsl:value-of select="$fnid"/>
						</xsl:attribute>
						<xsl:attribute name="href">
							<xsl:text>#fnsrc_</xsl:text>
							<xsl:value-of select="$fnid"/>
						</xsl:attribute>
						<sup style="border-bottom:1px solid blue;">
							<xsl:value-of select="$convergedcallout"/>
						</sup>
					</a>
					<xsl:text>  </xsl:text>
					<!--        </xsl:otherwise>
      </xsl:choose>-->
				</xsl:when>
				<xsl:when test="ancestor-or-self::*[contains(@class, ' topic/table ')]">
					<a
						style="display:inline-block;             border:none;             padding-bottom:2px;text-decoration:none;vertical-align:top;">
						<xsl:attribute name="id">
							<xsl:text>fntarg_</xsl:text>
							<xsl:value-of select="$fnid"/>
						</xsl:attribute>
						<xsl:attribute name="href">
							<xsl:text>#fnsrc_</xsl:text>
							<xsl:value-of select="$fnid"/>
						</xsl:attribute>
						<sup style="border-bottom:1px solid blue;">
							<xsl:value-of select="$convergedcallout"/>
						</sup>
					</a>
					<xsl:text>  </xsl:text>
					<!--        </xsl:otherwise>
      </xsl:choose>-->
				</xsl:when>
				<xsl:otherwise>
					<a
						style="display:inline-block;             border:none;             padding-bottom:2px;text-decoration:none;vertical-align:top;">
						<xsl:attribute name="id">
							<xsl:text>fntarg_</xsl:text>
							<xsl:value-of select="$fnid"/>
						</xsl:attribute>
						<xsl:attribute name="href">
							<xsl:text>#fnsrc_</xsl:text>
							<xsl:value-of select="$fnid"/>
						</xsl:attribute>
						<sup style="border-bottom:1px solid blue;">
							<xsl:value-of select="$convergedcallout"/>
						</sup>
					</a>
					<xsl:text>  </xsl:text>
					<!--        </xsl:otherwise>
      </xsl:choose>-->
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	
	
	
	<!-- US204 add support for specifying an HTML target type MJT:FMC 08/04/2016 -->
	<xsl:template match="*" mode="add-link-target-attribute">
		<xsl:if
			test="@scope = 'external' or @type = 'external' or ((@format = 'PDF' or @format = 'pdf') and not(@scope = 'local')) and not(@outputclass = 'newtarget')">
			<xsl:attribute name="target">_blank</xsl:attribute>
		</xsl:if>
		<xsl:if
			test="((@format = 'PDF' or @format = 'pdf') and @scope = 'local') and not(@outputclass = 'newtarget')">
			<xsl:attribute name="target">_blank</xsl:attribute>
		</xsl:if>
		<xsl:if test="@outputclass = 'newtarget'">
			<xsl:attribute name="target">newtarget</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	
	<!-- Comtech Services 09/09/2013 added to manage html5 video objects -->
	<!-- object, desc, & param -->
	<xsl:template match="*[contains(@class, ' topic/object ')]" name="topic.object">
		<iframe>
			<xsl:copy-of
				select="@id | @declare | @codebase | @type | @archive | @height | @usemap | @tabindex | @classid | @data | @codetype | @standby | @width | @name"/>
			<xsl:attribute name="frameborder">0</xsl:attribute>
			<xsl:if test="@longdescref or *[contains(@class, ' topic/longdescref ')]">
				<xsl:apply-templates select="." mode="ditamsg:longdescref-on-object"/>
			</xsl:if>
			<xsl:apply-templates select="." mode="ditamsg:webhelp-object"/>
			<xsl:apply-templates/>
			<!--
      <xsl:attribute name="frameborder">0</xsl:attribute>
      <xsl:text> </xsl:text>-->
		</iframe>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' topic/param ')]" name="topic.param">
		<xsl:choose>
			<xsl:when test="@name = 'movie'">
				<xsl:choose>
					<xsl:when test="contains(@value, 'watch?')">
						<xsl:variable name="firstPart">
							<xsl:value-of select="substring-after(@value, 'watch?v=')"/>
						</xsl:variable>
						<xsl:attribute name="src">
							<xsl:copy-of
								select="concat('http://www.youtube.com/embed/',substring-before($firstPart,'&amp;'))"
							/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="contains(@value, '?')">
						<xsl:variable name="firstPart">
							<xsl:value-of
								select="substring-after(substring-before(@value, '?'), '/v/')"/>
						</xsl:variable>
						<xsl:attribute name="src">
							<xsl:copy-of
								select="concat('http://www.youtube.com/embed/', $firstPart)"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="src">
							<xsl:copy-of select="@value"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="name">
					<xsl:copy-of select="@value"/>
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="*[contains(@class, ' topic/xref ')]" name="topic.xref">
		<xsl:variable name="ancestorlang">
			<xsl:call-template name="getLowerCaseLang"/>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="@href and normalize-space(@href) != ''">
				<xsl:apply-templates select="." mode="add-xref-highlight-at-start"/>
				<a>
					<xsl:if test="contains(@href, '_g_')">
						<xsl:attribute name="target">_blank</xsl:attribute>
					</xsl:if>
					<xsl:call-template name="commonattributes"/>
					
					<xsl:apply-templates select="." mode="add-linking-attributes"/>
					
					<!-- GEHC-19 -->
					<!-- Rally ID DE72 -->
					<!-- 2017-11-09: get the href attribute into a variable -->
					<!--xsl:apply-templates select="." mode="add-linking-attributes"/-->
					<!--					<xsl:variable name="getHREF">
						<HREF>
							<xsl:apply-templates select="." mode="add-linking-attributes"/>
						</HREF>
					</xsl:variable>

					<!-\- test if the xref has @outputclass = newtarget -\->
					<xsl:choose>
						<xsl:when test="@outputclass = 'newtarget'">
							<!-\- make the @href # -\->
							<xsl:attribute name="href" select="'#'" />

							<!-\- create an apos via a variable -\->
							<xsl:variable name="apos">'</xsl:variable>

							<!-\- add _Popup to the href -\->
							<xsl:variable name="addPopupToHREF">
								<xsl:variable name="b4HTML" select="substring-before($getHREF/child::*/@href, '.htm')" />
								<xsl:variable name="afterFilename" select="substring-after($getHREF/child::*/@href, $b4HTML)" />
								<xsl:value-of select="concat($apos, $b4HTML, '_Popup', $afterFilename, $apos)" />
							</xsl:variable>


							<!-\- create the onclick string -\->
							<!-\- GEHC-19 -\->
							<!-\- Rally ID DE72 -\->
							<!-\- 2017-11-12: use var popupWindow and popupWindow.focus(); -\->
							<!-\-xsl:apply-templates select="." mode="add-linking-attributes"/-\->
							<!-\-xsl:variable name="onclickString" select="concat('var popupWindow = window.open(', $addPopupToHREF, ', ', $apos, 'mywin', $apos, ', ',  $apos, 'left=800,top=260,width=600,height=600,toolbar=yes,resizable=yes,scrollbars=yes', $apos, '); popupWindow.focus();  return false')" /-\->
							<xsl:variable name="onclickString" select="concat('var popupWindow = window.open(', $addPopupToHREF, ', ', $apos, 'mywin', $apos, ', ',  $apos, 'left=800,top=260,width=600,height=600,toolbar=yes,resizable=yes,scrollbars=yes', $apos, '); popupWindow.focus();  return false')" />


							<!-\- output the onclick attribute with the value of onclickString -\->
							<xsl:attribute name="onclick" select="$onclickString" />
							<!-\- orginal code -\->
							<!-\-xsl:attribute name="onclick">window.open(this.href, 'mywin', 'left=800,top=260,width=600,height=600,toolbar=yes,resizable=yes,scrollbars=yes'); return false</xsl:attribute-\->
						</xsl:when>

						<xsl:otherwise>
							<xsl:attribute name="href" select="$getHREF/child::*/@href" />
						</xsl:otherwise>
					</xsl:choose>-->
					
					
					<xsl:apply-templates select="." mode="add-desc-as-hoverhelp"/>
					<!-- if there is text or sub element other than desc, apply templates to them otherwise, use the href as the value of link text. -->
					<xsl:choose>
						<xsl:when test="@type = 'fn'">
							<sup>
								<xsl:choose>
									<xsl:when
										test="*[not(contains(@class, ' topic/desc '))] | text()">
										<!--                    <xsl:variable name="prevFN">
                      <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ')])"/>
                    </xsl:variable>-->
										<xsl:choose>
											<xsl:when
												test="ancestor-or-self::*[contains(@class, 'table')]">
												<xsl:number format="I"
													value="count(preceding::*/*[contains(@class, ' topic/fn ')][ancestor-or-self::*[contains(@class, 'table')]])">
													<!--<xsl:apply-templates select="*[not(contains(@class,' topic/desc '))]|text()"/>-->
												</xsl:number>
											</xsl:when>
											<xsl:otherwise>
												<!--                        <xsl:number format="1"
                          value="*[not(contains(@class,' topic/desc '))]|text()">-->
												<xsl:apply-templates
													select="*[not(contains(@class, ' topic/desc '))] | text()"/>
												<!--</xsl:number>-->
											</xsl:otherwise>
										</xsl:choose>
										<!--use xref content-->
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="href"/>
										<!--use href text-->
									</xsl:otherwise>
								</xsl:choose>
							</sup>
						</xsl:when>
						
						<xsl:when test="@type = 'step' or @type = 'substep'">
							<span>
								<xsl:call-template name="getString">
									<xsl:with-param name="stringName" select="'Xref_Step'"/>
								</xsl:call-template>
								<xsl:text> </xsl:text>
							</span>
							<xsl:apply-templates
								select="*[not(contains(@class, ' topic/desc '))] | text()"/>
						</xsl:when>
						
						<xsl:when test="@type = 'table'">
							<xsl:variable name="currentHref">
								<xsl:choose>
									<xsl:when
										test=".[contains(@href, '#')] and substring-before(@href, '#') != ''">
										<xsl:value-of
											select="concat($tempDir, '/', substring-before(@href, '#'))"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($tempDir, '\', @href)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="thisHref">
								<xsl:choose>
									<xsl:when
										test=".[contains(@href, '#')] and substring-before(@href, '#') = ''">
										<xsl:value-of select="$currentHref"/>
										<xsl:message>INTERNAL REF NO MAKEURL</xsl:message>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="oxygen:makeURL($currentHref)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="targetElem">
								<xsl:call-template name="substring-after-last">
									<xsl:with-param name="text" select="substring-after(@href, '#')"/>
									<xsl:with-param name="delim" select="'/'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="tbl-count-actual">
								<xsl:choose>
									<xsl:when
										test=".[contains(@href, '#')] and substring-before(@href, '#') = ''">
										<xsl:value-of
											select="count(//*[contains(@class, ' topic/table ')][@id = $targetElem]/preceding::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]) + 1"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="count(document($thisHref)//*[contains(@class, ' topic/table ')][@id = $targetElem]/preceding::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]) + 1"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<span>
								<xsl:choose>
									<!-- Hungarian: "1. Table " -->
									<xsl:when
										test="((string-length($ancestorlang) = 5 and contains($ancestorlang, 'hu-hu')) or (string-length($ancestorlang) = 2 and contains($ancestorlang, 'hu')))">
										<xsl:value-of select="$tbl-count-actual"/>
										<xsl:text>. </xsl:text>
										<xsl:call-template name="getString">
											<xsl:with-param name="stringName" select="'Table'"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="getString">
											<xsl:with-param name="stringName" select="'Table'"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$tbl-count-actual"/>
										<!-- NMM 04/23/2017: Remove title from figure or table xref generated text -->
										<!-- <xsl:text>. </xsl:text> -->
									</xsl:otherwise>
								</xsl:choose>
							</span>
							<!--              <span>
                <xsl:call-template name="getString">
                  <xsl:with-param name="stringName" select="'Table'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
              </span>
              <xsl:value-of select="$tbl-count-actual"/>-->
							<!--  <xsl:apply-templates select="*[not(contains(@class,' topic/desc '))]|text()"/>-->
						</xsl:when>
						
						
						
						<xsl:when test="@type = 'fig'">
							<xsl:variable name="currentHref">
								<xsl:choose>
									<xsl:when
										test=".[contains(@href, '#')] and substring-before(@href, '#') != ''">
										<xsl:value-of
											select="concat($tempDir, '/', substring-before(@href, '#'))"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="concat($tempDir, '\', @href)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="thisHref">
								<xsl:choose>
									<xsl:when
										test=".[contains(@href, '#')] and substring-before(@href, '#') = ''">
										<xsl:value-of select="$currentHref"/>
										<xsl:message>INTERNAL REF NO MAKEURL</xsl:message>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="oxygen:makeURL($currentHref)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="targetElem">
								<xsl:call-template name="substring-after-last">
									<xsl:with-param name="text" select="substring-after(@href, '#')"/>
									<xsl:with-param name="delim" select="'/'"/>
								</xsl:call-template>
							</xsl:variable>
							
							<xsl:variable name="fig-count-actual">
								<xsl:choose>
									<xsl:when
										test=".[contains(@href, '#')] and substring-before(@href, '#') = ''">
										<xsl:value-of
											select="count(//*[contains(@class, ' topic/fig ')][@id = $targetElem]/preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]) + 1"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="count(document($thisHref)//*[contains(@class, ' topic/fig ')][@id = $targetElem]/preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]) + 1"
										/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<span>
								<xsl:choose>
									<!-- Hungarian: "1. Figure " -->
									<xsl:when
										test="((string-length($ancestorlang) = 5 and contains($ancestorlang, 'hu-hu')) or (string-length($ancestorlang) = 2 and contains($ancestorlang, 'hu')))">
										<xsl:value-of select="$fig-count-actual"/>
										<xsl:text>. </xsl:text>
										<xsl:call-template name="getString">
											<xsl:with-param name="stringName" select="'Figure'"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
									</xsl:when>
									
									<xsl:otherwise>
										<xsl:call-template name="getString">
											<xsl:with-param name="stringName" select="'Figure'"/>
										</xsl:call-template>
										<xsl:text> </xsl:text>
										<xsl:value-of select="$fig-count-actual"/>
										<!-- NMM 04/23/2017: Remove title from figure or table xref generated text -->
										<!-- <xsl:text>. </xsl:text> -->
									</xsl:otherwise>
								</xsl:choose>
							</span>
						</xsl:when>
						
						
						
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
									<xsl:apply-templates
										select="*[not(contains(@class, ' topic/desc '))] | text()"/>
									<!--use xref content-->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="href"/>
									<!--use href text-->
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</a>
				<xsl:apply-templates select="." mode="add-xref-highlight-at-end"/>
			</xsl:when>
			<xsl:otherwise>
				<span>
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates select="." mode="add-desc-as-hoverhelp"/>
					<xsl:apply-templates
						select="*[not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"
					/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="*[contains(@class, ' topic/cite ')]">
		<xsl:variable name="lang">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*/@xml:lang">
					<xsl:value-of select="ancestor-or-self::*/@xml:lang"/>
				</xsl:when>
				<xsl:when test="$LANGUAGE">
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="prefix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">[</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#171;</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-cn')">&#171;</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#171;</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="suffix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">]</xsl:when>
				<xsl:when test="starts-with(lower-case(lower-case($lang)), 'ru')">&#187;</xsl:when>
				<xsl:when test="contains(lower-case(lower-case($lang)), 'zh-cn')">&#187;</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#187;</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<!--    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-->
		<xsl:choose>
			<xsl:when test="starts-with(lower-case($lang), 'ru')">
				<span class="cite" style="font-weight:normal;font-style:italic;">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:when>
			<xsl:when test="starts-with(lower-case($lang), 'ja')">
				<span class="cite" style="font-weight:normal;font-style:normal;">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:when>
			<xsl:when test="contains(lower-case($lang), 'zh-cn')">
				<span class="cite" style="font-weight:normal;font-style:normal;">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:when>
			<xsl:when test="contains(lower-case($lang), 'zh-tw')">
				<span class="cite" style="font-weight:normal;font-style:normal;">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="cite" style="font-style:italic;">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/q ')]">
		<xsl:variable name="lang">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*/@xml:lang">
					<xsl:value-of select="ancestor-or-self::*/@xml:lang"/>
				</xsl:when>
				<xsl:when test="$LANGUAGE">
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="prefix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">[</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#x300C;</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#171;</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'fr')">&#171; </xsl:when>
				<xsl:when
					test="starts-with(lower-case($lang), 'de') or starts-with(lower-case($lang), 'cs')"
					>&#8222;</xsl:when>
				<xsl:otherwise>&quot;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="suffix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">]</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#x300D;</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#187;</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'fr')"> &#187;</xsl:when>
				<xsl:when
					test="starts-with(lower-case($lang), 'de') or starts-with(lower-case($lang), 'cs')"
					>&#8220;</xsl:when>
				<xsl:otherwise>&quot;</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-->
		<span class="q">
			<xsl:value-of select="$prefix-char"/>
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix-char"/>
		</span>
	</xsl:template>
	
	<xsl:template
		match="*[contains(@class, ' ui-d/uicontrol ') or contains(@class, ' ui-d/wintitle ')]">
		<xsl:variable name="lang">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*/@xml:lang">
					<xsl:value-of select="ancestor-or-self::*/@xml:lang"/>
				</xsl:when>
				<xsl:when test="$LANGUAGE">
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="uicontrolcount">
			<xsl:number count="*[contains(@class, ' ui-d/uicontrol ')]"/>
		</xsl:variable>
		<xsl:if
			test="$uicontrolcount &gt; '1' and parent::*[contains(@class, ' ui-d/menucascade ')]">
			<xsl:text> > </xsl:text>
		</xsl:if>
		<xsl:variable name="prefix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#171;</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">[</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-cn')">“</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#x02308;</xsl:when>
				<!--<xsl:when test="ancestor::*[contains(@class,' ui-d/menucascade ')]">
          <xsl:variable name="uicontrolcount">
            <xsl:number count="*[contains(@class,' ui-d/uicontrol ')]"/>
          </xsl:variable>
          <xsl:if test="$uicontrolcount&gt;'1'">
            <xsl:text> > </xsl:text>
          </xsl:if>
        </xsl:when>-->
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="suffix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#187;</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">]</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-cn')">”</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#x0230B;</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<!--    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-->
		<xsl:choose>
			<xsl:when test="starts-with(lower-case($lang), 'ja')">
				<span class="uicontrol">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:when>
			<xsl:when test="starts-with(lower-case($lang), 'ru')">
				<span class="uicontrol">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:when test="contains(lower-case($lang), 'zh-tw')">
				<span class="uicontrol">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:when>
			<xsl:when test="contains(lower-case($lang), 'zh-cn')">
				<span class="uicontrol">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="uicontrol">
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' sw-d/userinput ')]">
		<xsl:variable name="lang">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*/@xml:lang">
					<xsl:value-of select="ancestor-or-self::*/@xml:lang"/>
				</xsl:when>
				<xsl:when test="$LANGUAGE">
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="uicontrolcount">
			<xsl:number count="*[contains(@class, ' ui-d/uicontrol ')]"/>
		</xsl:variable>
		<xsl:if test="$uicontrolcount &gt; '1'">
			<xsl:text> > </xsl:text>
		</xsl:if>
		<xsl:variable name="prefix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#171;</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">[</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-cn')">“</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#x02308;</xsl:when>
				<!--<xsl:when test="ancestor::*[contains(@class,' ui-d/menucascade ')]">
          <xsl:variable name="uicontrolcount">
            <xsl:number count="*[contains(@class,' ui-d/uicontrol ')]"/>
          </xsl:variable>
          <xsl:if test="$uicontrolcount&gt;'1'">
            <xsl:text> > </xsl:text>
          </xsl:if>
        </xsl:when>-->
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="suffix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#187;</xsl:when>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">]</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-cn')">”</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#x0230B;</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<!--    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-->
		<xsl:choose>
			<xsl:when test="starts-with(lower-case($lang), 'ja')">
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!--<xsl:value-of select="$prefix-char"/>-->
					<xsl:apply-templates/>
					<!--<xsl:value-of select="$suffix-char"/>-->
				</span>
			</xsl:when>
			<xsl:when test="starts-with(lower-case($lang), 'ru')">
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!--<xsl:value-of select="$prefix-char"/>-->
					<xsl:apply-templates/>
					<!--<xsl:value-of select="$suffix-char"/>-->
				</span>
			</xsl:when>
			<xsl:when test="contains(lower-case($lang), 'zh-tw')">
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!--<xsl:value-of select="$prefix-char"/>-->
					<xsl:apply-templates/>
					<!--<xsl:value-of select="$suffix-char"/>-->
				</span>
			</xsl:when>
			<xsl:when test="contains(lower-case($lang), 'zh-cn')">
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!--<xsl:value-of select="$prefix-char"/>-->
					<xsl:apply-templates/>
					<!--<xsl:value-of select="$suffix-char"/>-->
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!--<xsl:value-of select="$prefix-char"/>-->
					<xsl:apply-templates/>
					<!--<xsl:value-of select="$suffix-char"/>-->
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' topic/lq ')]">
		<xsl:variable name="lang">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*/@xml:lang">
					<xsl:value-of select="ancestor-or-self::*/@xml:lang"/>
				</xsl:when>
				<xsl:when test="$LANGUAGE">
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="prefix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#171;</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="suffix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ru')">&#187;</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<!--    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-->
		<span class="lq">
			<xsl:value-of select="$prefix-char"/>
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix-char"/>
		</span>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' pr-d/option ')]" name="topic.pr-d.option">
		<xsl:variable name="lang">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*/@xml:lang">
					<xsl:value-of select="ancestor-or-self::*/@xml:lang"/>
				</xsl:when>
				<xsl:when test="$LANGUAGE">
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="prefix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">[</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="suffix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">]</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with(lower-case($lang), 'ja')">
				<span class="option" style="font-style:normal;">
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="commonattributes"/>
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="option" style="font-style:normal;">
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="commonattributes"/>
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' sw-d/varname ')] | *[contains(@class, ' pr-d/var ')]"
		name="topic.sw-d.varname">
		<xsl:variable name="lang">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*/@xml:lang">
					<xsl:value-of select="ancestor-or-self::*/@xml:lang"/>
				</xsl:when>
				<xsl:when test="$LANGUAGE">
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$LANGUAGE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="prefix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">[</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-cn')">“</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#x02308;</xsl:when>
				<!--<xsl:when test="ancestor::*[contains(@class,' ui-d/menucascade ')]">
          <xsl:variable name="uicontrolcount">
            <xsl:number count="*[contains(@class,' ui-d/uicontrol ')]"/>
          </xsl:variable>
          <xsl:if test="$uicontrolcount&gt;'1'">
            <xsl:text> > </xsl:text>
          </xsl:if>
        </xsl:when>-->
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="suffix-char">
			<xsl:choose>
				<xsl:when test="starts-with(lower-case($lang), 'ja')">]</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-cn')">”</xsl:when>
				<xsl:when test="contains(lower-case($lang), 'zh-tw')">&#x0230B;</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when
				test="starts-with(lower-case($lang), 'ja') or starts-with(lower-case($lang), 'zh')">
				<var class="varname" style="font-style:normal;">
					<xsl:call-template name="setidaname"/>
					<xsl:value-of select="$prefix-char"/>
					<xsl:apply-templates/>
					<xsl:value-of select="$suffix-char"/>
				</var>
			</xsl:when>
			<xsl:otherwise>
				<var class="varname">
					<xsl:call-template name="setidaname"/>
					<xsl:apply-templates/>
				</var>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[contains(@class, ' hi-d/sup ')]" name="topic.hi-d.sup">
		<span style="font-size:xx-small; vertical-align:top;">
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="setidaname"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' hi-d/sub ')]" name="topic.hi-d.sub">
		<span style="font-size:xx-small; vertical-align:bottom;">
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="setidaname"/>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template name="parsehref">
		<xsl:param name="href"/>
		<xsl:choose>
			<xsl:when test="$TRANSTYPE = 'webhelp-single'">
				<xsl:choose>
					<xsl:when test="contains($href, '.xml')">
						<xsl:message>ParseHref value with catch at .xml = <xsl:value-of
							select="substring-before(@href, '.xml')"/></xsl:message>
						<xsl:value-of select="substring-before($href, '.xml')"/>
					</xsl:when>
					<xsl:when test="contains($href, '/')">
						<xsl:message>ParseHref value with catch at / = <xsl:value-of
							select="substring-after(@href, '/')"/></xsl:message>
						<xsl:value-of select="substring-after($href, '/')"/>
					</xsl:when>
					<xsl:when test="contains($href, '#')">
						<xsl:message>ParseHref value with catch at # = <xsl:value-of
							select="substring-after(@href, '#')"/></xsl:message>
						<xsl:value-of select="substring-after($href, '#')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$href"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$TRANSTYPE = 'webhelp-single'">
						<xsl:choose>
							<xsl:when test="contains($href, '.xml')">
								<xsl:value-of select="substring-before($href, '.xml')"/>
							</xsl:when>
							<xsl:when test="contains($href, '/')">
								<xsl:value-of select="substring-after($href, '/')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$href"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="contains($href, '/')">
						<xsl:value-of select="substring-before($href, '/')"/>__<xsl:value-of
							select="substring-after($href, '/')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$href"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="commonattributes">
		<xsl:param name="default-output-class"/>
		<xsl:apply-templates select="@xml:lang"/>
		<xsl:apply-templates select="@dir"/>
		<xsl:apply-templates
			select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass"
			mode="add-ditaval-style"/>
		<xsl:apply-templates select="." mode="set-output-class">
			<xsl:with-param name="default" select="$default-output-class"/>
		</xsl:apply-templates>
		
		<xsl:if test="exists($passthrough-attrs)">
			<xsl:for-each select="@*">
				<xsl:if
					test="
					$passthrough-attrs[@att = name(current()) and (empty(@val) or (some $v in tokenize(current(), '\s+')
					satisfies $v = @val))]">
					<xsl:attribute name="data-{name()}" select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!-- This causes element before attribute processing error - should be removed as it's called in the following template -->
		<!-- GEHC-105 -->
		<!-- Rally ID US312 -->
		<!-- 2017-10-20: use new external param PRM_OUTPUT_PROFILING_VALUES to output profiling values -->
		
		<xsl:if test="upper-case($PRM_OUTPUT_PROFILING_VALUES) = 'YES'">
			
			<xsl:if test="@audience | @platform | @rev | @otherprops | @product">
				<xsl:attribute name="style">
					<xsl:text>border:1pt solid red;</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@href or ancestor-or-self::*[contains(@class, ' topic/table ')])">
				<xsl:for-each select="@*">
					<xsl:if
						test="local-name() = 'audience' or local-name() = 'platform' or local-name() = 'rev' or local-name() = 'otherprops' or local-name() = 'product'">
						<!--			<xsl:message>evaluates to localname</xsl:message>-->
						<!--<xsl:attribute name="style">border:1pt solid red;padding:3pt;</xsl:attribute>-->
						<!--<span style="background-color:pink;font-weight:bold;">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="local-name()"/>
							<xsl:value-of select="."/>
							<xsl:text>]</xsl:text>
						</span>-->
						<xsl:attribute name="data-{local-name()}">
							<xsl:value-of select="."/>
						</xsl:attribute>
						<!--<span style="background-color:pink;font-weight:bold;">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="local-name()"/>
							<xsl:value-of select="."/>
							<xsl:text>]</xsl:text>
						</span>-->
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*[@audience] | *[@platform] | *[@rev] | *[@otherprops] | *[@product]"
		mode="meta-info">
		<!--		<xsl:message>Caught Attribute <xsl:value-of select="local-name()"/>-start</xsl:message>
		<xsl:if test="local-name() = 'substeps'">
			<xsl:message>In substeps attribute</xsl:message>
			<xsl:message>
				<xsl:copy-of select="."/>
			</xsl:message>
		</xsl:if>-->
		<xsl:choose>
			<!-- GEHC-105 -->
			<!-- Rally ID US312 -->
			<!-- 2017-10-20: use new external param PRM_OUTPUT_PROFILING_VALUES to output profiling values -->
			<!--xsl:when test="upper-case($DRAFT) = 'YES'"-->
			<xsl:when test="upper-case($PRM_OUTPUT_PROFILING_VALUES) = 'YES'">
				<!-- <xsl:copy>-->
				<div>
					<xsl:attribute name="style">border:1pt solid red</xsl:attribute>
					<xsl:for-each select="@*">
						<xsl:if
							test="local-name() = 'audience' or local-name() = 'platform' or local-name() = 'rev' or local-name() = 'otherprops' or local-name() = 'product'">
							<!--<xsl:attribute name="style">border:1pt solid red;padding:3pt;</xsl:attribute>-->
							<span style="background-color:pink;font-weight:bold;">
								<xsl:text>[</xsl:text>
								<xsl:value-of select="local-name()"/>
								<xsl:value-of select="."/>
								<xsl:text>]</xsl:text>
							</span>
							<xsl:text>&#160;</xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:apply-templates mode="meta-info"/>
				</div>
				<!--</xsl:copy>-->
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
		<!--	<xsl:message>Caught Attribute <xsl:value-of select="local-name()"/>-end</xsl:message>-->
	</xsl:template>
	
	<xsl:template match="/|node()|@*" mode="gen-user-head">
		<!--<xsl:variable name="windows_inputMap">
			<xsl:value-of select="concat('file:///', $inputMap)"/>
		</xsl:variable>-->
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
	</xsl:template>
	
</xsl:stylesheet>