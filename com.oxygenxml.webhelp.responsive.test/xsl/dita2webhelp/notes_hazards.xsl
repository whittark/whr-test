<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:oxygen="http://www.oxygenxml.com/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ditamsg dita2html related-links xs oxygen" version="2.0">
    
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
	
    <!-- Define a newline character -->
    <xsl:variable name="newline">
        <xsl:text>
</xsl:text>
    </xsl:variable>
    
    <xsl:template match="*[contains(@class, ' topic/note ')]" name="topic.note" priority="100">
        <xsl:call-template name="spec-title"/>
    	<xsl:comment>PRM_OUTPUT_HAZARD_LABEL = <xsl:value-of select="$PRM_OUTPUT_HAZARD_LABEL"/></xsl:comment>
        <xsl:choose>
            <xsl:when test="@type = 'note'">
                <xsl:apply-templates select="." mode="process.note"/>
            </xsl:when>
            <xsl:when test="@type = 'tip'">
                <xsl:apply-templates select="." mode="process.note.tip"/>
            </xsl:when>
            <xsl:when test="@type = 'fastpath'">
                <xsl:apply-templates select="." mode="process.note.fastpath"/>
            </xsl:when>
            <xsl:when test="@type = 'important'">
                <xsl:apply-templates select="." mode="process.note.important"/>
            </xsl:when>
            <xsl:when test="@type = 'remember'">
                <xsl:apply-templates select="." mode="process.note.remember"/>
            </xsl:when>
            <xsl:when test="@type = 'restriction'">
                <xsl:apply-templates select="." mode="process.note.restriction"/>
            </xsl:when>
            <xsl:when test="@type = 'attention'">
                <xsl:apply-templates select="." mode="process.note.attention"/>
            </xsl:when>
            <xsl:when test="@type = 'caution'">
                <xsl:apply-templates select="." mode="process.note.caution"/>
            </xsl:when>
            <xsl:when test="@type = 'danger'">
                <xsl:apply-templates select="." mode="process.note.danger"/>
            </xsl:when>
            <xsl:when test="@type = 'warning'">
                <xsl:apply-templates select="." mode="process.note.warning"/>
            </xsl:when>
            <xsl:when test="@type = 'trouble'">
                <xsl:apply-templates select="." mode="process.note.trouble"/>
            </xsl:when>
            <xsl:when test="@type = 'notice'">
                <xsl:apply-templates select="." mode="process.note.notice"/>
            </xsl:when>
            <xsl:when test="@type = 'other'">
                <xsl:apply-templates select="." mode="process.note.other"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="process.note"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$newline"/>
    </xsl:template>
    
    <xsl:template
        match="*[contains(@class, ' topic/note')][@type = 'notice'] | *[contains(@class, ' topic/note')][@type = 'note']"
        mode="process.note.common-processing">
        <xsl:param name="type" select="@type"/>
        <xsl:param name="title">
            <xsl:choose>
                <xsl:when test="@type = 'notice'">
                    <xsl:call-template name="getWebhelpString">
                        <xsl:with-param name="stringName" select="'Notice'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@type = 'note'">
                    <xsl:call-template name="getWebhelpString">
                        <xsl:with-param name="stringName" select="'Notice'"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:param>
        <div class="{$type}">
            <xsl:call-template name="setidaname"/>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="$type"/>
            </xsl:call-template>
            
            <!-- Normal flags go before the generated title; revision flags only go on the content. -->
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
                mode="ditaval-outputflag"/>
            <span class="{$type}title">
                <xsl:value-of select="$title"/>
                <xsl:call-template name="getWebhelpString">
                    <xsl:with-param name="stringName" select="'ColonSymbol'"/>
                </xsl:call-template>
            </span>
            <xsl:text> </xsl:text>
            <xsl:apply-templates
                select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
                mode="ditaval-outputflag"/>
            <xsl:apply-templates/>
            <!-- Normal end flags and revision end flags both go out after the content. -->
            <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
                mode="out-of-line"/>
        </div>
    </xsl:template>
	<xsl:template match="*" mode="process.note.notice" priority="10">
		<!-- Comtech 08/15/2013 placed notice in a table and generated image -->
		<!-- US297 Hazard statements ANSI and IEC setup and styling MJT:FMC 8/30/2016 -->
		<xsl:choose>
			<xsl:when test=".[contains(@class, 'hazardstatement')]">
				<table class="haztable">
					<xsl:choose>
						<xsl:when test="upper-case($PRM_OUTPUT_HAZARD_LABEL) = 'ANSI'">
							<tr>
								<td class="hazLabel">
									<div>
										<xsl:call-template name="setidaname"/>
										<xsl:call-template name="commonattributes"/>
										<!-- Normal flags go before the generated title; revision flags only go on the content. -->
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
											mode="ditaval-outputflag"/>
										<xsl:choose>
											<xsl:when
												test="child::*[contains(@class, 'topic/image hazard-d/hazardsymbol')]">
												<div class="hazard">
													<xsl:apply-templates
														select="*[contains(@class, ' topic/image hazard-d/hazardsymbol ')]"
													/>
												</div>
											</xsl:when>
											<xsl:otherwise>
												<div class="hazard">
													<img width="60px;" class="image hazardsymbol"
														src="img/generalmand.png"
														alt="Notice Image"/>
												</div>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</td>
								<td class="hazNote">
									<ul class="hazul">
										<li>
											<div class="noticelabel">
												<span>
													<xsl:attribute name="class"
														>noticetitle</xsl:attribute>
													<xsl:call-template name="getWebhelpString">
														<xsl:with-param name="stringName"
															select="'Notice'"/>
													</xsl:call-template>
												</span>
											</div>
										</li>
									</ul>
									<div class="notice">
										<xsl:call-template name="commonattributes">
											<xsl:with-param name="default-output-class"
												select="'notice'"/>
										</xsl:call-template>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
											mode="ditaval-outputflag"/>
										<xsl:apply-templates
											select="*[not(contains(@class, ' topic/image hazard-d/hazardsymbol '))]"/>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
											mode="out-of-line"/>
									</div>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td class="iecLabel">
									<div>
										<xsl:call-template name="setidaname"/>
										<xsl:call-template name="commonattributes"/>
										<!-- Normal flags go before the generated title; revision flags only go on the content. -->
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
											mode="ditaval-outputflag"/>
										<ul style="list-style:none;">
											<li>
												<xsl:choose>
													<xsl:when
														test="child::*[contains(@class, 'topic/image hazard-d/hazardsymbol')]">
														<div class="hazard">
															<xsl:apply-templates
																select="*[contains(@class, 'topic/image hazard-d/hazardsymbol')]"
															/>
														</div>
													</xsl:when>
													<xsl:otherwise/>
												</xsl:choose>
											</li>
										</ul>
									</div>
								</td>
								<td class="iecNote">
									<div class="noticelabel">
										<span>
											<xsl:attribute name="class">noticetitle</xsl:attribute>
											<xsl:call-template name="getWebhelpString">
												<xsl:with-param name="stringName" select="'Notice'"
												/>
											</xsl:call-template>
										</span>
									</div>
									<div class="notice">
										<xsl:call-template name="commonattributes">
											<xsl:with-param name="default-output-class"
												select="'notice'"/>
										</xsl:call-template>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
											mode="ditaval-outputflag"/>
										<xsl:apply-templates
											select="*[not(contains(@class, ' topic/image hazard-d/hazardsymbol '))]"/>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
											mode="out-of-line"/>
									</div>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="process.note.common-processing"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="process.note">
		<xsl:apply-templates select="." mode="process.note.common-processing">
			<!-- Force the type to note, in case new unrecognized values are added
         before translations exist (such as Warning) -->
			<xsl:with-param name="type" select="'note'"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="*" mode="process.note.warning">
		<!-- Comtech 08/15/2013 placed warning in a table and generated image -->
	
		<xsl:choose>
			<xsl:when test=".[contains(@class, 'hazardstatement')]">
				<table class="haztable">
					<xsl:choose>
						<xsl:when test="upper-case($PRM_OUTPUT_HAZARD_LABEL) = 'ANSI'">
							<tr>
								<td class="hazLabel">
									<div>
										<xsl:call-template name="setidaname"/>
										<xsl:call-template name="commonattributes"/>
										<!-- Normal flags go before the generated title; revision flags only go on the content. -->
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
											mode="ditaval-outputflag"/>
										<xsl:choose>
											<xsl:when
												test="child::*[contains(@class, 'topic/image hazard-d/hazardsymbol')]">
												<div class="hazard">
												<xsl:apply-templates
												select="*[contains(@class, 'topic/image hazard-d/hazardsymbol')]"
												/>
												</div>
											</xsl:when>
											<xsl:otherwise>
												<div class="hazard">
												<img width="60px;" class="image hazardsymbol"
												src="img/generalhaz.png"
												alt="Notice Image"/>
												</div>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</td>
								<td class="hazNote">
									<ul class="hazul">
										<li>
											<div class="warninglabel">
												<img src="{$hazIcon}"/>
												<span>
												<xsl:attribute name="class"
												>warningtitle</xsl:attribute>
												<xsl:call-template name="getWebhelpString">
												<xsl:with-param name="stringName"
												select="'Warning'"/>
												</xsl:call-template>
												</span>
											</div>
										</li>
									</ul>
									<div class="warning">
										<xsl:call-template name="commonattributes">
											<xsl:with-param name="default-output-class"
												select="'warning'"/>
										</xsl:call-template>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
											mode="ditaval-outputflag"/>
										<xsl:apply-templates
											select="*[not(contains(@class, ' topic/image hazard-d/hazardsymbol '))]"/>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
											mode="out-of-line"/>
									</div>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td class="iecLabel">
									<div>
										<xsl:call-template name="setidaname"/>
										<xsl:call-template name="commonattributes"/>
										<!-- Normal flags go before the generated title; revision flags only go on the content. -->
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
											mode="ditaval-outputflag"/>
										<ul class="hazul">
											<li>
												<xsl:choose>
												<xsl:when
												test="child::*[contains(@class, 'topic/image hazard-d/hazardsymbol')]">
												<div class="hazard">
												<xsl:apply-templates
												select="*[contains(@class, 'topic/image hazard-d/hazardsymbol')]"
												/>
												</div>
												</xsl:when>
												<xsl:otherwise/>
												</xsl:choose>
											</li>
										</ul>
									</div>
								</td>
								<td class="iecNote">
									<div class="warninglabel">
										<span>
											<xsl:attribute name="class">warningtitle</xsl:attribute>
											<xsl:call-template name="getWebhelpString">
												<xsl:with-param name="stringName" select="'Warning'"
												/>
											</xsl:call-template>
										</span>
									</div>
									<div class="warning">
										<xsl:call-template name="commonattributes">
											<xsl:with-param name="default-output-class"
												select="'warning'"/>
										</xsl:call-template>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
											mode="ditaval-outputflag"/>
										<xsl:apply-templates
											select="*[not(contains(@class, ' topic/image hazard-d/hazardsymbol '))]"/>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
											mode="out-of-line"/>
									</div>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="process.note.common-processing"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="process.note.attention">
		<xsl:apply-templates select="." mode="process.note.common-processing"/>
	</xsl:template>
	<xsl:template match="*" mode="process.note.other">
		<xsl:choose>
			<xsl:when test="@othertype">
				<xsl:apply-templates select="." mode="process.note.common-processing">
					<xsl:with-param name="type" select="'note'"/>
					<xsl:with-param name="title" select="@othertype"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="process.note.common-processing">
					<xsl:with-param name="type" select="'note'"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Caution and Danger both use a div for the title, so they do not
     use the common note processing template. -->
	<xsl:template match="*" mode="process.note.caution">
		<!-- Comtech 08/15/2013 placed caution in a table and generated image -->
		<xsl:choose>
			<xsl:when test=".[contains(@class, 'hazardstatement')]">
				<table class="haztable">
					<xsl:choose>
						<xsl:when test="upper-case($PRM_OUTPUT_HAZARD_LABEL) = 'ANSI'">
							<tr>
								<td class="hazLabel">
									<div>
										<xsl:call-template name="setidaname"/>
										<xsl:call-template name="commonattributes"/>
										<!-- Normal flags go before the generated title; revision flags only go on the content. -->
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
											mode="ditaval-outputflag"/>
										<xsl:choose>
											<xsl:when
												test="child::*[contains(@class, 'topic/image hazard-d/hazardsymbol')]">
												<div class="hazard">
												<xsl:apply-templates
												select="*[contains(@class, 'topic/image hazard-d/hazardsymbol')]"
												/>
												</div>
											</xsl:when>
											<xsl:otherwise>
												<div class="hazard">
												<img width="60px;" class="image hazardsymbol"
												src="img/generalhaz.png"
												alt="Notice Image"/>
												</div>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</td>
								<td class="hazNote">
									<div class="caution">
										<xsl:call-template name="commonattributes">
											<xsl:with-param name="default-output-class"
												select="'caution'"/>
										</xsl:call-template>
										<ul class="hazul">
											<li>
												<div class="cautionlabel">
												<img src="{$hazIcon}"/>
												<span>
												<xsl:attribute name="class"
												>cautiontitle</xsl:attribute>
												<xsl:call-template name="getWebhelpString">
												<xsl:with-param name="stringName"
												select="'Caution'"/>
												</xsl:call-template>
												</span>
												</div>
											</li>
										</ul>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
											mode="ditaval-outputflag"/>
										<xsl:apply-templates
											select="*[not(contains(@class, ' topic/image hazard-d/hazardsymbol '))]"/>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
											mode="out-of-line"/>
									</div>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td class="iecLabel">
									<div>
										<xsl:call-template name="setidaname"/>
										<xsl:call-template name="commonattributes"/>
										<!-- Normal flags go before the generated title; revision flags only go on the content. -->
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
											mode="ditaval-outputflag"/>
										<ul class="hazul">
											<li>
												<xsl:choose>
												<xsl:when
												test="child::*[contains(@class, 'topic/image hazard-d/hazardsymbol')]">
												<div class="hazard">
												<xsl:apply-templates
												select="*[contains(@class, 'topic/image hazard-d/hazardsymbol')]"
												/>
												</div>
												</xsl:when>
												<xsl:otherwise/>
												</xsl:choose>
											</li>
										</ul>
									</div>
								</td>
								<td class="iecNote">
									<div class="cautionlabel">
										<span>
											<xsl:attribute name="class">cautiontitle</xsl:attribute>
											<xsl:call-template name="getWebhelpString">
												<xsl:with-param name="stringName" select="'Caution'"
												/>
											</xsl:call-template>
										</span>
									</div>
									<div class="caution">
										<xsl:call-template name="commonattributes">
											<xsl:with-param name="default-output-class"
												select="'caution'"/>
										</xsl:call-template>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
											mode="ditaval-outputflag"/>
										<xsl:apply-templates
											select="*[not(contains(@class, ' topic/image hazard-d/hazardsymbol '))]"/>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
											mode="out-of-line"/>
									</div>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="process.note.common-processing"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="process.note.danger">
		<!-- Comtech 08/15/2013 placed danger in a table and generated image -->
		<xsl:choose>
			<xsl:when test=".[contains(@class, 'hazardstatement')]">
				<table class="haztable">
					<xsl:choose>
						<xsl:when test="upper-case($PRM_OUTPUT_HAZARD_LABEL) = 'ANSI'">
							<tr>
								<td class="hazLabel">
									<div>
										<xsl:call-template name="setidaname"/>
										<xsl:call-template name="commonattributes"/>
										<!-- Normal flags go before the generated title; revision flags only go on the content. -->
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
											mode="ditaval-outputflag"/>
										<xsl:choose>
											<xsl:when
												test="child::*[contains(@class, 'topic/image hazard-d/hazardsymbol')]">
												<div class="hazard">
												<xsl:apply-templates
												select="*[contains(@class, 'topic/image hazard-d/hazardsymbol')]"
												/>
												</div>
											</xsl:when>
											<xsl:otherwise>
												<div class="hazard">
												<img width="60px;" class="image hazardsymbol"
												src="img/generalhaz.png"
												alt="Notice Image"/>
												</div>
											</xsl:otherwise>
										</xsl:choose>
									</div>
								</td>
								<td class="hazNote">
									<div class="danger">
										<xsl:call-template name="commonattributes">
											<xsl:with-param name="default-output-class"
												select="'danger'"/>
										</xsl:call-template>
										<ul class="hazul">
											<li>
												<div class="dangerlabel">
												<img src="{$hazIcon}"/>
												<span>
												<xsl:attribute name="class"
												>dangertitle</xsl:attribute>
												<xsl:call-template name="getWebhelpString">
												<xsl:with-param name="stringName"
												select="'Danger'"/>
												</xsl:call-template>
												</span>
												</div>
											</li>
										</ul>
										<!--<xsl:apply-templates
                            select="*[contains(@class,' ditaot-d/ditaval-startprop ')]/revprop"
                            mode="ditaval-outputflag"/>-->
										<xsl:apply-templates
											select="*[not(contains(@class, 'topic/image hazard-d/hazardsymbol'))]"/>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
											mode="out-of-line"/>
									</div>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td class="iecLabel">
									<div>
										<xsl:call-template name="setidaname"/>
										<xsl:call-template name="commonattributes"/>
										<!-- Normal flags go before the generated title; revision flags only go on the content. -->
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop"
											mode="ditaval-outputflag"/>
										<ul class="hazul">
											<li>
												<xsl:choose>
												<xsl:when
												test="child::*[contains(@class, 'topic/image hazard-d/hazardsymbol')]">
												<div class="hazard">
												<xsl:apply-templates
												select="*[contains(@class, 'topic/image hazard-d/hazardsymbol')]"
												/>
												</div>
												</xsl:when>
												<xsl:otherwise/>
												</xsl:choose>
											</li>
										</ul>
									</div>
								</td>
								<td class="iecNote">
									<div class="dangerlabel">
										<span>
											<xsl:attribute name="class">dangertitle</xsl:attribute>
											<xsl:call-template name="getWebhelpString">
												<xsl:with-param name="stringName" select="'Danger'"
												/>
											</xsl:call-template>
										</span>
									</div>
									<div class="danger">
										<xsl:call-template name="commonattributes">
											<xsl:with-param name="default-output-class"
												select="'danger'"/>
										</xsl:call-template>
										<!--<xsl:apply-templates
                            select="*[contains(@class,' ditaot-d/ditaval-startprop ')]/revprop"
                            mode="ditaval-outputflag"/>-->
										<xsl:apply-templates
											select="*[not(contains(@class, 'topic/image hazard-d/hazardsymbol'))]"/>
										<xsl:apply-templates
											select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
											mode="out-of-line"/>
									</div>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="process.note.common-processing"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
    
    
</xsl:stylesheet>