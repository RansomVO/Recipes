<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@                        Main Template                       @@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<xsl:template match="Recipe">

		<html lang="en">
			<head>
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				<link rel="stylesheet" type="text/css" href="styles.css" />
				<title>
					<xsl:value-of select="@title" />
				</title>
			</head>

			<body>
				<div class="TITLE">
					<span>
						<xsl:if test="@yields = 'ToDo'">
							<xsl:attribute name="class">TODO</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@title" />
					</span>
				</div>
				<xsl:if test="@titleNote">
					<div class="TITLE_NOTE">(<xsl:value-of select="@titleNote" />)</div>
					<br />
				</xsl:if>

				<table class="DIVIDER">
					<tr>
						<td class="RECIPE_SOURCE">
							<xsl:if test="Source">
								<xsl:apply-templates select="Source" />
							</xsl:if>
							<xsl:if test="Note">
								<i>&#xA0;(<xsl:apply-templates select="Note" />)</i>
							</xsl:if>
						</td>
						<xsl:if test="@yields">
							<td class="RECIPE_YIELDS" align="right">
								<b>Yields</b>: <span>
									<xsl:choose>
										<!-- TODO QZX: Figure out how to <xsl:apply-templates ...> to the links below so that it doesn't look like a link when printing. -->
										<xsl:when test="@yields = 'See Ingredients'">
											<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link">
												<xsl:with-param name="section" select="'Ingredients'" />
											</xsl:call-template> below) </xsl:when>
										<xsl:when test="@yields = 'See Instructions'">
											<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link">
												<xsl:with-param name="section" select="'Instructions'" />
											</xsl:call-template> below)</xsl:when>
										<xsl:when test="@yields = 'See Notes'">
											<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link">
												<xsl:with-param name="section" select="'Notes'" />
											</xsl:call-template> below) </xsl:when>
										<xsl:when test="@yields = 'See Modifications'">
											<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link">
												<xsl:with-param name="section" select="'Modifications'" />
											</xsl:call-template> below)</xsl:when>
										<xsl:when test="@yields = 'See Additional Notes'">
											<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link">
												<xsl:with-param name="section" select="'Additional Notes'" />
											</xsl:call-template> below)</xsl:when>
										<xsl:when test="@yields = 'See Final Note'">
											<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link">
												<xsl:with-param name="section" select="'Final Note'" />
											</xsl:call-template> below)</xsl:when>
										<xsl:when test="@yields = 'ToDo'">
											<xsl:attribute name="class">TODO</xsl:attribute>
											<xsl:value-of select="@yields" />
										</xsl:when>
										<xsl:when test="starts-with(@yields, '(')">
											<xsl:attribute name="class">NOTE</xsl:attribute>
											<xsl:value-of select="@yields" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@yields" />
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</td>
						</xsl:if>
					</tr>
					<tr>
						<td class="DESCRIPTION" colspan="2" style="padding-top:.5em;">
							<xsl:copy-of select="Description" />
						</td>
					</tr>
				</table>

				<xsl:apply-templates select="Ingredients" />

				<xsl:apply-templates select="Instructions" />

				<xsl:apply-templates select="Notes" />

				<xsl:apply-templates select="Modifications" />

				<xsl:apply-templates select="AdditionalNotes" />

				<xsl:apply-templates select="FinalNote" />

				<div class="no-print">
					<br />
					<hr />
					<table class="DIVIDER">
						<tr>
							<td>
								<a href="/">Home</a> / <xsl:choose>
									<xsl:when test="ParentSection">
										<a href="../..">Recipes</a> / <a href="..">
											<xsl:value-of select="ParentSection" />
										</a> / <a href=".">
											<xsl:value-of select="Section" />
										</a>
									</xsl:when>
									<xsl:otherwise>
										<a href="..">Recipes</a> / <a href=".">
											<xsl:value-of select="Section" />
										</a>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</div>
			</body>
		</html>

	</xsl:template>

	<!-- ************************************************************************************************************************ -->
	<!-- Tool Templates                                                                                                           -->
	<!-- ************************************************************************************************************************ -->
	<xsl:template name="replace_all">
		<xsl:param name="string" />
		<xsl:param name="oldValue" />
		<xsl:param name="newValue" />

		<xsl:choose>
			<xsl:when test="contains($string, $oldValue)">
				<xsl:value-of select="substring-before($string, $oldValue)" />
				<xsl:value-of select="$newValue" />
				<xsl:call-template name="replace_all">
					<xsl:with-param name="string" select="substring-after($string, $oldValue)" />
					<xsl:with-param name="oldValue" select="$oldValue" />
					<xsl:with-param name="newValue" select="$newValue" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="fix_text">
		<xsl:param name="string" />

		<xsl:variable name="step1"> <!-- Teaspoon - teaspoon -->
			<xsl:call-template name="replace_all">
				<xsl:with-param name="string">
					<xsl:value-of select="$string" />
				</xsl:with-param>
				<xsl:with-param name="oldValue" select="'Teaspoon'" />
				<xsl:with-param name="newValue" select="'teaspoon'" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="step2"> <!-- tablespoon - Tablespoon -->
			<xsl:call-template name="replace_all">
				<xsl:with-param name="string">
					<xsl:value-of select="$step1" />
				</xsl:with-param>
				<xsl:with-param name="oldValue" select="'tablespoon'" />
				<xsl:with-param name="newValue" select="'Tablespoon'" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy-of select="$step2" />
	</xsl:template>
	<xsl:template name="section-link">
		<xsl:param name="section" />

		<a class="no-print">
			<xsl:attribute name="href">#<xsl:value-of select="translate($section,' ','')" /></xsl:attribute>
			<xsl:value-of select="$section" />
		</a>
		<span class="no-screen">
			<xsl:value-of select="$section" />
		</span>
	</xsl:template>
	<xsl:template match="a">
		<a class="no-print">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</a>
		<span class="no-screen">
			<xsl:value-of select="text()" />
		</span>
	</xsl:template>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		In order to let "<xsl:apply-templates />" work, it is necessary to use this to copy standard HTML nodes and address their contents.
		As new HTML elements are used in the Recipes, make sure to add them to this template.
		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template match="blockquote|br|div|hr|img|li|ol|p|span|table|td|th|tr|ul">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>

	<!-- ************************************************************************************************************************ -->
	<!--  Templates for sub-items                                                                                                 -->
	<!-- ************************************************************************************************************************ -->
	<xsl:template match="LastModified">
		<xsl:value-of select="@year" />
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="@month=1">January</xsl:when>
			<xsl:when test="@month=2">February</xsl:when>
			<xsl:when test="@month=3">March</xsl:when>
			<xsl:when test="@month=4">April</xsl:when>
			<xsl:when test="@month=5">May</xsl:when>
			<xsl:when test="@month=6">June</xsl:when>
			<xsl:when test="@month=7">July</xsl:when>
			<xsl:when test="@month=8">August</xsl:when>
			<xsl:when test="@month=9">September</xsl:when>
			<xsl:when test="@month=10">October</xsl:when>
			<xsl:when test="@month=11">November</xsl:when>
			<xsl:when test="@month=12">December</xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:value-of select="@day" />
	</xsl:template>
	<xsl:template match="subSection">
		<table>
			<tr>
				<xsl:apply-templates select="$instruction/subSection" />
				<td class="RECIPE_SUBSECTION">
					<xsl:if test="@font-size">
						<xsl:attribute name="style">font-size:<xsl:value-of select="@font-size" />;</xsl:attribute>
					</xsl:if>
					<span class="SUBSECTION_HEADER" style="vertical-align:top;">
						<xsl:value-of select="@title" />
					</span>
					<xsl:if test="@image">
						<img style="float:right;">
							<xsl:attribute name="src">
								<xsl:value-of select="@image" />
							</xsl:attribute>
						</img>
					</xsl:if>
					<ol>
						<xsl:attribute name="style"> clear:right; padding-left:1em; list-style:<xsl:value-of select="@list-style" />; </xsl:attribute>
						<xsl:apply-templates />
					</ol>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="Ingredients">
		<xsl:choose>
			<xsl:when test="@pageBreak">
				<span class="no-screen">
					<i>(Continued on next page)</i>
				</span>
				<div style="break-after:page;" />
			</xsl:when>
			<xsl:otherwise>
				<span style="font-size:.5em;"> </span>
				<br />
			</xsl:otherwise>
		</xsl:choose>
		<div class="SECTION_HEADER" id="Ingredients">Ingredients</div>
		<div style="overflow-x:auto;">
			<table class="no-overflow" style="margin-left:1.5em; white-space:nowrap; overflow-x:auto;">
				<tr>
					<xsl:variable name="sectionCount" select="count(section)" />
					<xsl:for-each select="section">
						<td style="vertical-align:top;">
							<xsl:if test="@title = 'ToDo'">
								<xsl:attribute name="class">TODO</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when test="@title = '{BLANK}'">
									<div class="SUBSECTION_HEADER" style="text-decoration:none;">&#xA0;</div>
								</xsl:when>
								<xsl:otherwise>
									<span class="SUBSECTION_HEADER">
										<xsl:value-of select="@title" />
									</span>
								</xsl:otherwise>
							</xsl:choose>
							<table>
								<xsl:choose>
									<xsl:when test="@title">
										<xsl:attribute name="style">margin-left:1em; white-space:nowrap; overflow-x:auto;</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="style">white-space:nowrap; overflow-x:auto;</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:apply-templates select="ingredient">
									<xsl:with-param name="sectionCount">
										<xsl:value-of select="@sectionCount" />
									</xsl:with-param>
								</xsl:apply-templates>
							</table>
						</td>
					</xsl:for-each>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="ingredient">
		<xsl:param name="sectionCount" />
		<tr>
			<td class="RECIPE_INGREDIENT">
				<xsl:if test="@nameNote = 'Optional'">
					<i style="font-weight:normal;">(Optional)&#xA0;</i>
				</xsl:if>
				<xsl:call-template name="fix_text">
					<xsl:with-param name="string" select="@name" />
				</xsl:call-template>
				<xsl:if test="@nameNote and (@nameNote != 'Optional')">
					<xsl:if test="($sectionCount > 1) and ((string-length(@name) + string-length(@nameNote) + 2) > 32)">
						<br />&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; </xsl:if>
					<span class="SMALL_NOTE">&#xA0;(<xsl:call-template name="fix_text">
							<xsl:with-param name="string" select="@nameNote" />
						</xsl:call-template>)</span>
				</xsl:if>
			</td>
			<td class="RECIPE_INGREDIENT_QUANTITY">
				<xsl:call-template name="fix_text">
					<xsl:with-param name="string" select="@amount" />
				</xsl:call-template>
				<xsl:if test="@amountNote">
					<xsl:if test="($sectionCount > 1) and ((string-length(@name) + string-length(@nameNote) + 2) > 32)">
						<br />&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; </xsl:if>
					<xpan class="SMALL_NOTE">&#xA0;(<xsl:call-template name="fix_text">
							<xsl:with-param name="string" select="@amountNote" />
						</xsl:call-template>)</xpan>
				</xsl:if>
			</td>
		</tr>
		<xsl:if test="@finePrint">
			<tr>
				<td class="RECIPE_INGREDIENT_FINE_PRINT" colspan="2">(<xsl:call-template name="fix_text">
						<xsl:with-param name="string" select="@finePrint" />
					</xsl:call-template>)</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Instructions">
		<xsl:choose>
			<xsl:when test="@pageBreak">
				<span class="no-screen">
					<i>(Continued on next page)</i>
				</span>
				<div style="break-after:page;" />
			</xsl:when>
			<xsl:otherwise>
				<span style="font-size:.5em;"> </span>
				<br />
			</xsl:otherwise>
		</xsl:choose>
		<div class="SECTION_HEADER" id="Instructions">Instructions</div>
		<br />
		<xsl:for-each select="section">
			<div>
				<xsl:if test="@title = 'ToDo'">
					<xsl:attribute name="class">TODO</xsl:attribute>
				</xsl:if>
				<xsl:if test="@title">
					<xsl:attribute name="style">margin-left:2em;</xsl:attribute>
					<span class="SUBSECTION_HEADER">
						<xsl:value-of select="@title" />
					</span>
				</xsl:if>
				<ol style="margin-top:0; margin-bottom:0;">
					<xsl:apply-templates select="instruction" />
				</ol>
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="Notes">
		<xsl:if test="note">
			<xsl:choose>
				<xsl:when test="@pageBreak">
					<span class="no-screen">
						<i>(Continued on next page)</i>
					</span>
					<div style="break-after:page;" />
				</xsl:when>
				<xsl:otherwise>
					<span style="font-size:.5em;"> </span>
					<br />
				</xsl:otherwise>
			</xsl:choose>
			<div class="SECTION_HEADER" id="Notes">Notes</div>
			<ul style="margin-top:0;">
				<xsl:apply-templates select="note" />
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="AdditionalNotes">
		<xsl:if test="note">
			<xsl:choose>
				<xsl:when test="@pageBreak">
					<span class="no-screen">
						<i>(Continued on next page)</i>
					</span>
					<div style="break-after:page;" />
				</xsl:when>
				<xsl:otherwise>
					<span style="font-size:.5em;"> </span>
					<br />
				</xsl:otherwise>
			</xsl:choose>
			<div class="SECTION_HEADER" id="AdditionalNotes">Additional Notes</div>
			<ul style="margin-top:0;">
				<xsl:apply-templates select="note" />
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Modifications">
		<xsl:if test="modification">
			<xsl:choose>
				<xsl:when test="@pageBreak">
					<span class="no-screen">
						<i>(Continued on next page)</i>
					</span>
					<div style="break-after:page;" />
				</xsl:when>
				<xsl:otherwise>
					<span style="font-size:.5em;"> </span>
					<br />
				</xsl:otherwise>
			</xsl:choose>
			<div class="SECTION_HEADER" id="Modifications">Modifications</div>
			<ul style="margin-top:0;">
				<xsl:apply-templates select="modification" />
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="FinalNote">
		<br />
		<div class="NOTE" id="FinalNote">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="instruction|note|modification">
		<li>
			<xsl:apply-templates />
		</li>
	</xsl:template>

</xsl:stylesheet>
