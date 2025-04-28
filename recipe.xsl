<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="common.xsl" />

	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@                        Main Template                       @@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<xsl:template match="Recipe">
		<xsl:variable name="depth">
			<xsl:choose>
				<xsl:when test="document(concat(Section/section/@folder, '/section.xml'))/section/@folder = '.'">1</xsl:when>
				<xsl:when test="document(concat(Section/section/@folder, '/../section.xml'))/section/@folder = '.'">2</xsl:when>
				<xsl:when test="document(concat(Section/section/@folder, '/../../section.xml'))/section/@folder = '.'">3</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="linkPrefix">
			<xsl:call-template name="LinkPrefix">
				<xsl:with-param name="depth" select="$depth" />
			</xsl:call-template>
		</xsl:variable>

		<html lang="en">
			<head>
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				<link rel="stylesheet" type="text/css" href="styles.css" />
				<title> VanOrman Family Recipes - <xsl:if test="ParentSection">
						<xsl:value-of select="ParentSection" /> / </xsl:if><xsl:value-of select="normalize-space(Section)" />: <xsl:value-of select="@title" /></title>
			</head>

			<body>
				<div class="FLEX_CONTENT">
					<div style="margin-bottom: .25em;">
						<span class="TITLE">
							<xsl:value-of select="@title" />
						</span>
						<xsl:if test="@titleNote"> &#xA0;&#xA0;&#xA0;&#xA0;<span class="TITLE_NOTE">(<xsl:value-of select="@titleNote" />)</span>
						</xsl:if>
					</div>

					<table class="DIVIDER">
						<tr>
							<td class="RECIPE_SOURCE">
								<xsl:if test="Source">
									<xsl:apply-templates select="Source">
										<xsl:with-param name="linkPrefix" select="$linkPrefix" />
									</xsl:apply-templates>
								</xsl:if>
								<xsl:if test="Note">
									<i>&#xA0;(<xsl:apply-templates select="Note">
											<xsl:with-param name="linkPrefix" select="$linkPrefix" />
										</xsl:apply-templates>)</i>
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
											<xsl:when test="@yields = '???'">
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

					<xsl:apply-templates select="Ingredients">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>

					<xsl:apply-templates select="Instructions">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>

					<xsl:apply-templates select="Notes">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>

					<xsl:apply-templates select="Modifications">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>

					<xsl:apply-templates select="AdditionalNotes">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>

					<xsl:apply-templates select="FinalNote">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>
				</div>

				<footer class="FLEX_FOOTER">
					<table class="DIVIDER">
						<tr>
							<td class="no-print">
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
							<td class="LAST_MODIFIED" style="text-align:right;"> Last updated: <xsl:apply-templates select="LastModified" />
							</td>
						</tr>
					</table>
				</footer>
			</body>
		</html>

	</xsl:template>

	<!-- ************************************************************************************************************************ -->
	<!--  Templates for sub-items                                                                                                 -->
	<!-- ************************************************************************************************************************ -->
	<xsl:template match="subSection">
		<xsl:param name="linkPrefix" />

		<table>
			<xsl:copy-of select="@*" />
			<tr>
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
						<xsl:apply-templates>
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
						</xsl:apply-templates>
					</ol>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="Ingredients">
		<xsl:param name="linkPrefix" />

		<div class="SECTION_HEADER" id="Ingredients">Ingredients</div>
		<div style="overflow-x:auto;">
			<xsl:copy-of select="@*" />
			<table class="no-overflow" style="margin-left:1.5em; white-space:nowrap; overflow-x:auto;">
				<tr>
					<xsl:variable name="sectionCount" select="count(section)" />
					<xsl:variable name="first" select="true()" />
					<xsl:for-each select="section">
						<td style="vertical-align:top;">
							<div>
								<xsl:if test="@title = 'ToDo'">
									<xsl:attribute name="class">TODO</xsl:attribute>
								</xsl:if>
								<xsl:if test="position() > 1">
									<xsl:attribute name="style">border-left:1px solid black;padding-left:.5em;</xsl:attribute>
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
										<xsl:with-param name="sectionCount" select="@sectionCount" />
										<xsl:with-param name="linkPrefix" select="$linkPrefix" />
									</xsl:apply-templates>
								</table>
							</div>
						</td>
					</xsl:for-each>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="ingredient">
		<xsl:param name="sectionCount" />
		<xsl:param name="linkPrefix" />

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
		<xsl:param name="linkPrefix" />

		<div style="margin-top:.5em;">
			<xsl:copy-of select="@*" />
			<xsl:choose>
				<xsl:when test="@pageBreak">
					<span class="no-screen">
						<i>(Continued on next page)</i>
					</span>
					<div style="break-after:page;" />
				</xsl:when>
				<xsl:otherwise>
					<!-- <span style="font-size:.25em;"> </span>
				<br /> -->
				</xsl:otherwise>
			</xsl:choose>
			<div class="SECTION_HEADER" id="Instructions">Instructions</div>
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
					<xsl:if test="description">
						<div style="margin-left:1em;">
							<xsl:apply-templates select="description">
								<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							</xsl:apply-templates>
						</div>
					</xsl:if>
					<ol style="margin-top:0; margin-bottom:0;">
						<xsl:apply-templates select="instruction">
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
						</xsl:apply-templates>
					</ol>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="Notes">
		<xsl:param name="linkPrefix" />

		<xsl:if test="note">
			<div style="margin-top:.5em;">
				<xsl:choose>
					<xsl:when test="@pageBreak">
						<span class="no-screen">
							<i>(Continued on next page)</i>
						</span>
						<div style="break-after:page;" />
					</xsl:when>
					<xsl:otherwise>
						<!-- <span style="font-size:.25em;"> </span>
					<br /> -->
					</xsl:otherwise>
				</xsl:choose>
				<div class="SECTION_HEADER" id="Notes">Notes</div>
				<ul style="margin-top:0;">
					<xsl:copy-of select="@*" />
					<xsl:apply-templates select="note">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="AdditionalNotes">
		<xsl:param name="linkPrefix" />

		<xsl:if test="note">
			<div style="margin-top:.5em;">
				<xsl:choose>
					<xsl:when test="@pageBreak">
						<span class="no-screen">
							<i>(Continued on next page)</i>
						</span>
						<div style="break-after:page;" />
					</xsl:when>
					<xsl:otherwise>
						<!-- <span style="font-size:.25em;"> </span>
					<br /> -->
					</xsl:otherwise>
				</xsl:choose>
				<div class="SECTION_HEADER" id="AdditionalNotes">Additional Notes</div>
				<ul style="margin-top:0;">
					<xsl:apply-templates select="note">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Modifications">
		<xsl:param name="linkPrefix" />

		<xsl:if test="modification">
			<div style="margin-top:.5em;">
				<!-- <xsl:copy-of select="@*" /> -->
				<xsl:choose>
					<xsl:when test="@pageBreak">
						<span class="no-screen">
							<i>(Continued on next page)</i>
						</span>
						<div style="break-after:page;" />
					</xsl:when>
					<xsl:otherwise>
						<!-- <span style="font-size:.25em;"> </span>
						<br /> -->
					</xsl:otherwise>
				</xsl:choose>
				<div class="SECTION_HEADER" id="Modifications" style="">Modifications</div>
				<ul style="margin-top:0;">
					<xsl:apply-templates select="modification">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="FinalNote">
		<xsl:param name="linkPrefix" />

		<div class="NOTE" id="FinalNote" style="margin-top:.5em;">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates>
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="instruction|note|modification">
		<xsl:param name="linkPrefix" />

		<li>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates>
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>
		</li>
	</xsl:template>

</xsl:stylesheet>
