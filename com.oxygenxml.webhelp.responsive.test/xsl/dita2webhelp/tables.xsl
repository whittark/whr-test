<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:oxygen="http://www.oxygenxml.com/functions"
    exclude-result-prefixes="ditamsg dita2html related-links xs oxygen"
    version="2.0">
    
    
    
    
    
    <xsl:template match="*[contains(@class, ' topic/table ')]" name="topic.table">
    <xsl:variable name="uniqueTable">
        <xsl:text>table-</xsl:text>
        <xsl:value-of select="generate-id()"/>
    </xsl:variable>
    <xsl:message>
        <xsl:value-of select="$uniqueTable"/>
    </xsl:message>
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
    <xsl:value-of select="$newline"/>
    <!-- special case for IE & NS for frame & no rules - needs to be a double table -->
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
    <!-- Comtech Services 09/09/2013 added line to table template to generate footer -->
    <xsl:if test="descendant-or-self::*[contains(@class, ' topic/fn ')]">
        <p>
            <xsl:call-template name="gen-endnotes-tablefooter"/>
        </p>
    </xsl:if>
</xsl:template>
    
    <xsl:template name="place-tbl-lbl">
        <xsl:param name="id"/>
        <!-- Number of table/title's before this one -->
        <xsl:variable name="tbl-count-actual"
            select="count(preceding::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]) + 1"/>
        <!-- normally: "Table 1. " -->
        <xsl:variable name="ancestorlang">
            <xsl:call-template name="getLowerCaseLang"/>
        </xsl:variable>
        <xsl:choose>
            <!-- title -or- title & desc -->
            <xsl:when test="*[contains(@class, ' topic/title ')]">
                <xsl:if test="not(ancestor-or-self::*[contains(@outputclass, 'show_hide')])">
                    <caption>
                        <span class="tablecap">
                            <!-- FMC 03/10/2015 Add Table gentext from the Table titles -->
                            <xsl:choose>
                                <!-- Hungarian: "1. Table " -->
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
            <!-- desc -->
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
    </xsl:template>
    
    <xsl:template name="dotable">
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
            <!--<xsl:call-template name="commonattributes"/>-->
            <xsl:apply-templates select="." mode="generate-table-summary-attribute"/>
            <xsl:call-template name="setscale"/>
            <!-- When a table's width is set to page or column, force it's width to 100%. If it's in a list, use 90%.
         Otherwise, the table flows to the content -->
            <xsl:choose>
                <xsl:when
                    test="(@expanse = 'page' or @pgwide = '1')and (ancestor::*[contains(@class, ' topic/li ')] or ancestor::*[contains(@class, ' topic/dd ')] )">
                    <xsl:attribute name="width">90%</xsl:attribute>
                </xsl:when>
                <xsl:when
                    test="(@expanse = 'column' or @pgwide = '0') and (ancestor::*[contains(@class, ' topic/li ')] or ancestor::*[contains(@class, ' topic/dd ')] )">
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
            <!-- title and desc are processed elsewhere -->
            <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
        </table>
        <xsl:value-of select="$newline"/>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]"
            mode="out-of-line"/>
    </xsl:template>

    <!-- =========== SimpleTable - SEMANTIC TABLE =========== -->
    <xsl:template match="*[contains(@class, ' topic/simpletable ')]"
        mode="generate-table-summary-attribute">
        <!-- Override this to use a local convention for setting table's @summary attribute,
       until OASIS provides a standard mechanism for setting. -->
        <xsl:call-template name="profiling-atts"/>
    </xsl:template>
    <!-- Comtech Services 10/24/2013 added to conditionalize the footnotes for tables -->
    <!-- render any contained footnotes as endnotes.  Links back to reference point -->
    <!-- choice table is like a simpletable - 2 columns, set heading -->
    <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="pre-fmt">
        <!-- This template is deprecated in DITA-OT 1.7. Processing will moved into the main element rule. -->
        <xsl:if test="contains(@frame, 'top')">
            <hr/>
        </xsl:if>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]"
            mode="out-of-line"/>
        <xsl:call-template name="spec-title-nospace"/>
        <p style="border:1pt solid #1F4998;padding:6pt;white-space:pre-wrap;font-family:Courier;">
            <!--Remove the overflow:auto; from the paragraph styled above. - Pat-->
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
                    <!--<xsl:when test="contains(@href, '.xml')">
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
          </xsl:when>-->
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
                        <!--<xsl:call-template name="parsehref">
              <xsl:with-param name="href" select="substring-after(@href, '#')"/>
            </xsl:call-template>-->
                        <xsl:value-of select="substring-after(@href, '#')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>Href value with catch at otherwise = <xsl:value-of
                            select="@href"/></xsl:message>
                        <xsl:text>#</xsl:text>
                        <xsl:call-template name="parsehref">
                            <xsl:with-param name="href" select="@href"/>
                        </xsl:call-template>
                        <!--<xsl:value-of select="@href"/>-->
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="normalize-space(@href) = '' or not(@href)"/>
            <!-- For non-DITA formats - use the href as is -->
            <xsl:when
                test="(not(@format) and (@type = 'external' or @scope = 'external')) or (@format and not(@format = 'dita' or @format = 'DITA'))">
                <xsl:value-of select="@href"/>
            </xsl:when>
            <!-- For DITA - process the internal href -->
            <xsl:when test="starts-with(@href, '#')">
                <xsl:call-template name="parsehref">
                    <xsl:with-param name="href" select="@href"/>
                </xsl:call-template>
            </xsl:when>
            <!-- It's to a DITA file - process the file name (adding the html extension)
    and process the rest of the href -->
            <!-- for local links respect dita.extname extension
      and for peer links accept both .xml and .dita bug:3059256-->
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
    </xsl:template>

</xsl:stylesheet>