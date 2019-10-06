<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
	xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
	xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
	xmlns:oxygen="http://www.oxygenxml.com/functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="ditamsg dita2html related-links xs oxygen" version="2.0">
	<!--<xsl:include href="../../../../xsl/common/output-message.xsl"/>
  <xsl:param name="msgprefix">GECustom</xsl:param>-->
	<!-- <xsl:import href="../functions.xsl"/>
  <xsl:include href="../../../../xsl/common/output-message.xsl"/> -->
	<xsl:include href="dita-utilities.xsl"/>
	<xsl:param name="TEMPDIR"/>
	<xsl:param name="INPUTDIR"/>
	<xsl:param name="tempDir">
		<xsl:value-of select="$TEMPDIR"/>
	</xsl:param>
	<xsl:param name="LANGUAGE"/>
	<xsl:param name="DEFAULTLANG"/>
	<xsl:param name="FTR"/>
	<xsl:param name="inputMap"/>
	<xsl:param name="windows_inputMap">
		<xsl:value-of select="concat('file:///', $inputMap)"/>
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
	<xsl:param name="DRAFT.TOPICHEAD"/>
	<xsl:variable name="hazIcon"
		select="'oxygen-webhelp/resources/img/hazard_triangle_inline_2.png'"/>
	<!-- Comtech Services 12/06/2013 add footer value -->
	<xsl:template name="chapter-setup">
		<!-- Comtech 09/28/2013 update DTD is declared in index.html file for HTML 5 -->
		<!--<xsl:text disable-output-escaping="yes">HTML Header</xsl:text>-->
		<html>
			<xsl:variable name="mailtoSubject">
				<xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
			</xsl:variable>
			<xsl:variable name="Email">
				<xsl:call-template name="getWebhelpString">
					<xsl:with-param name="stringName" select="'Email'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="Print">
				<xsl:call-template name="getWebhelpString">
					<xsl:with-param name="stringName" select="'Print'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="OpenFrame">
				<xsl:call-template name="getWebhelpString">
					<xsl:with-param name="stringName" select="'OpenFrame'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="windows_inputMap">
				<xsl:value-of select="concat('file:///', $inputMap)"/>
			</xsl:variable>
			<xsl:call-template name="setTopicLanguage"/>
			<xsl:attribute name="stringName" select="@id"/>
			<!--h1[@id='emailsubject']-->
			<xsl:value-of select="$newline"/>
			<xsl:call-template name="chapterHead"/>
			<div style="float:right;padding: 6px 6px 0 0;">
				<a id="oldFrames" target="_blank" href="index_frames.html" title="{$OpenFrame}"
					class="openFrame" style="background-repeat: no-repeat;">
					<!--Open with Frames-->
					<!--<img border="0" src="oxygen-webhelp/resources/img/frames.png" alt="Frames"/>-->
				</a>
				<xsl:text> </xsl:text>
				<a HREF="javascript:window.print()" title="{$Print}" class="printTopic">
					<!--Print this Topic-->
					<!--<img src="oxygen-webhelp/resources/img/print.png" border="0" align="top" alt="Print"/>-->
				</a>
				<xsl:text> </xsl:text>
				<!-- Release7Drop3 Testing - IM for email must be xref, or text node in ph, otherwise, default help feedback -->
				<xsl:variable name="emailaddress">
					<xsl:choose>
						<xsl:when
							test="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'biz_email']/ph">
							<xsl:choose>
								<xsl:when
									test="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'biz_email']/ph/xref">
									<xsl:value-of
										select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'biz_email']/ph/xref/substring-after(@href, 'mailto:')"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'biz_email']/ph"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>help.feedback@ge.com</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<script>
          document.write('<a href="mailto:{$emailaddress}?subject={$mailtoSubject}&amp;body='+window.location.href+'" title="{$Email}" class="mail" target="_blank">
            </a>');
        </script>
			</div>
			<xsl:call-template name="chapterBody"/>
		</html>
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

	<!-- moved to ge_custom.xsl -->
	<!--	<xsl:template match="*[contains(@class, ' sw-d/msgph ')]">
		<samp class="msgph">
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="setidaname"/>
			<xsl:text>(</xsl:text>
			<xsl:call-template name="getWebhelpString">
				<xsl:with-param name="stringName" select="'msgph-For'"/>
			</xsl:call-template>
			<xsl:value-of select="' '"/>
			<xsl:apply-templates/>
			<!-\-      <xsl:call-template name="getWebhelpString">
        <xsl:with-param name="stringName" select="'ColonSymbol'"/>
      </xsl:call-template>-\->
			<xsl:text>) </xsl:text>
		</samp>
	</xsl:template>-->


<!-- moved to ge_custom.xsl -->
	<!--<xsl:template name="profiling-atts">
		<xsl:choose>
			<xsl:when test="upper-case($PRM_OUTPUT_PROFILING_VALUES) = 'YES'">
				<xsl:if test="not(@href)">
					<xsl:for-each select="@*">
						<xsl:if
							test="local-name() = 'audience' or local-name() = 'platform' or local-name() = 'rev' or local-name() = 'otherprops' or local-name() = 'product'">
							<!-\-<xsl:attribute name="data-{local-name()}"><xsl:value-of select="."/></xsl:attribute>-\->
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

	</xsl:template>-->


<!-- moved to tables.xsl -->
	<!-- Comtech Services 09/09/2013 Override where table <fn> are displayed, moved from bottom of page to within table -->
	<!--<xsl:template match="*[contains(@class, ' topic/table ')]" mode="table-fmt">
		<!-\- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -\->
		<xsl:variable name="uniqueTable">
			<xsl:text>table-</xsl:text>
			<xsl:value-of select="generate-id()"/>
		</xsl:variable>
		<xsl:if test="@outputclass = 'datatable'">
			<xsl:element name="style">
				<xsl:text>table.dataTable {
    width: 100%;
    margin: 0 auto;
    clear: both;
    border-collapse: separate;
    border-spacing: 0
}

table.dataTable thead th, table.dataTable tfoot th {
    font-weight: bold
}

table.dataTable thead th, table.dataTable thead td {
    padding: 10px 18px;
    border-bottom: 1px solid #111
}

table.dataTable thead th:active, table.dataTable thead td:active {
    outline: none
}

table.dataTable tfoot th, table.dataTable tfoot td {
    padding: 10px 18px 6px 18px;
    border-top: 1px solid #111
}

table.dataTable thead .sorting, table.dataTable thead .sorting_asc,
table.dataTable thead .sorting_desc {
    cursor: pointer;
    * cursor: hand
}

table.dataTable thead .sorting, table.dataTable thead .sorting_asc,
table.dataTable thead .sorting_desc, table.dataTable thead .sorting_asc_disabled,
table.dataTable thead .sorting_desc_disabled {
    background-repeat: no-repeat;
    background-position: center right
}

table.dataTable thead .sorting {
    background-image: url("oxygen-webhelp/images/sort_both.png")
}

table.dataTable thead .sorting_asc {
    background-image: url("oxygen-webhelp/images/sort_asc.png")
}

table.dataTable thead .sorting_desc {
    background-image: url("oxygen-webhelp/images/sort_desc.png")
}

table.dataTable thead .sorting_asc_disabled {
    background-image: url("oxygen-webhelp/images/sort_asc_disabled.png")
}

table.dataTable thead .sorting_desc_disabled {
    background-image: url("oxygen-webhelp/images/sort_desc_disabled.png")
}

table.dataTable tbody tr {
    background-color: #ffffff
}

table.dataTable tbody tr.selected {
    background-color: #B0BED9
}

table.dataTable tbody th, table.dataTable tbody td {
    padding: 8px 10px
}

table.dataTable.row-border tbody th, table.dataTable.row-border tbody td,
table.dataTable.display tbody th, table.dataTable.display tbody td {
    border-top: 1px solid #ddd
}

table.dataTable.row-border tbody tr:first-child th, table.dataTable.row-border tbody tr:first-child td,
table.dataTable.display tbody tr:first-child th, table.dataTable.display tbody tr:first-child td {
    border-top: none
}

table.dataTable.cell-border tbody th, table.dataTable.cell-border tbody td {
    border-top: 1px solid #ddd;
    border-right: 1px solid #ddd
}

table.dataTable.cell-border tbody tr th:first-child, table.dataTable.cell-border tbody tr td:first-child {
    border-left: 1px solid #ddd
}

table.dataTable.cell-border tbody tr:first-child th, table.dataTable.cell-border tbody tr:first-child td {
    border-top: none
}

table.dataTable.stripe tbody tr.odd, table.dataTable.display tbody tr.odd {
    background-color: #f9f9f9
}

table.dataTable.stripe tbody tr.odd.selected, table.dataTable.display tbody tr.odd.selected {
    background-color: #acbad4
}

table.dataTable.hover tbody tr:hover, table.dataTable.display tbody tr:hover {
    background-color: #f6f6f6
}

table.dataTable.hover tbody tr:hover.selected, table.dataTable.display tbody tr:hover.selected {
    background-color: #aab7d1
}

table.dataTable.order-column tbody tr > .sorting_1, table.dataTable.order-column tbody tr > .sorting_2,
table.dataTable.order-column tbody tr > .sorting_3, table.dataTable.display tbody tr > .sorting_1,
table.dataTable.display tbody tr > .sorting_2, table.dataTable.display tbody tr > .sorting_3 {
    background-color: #fafafa
}

table.dataTable.order-column tbody tr.selected > .sorting_1, table.dataTable.order-column tbody tr.selected > .sorting_2,
table.dataTable.order-column tbody tr.selected > .sorting_3, table.dataTable.display tbody tr.selected > .sorting_1,
table.dataTable.display tbody tr.selected > .sorting_2, table.dataTable.display tbody tr.selected > .sorting_3 {
    background-color: #acbad5
}

table.dataTable.display tbody tr.odd > .sorting_1, table.dataTable.order-column.stripe tbody tr.odd > .sorting_1 {
    background-color: #f1f1f1
}

table.dataTable.display tbody tr.odd > .sorting_2, table.dataTable.order-column.stripe tbody tr.odd > .sorting_2 {
    background-color: #f3f3f3
}

table.dataTable.display tbody tr.odd > .sorting_3, table.dataTable.order-column.stripe tbody tr.odd > .sorting_3 {
    background-color: whitesmoke
}

table.dataTable.display tbody tr.odd.selected > .sorting_1, table.dataTable.order-column.stripe tbody tr.odd.selected > .sorting_1 {
    background-color: #a6b4cd
}

table.dataTable.display tbody tr.odd.selected > .sorting_2, table.dataTable.order-column.stripe tbody tr.odd.selected > .sorting_2 {
    background-color: #a8b5cf
}

table.dataTable.display tbody tr.odd.selected > .sorting_3, table.dataTable.order-column.stripe tbody tr.odd.selected > .sorting_3 {
    background-color: #a9b7d1
}

table.dataTable.display tbody tr.even > .sorting_1, table.dataTable.order-column.stripe tbody tr.even > .sorting_1 {
    background-color: #fafafa
}

table.dataTable.display tbody tr.even > .sorting_2, table.dataTable.order-column.stripe tbody tr.even > .sorting_2 {
    background-color: #fcfcfc
}

table.dataTable.display tbody tr.even > .sorting_3, table.dataTable.order-column.stripe tbody tr.even > .sorting_3 {
    background-color: #fefefe
}

table.dataTable.display tbody tr.even.selected > .sorting_1, table.dataTable.order-column.stripe tbody tr.even.selected > .sorting_1 {
    background-color: #acbad5
}

table.dataTable.display tbody tr.even.selected > .sorting_2, table.dataTable.order-column.stripe tbody tr.even.selected > .sorting_2 {
    background-color: #aebcd6
}

table.dataTable.display tbody tr.even.selected > .sorting_3, table.dataTable.order-column.stripe tbody tr.even.selected > .sorting_3 {
    background-color: #afbdd8
}

table.dataTable.display tbody tr:hover > .sorting_1, table.dataTable.order-column.hover tbody tr:hover > .sorting_1 {
    background-color: #eaeaea
}

table.dataTable.display tbody tr:hover > .sorting_2, table.dataTable.order-column.hover tbody tr:hover > .sorting_2 {
    background-color: #ececec
}

table.dataTable.display tbody tr:hover > .sorting_3, table.dataTable.order-column.hover tbody tr:hover > .sorting_3 {
    background-color: #efefef
}

table.dataTable.display tbody tr:hover.selected > .sorting_1, table.dataTable.order-column.hover tbody tr:hover.selected > .sorting_1 {
    background-color: #a2aec7
}

table.dataTable.display tbody tr:hover.selected > .sorting_2, table.dataTable.order-column.hover tbody tr:hover.selected > .sorting_2 {
    background-color: #a3b0c9
}

table.dataTable.display tbody tr:hover.selected > .sorting_3, table.dataTable.order-column.hover tbody tr:hover.selected > .sorting_3 {
    background-color: #a5b2cb
}

table.dataTable.no-footer {
    border-bottom: 1px solid #111
}

table.dataTable.nowrap th, table.dataTable.nowrap td {
    white-space: nowrap
}

table.dataTable.compact thead th, table.dataTable.compact thead td {
    padding: 4px 17px 4px 4px
}

table.dataTable.compact tfoot th, table.dataTable.compact tfoot td {
    padding: 4px
}

table.dataTable.compact tbody th, table.dataTable.compact tbody td {
    padding: 4px
}

table.dataTable th.dt-left, table.dataTable td.dt-left {
    text-align: left
}

table.dataTable th.dt-center, table.dataTable td.dt-center, table.dataTable td.dataTables_empty {
    text-align: center
}

table.dataTable th.dt-right, table.dataTable td.dt-right {
    text-align: right
}

table.dataTable th.dt-justify, table.dataTable td.dt-justify {
    text-align: justify
}

table.dataTable th.dt-nowrap, table.dataTable td.dt-nowrap {
    white-space: nowrap
}

table.dataTable thead th.dt-head-left, table.dataTable thead td.dt-head-left,
table.dataTable tfoot th.dt-head-left, table.dataTable tfoot td.dt-head-left {
    text-align: left
}

table.dataTable thead th.dt-head-center, table.dataTable thead td.dt-head-center,
table.dataTable tfoot th.dt-head-center, table.dataTable tfoot td.dt-head-center {
    text-align: center
}

table.dataTable thead th.dt-head-right, table.dataTable thead td.dt-head-right,
table.dataTable tfoot th.dt-head-right, table.dataTable tfoot td.dt-head-right {
    text-align: right
}

table.dataTable thead th.dt-head-justify, table.dataTable thead td.dt-head-justify,
table.dataTable tfoot th.dt-head-justify, table.dataTable tfoot td.dt-head-justify {
    text-align: justify
}

table.dataTable thead th.dt-head-nowrap, table.dataTable thead td.dt-head-nowrap,
table.dataTable tfoot th.dt-head-nowrap, table.dataTable tfoot td.dt-head-nowrap {
    white-space: nowrap
}

table.dataTable tbody th.dt-body-left, table.dataTable tbody td.dt-body-left {
    text-align: left
}

table.dataTable tbody th.dt-body-center, table.dataTable tbody td.dt-body-center {
    text-align: center
}

table.dataTable tbody th.dt-body-right, table.dataTable tbody td.dt-body-right {
    text-align: right
}

table.dataTable tbody th.dt-body-justify, table.dataTable tbody td.dt-body-justify {
    text-align: justify
}

table.dataTable tbody th.dt-body-nowrap, table.dataTable tbody td.dt-body-nowrap {
    white-space: nowrap
}

table.dataTable, table.dataTable th, table.dataTable td {
    -webkit-box-sizing: content-box;
    -moz-box-sizing: content-box;
    box-sizing: content-box
}

.dataTables_wrapper {
    position: relative;
    clear: both;
    * zoom: 1;
    zoom: 1
}

.dataTables_wrapper .dataTables_length {
    float: left
}

.dataTables_wrapper .dataTables_filter {
    float: right;
    text-align: right
}

.dataTables_wrapper .dataTables_filter input {
    margin-left: 0.5em
}

.dataTables_wrapper .dataTables_info {
    clear: both;
    float: left;
    padding-top: 0.755em
}

.dataTables_wrapper .dataTables_paginate {
    float: right;
    text-align: right;
    padding-top: 0.25em
}

.dataTables_wrapper .dataTables_paginate .paginate_button {
    box-sizing: border-box;
    display: inline-block;
    min-width: 1.5em;
    padding: 0.5em 1em;
    margin-left: 2px;
    text-align: center;
    text-decoration: none !important;
    cursor: pointer;
    * cursor: hand;
    color: #333 !important;
    border: 1px solid transparent;
    border-radius: 2px
}

.dataTables_wrapper .dataTables_paginate .paginate_button.current,
.dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
    color: #333 !important;
    border: 1px solid #979797;
    background-color: white;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #fff), color-stop(100%, #dcdcdc));
    background: -webkit-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background: -moz-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background: -ms-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background: -o-linear-gradient(top, #fff 0%, #dcdcdc 100%);
    background: linear-gradient(to bottom, #fff 0%, #dcdcdc 100%)
}

.dataTables_wrapper .dataTables_paginate .paginate_button.disabled,
.dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover,
.dataTables_wrapper .dataTables_paginate .paginate_button.disabled:active {
    cursor: default;
    color: #666 !important;
    border: 1px solid transparent;
    background: transparent;
    box-shadow: none
}

.dataTables_wrapper .dataTables_paginate .paginate_button:hover {
    color: white !important;
    border: 1px solid #111;
    background-color: #585858;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #585858), color-stop(100%, #111));
    background: -webkit-linear-gradient(top, #585858 0%, #111 100%);
    background: -moz-linear-gradient(top, #585858 0%, #111 100%);
    background: -ms-linear-gradient(top, #585858 0%, #111 100%);
    background: -o-linear-gradient(top, #585858 0%, #111 100%);
    background: linear-gradient(to bottom, #585858 0%, #111 100%)
}

.dataTables_wrapper .dataTables_paginate .paginate_button:active {
    outline: none;
    background-color: #2b2b2b;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #2b2b2b), color-stop(100%, #0c0c0c));
    background: -webkit-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);
    background: -moz-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);
    background: -ms-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);
    background: -o-linear-gradient(top, #2b2b2b 0%, #0c0c0c 100%);
    background: linear-gradient(to bottom, #2b2b2b 0%, #0c0c0c 100%);
    box-shadow: inset 0 0 3px #111
}

.dataTables_wrapper .dataTables_paginate .ellipsis {
    padding: 0 1em
}

.dataTables_wrapper .dataTables_processing {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 100%;
    height: 40px;
    margin-left: -50%;
    margin-top: -25px;
    padding-top: 20px;
    text-align: center;
    font-size: 1.2em;
    background-color: white;
    background: -webkit-gradient(linear, left top, right top, color-stop(0%, rgba(255, 255, 255, 0)), color-stop(25%, rgba(255, 255, 255, 0.9)), color-stop(75%, rgba(255, 255, 255, 0.9)), color-stop(100%, rgba(255, 255, 255, 0)));
    background: -webkit-linear-gradient(left, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.9) 25%, rgba(255, 255, 255, 0.9) 75%, rgba(255, 255, 255, 0) 100%);
    background: -moz-linear-gradient(left, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.9) 25%, rgba(255, 255, 255, 0.9) 75%, rgba(255, 255, 255, 0) 100%);
    background: -ms-linear-gradient(left, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.9) 25%, rgba(255, 255, 255, 0.9) 75%, rgba(255, 255, 255, 0) 100%);
    background: -o-linear-gradient(left, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.9) 25%, rgba(255, 255, 255, 0.9) 75%, rgba(255, 255, 255, 0) 100%);
    background: linear-gradient(to right, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.9) 25%, rgba(255, 255, 255, 0.9) 75%, rgba(255, 255, 255, 0) 100%)
}

.dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter,
.dataTables_wrapper .dataTables_info, .dataTables_wrapper .dataTables_processing,
.dataTables_wrapper .dataTables_paginate {
    color: #333
}

.dataTables_wrapper .dataTables_scroll {
    clear: both
}

.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody {
    * margin-top: -1px;
    -webkit-overflow-scrolling: touch
}

.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody th,
.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody td {
    vertical-align: middle
}

.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody th > div.dataTables_sizing,
.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody td > div.dataTables_sizing {
    height: 0;
    overflow: hidden;
    margin: 0 !important;
    padding: 0 !important
}

.dataTables_wrapper.no-footer .dataTables_scrollBody {
    border-bottom: 1px solid #111
}

.dataTables_wrapper.no-footer div.dataTables_scrollHead table,
.dataTables_wrapper.no-footer div.dataTables_scrollBody table {
    border-bottom: none
}

.dataTables_wrapper:after {
    visibility: hidden;
    display: block;
    content: "";
    clear: both;
    height: 0
}

@media screen and (max-width: 767px) {
    .dataTables_wrapper .dataTables_info, .dataTables_wrapper .dataTables_paginate {
        float: none;
        text-align: center
    }

    .dataTables_wrapper .dataTables_paginate {
        margin-top: 0.5em
    }
}

@media screen and (max-width: 640px) {
    .dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter {
        float: none;
        text-align: center
    }

    .dataTables_wrapper .dataTables_filter {
        margin-top: 0.5em
    }
}

</xsl:text>
			</xsl:element>
			<xsl:element name="script">
				<xsl:text>$(document).ready(function() {</xsl:text>
				<xsl:text>$('#</xsl:text>
				<xsl:value-of select="$uniqueTable"/>
				<xsl:text>').DataTable();} );</xsl:text>
			</xsl:element>
		</xsl:if>
		<!-\-<script>
        $(document).ready(function() {
        $('#table-d1449e99').dataTable( {
        "scrollY":        "200px",
        "scrollCollapse": true,
        "paging":         false
        } );
        } );
      </script>-\->
		<xsl:value-of select="$newline"/>
		<!-\- special case for IE & NS for frame & no rules - needs to be a double table -\->
		<xsl:variable name="colsep">
			<xsl:choose>
				<xsl:when test="*[contains(@class, ' topic/tgroup ')]/@colsep">
					<xsl:value-of select="*[contains(@class, ' topic/tgroup ')]/@colsep"/>
				</xsl:when>
				<xsl:when test="@colsep">
					<xsl:value-of select="@colsep"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rowsep">
			<xsl:choose>
				<xsl:when test="*[contains(@class, ' topic/tgroup ')]/@rowsep">
					<xsl:value-of select="*[contains(@class, ' topic/tgroup ')]/@rowsep"/>
				</xsl:when>
				<xsl:when test="@rowsep">
					<xsl:value-of select="@rowsep"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@frame = 'all' and $colsep = '0' and $rowsep = '0'">
				<xsl:call-template name="profiling-atts"/>
				<table id="{$uniqueTable}" cellpadding="4" cellspacing="0" border="1"
					class="tableborder">
					<tr valign="top">
						<td>
							<xsl:value-of select="$newline"/>
							<xsl:call-template name="dotable"/>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="@frame = 'top' and $colsep = '0' and $rowsep = '0'">
				<hr/>
				<xsl:value-of select="$newline"/>
				<xsl:call-template name="profiling-atts"/>
				<xsl:call-template name="dotable"/>
			</xsl:when>
			<xsl:when test="@frame = 'bot' and $colsep = '0' and $rowsep = '0'">
				<xsl:call-template name="profiling-atts"/>
				<xsl:call-template name="dotable"/>
				<hr/>
				<xsl:value-of select="$newline"/>
			</xsl:when>
			<xsl:when test="@frame = 'topbot' and $colsep = '0' and $rowsep = '0'">
				<xsl:call-template name="profiling-atts"/>
				<hr/>
				<xsl:value-of select="$newline"/>
				<xsl:call-template name="dotable"/>
				<hr/>
				<xsl:value-of select="$newline"/>
			</xsl:when>
			<xsl:when test="not(@frame) and $colsep = '0' and $rowsep = '0'">
				<xsl:call-template name="profiling-atts"/>
				<span class="orgID">
					<xsl:attribute name="stringName" select="@id"/>
				</span>
				<table id="{$uniqueTable}" cellpadding="4" cellspacing="0" border="1"
					class="tableborder">
					<tr valign="top">
						<td>
							<xsl:value-of select="$newline"/>
							<xsl:call-template name="dotable"/>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="profiling-atts"/>
				<div class="tablenoborder">
					<xsl:call-template name="dotable">
						<xsl:with-param name="uniqueTable">
							<xsl:value-of select="$uniqueTable"/>
						</xsl:with-param>
					</xsl:call-template>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
		<!-\- Comtech Services 09/09/2013 added line to table template to generate footer -\->
		<xsl:if test="descendant-or-self::*[contains(@class, ' topic/fn ')]">
			<p>
				<xsl:call-template name="gen-endnotes-tablefooter"/>
			</p>
		</xsl:if>
	</xsl:template>-->
	<!-- Comtech Services 09/09/2013 added to conditionalize the footnotes for tables -->
	<!-- render any contained footnotes as endnotes.  Links back to reference point -->
	
	<!-- added to ge_custom.xsl -->
	<!--<xsl:template name="gen-endnotes">
		<!-\- Skip any footnotes that are in draft elements when draft = no -\->
		<xsl:apply-templates
			select="//*[contains(@class, ' topic/fn ')][not((ancestor::*[contains(@class, ' topic/draft-comment ')] or ancestor::*[contains(@class, ' topic/required-cleanup ')] or ancestor::*[contains(@class, ' topic/table ')] or ancestor::*[contains(@class, ' task/choicetable ')] or ancestor::*[contains(@class, ' topic/simpletable ')]))]"
			mode="genEndnote"/>
	</xsl:template>
	<xsl:template name="gen-endnotes-tablefooter">
		<!-\- Skip any footnotes that are in draft elements when draft = no -\->
		<xsl:apply-templates select="descendant-or-self::*[contains(@class, ' topic/fn ')]"
			mode="genEndnote"/>
	</xsl:template>-->
	<!-- Comtech Services 09/09/2013 added to conditionalize the footnotes for tables with letter callouts and other callouts with number callouts -->
	<!-- Footnote source and target not working in tables US271 Defect MJT:FMC 7/12/2016 -->
	<!--<xsl:template match="*[contains(@class, ' topic/fn ')]" name="topic.fn">
		<xsl:param name="xref"/>
		<!-\- when FN has an ID, it can only be referenced, otherwise, output an a-name & a counter -\->
		<!-\-<xsl:if test="not(@id) or $xref='yes'">-\->
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
		<!-\-</xsl:if>-\->
	</xsl:template>-->
	<!-- Comtech Services 09/09/2013 added to conditionalize the footnotes for tables with letter callouts and other callouts with number callouts -->
	<!--<xsl:template match="*[contains(@class, ' topic/fn ')]" mode="genEndnote">
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
			<!-\-<xsl:choose>
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
        <xsl:otherwise>-\->
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
					<!-\-        </xsl:otherwise>
      </xsl:choose>-\->
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
					<!-\-        </xsl:otherwise>
      </xsl:choose>-\->
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
					<!-\-        </xsl:otherwise>
      </xsl:choose>-\->
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
					<!-\-        </xsl:otherwise>
      </xsl:choose>-\->
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</div>
	</xsl:template>-->
	<!-- Comtech Services 09/09/2013 added to manage html5 video objects -->
	<!-- object, desc, & param -->
	
	<!-- topic/object moved to ge_custom.xsl -->
	<!--<xsl:template match="*[contains(@class, ' topic/object ')]" name="topic.object">
		<iframe>
			<xsl:copy-of
				select="@id | @declare | @codebase | @type | @archive | @height | @usemap | @tabindex | @classid | @data | @codetype | @standby | @width | @name"/>
			<xsl:attribute name="frameborder">0</xsl:attribute>
			<xsl:if test="@longdescref or *[contains(@class, ' topic/longdescref ')]">
				<xsl:apply-templates select="." mode="ditamsg:longdescref-on-object"/>
			</xsl:if>
			<xsl:apply-templates select="." mode="ditamsg:webhelp-object"/>
			<xsl:apply-templates/>
			<!-\-
      <xsl:attribute name="frameborder">0</xsl:attribute>
      <xsl:text> </xsl:text>-\->
		</iframe>
	</xsl:template>-->
	<!--<xsl:template match="*[contains(@class, ' topic/param ')]" name="topic.param">
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
	</xsl:template>-->
	<!-- Comtech Services 09/09/2013 remove context gentext -->
	<!--<xsl:template match="*[contains(@class, ' task/context ')]" mode="dita2html:section-heading">
		<!-\-<xsl:apply-templates select="." mode="generate-task-label">
      <xsl:with-param name="use-label">
        <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'task_context'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:apply-templates>-\->
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/prereq ')]" mode="dita2html:section-heading">
		<xsl:apply-templates select="." mode="generate-task-label">
			<xsl:with-param name="use-label">
				<xsl:choose>
					<xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
						<!-\-<xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'Prerequisite Open'"/>
            </xsl:call-template>-\->
					</xsl:when>
					<xsl:when
						test="$GENERATE-TASK-LABELS = 'mr-labels' or $GENERATE-TASK-LABELS = 'imaging-labels'">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Prerequisite Open_MR'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$GENERATE-TASK-LABELS = 'basic-labels'">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Prerequisite Open_BASIC'"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/result ')]" mode="dita2html:section-heading">
		<xsl:apply-templates select="." mode="generate-task-label">
			<xsl:with-param name="use-label">
				<xsl:choose>
					<xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
						<!-\-<xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'Reslut Open'"/>
            </xsl:call-template>-\->
					</xsl:when>
					<xsl:when
						test="$GENERATE-TASK-LABELS = 'mr-labels' or $GENERATE-TASK-LABELS = 'imaging-labels'">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Result Open_MR'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$GENERATE-TASK-LABELS = 'basic-labels'">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Result Open_BASIC'"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/postreq ')]" mode="dita2html:section-heading">
		<xsl:apply-templates select="." mode="generate-task-label">
			<xsl:with-param name="use-label">
				<xsl:choose>
					<xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
						<!-\-<xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'Postrequisite Open'"/>
            </xsl:call-template>-\->
					</xsl:when>
					<xsl:when
						test="$GENERATE-TASK-LABELS = 'mr-labels' or $GENERATE-TASK-LABELS = 'imaging-labels'">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Postrequisite Open_MR'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$GENERATE-TASK-LABELS = 'basic-labels'">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Postrequisite Open_BASIC'"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template
		match="*[contains(@class, ' task/taskbody ')]/*[contains(@class, ' topic/example ')][not(*[contains(@class, ' topic/title ')])]"
		mode="dita2html:section-heading">
		<xsl:apply-templates select="." mode="generate-task-label">
			<xsl:with-param name="use-label">
				<xsl:choose>
					<xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
						<!-\-<xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'Example Open'"/>
            </xsl:call-template>-\->
					</xsl:when>
					<xsl:when
						test="$GENERATE-TASK-LABELS = 'mr-labels' or $GENERATE-TASK-LABELS = 'imaging-labels'">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Example Open'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$GENERATE-TASK-LABELS = 'basic-labels'">
						<xsl:call-template name="getString">
							<xsl:with-param name="stringName" select="'Example Open'"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="*" mode="generate-task-label">
		<xsl:param name="use-label"/>
		<xsl:if
			test="$GENERATE-TASK-LABELS = 'mr-labels' or $GENERATE-TASK-LABELS = 'imaging-labels' or $GENERATE-TASK-LABELS = 'basic-labels'">
			<xsl:variable name="headLevel">
				<xsl:variable name="headCount">
					<xsl:value-of select="count(ancestor::*[contains(@class, ' topic/topic ')]) + 1"
					/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$headCount > 6">h6</xsl:when>
					<xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div class="tasklabel">
				<xsl:element name="{$headLevel}">
					<xsl:attribute name="class">sectiontitle tasklabel</xsl:attribute>
					<xsl:value-of select="$use-label"/>
				</xsl:element>
			</div>
		</xsl:if>
	</xsl:template>-->
	<!-- paragraphs -->
	<xsl:template match="*[contains(@class, ' topic/p ')]" name="topic.p">
		<!-- To ensure XHTML validity, need to determine whether the DITA kids are block elements.
      If so, use div_class="p" instead of p -->
		<!-- Comtech 07/18/2013 set first <p> into concept topic to span page using <aside> -->
		<xsl:choose>
			<xsl:when test="preceding-sibling::* and parent::*[contains(@class, ' topic/body ')]">
				<xsl:choose>
					<!-- Comtech 07/18/2013 add twisty catch and wrap content in <p>-->
					<xsl:when test="contains(@outputclass, 'show_hide')">
						<p>
							<!--<div class="p collapsible">-->
							<xsl:call-template name="setid"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:element name="a">
								<xsl:attribute name="onclick">
									<xsl:text>javascript:toggleTwisty('</xsl:text>
									<xsl:value-of select="generate-id()"/>
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
									<xsl:value-of select="generate-id()"/>
								</xsl:attribute>
								<xsl:element name="div">
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:element>
							<!--</div>-->
							<script type="text/javascript">
                <xsl:text>hideTwisty('</xsl:text>
                <xsl:value-of select="generate-id()"/>
                <xsl:text>');</xsl:text>
              </script>
						</p>
					</xsl:when>
					<xsl:when test="contains(@outputclass, 'show_hide_expanded')">
						<p>
							<!--<div class="p collapsible">-->
							<xsl:call-template name="setid"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:element name="a">
								<xsl:attribute name="onclick">
									<xsl:text>javascript:toggleTwisty('</xsl:text>
									<xsl:value-of select="generate-id()"/>
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
									<xsl:value-of select="generate-id()"/>
								</xsl:attribute>
								<xsl:element name="div">
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:element>
							<!--</div>-->
						</p>
					</xsl:when>
					<xsl:when
						test="descendant::*[contains(@class, ' topic/pre ')] or descendant::*[contains(@class, ' topic/ul ')] or descendant::*[contains(@class, ' topic/sl ')] or descendant::*[contains(@class, ' topic/ol ')] or descendant::*[contains(@class, ' topic/lq ')] or descendant::*[contains(@class, ' topic/dl ')] or descendant::*[contains(@class, ' topic/note ')] or descendant::*[contains(@class, ' topic/lines ')] or descendant::*[contains(@class, ' topic/fig ')] or descendant::*[contains(@class, ' topic/table ')] or descendant::*[contains(@class, ' topic/simpletable ')]">
						<div class="p">
							<xsl:call-template name="setid"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<p>
							<xsl:call-template name="setid"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="contains(@outputclass, 'show_hide')">
						<p>
							<!--<div class="p collapsible">-->
							<xsl:call-template name="setid"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:element name="a">
								<xsl:attribute name="onclick">
									<xsl:text>javascript:toggleTwisty('</xsl:text>
									<xsl:value-of select="generate-id()"/>
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
									<xsl:value-of select="generate-id()"/>
								</xsl:attribute>
								<xsl:element name="div">
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:element>
							<!--</div>-->
						</p>
						<script type="text/javascript">
              <xsl:text>hideTwisty('</xsl:text>
              <xsl:value-of select="generate-id()"/>
              <xsl:text>');</xsl:text>
            </script>
					</xsl:when>
					<xsl:when test="contains(@outputclass, 'show_hide_expanded')">
						<p>
							<!--<div class="p collapsible">-->
							<xsl:call-template name="setid"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:element name="a">
								<xsl:attribute name="onclick">
									<xsl:text>javascript:toggleTwisty('</xsl:text>
									<xsl:value-of select="generate-id()"/>
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
									<xsl:value-of select="generate-id()"/>
								</xsl:attribute>
								<xsl:element name="div">
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:element>
							<!--</div>-->
						</p>
					</xsl:when>
					<xsl:when
						test="descendant::*[contains(@class, ' topic/pre ')] or descendant::*[contains(@class, ' topic/ul ')] or descendant::*[contains(@class, ' topic/sl ')] or descendant::*[contains(@class, ' topic/ol ')] or descendant::*[contains(@class, ' topic/lq ')] or descendant::*[contains(@class, ' topic/dl ')] or descendant::*[contains(@class, ' topic/note ')] or descendant::*[contains(@class, ' topic/lines ')] or descendant::*[contains(@class, ' topic/fig ')] or descendant::*[contains(@class, ' topic/table ')] or descendant::*[contains(@class, ' topic/simpletable ')]">
						<div class="p">
							<xsl:call-template name="setid"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<p>
							<xsl:call-template name="setid"/>
							<xsl:call-template name="commonattributes"/>
							<xsl:apply-templates/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!-- US274 remove border from callout list MJT:FMC 8/31/2016 -->
	<!--<xsl:template match="*[contains(@class, ' topic/ol ')]" name="topic.ol">
		<xsl:if test="contains(@class, ' task/steps ')">
			<xsl:apply-templates select="." mode="generate-task-label">
				<xsl:with-param name="use-label">
					<xsl:choose>
						<xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
							<!-\-<xsl:call-template name="getWebhelpString">
              <xsl:with-param name="stringName" select="'Steps Open'"/>
            </xsl:call-template>-\->
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
					<!-\-<div class="p collapsible">-\->
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
					<!-\-</div>-\->
				</p>
				<script type="text/javascript">
          <xsl:text>hideTwisty('</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>');</xsl:text>
        </script>
			</xsl:when>
			<xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
				<p>
					<!-\-<div class="p collapsible">-\->
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
					<!-\-</div>-\->
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
									<!-\-<table style="border:1pt solid grey;width:50%;margin-top:6pt;">-\->
									<!-\- start-indent="-.0625in" -\->
									<xsl:for-each
										select="child::*[position() &lt;= $calloutCountSplit + 1]">
										<tr>
											<td style="margin-right:24pt;">
												<span><xsl:value-of
												select="count(preceding-sibling::*) + 1"/>. </span>
												<span>
												<xsl:apply-templates/>
												</span>
											</td>
											<td>
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
									<!-\- start-indent="-.0625in" -\->
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
	</xsl:template>-->
	<!-- US261 checkbox list MJT:FMC 8/31/2016 -->
	<!-- list item -->
	<!--<xsl:template match="*[contains(@class, ' topic/li ')]" name="topic.li">
		<xsl:choose>
			<xsl:when test="ancestor-or-self::*[contains(@class, ' hazard-d/messagepanel ')]">
				<li>
					<xsl:if test="ancestor-or-self::*[contains(@class, 'hazardstatement')]">
						<xsl:attribute name="style">list-style:none;</xsl:attribute>
					</xsl:if>
					<!-\-<xsl:choose>
            <xsl:when test="parent::*/@compact='no'">
              <xsl:attribute name="class">liexpand</xsl:attribute>
              <!-\\- handle non-compact list items -\\->
              <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'liexpand'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="commonattributes"/>
            </xsl:otherwise>
          </xsl:choose>-\->
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>
				</li>
				<xsl:value-of select="$newline"/>
			</xsl:when>
			<xsl:when
				test="*[contains(@class, ' hazard-d/hazardstatement')][ancestor-or-self::*[contains(@class, ' task/step')]]">
				<!-\- FMC 03/16/2015 move hazardstatement above cmd -\->
				<!-\- GEHC-86 / Ryffine-MJT- Move hazardstatement ONLY when step list-\->
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
					<!-\- NMM 04/23/2017: Move note content above cmd -\->
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
					<!-\- this is to process callout list -\->
					<xsl:if test="ancestor-or-self::*[contains(@class, ' topic/fig ')]">
						<!-\-<xsl:attribute name="style">margin-left:-5pt;</xsl:attribute>-\->
					</xsl:if>
					<!-\-<xsl:choose>
            <xsl:when test="parent::*/@compact='no'">
              <xsl:attribute name="class">liexpand</xsl:attribute>
              <!-\\- handle non-compact list items -\\->
              <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'liexpand'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="commonattributes"/>
            </xsl:otherwise>
          </xsl:choose>-\->
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
					<!-\- this is to process callout list -\->
					<xsl:if test="ancestor-or-self::*[contains(@class, ' topic/fig ')]">
						<!-\-<xsl:attribute name="style">margin-left:-5pt;</xsl:attribute>-\->
					</xsl:if>
					<!-\-<xsl:choose>
            <xsl:when test="parent::*/@compact='no'">
              <xsl:attribute name="class">liexpand</xsl:attribute>
              <!-\\- handle non-compact list items -\\->
              <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'liexpand'"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="commonattributes"/>
            </xsl:otherwise>
          </xsl:choose>-\->
					<xsl:call-template name="setidaname"/>
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>
				</li>
				<xsl:value-of select="$newline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	<!-- Simple List -->
	<!-- handle all levels thru browser processing -->
	<!--<xsl:template match="*[contains(@class, ' topic/sl ')]" name="topic.sl">
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
	</xsl:template>-->
	<!--<xsl:template match="*[contains(@class, ' hazard-d/messagepanel ')]">
		<!-\- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -\->
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
	</xsl:template>-->
	<!--<xsl:template match="*[contains(@class, ' topic/ul ')]" mode="ul-fmt">
		<xsl:choose>
			<xsl:when test="contains(@outputclass, 'show_hide') and @id">
				<p>
					<!-\-<div class="p collapsible">-\->
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
						<!-\- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -\->
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
					<!-\-</div>-\->
				</p>
				<script type="text/javascript">
          <xsl:text>hideTwisty('</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>');</xsl:text>
        </script>
			</xsl:when>
			<xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
				<p>
					<!-\-<div class="p collapsible">-\->
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
						<!-\- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -\->
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
					<!-\-</div>-\->
				</p>
			</xsl:when>
			<xsl:otherwise>
				<!-\- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -\->
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
	</xsl:template>-->
	<!-- =========== FIGURE =========== -->
	<!--<xsl:template match="*[contains(@class, ' topic/fig ')]" name="topic.fig">
		<!-\- OXYGEN PATCH START  EXM-18109 - moved image caption below. -\->
		<!-\-<xsl:apply-templates
        select="*[not(contains(@class,' topic/title '))][not(contains(@class,' topic/desc '))] |text()|comment()|processing-instruction()"/>-\->
		<!-\-<xsl:call-template name="place-fig-lbl"/>-\->
		<!-\- OXYGEN PATCH END  EXM-18109 -\->
		<xsl:choose>
			<xsl:when test="contains(@outputclass, 'show_hide') and @id">
				<p>
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<!-\-<div class="p collapsible">-\->
					<xsl:call-template name="commonattributes"/>
					<!-\-<xsl:call-template name="setid"/>-\->
					<xsl:call-template name="place-fig-lbl"/>
					<xsl:text>  </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="style">padding-left:6pt;</xsl:attribute>
						<xsl:attribute name="onclick">
							<xsl:text>javascript:toggleTwisty('</xsl:text>
							<xsl:value-of select="generate-id(@id)"/>
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
							<xsl:value-of select="generate-id(@id)"/>
						</xsl:attribute>
						<xsl:apply-templates select="." mode="fig-fmt"/>
					</xsl:element>
					<!-\-</div>-\->
				</p>
				<script type="text/javascript">
          <xsl:text>hideTwisty('</xsl:text>
          <xsl:value-of select="generate-id(@id)"/>
          <xsl:text>');</xsl:text>
        </script>
			</xsl:when>
			<xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
				<p>
					<xsl:attribute name="id">
						<xsl:value-of select="@id"/>
					</xsl:attribute>
					<!-\-<div class="p collapsible">-\->
					<xsl:call-template name="commonattributes"/>
					<!-\-<xsl:call-template name="setid"/>-\->
					<xsl:call-template name="place-fig-lbl"/>
					<xsl:text>  </xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="onclick">
							<xsl:text>javascript:toggleTwisty('</xsl:text>
							<xsl:value-of select="generate-id(@id)"/>
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
							<xsl:value-of select="generate-id(@id)"/>
						</xsl:attribute>
						<xsl:apply-templates select="." mode="fig-fmt"/>
					</xsl:element>
					<!-\-</div>-\->
				</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="fig-fmt"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	<!--<xsl:template name="topic-image">
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<img>
			<xsl:call-template name="commonattributes">
				<xsl:with-param name="default-output-class">
					<xsl:choose>
						<xsl:when test="@placement = 'break' or not(@placement)">
							<!-\-Align only works for break-\->
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
					<!-\-xsl:when test="../@scale and string(number(../@scale))!='NaN'">
            <xsl:value-of select="number($width-in-pixel) * number(../@scale)"/>
          </xsl:when>-\->
					<xsl:otherwise>
						<xsl:value-of select="number($width-in-pixel)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="width">
				<!-\-xsl:choose>
        <xsl:when test="../@scale and string(number(../@scale))!='NaN'">
          <xsl:value-of select="number($width-in-pixel) * number(../@scale)"/>
        </xsl:when>
        <xsl:otherwise-\->
				<xsl:value-of select="number($width-in-pixel)"/>
				<!-\-/xsl:otherwise>
      </xsl:choose-\->
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<!-\- Figure title below image US278 MJT:FMC 6/27/2016 -\->
	<xsl:template match="*[contains(@class, ' topic/fig ')]" mode="fig-fmt">
		<!-\- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -\->
		<xsl:variable name="default-fig-class">
			<xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
		</xsl:variable>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<!-\- Comtech 07/18/2013 change <div> to <figure> -\->
		<!-\- US285 List alignment MJT:FMC 8/19/2016 -\->
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
						<!-\- US61 honor @expanse for figures in lists, etc. MJT:FMC 7/24/2016 -\->
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
											<!-\-   <xsl:value-of select="concat('margin-left: -', $indentDecrement * 40, 'px;')"/>-\->
											<!-\- not working now that I introduced list margins -\->
											<xsl:text>margin-right: 0; padding-left: 0; padding-right: 0;</xsl:text>
										</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<!-\-<xsl:attribute name="style">margin-left: -40px; margin-right: 0; padding-left: 0; padding-right: 0;</xsl:attribute>-\->
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
						<!-\- OXYGEN PATCH START  EXM-18109 -\->
						<xsl:apply-templates
							select="*[not(contains(@class, ' topic/title '))][not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"/>
						<!-\- OXYGEN PATCH END  EXM-18109 -\->
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
					<!-\- OXYGEN PATCH START  EXM-18109 -\->
					<xsl:apply-templates
						select="*[not(contains(@class, ' topic/title '))][not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"/>
					<!-\- OXYGEN PATCH END  EXM-18109 -\->
				</figure>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<xsl:template name="place-fig-lbl">
		<xsl:param name="id"/>
		<!-\- Number of fig/title's including this one -\->
		<xsl:variable name="fig-count-actual"
			select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]) + 1"/>
		<xsl:variable name="ancestorlang">
			<xsl:call-template name="getLowerCaseLang"/>
		</xsl:variable>
		<xsl:choose>
			<!-\- title -or- title & desc -\->
			<xsl:when test="*[contains(@class, ' topic/title ')]">
				<!-\- OXYGEN PATCH START  EXM-18109 -\->
				<!-\-<span class="figcap">-\->
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
							<!-\- FMC 03/10/2015 Add Figure gentext from the Table titles -\->
							<xsl:choose>
								<!-\- Hungarian: "1. Figure " -\->
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
							<!-\- OXYGEN PATCH END  EXM-18109 -\->
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
			<!-\- desc -\->
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
		<!-\- Comtech 07/18/2013 added <figurecaption> -\->
		<figurecaption>
			<xsl:apply-templates/>
		</figurecaption>
	</xsl:template>-->
	
	<!-- moved to tables.xsl -->
	<!-- =========== TABLE =========== -->
	<!--<xsl:template match="*[contains(@class, ' topic/table ')]" name="topic.table">
		<aside>
			<xsl:choose>
				<xsl:when test="contains(@outputclass, 'show_hide') and @id">
					<p>
						<!-\-<div class="p collapsible">-\->
						<xsl:call-template name="commonattributes"/>
						<xsl:call-template name="setid"/>
						<xsl:element name="h4">
							<xsl:attribute name="class">sectiontitle</xsl:attribute>
							<xsl:call-template name="commonattributes">
								<xsl:with-param name="default-output-class" select="'sectiontitle'"
								/>
							</xsl:call-template>
							<xsl:apply-templates select="*[contains(@class, ' topic/title ')]"
								mode="section-fmt-title">
								<xsl:with-param name="idValue">
									<xsl:value-of select="@id"/>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:element>
						<xsl:element name="div">
							<xsl:attribute name="id">
								<xsl:value-of select="@id"/>
							</xsl:attribute>
							<xsl:apply-templates select="." mode="table-fmt"/>
						</xsl:element>
						<!-\-</div>-\->
					</p>
					<script type="text/javascript">
          <xsl:text>hideTwisty('</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>');</xsl:text>
        </script>
				</xsl:when>
				<xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
					<p>
						<!-\-<div class="p collapsible">-\->
						<xsl:call-template name="commonattributes"/>
						<xsl:call-template name="setid"/>
						<xsl:element name="h4">
							<xsl:attribute name="class">sectiontitle</xsl:attribute>
							<xsl:call-template name="commonattributes">
								<xsl:with-param name="default-output-class" select="'sectiontitle'"
								/>
							</xsl:call-template>
							<xsl:apply-templates select="*[contains(@class, ' topic/title ')]"
								mode="section-fmt-title">
								<xsl:with-param name="idValue">
									<xsl:value-of select="@id"/>
								</xsl:with-param>
							</xsl:apply-templates>
						</xsl:element>
						<xsl:element name="div">
							<xsl:attribute name="id">
								<xsl:value-of select="@id"/>
							</xsl:attribute>
							<xsl:apply-templates select="." mode="table-fmt"/>
						</xsl:element>
						<!-\-</div>-\->
					</p>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="table-fmt"/>
				</xsl:otherwise>
			</xsl:choose>
		</aside>
	</xsl:template>-->
	<!--<xsl:template match="*[contains(@class, ' topic/section ')]" name="topic.section">
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'show_hide') and @id">
        <section>
          <!-\-<div class="p collapsible">-\->
          <xsl:call-template name="commonattributes"/>
          <xsl:call-template name="setid"/>
          <xsl:element name="h4">
            <xsl:attribute name="class">sectiontitle</xsl:attribute>
            <xsl:call-template name="commonattributes">
              <xsl:with-param name="default-output-class" select="'sectiontitle'"/>
            </xsl:call-template>
            <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"
              mode="section-fmt-title">
              <xsl:with-param name="idValue">
                <xsl:value-of select="@id"/>
              </xsl:with-param>
            </xsl:apply-templates>
          </xsl:element>
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
            <!-\- Comtech 07/18/2013 change <div @class='section'> to <section> -\->
            <section>

              <xsl:call-template name="gen-toc-id"/>
              <xsl:call-template name="setidaname"/>
              <xsl:call-template name="commonattributes"/>
              <xsl:apply-templates select=".[not(contains(@class, ' topic/title '))]"
                mode="section-fmt"/>
            </section>
            <xsl:value-of select="$newline"/>
          </xsl:element>
          <!-\-</div>-\->
        </section>
        <script type="text/javascript">
          <xsl:text>hideTwisty('</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>');</xsl:text>
        </script>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
        <section>

          <!-\-<div class="p collapsible">-\->
          <xsl:call-template name="commonattributes"/>
          <xsl:call-template name="setid"/>
          <xsl:element name="h4">
            <xsl:attribute name="class">sectiontitle</xsl:attribute>
            <xsl:call-template name="commonattributes">
              <xsl:with-param name="default-output-class" select="'sectiontitle'"/>
            </xsl:call-template>
            <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"
              mode="section-fmt-title">
              <xsl:with-param name="idValue">
                <xsl:value-of select="@id"/>
              </xsl:with-param>
            </xsl:apply-templates>
          </xsl:element>
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
            <!-\- Comtech 07/18/2013 change <div @class='section'> to <section> -\->
            <section>
              <xsl:call-template name="gen-toc-id"/>
              <xsl:call-template name="setidaname"/>
              <xsl:call-template name="commonattributes"/>
              <xsl:apply-templates select="." mode="section-fmt"/>
            </section>
            <xsl:value-of select="$newline"/>
          </xsl:element>
          <!-\-</div>-\->
        </section>
      </xsl:when>
      <xsl:otherwise>
        <!-\- Comtech 07/18/2013 change <div @class='section'> to <section> -\->
        <section>
          <xsl:call-template name="gen-toc-id"/>
          <xsl:call-template name="setidaname"/>
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates select="." mode="section-fmt"/>
        </section>
        <xsl:value-of select="$newline"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->
	<!--<xsl:template
    match="
      *[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')] |
      *[contains(@class, ' topic/example ')]/*[contains(@class, ' topic/title ')]"
    name="topic.section_title">
    <xsl:param name="headLevel">
      <xsl:variable name="headCount">
        <xsl:value-of select="count(ancestor::*[contains(@class, ' topic/topic ')]) + 1"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$headCount > 6">h6</xsl:when>
        <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:if test="not(ancestor-or-self::*[contains(@outputclass, 'show_hide')])">
      <xsl:element name="h4">
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:attribute name="class">sectiontitle</xsl:attribute>
        <xsl:call-template name="commonattributes">
          <xsl:with-param name="default-output-class" select="'sectiontitle'"/>
        </xsl:call-template>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
  </xsl:template>-->
	
	<!-- moved to tables.xsl -->
	<!--<xsl:template name="place-tbl-lbl">
		<xsl:param name="id"/>
		<!-\- Number of table/title's before this one -\->
		<xsl:variable name="tbl-count-actual"
			select="count(preceding::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]) + 1"/>
		<!-\- normally: "Table 1. " -\->
		<xsl:variable name="ancestorlang">
			<xsl:call-template name="getLowerCaseLang"/>
		</xsl:variable>
		<xsl:choose>
			<!-\- title -or- title & desc -\->
			<xsl:when test="*[contains(@class, ' topic/title ')]">
				<xsl:if test="not(ancestor-or-self::*[contains(@outputclass, 'show_hide')])">
					<caption>
						<span class="tablecap">
							<!-\- FMC 03/10/2015 Add Table gentext from the Table titles -\->
							<xsl:choose>
								<!-\- Hungarian: "1. Table " -\->
								<xsl:when
									test="((string-length($ancestorlang) = 5 and contains($ancestorlang, 'hu-hu')) or (string-length($ancestorlang) = 2 and contains($ancestorlang, 'hu')))">
									<xsl:value-of select="$tbl-count-actual"/>
									<xsl:text>. </xsl:text>
									<xsl:call-template name="getWebhelpString">
										<xsl:with-param name="stringName" select="'Table'"/>
									</xsl:call-template>
									<xsl:text> </xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="getWebhelpString">
										<xsl:with-param name="stringName" select="'Table'"/>
									</xsl:call-template>
									<xsl:text> </xsl:text>
									<xsl:value-of select="$tbl-count-actual"/>
									<xsl:text>. </xsl:text>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:apply-templates select="*[contains(@class, ' topic/title ')]"
								mode="tabletitle"/>
						</span>
						<xsl:if test="*[contains(@class, ' topic/desc ')]">
							<p class="tabledesc">
								<xsl:for-each select="*[contains(@class, ' topic/desc ')]">
									<xsl:call-template name="commonattributes"/>
								</xsl:for-each>
								<xsl:apply-templates select="*[contains(@class, ' topic/desc ')]"
									mode="tabledesc"/>
							</p>
						</xsl:if>
					</caption>
				</xsl:if>
			</xsl:when>
			<!-\- desc -\->
			<xsl:when test="*[contains(@class, ' topic/desc ')]">
				<p class="tabledesc">
					<xsl:for-each select="*[contains(@class, ' topic/desc ')]">
						<xsl:call-template name="commonattributes"/>
					</xsl:for-each>
					<xsl:apply-templates select="*[contains(@class, ' topic/desc ')]"
						mode="tabledesc"/>
				</p>
			</xsl:when>
		</xsl:choose>
	</xsl:template>-->

	<!-- moved to ge_custom.xsl -->
	<!--	<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]"
		mode="figtitle">
		<xsl:apply-templates/>
	</xsl:template>-->
	
	
	<!--<xsl:template
    match="
      *[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')] |
      *[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')] |
      *[contains(@class, ' topic/example ')]/*[contains(@class, ' topic/title ')]"
    mode="section-fmt-title">
    <xsl:param name="idValue"/>
    <xsl:param name="headLevel">
      <xsl:variable name="headCount">
        <xsl:value-of select="count(ancestor::*[contains(@class, ' topic/topic ')]) + 1"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$headCount > 6">h6</xsl:when>
        <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:choose>
      <xsl:when
        test="ancestor-or-self::*[contains(@outputclass, 'show_hide')] and ancestor-or-self::*[@id]">
        <xsl:element name="h4">
          <xsl:attribute name="class">sectiontitle</xsl:attribute>
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class" select="'sectiontitle'"/>
          </xsl:call-template>
          <xsl:apply-templates/>
          <xsl:element name="a">
            <xsl:attribute name="style">padding-left:6pt;</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:text>javascript:toggleTwisty('</xsl:text>
              <xsl:value-of select="$idValue"/>
              <xsl:text>');</xsl:text>
            </xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="class">show_hide_expanded</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:value-of select="concat('oxygen-webhelp/resources/img/', 'collapse.gif')"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when
        test="ancestor-or-self::*[contains(@outputclass, 'show_hide_expanded')] and ancestor-or-self::*[@id]">
        <xsl:element name="h4">
          <xsl:attribute name="class">sectiontitle</xsl:attribute>
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class" select="'sectiontitle'"/>
          </xsl:call-template>
          <xsl:apply-templates/>
          <xsl:element name="a">
            <xsl:attribute name="style">padding-left:6pt;</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:text>javascript:toggleTwisty('</xsl:text>
              <xsl:value-of select="$idValue"/>
              <xsl:text>');</xsl:text>
            </xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="class">show_hide_expanded</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:value-of select="concat('oxygen-webhelp/resources/img/', 'expanded.gif')"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>-->
	<!--<xsl:template match="*[contains(@class, ' topic/example ')]" name="topic.example">
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'show_hide') and @id">
        <p>
          <!-\-<div class="p collapsible">-\->
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
                <xsl:value-of select="concat('oxygen-webhelp/resources/img/', 'collapse.gif')"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
            <!-\- Comtech 07/18/2013 change <div @class='section'> to <section> -\->
            <section>
              <xsl:call-template name="gen-toc-id"/>
              <xsl:call-template name="setidaname"/>
              <xsl:call-template name="commonattributes"/>
              <xsl:apply-templates select="." mode="example-fmt"/>
            </section>
            <xsl:value-of select="$newline"/>
          </xsl:element>
          <!-\-</div>-\->
        </p>
        <script type="text/javascript">
          <xsl:text>hideTwisty('</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>');</xsl:text>
        </script>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
        <p>
          <!-\-<div class="p collapsible">-\->
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
                <xsl:value-of select="concat('oxygen-webhelp/resources/img/', 'expanded.gif')"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="@id"/>
            </xsl:attribute>
            <!-\- Comtech 07/18/2013 change <div @class='section'> to <section> -\->
            <section>
              <xsl:call-template name="gen-toc-id"/>
              <xsl:call-template name="setidaname"/>
              <xsl:call-template name="commonattributes"/>
              <xsl:apply-templates select="." mode="example-fmt"/>
            </section>
            <xsl:value-of select="$newline"/>
          </xsl:element>
          <!-\-</div>-\->
        </p>
      </xsl:when>
      <xsl:otherwise>
        <!-\- Comtech 07/18/2013 change <div @class='section'> to <section> -\->
        <section>
          <xsl:call-template name="gen-toc-id"/>
          <xsl:call-template name="setidaname"/>
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates select="." mode="example-fmt"/>
        </section>
        <xsl:value-of select="$newline"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->
	
	<!-- moved to ge_custom.xsl -->
	<!--<xsl:template match="*[contains(@class, ' topic/example ')]" name="topic.example">
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
	</xsl:template>-->
	
	<!-- moved to taskdisplay.xsl -->
	<!--<xsl:template match="*[contains(@class, ' task/steps ')]" mode="steps-fmt">
		<xsl:param name="step_expand"/>
		<xsl:choose>
			<xsl:when test="contains(@outputclass, 'show_hide') and @id">
				<p>
					<!-\-<div class="p collapsible">-\->
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
						<xsl:apply-templates select="." mode="common-processing-within-steps">
							<xsl:with-param name="step_expand" select="$step_expand"/>
							<xsl:with-param name="list-type" select="'ol'"/>
						</xsl:apply-templates>
					</xsl:element>
					<!-\-</div>-\->
				</p>
				<script type="text/javascript">
          <xsl:text>hideTwisty('</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>');</xsl:text>
        </script>
			</xsl:when>
			<xsl:when test="contains(@outputclass, 'show_hide_expanded') and @id">
				<p>
					<!-\-<div class="p collapsible">-\->
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
						<xsl:apply-templates select="." mode="common-processing-within-steps">
							<xsl:with-param name="step_expand" select="$step_expand"/>
							<xsl:with-param name="list-type" select="'ol'"/>
						</xsl:apply-templates>
					</xsl:element>
					<!-\-</div>-\->
				</p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="common-processing-within-steps">
					<xsl:with-param name="step_expand" select="$step_expand"/>
					<xsl:with-param name="list-type" select="'ol'"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	<!-- NESTED TOPIC TITLES (sensitive to nesting depth, but are still processed for contained markup) -->
	<!-- 1st level - topic/title -->
	<!-- Condensed topic title into single template without priorities; use $headinglevel to set heading.
     If desired, somebody could pass in the value to manually set the heading level -->
	
	<!-- moved to ge_custom.xsl -->
	<!--<xsl:template
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
		<xsl:variable name="windows_inputMap">
			<xsl:value-of select="concat('file:///', $inputMap)"/>
		</xsl:variable>
		<xsl:if test="$TRANSTYPE = 'webhelp-single'">
			<a href="#topPage">
				<xsl:call-template name="getWebhelpString">
					<xsl:with-param name="stringName" select="'BacktoTop'"/>
				</xsl:call-template>
			</a>
		</xsl:if>
		<!-\- Comtech 07/18/2013 wrap h1 and shortdesc in header HTML5 tag -\->
		<xsl:element name="header">
			<!-\-  <xsl:attribute name="style">border:0.1pt solid white;</xsl:attribute>-\->
			<xsl:attribute name="class">contentHead</xsl:attribute>
			<xsl:value-of select="$newline"/>
			<!-\- FMC 04/2015, topic header block -\->
			<!-\- US292 topic meta placement, handling for topic ID (with string manipulation - remove initial underscore MJT:FMC 7/24/2016 -\->
			<xsl:message>Value of draft.topichead <xsl:value-of select="$DRAFT.TOPICHEAD"
				/></xsl:message>
			<xsl:if test="upper-case($DRAFT.TOPICHEAD) = 'YES'">
				<div class="topicMeta">
					<!-\- <p>Draft Metadata</p>-\->
					<ul>
						<xsl:call-template name="commonattributes"/>
						<li style="text-align: justify;">
							<!-\-<span style="color:#1F4998;font-weight:bold;">Proprietary statement: </span> -\->
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_prop']/ph"
								mode="meta-info"/>
						</li>
						<li>
							<!-\-<span style="color:#1F4998;font-weight:bold;">Marketing name: </span> -\->
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_marketing']/ph"
								mode="meta-info"/>
							<xsl:text> </xsl:text>
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_sys']/ph"
								mode="meta-info"/>
						</li>
						<!-\-              <li><!-\\-<span style="color:#1F4998;font-weight:bold;">System: </span>-\\->
                <xsl:apply-templates select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id='header_sys']/ph"/>
              </li>-\->
						<li>
							<!-\-<span style="color:#1F4998;font-weight:bold;">Field Strength: </span>-\->
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_field']/ph"
								mode="meta-info"/>
						</li>
						<li>
							<!-\-<span style="color:#1F4998;font-weight:bold;">Platform: </span>-\->
							<xsl:apply-templates
								select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id = 'header_platform']/ph"
								mode="meta-info"/>
						</li>
						<li>
							<span style="color:#1F4998;font-weight:bold;">Topic ID: </span>
							<!-\- <xsl:variable name="topicID" select="ancestor-or-self::*[contains(@class, ' topic/topic ')]/@id"/>-\->
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
						<!-\-<li>
            <span style="color:#1F4998;font-weight:bold;">Topic ID, version x.0 (no date): </span>
            <xsl:apply-templates select="document($windows_inputMap)/bookmap/bookmeta[1]/data/data-about/data[@id='header_topic']/ph"/>
          </li>-\->
					</ul>
				</div>
			</xsl:if>
			<xsl:element name="h{$headinglevel}">
				<xsl:attribute name="class">topictitle<xsl:value-of select="$headinglevel"
					/></xsl:attribute>
				<xsl:attribute name="id">emailsubject</xsl:attribute>
				<!-\- <xsl:attribute name="style">margin-top:5%;</xsl:attribute>-\->
				<xsl:call-template name="commonattributes">
					<xsl:with-param name="default-output-class">topictitle<xsl:value-of
							select="$headinglevel"/></xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates/>
			</xsl:element>
			<!-\- Comtech 07/18/2013 add shortdesc to header HTML5 tag -\->
			<xsl:apply-templates select="//*[contains(@class, ' topic/abstract ')]" mode="outofline"/>
			<!-\- Insert pre-req links - after shortdesc - unless there is a prereq section about -\->
			<xsl:apply-templates select="//*[contains(@class, ' topic/related-links ')]"
				mode="prereqs"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>-->
<!--	<xsl:template match="*[contains(@class, ' topic/related-links ')]" name="topic.related-links">
		<!-\- Comtech 07/18/2013 change <div> to <section> -\->
		<footer style="padding-bottom:24pt;">
			<nav>
				<xsl:call-template name="commonattributes"/>
				<!-\- Comtech Services 08/20/2013 comment out templates to prevent family linking list caused by overriding nextprevfulliteration file to force sequence browsing -\->
				<!-\-<xsl:call-template name="ul-child-links"/>-\->
				<!-\-handle child/descendants outside of linklists in collection-type=unordered or choice-\->
				<xsl:call-template name="ol-child-links"/>
				<!-\-<xsl:if test="not($disableRelatedLinks='nofamily')">
          <xsl:call-template name="ul-child-links"/>
        </xsl:if>-\->
				<!-\-handle child/descendants outside of linklists in collection-type=ordered/sequence-\->
				<!-\- OXYGEN PATCH START EXM-17960 - omit links generated by DITA-OT. -\->
				<xsl:call-template name="next-prev-parent-links"/>
				<!-\-handle next and previous links-\->
				<!-\- OXYGEN PATCH END EXM-17960 - omit links generated by DITA-OT. -\->
				<xsl:apply-templates select="." mode="related-links:group-unordered-links">
					<xsl:with-param name="nodes"
						select="descendant::*[contains(@class, ' topic/link ')][count(. | key('omit-from-unordered-links', 1)) != count(key('omit-from-unordered-links', 1))][generate-id(.) = generate-id((key('hideduplicates', concat(ancestor::*[contains(@class, ' topic/related-links ')]/parent::*[contains(@class, ' topic/topic ')]/@id, ' ', @href, @scope, @audience, @platform, @product, @otherprops, @rev, @type, normalize-space(child::*[1]))))[1])]"
					/>
				</xsl:apply-templates>
				<xsl:apply-templates select="*[contains(@class, ' topic/linklist ')]"/>
			</nav>
		</footer>
	</xsl:template>-->

<!-- moved to ge_custom.xsl -->

	<!--<xsl:template match="*[contains(@class, ' topic/xref ')]" name="topic.xref">
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

					<!-\- GEHC-19 -\->
					<!-\- Rally ID DE72 -\->
					<!-\- 2017-11-09: get the href attribute into a variable -\->
					<!-\-xsl:apply-templates select="." mode="add-linking-attributes"/-\->
					<!-\-					<xsl:variable name="getHREF">
						<HREF>
							<xsl:apply-templates select="." mode="add-linking-attributes"/>
						</HREF>
					</xsl:variable>

					<!-\\- test if the xref has @outputclass = newtarget -\\->
					<xsl:choose>
						<xsl:when test="@outputclass = 'newtarget'">
							<!-\\- make the @href # -\\->
							<xsl:attribute name="href" select="'#'" />

							<!-\\- create an apos via a variable -\\->
							<xsl:variable name="apos">'</xsl:variable>

							<!-\\- add _Popup to the href -\\->
							<xsl:variable name="addPopupToHREF">
								<xsl:variable name="b4HTML" select="substring-before($getHREF/child::*/@href, '.htm')" />
								<xsl:variable name="afterFilename" select="substring-after($getHREF/child::*/@href, $b4HTML)" />
								<xsl:value-of select="concat($apos, $b4HTML, '_Popup', $afterFilename, $apos)" />
							</xsl:variable>


							<!-\\- create the onclick string -\\->
							<!-\\- GEHC-19 -\\->
							<!-\\- Rally ID DE72 -\\->
							<!-\\- 2017-11-12: use var popupWindow and popupWindow.focus(); -\\->
							<!-\\-xsl:apply-templates select="." mode="add-linking-attributes"/-\\->
							<!-\\-xsl:variable name="onclickString" select="concat('var popupWindow = window.open(', $addPopupToHREF, ', ', $apos, 'mywin', $apos, ', ',  $apos, 'left=800,top=260,width=600,height=600,toolbar=yes,resizable=yes,scrollbars=yes', $apos, '); popupWindow.focus();  return false')" /-\\->
							<xsl:variable name="onclickString" select="concat('var popupWindow = window.open(', $addPopupToHREF, ', ', $apos, 'mywin', $apos, ', ',  $apos, 'left=800,top=260,width=600,height=600,toolbar=yes,resizable=yes,scrollbars=yes', $apos, '); popupWindow.focus();  return false')" />


							<!-\\- output the onclick attribute with the value of onclickString -\\->
							<xsl:attribute name="onclick" select="$onclickString" />
							<!-\\- orginal code -\\->
							<!-\\-xsl:attribute name="onclick">window.open(this.href, 'mywin', 'left=800,top=260,width=600,height=600,toolbar=yes,resizable=yes,scrollbars=yes'); return false</xsl:attribute-\\->
						</xsl:when>

						<xsl:otherwise>
							<xsl:attribute name="href" select="$getHREF/child::*/@href" />
						</xsl:otherwise>
					</xsl:choose>-\->


					<xsl:apply-templates select="." mode="add-desc-as-hoverhelp"/>
					<!-\- if there is text or sub element other than desc, apply templates to them otherwise, use the href as the value of link text. -\->
					<xsl:choose>
						<xsl:when test="@type = 'fn'">
							<sup>
								<xsl:choose>
									<xsl:when
										test="*[not(contains(@class, ' topic/desc '))] | text()">
										<!-\-                    <xsl:variable name="prevFN">
                      <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ')])"/>
                    </xsl:variable>-\->
										<xsl:choose>
											<xsl:when
												test="ancestor-or-self::*[contains(@class, 'table')]">
												<xsl:number format="I"
												value="count(preceding::*/*[contains(@class, ' topic/fn ')][ancestor-or-self::*[contains(@class, 'table')]])">
												<!-\-<xsl:apply-templates select="*[not(contains(@class,' topic/desc '))]|text()"/>-\->
												</xsl:number>
											</xsl:when>
											<xsl:otherwise>
												<!-\-                        <xsl:number format="1"
                          value="*[not(contains(@class,' topic/desc '))]|text()">-\->
												<xsl:apply-templates
												select="*[not(contains(@class, ' topic/desc '))] | text()"/>
												<!-\-</xsl:number>-\->
											</xsl:otherwise>
										</xsl:choose>
										<!-\-use xref content-\->
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="href"/>
										<!-\-use href text-\->
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
									<!-\- Hungarian: "1. Table " -\->
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
										<!-\- NMM 04/23/2017: Remove title from figure or table xref generated text -\->
										<!-\- <xsl:text>. </xsl:text> -\->
									</xsl:otherwise>
								</xsl:choose>
							</span>
							<!-\-              <span>
                <xsl:call-template name="getString">
                  <xsl:with-param name="stringName" select="'Table'"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
              </span>
              <xsl:value-of select="$tbl-count-actual"/>-\->
							<!-\-  <xsl:apply-templates select="*[not(contains(@class,' topic/desc '))]|text()"/>-\->
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
									<!-\- Hungarian: "1. Figure " -\->
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
										<!-\- NMM 04/23/2017: Remove title from figure or table xref generated text -\->
										<!-\- <xsl:text>. </xsl:text> -\->
									</xsl:otherwise>
								</xsl:choose>
							</span>
						</xsl:when>



						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
									<xsl:apply-templates
										select="*[not(contains(@class, ' topic/desc '))] | text()"/>
									<!-\-use xref content-\->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="href"/>
									<!-\-use href text-\->
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
	</xsl:template>-->


	<!-- old template -->
	<!--<xsl:template match="*[contains(@class, ' topic/xref ')]" name="topic.xref">
    <xsl:choose>
      <xsl:when test="@href and normalize-space(@href) != ''">
        <xsl:apply-templates select="." mode="add-xref-highlight-at-start"/>
        <a>
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates select="." mode="add-linking-attributes"/>
          <xsl:apply-templates select="." mode="add-desc-as-hoverhelp"/>
          <xsl:if test="@scope = 'external'">
            <xsl:attribute name="target">_blank</xsl:attribute>
          </xsl:if>
          <!-\- if there is text or sub element other than desc, apply templates to them
          otherwise, use the href as the value of link text. -\->

          <xsl:variable name="href" select="@href"/>
          <xsl:variable name="destElementId" select="substring-after($href,'/')"/>
          <xsl:variable name="base-uri" select="translate(base-uri(), '\', '/')"/>
          <xsl:variable name="temp-dir-path" select="resolve-uri(translate($TEMPDIR, '\', '/'))"/>
          <xsl:variable name="input-dir-path" select="resolve-uri(translate($INPUTDIR, '\', '/'))"/>

          <!-\- Replace path to use original file from input directory instead of temp dir because of failures if file is used by transformation in the same time. -\->
          <xsl:variable name="replaced-path" select="replace($base-uri, $temp-dir-path, $input-dir-path)"/>
          <xsl:variable name="base-name" select="tokenize($base-uri, '/')[last()]"/>
          
          <xsl:variable name="doc-name">
            <xsl:choose>
              <xsl:when test="contains($href, '#')">
                <xsl:choose>
                  <xsl:when test="substring-before($href, '#') eq ''">
                    <xsl:value-of select="tokenize(document-uri(/), '/')[last()]"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="substring-before($href, '#')"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$href"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          
	  <!-\- test *** -\->
          <xsl:variable name="ref-doc-uri" select="resolve-uri(concat(substring-before($replaced-path, $base-name), $doc-name))"/>
          <xsl:variable name="ref-doc">
            <xsl:choose>
              <xsl:when test="(@format and @format = 'dita' or @format = 'DITA')">        
                <xsl:value-of select="document($ref-doc-uri)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@ref-doc-uri"/>
                <!-\- external doc -\->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="ref-descendant-element">
            <xsl:choose>
              <xsl:when test="@format and (@format = 'dita' or @format = 'DITA')">  
  <!-\-              <xsl:message>this is destElement = <xsl:value-of select="$destElementId"/></xsl:message>-\->
                <xsl:value-of select="$ref-doc/descendant::*[@id = $destElementId]"/>
              </xsl:when>
              <xsl:otherwise>
            <!-\- external doc -\->
                <xsl:value-of select="@ref-doc-uri"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:choose>
            <xsl:when test="@type = 'table'">

              <xsl:variable name="currentHref">
                <xsl:choose>
                  <xsl:when test=".[contains(@href, '#')] and substring-before(@href, '#') != ''">
                    <xsl:value-of select="concat($tempDir, '/', substring-before(@href, '#'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat($tempDir, '\', @href)"/>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:variable>

              <xsl:variable name="thisHref">
                <xsl:choose>
                  <xsl:when test=".[contains(@href, '#')] and substring-before(@href, '#') = ''">
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
                  <xsl:when test=".[contains(@href, '#')] and substring-before(@href, '#') = ''">
                    <xsl:value-of
                      select="count(//*[contains(@class, ' topic/table ')][@id = $targetElem]/preceding::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]) + 1"/>

                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="count(document($thisHref)//*[contains(@class, ' topic/table ')][@id = $targetElem]/preceding::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]) + 1"/>

                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <!-\-    <xsl:message>This is HREF <xsl:value-of select="$currentHref"/></xsl:message>-\->
              <!-\-      <xsl:message>This is URLHREF <xsl:value-of select="$thisHref"/></xsl:message>-\->
              <!-\-   <xsl:message>This is the table count  $targetElem: <xsl:value-of select="$targetElem"/> count <xsl:value-of select="$tbl-count-actual"/></xsl:message>-\->
              <!-\- normally: "Table 1. " -\->
              <xsl:variable name="ancestorlang">
                <xsl:call-template name="getLowerCaseLang"/>
              </xsl:variable>


              <!-\-    <xsl:value-of select="'need to get table string and #'"/>-\->
              <span>
                <xsl:choose>
                  <!-\- Hungarian: "1. Table " -\->
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
                    <!-\- NMM 04/23/2017: Remove title from figure or table xref generated text -\->
                    <!-\- <xsl:text>. </xsl:text> -\->
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </xsl:when>
            <xsl:when test="@type = 'fig'">

              <xsl:variable name="currentHref">
                <xsl:choose>
                  <xsl:when test=".[contains(@href, '#')] and substring-before(@href, '#') != ''">
                    <xsl:value-of select="concat($tempDir, '/', substring-before(@href, '#'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat($tempDir, '\', @href)"/>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:variable>

              <!-\- <xsl:variable name="thisHref" select="oxygen:makeURL($currentHref)"/>-\->
              <xsl:variable name="thisHref">
                <xsl:choose>
                  <xsl:when test=".[contains(@href, '#')] and substring-before(@href, '#') = ''">
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
                  <xsl:when test=".[contains(@href, '#')] and substring-before(@href, '#') = ''">
                    <xsl:value-of
                      select="count(//*[contains(@class, ' topic/fig ')][@id = $targetElem]/preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]) + 1"
                    />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of
                      select="count(document($thisHref)//*[contains(@class, ' topic/fig ')][@id = $targetElem]/preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]) + 1"/>

                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:message>This is HREF <xsl:value-of select="$currentHref"/></xsl:message>
              <xsl:message>This is URLHREF <xsl:value-of select="$thisHref"/></xsl:message>
              <!-\-   <xsl:message>This is the table count  $targetElem: <xsl:value-of select="$targetElem"/> count <xsl:value-of select="$tbl-count-actual"/></xsl:message>-\->
              <!-\- normally: "Table 1. " -\->
              <xsl:variable name="ancestorlang">
                <xsl:call-template name="getLowerCaseLang"/>
              </xsl:variable>

              <span>
                <xsl:choose>
                  <!-\- Hungarian: "1. Figure " -\->
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
                    <!-\- NMM 04/23/2017: Remove title from figure or table xref generated text -\->
                    <!-\- <xsl:text>. </xsl:text> -\->
                  </xsl:otherwise>
                </xsl:choose>
              </span>
            </xsl:when>
          </xsl:choose>
          <xsl:choose>
              <xsl:when test="@type = 'step'">
                  <span>
                      <xsl:call-template name="getString">
                          <xsl:with-param name="stringName" select="'Xref_Step'"/>
                      </xsl:call-template>
                  </span>

                  <xsl:if test="exists($ref-descendant-element) and $ref-descendant-element[contains(@class, ' task/step ')]">
                      <xsl:text>&#xA0;</xsl:text>
                      <xsl:value-of select="count($ref-descendant-element/preceding-sibling::*[contains(@class, ' task/step ')]) + 1"/>
                  </xsl:if>
              </xsl:when>
            
            <xsl:when test="@type = 'substep'">
              <span>
                <xsl:call-template name="getString">
                  <xsl:with-param name="stringName" select="'Xref_Step'"/>
                </xsl:call-template>
              </span>
              <xsl:if test="exists($ref-descendant-element) and $ref-descendant-element[contains(@class, ' task/substep ')]">
                <xsl:text>&#xA0;</xsl:text>
                <xsl:number format="1" value="count($ref-descendant-element/preceding::*[contains(@class, ' task/step ')]) + 1"/>
                <xsl:number format="a" value="count($ref-descendant-element/preceding-sibling::*[contains(@class, ' task/substep ')]) + 1" />
              </xsl:if>
            </xsl:when>
            
            <xsl:when test="@type = 'li'">
              <xsl:choose>
                <xsl:when test="$ref-descendant-element/ancestor::*[contains(@class, ' topic/fig ')]">
                  <xsl:value-of select="count($ref-descendant-element/preceding-sibling::*[contains(@class, ' topic/li ')]) + 1"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            
              <xsl:when test="@type = 'fn'">
              <xsl:attribute name="style">style="display:inline-block; border:none;
                padding-bottom:2px;text-decoration:none;vertical-align:top;"</xsl:attribute>
              <sup style="
                border-bottom:1px solid blue;">
                <xsl:variable name="grapFNlocation">
                  <xsl:value-of select="node-name(parent::*)"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when
                    test="string(number(*[not(contains(@class, ' topic/desc '))] | text())) != 'NaN'">
                    <xsl:choose>
                      <xsl:when test="$grapFNlocation = 'entry'">
                        <xsl:number format="a"
                          value="count(preceding::fn[ancestor-or-self::table]) + 1 - count(preceding::table/descendant-or-self::fn)"
                        />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:number format="1"
                          value="*[not(contains(@class, ' topic/desc '))] | text()"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!-\-use xref content-\->
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:variable name="cleanHref">
                      <xsl:call-template name="href"/>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="contains($cleanHref, '.xml')">
                        <xsl:value-of select="substring-before($cleanHref, '.xml')"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="$cleanHref"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!-\-use href text-\->
                  </xsl:otherwise>
                </xsl:choose>
              </sup>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>

                <xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
                  <!-\- NMM 04/23/2017: Remove title from figure or table xref generated text -\->
                  <xsl:choose>
                    <xsl:when test="@type = 'fig' or @type = 'table'"/>
                    <xsl:otherwise>
                      <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!-\-use xref content-\->
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="cleanHref">
                    <xsl:call-template name="href"/>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="contains($cleanHref, '.xml')">
                      <xsl:value-of select="substring-before($cleanHref, '.xml')"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$cleanHref"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!-\-use href text-\->
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
  </xsl:template>-->
	<!-- end old template -->
	<!-- Override this template to add any standard link attributes.
     Called for all links. -->


	<!-- GEHC-19 -->
	<!-- Rally ID DE72 -->
	<!-- 2017-11-06: removed linebreaks that appear in the output. My OCD in overdrive -->
	<!-- 2017-11-09: comment out and add directly to the xref template -->
	<!-- US204 Adding JavaScript onClick handling to create a new window. Tested in Chrome v51, FF 45, IE11 -->
	<!--xsl:template match="*" mode="add-custom-link-attributes">
		<xsl:if test="@outputclass = 'newtarget'">
			<xsl:attribute name="onclick">window.open(this.href, 'mywin', 'left=800,top=260,width=600,height=600,toolbar=yes,resizable=yes,scrollbars=yes'); return false</xsl:attribute>
		</xsl:if>
	</xsl:template-->

<!-- moved to ge_custom.xsl -->
	<!-- US204 add support for specifying an HTML target type MJT:FMC 08/04/2016 -->
	<!--<xsl:template match="*" mode="add-link-target-attribute">
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
	</xsl:template>-->
	
	<!-- moved to tables.xsl -->
	<!--<xsl:template name="dotable">
		<xsl:param name="uniqueTable"/>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<span class="orgID">
			<xsl:attribute name="id" select="@id"/>
		</span>
		<xsl:call-template name="setaname"/>
		<table id="{$uniqueTable}" cellpadding="4" cellspacing="0" style="margin-top:12pt;">
			<xsl:variable name="colsep">
				<xsl:choose>
					<xsl:when test="*[contains(@class, ' topic/tgroup ')]/@colsep">
						<xsl:value-of select="*[contains(@class, ' topic/tgroup ')]/@colsep"/>
					</xsl:when>
					<xsl:when test="@colsep">
						<xsl:value-of select="@colsep"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="rowsep">
				<xsl:choose>
					<xsl:when test="*[contains(@class, ' topic/tgroup ')]/@rowsep">
						<xsl:value-of select="*[contains(@class, ' topic/tgroup ')]/@rowsep"/>
					</xsl:when>
					<xsl:when test="@rowsep">
						<xsl:value-of select="@rowsep"/>
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:call-template name="setid"/>
			<!-\-<xsl:call-template name="commonattributes"/>-\->
			<xsl:apply-templates select="." mode="generate-table-summary-attribute"/>
			<xsl:call-template name="setscale"/>
			<!-\- When a table's width is set to page or column, force it's width to 100%. If it's in a list, use 90%.
       Otherwise, the table flows to the content -\->
			<xsl:choose>
				<xsl:when
					test="(@expanse = 'page' or @pgwide = '1') and (ancestor::*[contains(@class, ' topic/li ')] or ancestor::*[contains(@class, ' topic/dd ')])">
					<xsl:attribute name="width">90%</xsl:attribute>
				</xsl:when>
				<xsl:when
					test="(@expanse = 'column' or @pgwide = '0') and (ancestor::*[contains(@class, ' topic/li ')] or ancestor::*[contains(@class, ' topic/dd ')])">
					<xsl:attribute name="width">90%</xsl:attribute>
				</xsl:when>
				<xsl:when test="(@expanse = 'page' or @pgwide = '1')">
					<xsl:attribute name="width">100%</xsl:attribute>
				</xsl:when>
				<xsl:when test="(@expanse = 'column' or @pgwide = '0')">
					<xsl:attribute name="width">100%</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@frame = 'all' and $colsep = '0' and $rowsep = '0'">
					<xsl:attribute name="border">0</xsl:attribute>
				</xsl:when>
				<xsl:when test="not(@frame) and $colsep = '0' and $rowsep = '0'">
					<xsl:attribute name="border">0</xsl:attribute>
				</xsl:when>
				<xsl:when test="@frame = 'sides'">
					<xsl:attribute name="frame">vsides</xsl:attribute>
					<xsl:attribute name="border">1</xsl:attribute>
				</xsl:when>
				<xsl:when test="@frame = 'top'">
					<xsl:attribute name="frame">above</xsl:attribute>
					<xsl:attribute name="border">1</xsl:attribute>
				</xsl:when>
				<xsl:when test="@frame = 'bottom'">
					<xsl:attribute name="frame">below</xsl:attribute>
					<xsl:attribute name="border">1</xsl:attribute>
				</xsl:when>
				<xsl:when test="@frame = 'topbot'">
					<xsl:attribute name="frame">hsides</xsl:attribute>
					<xsl:attribute name="border">1</xsl:attribute>
				</xsl:when>
				<xsl:when test="@frame = 'none'">
					<xsl:attribute name="frame">void</xsl:attribute>
					<xsl:attribute name="border">1</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="frame">border</xsl:attribute>
					<xsl:attribute name="border">1</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@frame = 'all' and $colsep = '0' and $rowsep = '0'">
					<xsl:attribute name="border">0</xsl:attribute>
				</xsl:when>
				<xsl:when test="not(@frame) and $colsep = '0' and $rowsep = '0'">
					<xsl:attribute name="border">0</xsl:attribute>
				</xsl:when>
				<xsl:when test="$colsep = '0' and $rowsep = '0'">
					<xsl:attribute name="rules">none</xsl:attribute>
					<xsl:attribute name="border">0</xsl:attribute>
				</xsl:when>
				<xsl:when test="$colsep = '0'">
					<xsl:attribute name="rules">rows</xsl:attribute>
				</xsl:when>
				<xsl:when test="$rowsep = '0'">
					<xsl:attribute name="rules">cols</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="rules">all</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="place-tbl-lbl"/>
			<!-\- title and desc are processed elsewhere -\->
			<xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
		</table>
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
	</xsl:template>-->
	
	<!-- moved to taskdisplay.xsl -->
	<!--<xsl:template
		match="*[contains(@class, ' task/steps ') or contains(@class, ' task/steps-unordered ')]"
		mode="common-processing-within-steps">
		<xsl:param name="step_expand"/>
		<xsl:param name="list-type">
			<xsl:choose>
				<xsl:when test="contains(@class, ' task/steps ')">ol</xsl:when>
				<xsl:otherwise>ul</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:apply-templates select="." mode="generate-task-label">
			<xsl:with-param name="use-label">
				<xsl:choose>
					<xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
						<!-\-<xsl:call-template name="getWebhelpString">
              <xsl:with-param name="stringName" select="'Steps Open'"/>
            </xsl:call-template>-\->
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
		<xsl:choose>
			<xsl:when
				test="*[contains(@class, ' task/step ')] and not(*[contains(@class, ' task/step ')][2])">
				<!-\- Single step. Process any stepsection before the step (cannot appear after). -\->
				<xsl:apply-templates select="*[contains(@class, ' task/stepsection ')]"/>
				<xsl:apply-templates select="*[contains(@class, ' task/step ')]" mode="onestep">
					<xsl:with-param name="step_expand" select="$step_expand"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="not(*[contains(@class, ' task/stepsection ')])">
				<xsl:apply-templates select="." mode="step-elements-with-no-stepsection">
					<xsl:with-param name="step_expand" select="$step_expand"/>
					<xsl:with-param name="list-type" select="$list-type"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when
				test="*[1][contains(@class, ' task/stepsection ')] and not(*[contains(@class, ' task/stepsection ')][2])">
				<!-\- Stepsection is first, no other appearances -\->
				<xsl:apply-templates select="*[contains(@class, ' task/stepsection ')]"/>
				<xsl:apply-templates select="." mode="step-elements-with-no-stepsection">
					<xsl:with-param name="step_expand" select="$step_expand"/>
					<xsl:with-param name="list-type" select="$list-type"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-\- Stepsection elements mixed in with steps -\->
				<xsl:apply-templates select="." mode="step-elements-with-stepsection">
					<xsl:with-param name="step_expand" select="$step_expand"/>
					<xsl:with-param name="list-type" select="$list-type"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	<!-- Comtech Services 11-21-2013 copy code from webworks implementation -->
	
	<!-- moved to ge_custom.xsl -->
	<!--<xsl:template match="*[contains(@class, ' topic/cite ')]">
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
		<!-\-    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-\->
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
	</xsl:template>-->
	<!-- Comtech Services 11-21-2013 copy code from webworks implementation -->
	
	<!-- moved to ge_custom.xsl -->
	<!--<xsl:template match="*[contains(@class, ' topic/q ')]">
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
		<!-\-    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-\->
		<span class="q">
			<xsl:value-of select="$prefix-char"/>
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix-char"/>
		</span>
	</xsl:template>-->
	<!-- Comtech Services 11-21-2013 copy code from webworks implementation -->
	<!--<xsl:template
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
				<!-\-<xsl:when test="ancestor::*[contains(@class,' ui-d/menucascade ')]">
          <xsl:variable name="uicontrolcount">
            <xsl:number count="*[contains(@class,' ui-d/uicontrol ')]"/>
          </xsl:variable>
          <xsl:if test="$uicontrolcount&gt;'1'">
            <xsl:text> > </xsl:text>
          </xsl:if>
        </xsl:when>-\->
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
		<!-\-    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-\->
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
	</xsl:template>-->
	<!--<xsl:template match="*[contains(@class, ' sw-d/userinput ')]">
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
				<!-\-<xsl:when test="ancestor::*[contains(@class,' ui-d/menucascade ')]">
          <xsl:variable name="uicontrolcount">
            <xsl:number count="*[contains(@class,' ui-d/uicontrol ')]"/>
          </xsl:variable>
          <xsl:if test="$uicontrolcount&gt;'1'">
            <xsl:text> > </xsl:text>
          </xsl:if>
        </xsl:when>-\->
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
		<!-\-    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-\->
		<xsl:choose>
			<xsl:when test="starts-with(lower-case($lang), 'ja')">
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!-\-<xsl:value-of select="$prefix-char"/>-\->
					<xsl:apply-templates/>
					<!-\-<xsl:value-of select="$suffix-char"/>-\->
				</span>
			</xsl:when>
			<xsl:when test="starts-with(lower-case($lang), 'ru')">
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!-\-<xsl:value-of select="$prefix-char"/>-\->
					<xsl:apply-templates/>
					<!-\-<xsl:value-of select="$suffix-char"/>-\->
				</span>
			</xsl:when>
			<xsl:when test="contains(lower-case($lang), 'zh-tw')">
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!-\-<xsl:value-of select="$prefix-char"/>-\->
					<xsl:apply-templates/>
					<!-\-<xsl:value-of select="$suffix-char"/>-\->
				</span>
			</xsl:when>
			<xsl:when test="contains(lower-case($lang), 'zh-cn')">
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!-\-<xsl:value-of select="$prefix-char"/>-\->
					<xsl:apply-templates/>
					<!-\-<xsl:value-of select="$suffix-char"/>-\->
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="userinput"
					style="font-weight: bold; font-family:courier, fixed, monospace;">
					<!-\-<xsl:value-of select="$prefix-char"/>-\->
					<xsl:apply-templates/>
					<!-\-<xsl:value-of select="$suffix-char"/>-\->
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	<!-- Comtech Services 11-21-2013 copy code from webworks implementation -->
	<!--<xsl:template match="*[contains(@class, ' topic/lq ')]">
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
		<!-\-    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="$prefix-char"/>
      <xsl:apply-templates/>
      <xsl:value-of select="$suffix-char"/>
    </xsl:copy>-\->
		<span class="lq">
			<xsl:value-of select="$prefix-char"/>
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix-char"/>
		</span>
	</xsl:template>-->
	<!-- Comtech Services 11-21-2013 copy code from webworks implementation -->
	<!--<xsl:template match="*[contains(@class, ' pr-d/option ')]" name="topic.pr-d.option">
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
	</xsl:template>-->
	<!-- Comtech Services 11-21-2013 copy code from webworks implementation -->
	<!--<xsl:template match="*[contains(@class, ' sw-d/varname ')] | *[contains(@class, ' pr-d/var ')]"
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
				<!-\-<xsl:when test="ancestor::*[contains(@class,' ui-d/menucascade ')]">
          <xsl:variable name="uicontrolcount">
            <xsl:number count="*[contains(@class,' ui-d/uicontrol ')]"/>
          </xsl:variable>
          <xsl:if test="$uicontrolcount&gt;'1'">
            <xsl:text> > </xsl:text>
          </xsl:if>
        </xsl:when>-\->
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
	</xsl:template>-->
	<!--<!-\- =========== SimpleTable - SEMANTIC TABLE =========== -\->
	<xsl:template match="*[contains(@class, ' topic/simpletable ')]"
		mode="generate-table-summary-attribute">
		<!-\- Override this to use a local convention for setting table's @summary attribute,
       until OASIS provides a standard mechanism for setting. -\->
		<xsl:call-template name="profiling-atts"/>
	</xsl:template>
	<!-\- Comtech Services 10/24/2013 added to conditionalize the footnotes for tables -\->
	<!-\- render any contained footnotes as endnotes.  Links back to reference point -\->
	<!-\- choice table is like a simpletable - 2 columns, set heading -\->
	<xsl:template match="*[contains(@class, ' topic/pre ')]" mode="pre-fmt">
		<!-\- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -\->
		<xsl:if test="contains(@frame, 'top')">
			<hr/>
		</xsl:if>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<xsl:call-template name="spec-title-nospace"/>
		<p style="border:1pt solid #1F4998;padding:6pt;white-space:pre-wrap;font-family:Courier;">
			<!-\-Remove the overflow:auto; from the paragraph styled above. - Pat-\->
			<xsl:attribute name="class">
				<xsl:value-of select="name()"/>
			</xsl:attribute>
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="setscale"/>
			<xsl:call-template name="setidaname"/>
			<xsl:apply-templates/>
		</p>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
		<xsl:if test="contains(@frame, 'bot')">
			<hr/>
		</xsl:if>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<xsl:template name="href">
		<xsl:apply-templates select="." mode="determine-final-href"/>
	</xsl:template>
	<xsl:template match="*" mode="determine-final-href">
		<xsl:message>Starting value of @href= <xsl:copy-of select="@href"/></xsl:message>
		<xsl:choose>
			<xsl:when
				test="(not(@format) and (@type = 'external' or @scope = 'external')) or (@format and not(@format = 'dita' or @format = 'DITA'))">
				<xsl:value-of select="@href"/>
			</xsl:when>
			<xsl:when test="$TRANSTYPE = 'webhelp-single'">
				<xsl:choose>
					<!-\-<xsl:when test="contains(@href, '.xml')">
            <xsl:message>Href value with catch at .xml = <xsl:value-of select="substring-before(@href, '.xml')"/></xsl:message>
            <xsl:text>#</xsl:text>
            <xsl:variable name="beforeXML">
              <xsl:value-of select="substring-before(@href, '.xml')"/>
            </xsl:variable>
            <xsl:variable name="afterXML">
              <xsl:value-of select="substring-after(@href, '.xml')"/>
            </xsl:variable>
            <xsl:call-template name="parsehref">
              <xsl:with-param name="href">
                <xsl:value-of select="$beforeXML"/><xsl:value-of select="$beforeXML"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:when>-\->
					<xsl:when test="contains(@href, '/')">
						<xsl:text>#</xsl:text>
						<xsl:variable name="LastString">
							<xsl:call-template name="substring-after-last">
								<xsl:with-param name="text" select="@href"/>
								<xsl:with-param name="delim" select="'/'"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:message>Href value with catch at / = <xsl:value-of select="$LastString"
							/></xsl:message>
						<xsl:value-of select="$LastString"/>
					</xsl:when>
					<xsl:when test="contains(@href, '#')">
						<xsl:message>Href value with catch at # = <xsl:value-of
								select="substring-before(@href, '#')"/></xsl:message>
						<xsl:text>#</xsl:text>
						<!-\-<xsl:call-template name="parsehref">
              <xsl:with-param name="href" select="substring-after(@href, '#')"/>
            </xsl:call-template>-\->
						<xsl:value-of select="substring-after(@href, '#')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:message>Href value with catch at otherwise = <xsl:value-of
								select="@href"/></xsl:message>
						<xsl:text>#</xsl:text>
						<xsl:call-template name="parsehref">
							<xsl:with-param name="href" select="@href"/>
						</xsl:call-template>
						<!-\-<xsl:value-of select="@href"/>-\->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="normalize-space(@href) = '' or not(@href)"/>
			<!-\- For non-DITA formats - use the href as is -\->
			<xsl:when
				test="(not(@format) and (@type = 'external' or @scope = 'external')) or (@format and not(@format = 'dita' or @format = 'DITA'))">
				<xsl:value-of select="@href"/>
			</xsl:when>
			<!-\- For DITA - process the internal href -\->
			<xsl:when test="starts-with(@href, '#')">
				<xsl:call-template name="parsehref">
					<xsl:with-param name="href" select="@href"/>
				</xsl:call-template>
			</xsl:when>
			<!-\- It's to a DITA file - process the file name (adding the html extension)
    and process the rest of the href -\->
			<!-\- for local links respect dita.extname extension
      and for peer links accept both .xml and .dita bug:3059256-\->
			<xsl:when
				test="(not(@scope) or @scope = 'local' or @scope = 'peer') and (not(@format) or @format = 'dita' or @format = 'DITA') and not(@outputclass = 'newtarget')">
				<xsl:call-template name="replace-extension">
					<xsl:with-param name="filename" select="@href"/>
					<xsl:with-param name="extension" select="$OUTEXT"/>
					<xsl:with-param name="ignore-fragment" select="true()"/>
				</xsl:call-template>
				<xsl:if test="contains(@href, '#')">
					<xsl:text>#</xsl:text>
					<xsl:choose>
						<xsl:when test="@type = 'table' or @type = 'fig'">
							<xsl:call-template name="parsehref">
								<xsl:with-param name="href" select="substring-after(@href, '#')"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="parsehref">
								<xsl:with-param name="href" select="substring-after(@href, '#')"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:when
				test="(not(@scope) or @scope = 'local' or @scope = 'peer') and (not(@format) or @format = 'dita' or @format = 'DITA') and @outputclass = 'newtarget'">
				<xsl:call-template name="replace-extension">
					<xsl:with-param name="filename" select="@href"/>
					<xsl:with-param name="extension" select="$OUTEXT"/>
					<xsl:with-param name="ignore-fragment" select="true()"/>
				</xsl:call-template>
				<xsl:if test="contains(@href, '#')">
					<xsl:text>#</xsl:text>
					<xsl:choose>
						<xsl:when test="@type = 'table' or @type = 'fig'">
							<xsl:call-template name="parsehref">
								<xsl:with-param name="href" select="substring-after(@href, '#')"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="parsehref">
								<xsl:with-param name="href" select="substring-after(@href, '#')"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:text>?turn_off_js=true</xsl:text>
			</xsl:when>

			<xsl:otherwise>
				<xsl:apply-templates select="." mode="ditamsg:unknown-extension"/>
				<xsl:value-of select="@href"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
	<!--<xsl:template name="parsehref">
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
	</xsl:template>-->
	
	
	<!--<xsl:template match="*[contains(@class, ' hi-d/sup ')]" name="topic.hi-d.sup">
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
	</xsl:template>-->
	<!-- Process standard attributes that may appear anywhere. Previously this was "setclass" -->
	<!--  <xsl:template name="commonattributes">
    <xsl:param name="default-output-class"/>
    <xsl:apply-templates select="@xml:lang"/>
    <xsl:apply-templates select="@dir"/>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass"
      mode="add-ditaval-style"/>
    <xsl:apply-templates select="." mode="set-output-class">
      <xsl:with-param name="default" select="$default-output-class"/>
    </xsl:apply-templates>



  </xsl:template>
  -->

	<!--<xsl:template name="commonattributes">
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
		<!-\- This causes element before attribute processing error - should be removed as it's called in the following template -\->
		<!-\- GEHC-105 -\->
		<!-\- Rally ID US312 -\->
		<!-\- 2017-10-20: use new external param PRM_OUTPUT_PROFILING_VALUES to output profiling values -\->

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
						<!-\-			<xsl:message>evaluates to localname</xsl:message>-\->
						<!-\-<xsl:attribute name="style">border:1pt solid red;padding:3pt;</xsl:attribute>-\->
						<!-\-<span style="background-color:pink;font-weight:bold;">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="local-name()"/>
							<xsl:value-of select="."/>
							<xsl:text>]</xsl:text>
						</span>-\->
						<xsl:attribute name="data-{local-name()}">
							<xsl:value-of select="."/>
						</xsl:attribute>
						<!-\-<span style="background-color:pink;font-weight:bold;">
							<xsl:text>[</xsl:text>
							<xsl:value-of select="local-name()"/>
							<xsl:value-of select="."/>
							<xsl:text>]</xsl:text>
						</span>-\->
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>-->
	<!--<xsl:template match="*[@audience] | *[@platform] | *[@rev] | *[@otherprops] | *[@product]"
		mode="meta-info">
		<!-\-		<xsl:message>Caught Attribute <xsl:value-of select="local-name()"/>-start</xsl:message>
		<xsl:if test="local-name() = 'substeps'">
			<xsl:message>In substeps attribute</xsl:message>
			<xsl:message>
				<xsl:copy-of select="."/>
			</xsl:message>
		</xsl:if>-\->
		<xsl:choose>
			<!-\- GEHC-105 -\->
			<!-\- Rally ID US312 -\->
			<!-\- 2017-10-20: use new external param PRM_OUTPUT_PROFILING_VALUES to output profiling values -\->
			<!-\-xsl:when test="upper-case($DRAFT) = 'YES'"-\->
			<xsl:when test="upper-case($PRM_OUTPUT_PROFILING_VALUES) = 'YES'">
				<!-\- <xsl:copy>-\->
				<div>
					<xsl:attribute name="style">border:1pt solid red</xsl:attribute>
					<xsl:for-each select="@*">
						<xsl:if
							test="local-name() = 'audience' or local-name() = 'platform' or local-name() = 'rev' or local-name() = 'otherprops' or local-name() = 'product'">
							<!-\-<xsl:attribute name="style">border:1pt solid red;padding:3pt;</xsl:attribute>-\->
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
				<!-\-</xsl:copy>-\->
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
		<!-\-	<xsl:message>Caught Attribute <xsl:value-of select="local-name()"/>-end</xsl:message>-\->
	</xsl:template>-->
	<xsl:template match="/|node()|@*" mode="gen-user-head">
		<xsl:variable name="windows_inputMap">
			<xsl:value-of select="concat('file:///', $inputMap)"/>
		</xsl:variable>
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
	<!--  Header navigation.  -->
	<!-- obsolete for responsive -->
	<!--<xsl:template match="/|node()|@*" mode="gen-user-header">
		<table class="nav">
			<tbody>
				<tr>
					<td colspan="2">
						<!-\- Print link. -\->
						<xsl:variable name="printLinkText">
							<xsl:call-template name="getWebhelpString">
								<xsl:with-param name="stringName" select="'printThisPage'"/>
							</xsl:call-template>
						</xsl:variable>
						<div id="printlink">
							<a href="javascript:window.print();" title="{$printLinkText}"/>
						</div>
						<!-\- Permanent link. -\->
						<xsl:variable name="permaLinkText">
							<xsl:call-template name="getWebhelpString">
								<xsl:with-param name="stringName" select="'linkToThis'"/>
							</xsl:call-template>
						</xsl:variable>
						<div id="permalink">
							<a href="#" title="{$permaLinkText}"/>
						</div>
					</td>
				</tr>
				<tr>
					<td style="width:75%;">
						<span class="topic_breadcrumb_links">
							<xsl:if
								test="count(distinct-values(descendant::*[contains(@class, ' topic/link ')][@role = 'parent']/@href)) = 1">
								<!-\- Bread-crumb -\->
								<xsl:variable name="parentRelativePath"
									select="descendant::*[contains(@class, ' topic/link ')][@role = 'parent'][1]/@href"/>
								<xsl:variable name="parentTopic"
									select="document($parentRelativePath)"/>
								<xsl:if
									test="count(distinct-values($parentTopic//*[contains(@class, ' topic/link ')][@role = 'parent']/@href)) = 1">
									<!-\- Link to parent of parent. -\->
									<xsl:variable name="parentOfParentTopic"
										select="($parentTopic//*[contains(@class, ' topic/link ')][@role = 'parent'])[1]"/>
									<xsl:for-each select="$parentOfParentTopic">
										<span class="topic_breadcrumb_link">
											<xsl:call-template name="makelink">
												<xsl:with-param name="final-path" tunnel="yes"
												select="oxygen:combineRelativePaths($parentRelativePath, @href)"
												/>
											</xsl:call-template>
										</span>
										<xsl:text> / </xsl:text>
									</xsl:for-each>
								</xsl:if>
								<!-\- Link to parent. -\->
								<xsl:for-each
									select="(descendant::*[contains(@class, ' topic/link ')][@role = 'parent'])[1]">
									<span class="topic_breadcrumb_link">
										<xsl:call-template name="makelink"/>
									</span>
								</xsl:for-each>
							</xsl:if>
						</span>
					</td>
					<td>
						<!-\- Navigation to the next, previous siblings and to the parent. -\->
						<span id="topic_navigation_links" class="navheader">
							<xsl:call-template name="oxygenCustomHeaderAndFooter"/>
						</span>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>-->
	<!-- messaging -->
	<!-- <xsl:template match="*" mode="ditamsg:webhelp-object">
    <xsl:variable name="msgprefix">GECUSTOM</xsl:variable>
    <xsl:message>In the output message</xsl:message>
    <xsl:call-template name="output-message">
      <xsl:with-param name="msgnum">03856</xsl:with-param>
      <xsl:with-param name="msgcat" select="$msgprefix"/>
      <xsl:with-param name="msgsev">I</xsl:with-param>
      <xsl:with-param name="msgparams">%1=<xsl:value-of select="name(.)"/></xsl:with-param>
    </xsl:call-template>
    <xsl:message>Done with output message</xsl:message>
  </xsl:template> -->
	<!-- Fixed SF Bug 1405184 "Note template for XHTML should be easier to override" -->
	<!-- RFE 2703335 reduces duplicated code by adding common processing rules.
     To override all notes, match the note element's class attribute directly, as in this rule.
     To override a single note type, match the class with mode="process.note.(selected-type)"
     To override all notes except danger and caution, match the class with mode="process.note.common-processing" -->
	<xsl:template match="*[contains(@class, ' topic/note ')]" name="topic.note" priority="10">
		<xsl:call-template name="spec-title"/>
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
	<!-- <xsl:template match="*" mode="process.note">
    <xsl:apply-templates select="." mode="process.note.common-processing">
      <!-\- Force the type to note, in case new unrecognized values are added
         before translations exist (such as Warning) -\->
      <xsl:with-param name="type" select="'note'"/>
    </xsl:apply-templates>
  </xsl:template> -->
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
												src="oxygen-webhelp/resources/img/generalmand.png"
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
												src="oxygen-webhelp/resources/img/generalhaz.png"
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
												src="oxygen-webhelp/resources/img/generalhaz.png"
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
												src="oxygen-webhelp/resources/img/generalhaz.png"
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
	<!--<!-\-  ******************* Choice table override **********************-\->
	<!-\- choice table is like a simpletable - 2 columns, set heading -\->
	<xsl:template match="*[contains(@class, ' task/choicetable ')]" name="topic.task.choicetable">
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<xsl:call-template name="setaname"/>
		<xsl:value-of select="$newline"/>
		<xsl:call-template name="profiling-atts"/>
		<table border="1" frame="hsides" rules="rows" cellpadding="4" cellspacing="0" summary=""
			class="choicetableborder">
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates select="." mode="generate-table-summary-attribute"/>
			<xsl:call-template name="setid"/>
			<xsl:value-of select="$newline"/>
			<xsl:call-template name="dita2html:simpletable-cols"/>
			<!-\-If the choicetable has no header - output a default one-\->
			<xsl:variable name="chhead" as="element()?">
				<xsl:choose>
					<xsl:when test="exists(*[contains(@class, ' task/chhead ')])">
						<xsl:sequence select="*[contains(@class, ' task/chhead ')]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="gen" as="element(gen)?">
							<xsl:call-template name="gen-chhead"/>
						</xsl:variable>
						<xsl:sequence select="$gen/*"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:apply-templates select="$chhead"/>
			<tbody>
				<xsl:apply-templates select="*[contains(@class, ' task/chrow ')]"/>
			</tbody>
		</table>
		<xsl:value-of select="$newline"/>
		<xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/choicetable ')]" mode="get-output-class"
		>choicetableborder</xsl:template>
	<xsl:template match="*[contains(@class, ' task/choicetable ')]"
		mode="dita2html:get-max-entry-count" as="xs:integer">
		<xsl:sequence select="2"/>
	</xsl:template>
	<!-\- Generate default choicetable header -\->
	<xsl:template name="gen-chhead" as="element(gen)?">
		<xsl:variable name="choicetable"
			select="ancestor-or-self::*[contains(@class, ' task/choicetable ')][1]" as="element()"/>
		<!-\- Generated header needs to be wrapped in gen element to allow correct language detection -\->
		<gen>
			<xsl:copy-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
			<chhead class="- topic/sthead task/chhead ">
				<choptionhd class="- topic/stentry task/choptionhd "
					id="{generate-id($choicetable)}">
					<xsl:call-template name="getVariable">
						<xsl:with-param name="id" select="'Option'"/>
					</xsl:call-template>
				</choptionhd>
				<chdeschd class="- topic/stentry task/chdeschd " id="{generate-id($choicetable)}">
					<xsl:call-template name="getVariable">
						<xsl:with-param name="id" select="'Description'"/>
					</xsl:call-template>
				</chdeschd>
			</chhead>
		</gen>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/chhead ')]">
		<thead>
			<tr>
				<xsl:call-template name="commonattributes"/>
				<xsl:apply-templates
					select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass"
					mode="add-ditaval-style"/>
				<xsl:apply-templates select="*[contains(@class, ' task/choptionhd ')]"/>
				<xsl:apply-templates select="*[contains(@class, ' task/chdeschd ')]"/>
			</tr>
		</thead>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/choptionhd ')]">
		<th>
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="style">
				<xsl:with-param name="contents">
					<xsl:text>vertical-align:bottom;</xsl:text>
					<xsl:call-template name="th-align"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:attribute name="id">
				<xsl:choose>
					<!-\- if the option header has an ID, use that -\->
					<xsl:when test="@id">
						<xsl:value-of select="@id"/>
					</xsl:when>
					<xsl:otherwise>
						<!-\- output a default option header ID -\->
						<xsl:value-of select="generate-id(../..)"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>-option</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="." mode="chtabhdr"/>
		</th>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/chdeschd ')]">
		<th>
			<xsl:call-template name="commonattributes"/>
			<xsl:call-template name="style">
				<xsl:with-param name="contents">
					<xsl:text>vertical-align:bottom;</xsl:text>
					<xsl:call-template name="th-align"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:attribute name="id">
				<xsl:choose>
					<!-\- if the description header has an ID, use that -\->
					<xsl:when test="@id">
						<xsl:value-of select="@id"/>
					</xsl:when>
					<xsl:otherwise>
						<!-\- output a default descr header ID -\->
						<xsl:value-of select="generate-id(../..)"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>-desc</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates select="." mode="chtabhdr"/>
		</th>
	</xsl:template>
	<!-\- Option & Description headers -\->
	<xsl:template match="*[contains(@class, ' task/choptionhd ')]" mode="chtabhdr">
		<xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<xsl:apply-templates/>
		<xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/chdeschd ')]" mode="chtabhdr">
		<xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
			mode="out-of-line"/>
		<xsl:apply-templates/>
		<xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
			mode="out-of-line"/>
	</xsl:template>
	<xsl:template match="*[contains(@class, ' task/chrow ')]" name="topic.task.chrow">
		<tr>
			<xsl:call-template name="setid"/>
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates/>
		</tr>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!-\- specialization of stentry - choption -\->
	<!-\- for specentry - if no text in cell, output specentry attr; otherwise output text -\->
	<!-\- Bold the @keycol column. Get the column's number. When (Nth stentry = the @keycol value) then bold the stentry -\->
	<xsl:template match="*[contains(@class, ' task/choption ')]" name="topic.task.choption">
		<xsl:variable name="localkeycol" as="xs:integer">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/simpletable ')][1]/@keycol">
					<xsl:value-of
						select="ancestor::*[contains(@class, ' topic/simpletable ')][1]/@keycol"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="element-name"
			select="
				if ($localkeycol = 1) then
					'th'
				else
					'td'"/>
		<xsl:element name="{$element-name}">
			<xsl:call-template name="style">
				<xsl:with-param name="contents">
					<xsl:text>vertical-align:top;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<!-\- Add header attr for column header -\->
			<xsl:attribute name="headers">
				<xsl:choose>
					<!-\- First choice: if there is a user-specified header, and it has an ID -\->
					<xsl:when
						test="ancestor::*[contains(@class, ' task/choicetable ')][1]/*[contains(@class, ' task/chhead ')]/*[contains(@class, ' task/choptionhd ')]/@id">
						<xsl:value-of
							select="ancestor::*[contains(@class, ' task/choicetable ')][1]/*[contains(@class, ' task/chhead ')]/*[contains(@class, ' task/choptionhd ')]/@id"
						/>
					</xsl:when>
					<!-\- Second choice: no user-specified header for this column. ID is based on the table's generated ID. -\->
					<xsl:otherwise>
						<xsl:value-of
							select="generate-id(ancestor::*[contains(@class, ' task/choicetable ')][1])"
						/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>-option</xsl:text>
			</xsl:attribute>
			<!-\- Add header attr, column header then row header -\->
			<xsl:attribute name="id">
				<!-\- If there is a user-specified ID, use it -\->
				<xsl:choose>
					<xsl:when test="@id">
						<xsl:value-of select="@id"/>
					</xsl:when>
					<xsl:otherwise>
						<!-\- generate one -\->
						<xsl:value-of select="generate-id(.)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
				mode="out-of-line"/>
			<xsl:call-template name="stentry-templates"/>
			<xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
				mode="out-of-line"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
	<!-\- specialization of stentry - chdesc -\->
	<!-\- for specentry - if no text in cell, output specentry attr; otherwise output text -\->
	<!-\- Bold the @keycol column. Get the column's number. When (Nth stentry = the @keycol value) then bold the stentry -\->
	<xsl:template match="*[contains(@class, ' task/chdesc ')]" name="topic.task.chdesc">
		<xsl:variable name="localkeycol" as="xs:integer">
			<xsl:choose>
				<xsl:when test="ancestor::*[contains(@class, ' topic/simpletable ')][1]/@keycol">
					<xsl:value-of
						select="ancestor::*[contains(@class, ' topic/simpletable ')][1]/@keycol"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="element-name"
			select="
				if ($localkeycol = 2) then
					'th'
				else
					'td'"/>
		<xsl:element name="{$element-name}">
			<xsl:call-template name="style">
				<xsl:with-param name="contents">
					<xsl:text>vertical-align:top;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
			<!-\- Add header attr, column header then option header -\->
			<xsl:attribute name="headers">
				<xsl:choose>
					<!-\- First choice: if there is a user-specified header, and it has an ID-\->
					<xsl:when
						test="ancestor::*[contains(@class, ' task/choicetable ')][1]/*[contains(@class, ' task/chhead ')]/*[contains(@class, ' task/chdeschd ')]/@id">
						<!-\- If there is a user-specified row ID -\->
						<xsl:value-of
							select="ancestor::*[contains(@class, ' task/choicetable ')][1]/*[contains(@class, ' task/chhead ')]/*[contains(@class, ' task/chdeschd ')]/@id"
						/>
					</xsl:when>
					<!-\- Second choice: no user-specified header for this column. ID is based on the table's generated ID. -\->
					<xsl:otherwise>
						<xsl:value-of
							select="generate-id(ancestor::*[contains(@class, ' task/choicetable ')][1])"
						/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>-desc </xsl:text>
				<!-\- add CHOption ID -\->
				<xsl:choose>
					<xsl:when test="../*[contains(@class, ' task/choption ')]/@id">
						<xsl:value-of select="../*[contains(@class, ' task/choption ')]/@id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="generate-id(../*[contains(@class, ' task/choption ')])"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-\- If there is a user-specified ID, add it -\->
			<xsl:if test="@id">
				<xsl:attribute name="id" select="@id"/>
			</xsl:if>
			<xsl:call-template name="commonattributes"/>
			<xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
				mode="out-of-line"/>
			<xsl:call-template name="stentry-templates"/>
			<xsl:apply-templates select="../*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
				mode="out-of-line"/>
		</xsl:element>
		<xsl:value-of select="$newline"/>
	</xsl:template>
-->

	<!-- GEHC-19 -->
	<!-- Rally ID DE72 -->
	<!-- 2017-11-09: create the popup html -->
	<!--	<xsl:template name="createPopupHTML">
		<xsl:param name="html" />

	 	<xsl:result-document href="{concat(substring-before(tokenize(base-uri(), '/')[last()], '.dita'), '_Popup.html')}" encoding="UTF-8" method="xhtml" indent="no" doctype-public="" doctype-system="about:legacy-compat" omit-xml-declaration="yes">
	  		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{$html//descendant::*[local-name() = 'html']/@xml:lang}" lang="{$html//descendant::*[local-name() = 'html']/@lang}" stringName="{$html//descendant::*[local-name() = 'html']/@stringName}">
	  			<head>
	  				<link rel="stylesheet" type="text/css" href="oxygen-webhelp/resources/css/commonltr.css"><!-\-\-\-></link>
	  				<link rel="stylesheet" type="text/css" href="oxygen-webhelp/resources/css/webhelp_topic.css"><!-\-\-\-></link>
	  			</head>
	  			<div style="float:right;padding: 6px 6px 0 0;">


	  				<!-\- GEHC-19 -\->
					<!-\- Rally ID DE72 -\->
					<!-\- 2017-11-12: removed "Open with frames" -\->
	  				<!-\-a id="oldFrames" target="_blank" href="index_frames.html" title="Open with frames" class="openFrame" style="background-repeat: no-repeat;"></a-\->


	  				<a HREF="javascript:window.print()" title="Print this page" class="printTopic" style="padding-right: 5px;"></a>
					<script>document.write('<a href="mailto:help.feedback@ge.com?subject=Test Concept Topic 3ab - Test cross references (xrefs)&amp;body='+window.location.href+'" title="Email" class="mail" target="_blank"></a>');</script>
				</div>
	  			<body id="{$html//descendant::*[local-name() = 'body']/@id}">
	  				<xsl:copy-of select="$html//descendant::*[local-name() = 'body']/child::*" />
	  			</body>
	  		</html>
	  	</xsl:result-document>
	</xsl:template>-->

</xsl:stylesheet>
