<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->
<!-- 20090904 RDA: Add support for stepsection; combine duplicated logic
                   for main steps and steps-unordered templates. -->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
                xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="related-links dita2html ditamsg xs">

    <!-- Determines whether to generate titles for task sections. Values are YES and NO. -->
    <xsl:param name="GENERATE-TASK-LABELS" select="'NO'"/>

    <!-- == TASK UNIQUE SUBSTRUCTURES == -->

    <xsl:template match="*[contains(@class, ' task/context ')]" mode="dita2html:section-heading">
        <!--<xsl:apply-templates select="." mode="generate-task-label">
          <xsl:with-param name="use-label">
            <xsl:call-template name="getString">
              <xsl:with-param name="stringName" select="'task_context'"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:apply-templates>-->
    </xsl:template>
    <xsl:template match="*[contains(@class, ' task/prereq ')]" mode="dita2html:section-heading">
        <xsl:apply-templates select="." mode="generate-task-label">
            <xsl:with-param name="use-label">
                <xsl:choose>
                    <xsl:when test="$GENERATE-TASK-LABELS = 'no-labels'">
                        <!--<xsl:call-template name="getString">
                          <xsl:with-param name="stringName" select="'Prerequisite Open'"/>
                        </xsl:call-template>-->
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
                        <!--<xsl:call-template name="getString">
                          <xsl:with-param name="stringName" select="'Reslut Open'"/>
                        </xsl:call-template>-->
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
                        <!--<xsl:call-template name="getString">
                          <xsl:with-param name="stringName" select="'Postrequisite Open'"/>
                        </xsl:call-template>-->
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
                        <!--<xsl:call-template name="getString">
                          <xsl:with-param name="stringName" select="'Example Open'"/>
                        </xsl:call-template>-->
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
                    <xsl:otherwise>h<xsl:value-of select="$headCount"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <div class="tasklabel">
                <xsl:element name="{$headLevel}">
                    <xsl:attribute name="class">sectiontitle tasklabel</xsl:attribute>
                    <xsl:value-of select="$use-label"/>
                </xsl:element>
            </div>
        </xsl:if>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' task/steps ')][contains(@outputclass, 'show_hide_expanded')][@id]"
                  mode="steps-fmt" priority="20">
        <xsl:param name="step_expand"/>
        <p>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="generate-twisty">
                <xsl:with-param name="id" select="@id"/>
            </xsl:call-template>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:apply-templates select="." mode="common-processing-within-steps">
                    <xsl:with-param name="step_expand" select="$step_expand"/>
                    <xsl:with-param name="list-type" select="'ol'"/>
                </xsl:apply-templates>
            </xsl:element>
        </p>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' task/steps ')][contains(@outputclass, 'show_hide')][@id]"
                  mode="steps-fmt" priority="10">
        <xsl:param name="step_expand"/>
        <p>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="generate-twisty">
                <xsl:with-param name="id" select="@id"/>
            </xsl:call-template>
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:apply-templates select="." mode="common-processing-within-steps">
                    <xsl:with-param name="step_expand" select="$step_expand"/>
                    <xsl:with-param name="list-type" select="'ol'"/>
                </xsl:apply-templates>
            </xsl:element>
        </p>
        <xsl:call-template name="hide-twisty">
            <xsl:with-param name="id" select="@id"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' task/steps ')]" mode="steps-fmt">
        <xsl:param name="step_expand"/>
        <xsl:apply-templates select="." mode="common-processing-within-steps">
            <xsl:with-param name="step_expand" select="$step_expand"/>
            <xsl:with-param name="list-type" select="'ol'"/>
        </xsl:apply-templates>
    </xsl:template>


    <xsl:template
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
                        <!--<xsl:call-template name="getWebhelpString">
                          <xsl:with-param name="stringName" select="'Steps Open'"/>
                        </xsl:call-template>-->
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
                <!-- Single step. Process any stepsection before the step (cannot appear after). -->
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
                <!-- Stepsection is first, no other appearances -->
                <xsl:apply-templates select="*[contains(@class, ' task/stepsection ')]"/>
                <xsl:apply-templates select="." mode="step-elements-with-no-stepsection">
                    <xsl:with-param name="step_expand" select="$step_expand"/>
                    <xsl:with-param name="list-type" select="$list-type"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <!-- Stepsection elements mixed in with steps -->
                <xsl:apply-templates select="." mode="step-elements-with-stepsection">
                    <xsl:with-param name="step_expand" select="$step_expand"/>
                    <xsl:with-param name="list-type" select="$list-type"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  ******************* Choice table override **********************-->
    <!-- choice table is like a simpletable - 2 columns, set heading -->
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
            <!--If the choicetable has no header - output a default one-->
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
    >choicetableborder
    </xsl:template>
    <xsl:template match="*[contains(@class, ' task/choicetable ')]"
                  mode="dita2html:get-max-entry-count" as="xs:integer">
        <xsl:sequence select="2"/>
    </xsl:template>
    <!-- Generate default choicetable header -->
    <xsl:template name="gen-chhead" as="element(gen)?">
        <xsl:variable name="choicetable"
                      select="ancestor-or-self::*[contains(@class, ' task/choicetable ')][1]" as="element()"/>
        <!-- Generated header needs to be wrapped in gen element to allow correct language detection -->
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
                    <!-- if the option header has an ID, use that -->
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- output a default option header ID -->
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
                    <!-- if the description header has an ID, use that -->
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- output a default descr header ID -->
                        <xsl:value-of select="generate-id(../..)"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>-desc</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="." mode="chtabhdr"/>
        </th>
    </xsl:template>
    <!-- Option & Description headers -->
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
    <!-- specialization of stentry - choption -->
    <!-- for specentry - if no text in cell, output specentry attr; otherwise output text -->
    <!-- Bold the @keycol column. Get the column's number. When (Nth stentry = the @keycol value) then bold the stentry -->
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
            <!-- Add header attr for column header -->
            <xsl:attribute name="headers">
                <xsl:choose>
                    <!-- First choice: if there is a user-specified header, and it has an ID -->
                    <xsl:when
                            test="ancestor::*[contains(@class, ' task/choicetable ')][1]/*[contains(@class, ' task/chhead ')]/*[contains(@class, ' task/choptionhd ')]/@id">
                        <xsl:value-of
                                select="ancestor::*[contains(@class, ' task/choicetable ')][1]/*[contains(@class, ' task/chhead ')]/*[contains(@class, ' task/choptionhd ')]/@id"
                        />
                    </xsl:when>
                    <!-- Second choice: no user-specified header for this column. ID is based on the table's generated ID. -->
                    <xsl:otherwise>
                        <xsl:value-of
                                select="generate-id(ancestor::*[contains(@class, ' task/choicetable ')][1])"
                        />
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>-option</xsl:text>
            </xsl:attribute>
            <!-- Add header attr, column header then row header -->
            <xsl:attribute name="id">
                <!-- If there is a user-specified ID, use it -->
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- generate one -->
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
    <!-- specialization of stentry - chdesc -->
    <!-- for specentry - if no text in cell, output specentry attr; otherwise output text -->
    <!-- Bold the @keycol column. Get the column's number. When (Nth stentry = the @keycol value) then bold the stentry -->
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
            <!-- Add header attr, column header then option header -->
            <xsl:attribute name="headers">
                <xsl:choose>
                    <!-- First choice: if there is a user-specified header, and it has an ID-->
                    <xsl:when
                            test="ancestor::*[contains(@class, ' task/choicetable ')][1]/*[contains(@class, ' task/chhead ')]/*[contains(@class, ' task/chdeschd ')]/@id">
                        <!-- If there is a user-specified row ID -->
                        <xsl:value-of
                                select="ancestor::*[contains(@class, ' task/choicetable ')][1]/*[contains(@class, ' task/chhead ')]/*[contains(@class, ' task/chdeschd ')]/@id"
                        />
                    </xsl:when>
                    <!-- Second choice: no user-specified header for this column. ID is based on the table's generated ID. -->
                    <xsl:otherwise>
                        <xsl:value-of
                                select="generate-id(ancestor::*[contains(@class, ' task/choicetable ')][1])"
                        />
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>-desc </xsl:text>
                <!-- add CHOption ID -->
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
            <!-- If there is a user-specified ID, add it -->
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


</xsl:stylesheet>
