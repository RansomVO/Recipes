<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="common.xsl" />

	<!-- QZX TODO: Make it so ingredients that are in Modifications are show in the Ingredients section, but marked as optional -->
	<!-- QZX TODO: -->

	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@                        Main Template                       @@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<xsl:template match="Recipe">
		<xsl:variable name="depth">
			<xsl:choose>
				<xsl:when test="document('../section.xml', .)/Section/@folder = '.'">1</xsl:when>
				<xsl:when test="document('../../section.xml', .)/Section/@folder = '.'">2</xsl:when>
				<xsl:when test="document('../../../section.xml', .)/Section/@folder = '.'">3</xsl:when>
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
				<title>
					VanOrman Family Recipes -
					<xsl:if test="ParentSection"><xsl:value-of select="ParentSection" /> / </xsl:if>
					<xsl:value-of select="normalize-space(Section)" />: <xsl:value-of select="Title" />
				</title>
			</head>

			<body>
				<div class="FLEX_CONTENT">
					<div style="margin-bottom: .25em;">
						<xsl:apply-templates select="Title" />
					</div>

					<table class="DIVIDER">
						<tr>
							<xsl:apply-templates select="Source">
								<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							</xsl:apply-templates>

							<xsl:if test="Requires">
							</xsl:if>

							<xsl:apply-templates select="Yields">
								<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							</xsl:apply-templates>
						</tr>
						<tr>
							<td class="DESCRIPTION" style="padding-top:.5em;">
								<xsl:attribute name="colspan">
									<xsl:choose>
										<xsl:when test="Requires">3</xsl:when>
										<xsl:otherwise>2</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:apply-templates select="Description">
									<xsl:with-param name="linkPrefix" select="$linkPrefix" />
								</xsl:apply-templates>
							</td>
						</tr>
					</table>

					<xsl:apply-templates select="Ingredients">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>

					<xsl:apply-templates select="Preparation">
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
								<xsl:call-template name="RecipeLink">
									<xsl:with-param name="href" select="'/'" />
									<xsl:with-param name="text" select="'Home'" />
									<xsl:with-param name="linkPrefix" select="$linkPrefix" />
								</xsl:call-template> / <xsl:call-template name="RecipeLink">
									<xsl:with-param name="href" select="'.../'" />
									<xsl:with-param name="text" select="'Recipes'" />
									<xsl:with-param name="linkPrefix" select="$linkPrefix" />
								</xsl:call-template> / <xsl:if test="ParentSection">
									<xsl:call-template name="RecipeLink">
										<xsl:with-param name="href" select="'..'" />
										<xsl:with-param name="text" select="ParentSection" />
										<xsl:with-param name="linkPrefix" select="$linkPrefix" />
									</xsl:call-template> / </xsl:if><xsl:call-template name="RecipeLink">
									<xsl:with-param name="href" select="'.'" />
									<xsl:with-param name="text" select="Section" />
									<xsl:with-param name="linkPrefix" select="$linkPrefix" />
								</xsl:call-template>
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
						<xsl:attribute name="style">clear:right; padding-left:3em; list-style:<xsl:value-of select="@list-style" />;</xsl:attribute>
						<xsl:apply-templates>
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
						</xsl:apply-templates>
					</ol>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:variable name="maxWidth">24</xsl:variable>
	<xsl:variable name="noteRatio">.4</xsl:variable>
	<xsl:variable name="widthRatio">.66</xsl:variable>

	<xsl:template match="Note">
		<xsl:param name="linkPrefix" />
		<xsl:param name="mode" />

		<span>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$mode = 'TITLE'">TITLE_NOTE</xsl:when>
					<xsl:otherwise>SMALL_NOTE</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="style">
				display: inline-block;
			</xsl:attribute>

			<xsl:choose>
				<xsl:when test="$mode = 'TITLE'">&#xA0;&#xA0;&#xA0;&#xA0;</xsl:when>
				<xsl:otherwise>&#xA0;&#xA0;</xsl:otherwise>
			</xsl:choose>

			<!-- -->(<xsl:apply-templates select="./text()|*">
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>)<!-- -->

			<!-- -->&#xA0;&#xA0;&#xA0;&#xA0;<!-- -->
		</span>
	</xsl:template>
	<xsl:template match="Description">
		<xsl:param name="linkPrefix" />

		<xsl:apply-templates>
			<xsl:with-param name="linkPrefix" select="$linkPrefix" />
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Title">
		<xsl:param name="linkPrefix" />

		<span class="TITLE">
			<xsl:apply-templates select="./text()|*">
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
				<xsl:with-param name="mode" select="'TITLE'" />
			</xsl:apply-templates>
		</span>


	</xsl:template>
	<xsl:template match="Source">
		<xsl:param name="linkPrefix" />

		<td class="RECIPE_SOURCE">
			<xsl:apply-templates select="./text()|*">
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
				<xsl:with-param name="mode" select="'SOURCE'" />
			</xsl:apply-templates>
		</td>
	</xsl:template>
	<xsl:template match="Requires">
		<xsl:param name="linkPrefix" />

		<td class="RECIPE_REQUIRES">
			<xsl:attribute name="class">
				<xsl:value-of select="concat('RECIPE_REQUIRES ', Requires/@class)" />
			</xsl:attribute>
			<b>Requires</b>: <!-- -->
			<xsl:apply-templates select="./text()|*">
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
				<xsl:with-param name="mode" select="'REQUIRES'" />
			</xsl:apply-templates>
		</td>
	</xsl:template>
	<xsl:template match="Yields">
		<xsl:param name="linkPrefix" />
		<td class="RECIPE_YIELDS">
			<b>Yields</b>: <span>
				<xsl:choose>
					<!-- QZX TODO: Figure out how to <xsl:apply-templates ...> to the links below so that it doesn't look like a link when printing. -->
					<xsl:when test="text() = 'See Ingredients'">
						<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link"><xsl:with-param name="section" select="'Ingredients'" /></xsl:call-template> below)
					</xsl:when>
					<xsl:when test="text() = 'See Preparation'">
						<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link"> <xsl:with-param name="section" select="'Preparation'" /> </xsl:call-template> below)
					</xsl:when>
					<xsl:when test="text() = 'See Instructions'">
						<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link"><xsl:with-param name="section" select="'Instructions'" /></xsl:call-template> below)
					</xsl:when>
					<xsl:when test="text() = 'See Notes'">
						<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link"><xsl:with-param name="section" select="'Notes'" /></xsl:call-template> below)
					</xsl:when>
					<xsl:when test="text() = 'See Modifications'">
						<xsl:attribute name="class">NOTE</xsl:attribute>(See <xsl:call-template name="section-link"><xsl:with-param name="section" select="'Modifications'" /></xsl:call-template> below)
					</xsl:when>
					<xsl:when test="text() = 'See Additional Notes'">
						<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link"><xsl:with-param name="section" select="'Additional Notes'" /></xsl:call-template> below)
					</xsl:when>
					<xsl:when test="text() = 'See Final Note'">
						<xsl:attribute name="class">NOTE</xsl:attribute> (See <xsl:call-template name="section-link"><xsl:with-param name="section" select="'Final Note'" /></xsl:call-template> below)
					</xsl:when>

					<xsl:when test="text() = 'ToDo'"><xsl:attribute name="class">TODO</xsl:attribute><xsl:value-of select="Yields" /></xsl:when>
					<xsl:when test="text() = '???'"><xsl:attribute name="class">TODO</xsl:attribute><xsl:apply-templates select="Yields"><xsl:with-param name="linkPrefix" select="$linkPrefix" /></xsl:apply-templates></xsl:when>
					<xsl:when test="starts-with(text(), '(')">
						<xsl:attribute name="class">NOTE</xsl:attribute> <xsl:apply-templates select="Yields"><xsl:with-param name="linkPrefix" select="$linkPrefix" /></xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="./text()|*">
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							<xsl:with-param name="mode" select="'YIELDS'" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</td>
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
										<xsl:with-param name="sectionCount" select="$sectionCount" />
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

		<xsl:variable name="maxIngredientLength">
			<xsl:for-each select="../ingredient">
				<xsl:sort select="(string-length(node()[not(self::note or self::finePrint or self::amount)]) + ((string-length(note) + 2) * $noteRatio)) * $widthRatio" data-type="number" />
				<xsl:if test="position()=last()">
					<xsl:value-of select="string-length(node()[not(self::note or self::finePrint or self::amount)]) + ((string-length(note) + 2) * $noteRatio)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="ingredientWidth">
			<xsl:choose>
				<xsl:when test="$maxWidth > $maxIngredientLength">
					<xsl:value-of select="$maxIngredientLength" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$maxWidth" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="maxAmountLength">
			<xsl:for-each select="../ingredient">
				<xsl:sort select="(string-length(amount/node()[not(self::note or self::finePrint)]) + ((string-length(amount/note) + 2) * $noteRatio)) * $widthRatio" data-type="number" />
				<xsl:if test="position()=last()">
					<xsl:value-of select="string-length(amount/node()[not(self::note or self::finePrint)]) + ((string-length(amount/note) + 2) * $noteRatio)" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="amountWidth">
			<xsl:choose>
				<xsl:when test="$maxWidth > $maxAmountLength">
					<xsl:value-of select="$maxAmountLength" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$maxWidth" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<tr>
			<td class="RECIPE_INGREDIENT">
				<xsl:if test="note = 'Optional'">
					<i style="font-weight:normal;">(Optional)&#xA0;</i>
				</xsl:if>
				<xsl:apply-templates select="node()[not(self::note or self::finePrint or self::amount)]">
					<xsl:with-param name="linkPrefix" select="$linkPrefix" />
				</xsl:apply-templates>
				<xsl:if test="note and (note != 'Optional')">
					<xsl:choose>
						<xsl:when test="($sectionCount > 1) and (string-length(node()[not(self::note or self::finePrint or self::amount)]) + ((string-length(note) + 2) * $noteRatio) > $maxWidth)">
							<div class="SMALL_NOTE">
								<xsl:attribute name="style">
									<xsl:value-of select="concat('width:', $ingredientWidth * $widthRatio, 'em;', ' margin:0; text-align:right;')" />
								</xsl:attribute> (<xsl:apply-templates select="note/node()">
									<xsl:with-param name="linkPrefix" select="$linkPrefix" />
								</xsl:apply-templates>) </div>
						</xsl:when>

						<xsl:otherwise>
							<span class="SMALL_NOTE">&#xA0;(<xsl:apply-templates select="note/node()">
									<xsl:with-param name="linkPrefix" select="$linkPrefix" />
								</xsl:apply-templates>)</span>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="finePrint">
					<div class="RECIPE_INGREDIENT_FINE_PRINT">
						<xsl:attribute name="style">
							<xsl:value-of select="concat('width:', $ingredientWidth * $widthRatio, 'em;')" />
						</xsl:attribute>
						<xsl:apply-templates select="finePrint">
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
						</xsl:apply-templates>
					</div>
				</xsl:if>
			</td>
			<td class="RECIPE_INGREDIENT_QUANTITY">
				<xsl:apply-templates select="amount/node()[not(self::note or self::finePrint)]">
					<xsl:with-param name="linkPrefix" select="$linkPrefix" />
				</xsl:apply-templates>
				<xsl:if test="amount/note">
					<xsl:choose>
						<xsl:when test="($sectionCount > 1) and (string-length(amount/node()[not(self::note or self::finePrint)]) + ((string-length(amount/note) + 2) * $noteRatio) > $maxWidth)">
							<div class="SMALL_NOTE">
								<xsl:attribute name="style">
									<xsl:value-of select="concat('width:', $amountWidth * $widthRatio, 'em;', ' margin:0; text-align:right;')" />
								</xsl:attribute> (<xsl:apply-templates select="amount/note/node()">
									<xsl:with-param name="linkPrefix" select="$linkPrefix" />
								</xsl:apply-templates>) </div>
						</xsl:when>

						<xsl:otherwise>
							<span class="SMALL_NOTE">&#xA0;(<xsl:apply-templates select="amount/note/node()">
									<xsl:with-param name="linkPrefix" select="$linkPrefix" />
								</xsl:apply-templates>)</span>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>

	<xsl:template name="PrepNote">
		<xsl:param name="width" />
		<xsl:param name="content" />

		<div class="SMALL_NOTE">
			<xsl:attribute name="style">
				<xsl:value-of select="concat('width:', $width * $widthRatio, 'em; ', 'margin-left:2em; font-weight:normal; text-wrap:wrap;')" />
			</xsl:attribute>

			<xsl:apply-templates select="$content" />
		</div>
	</xsl:template>
	<xsl:template match="Preparation">
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
					<!-- <span style="font-size:.25em;"></span><br /> -->
				</xsl:otherwise>
			</xsl:choose>
			<div class="SECTION_HEADER" id="Preparation">Preparation</div>
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
						<xsl:apply-templates select="prep">
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
						</xsl:apply-templates>
					</ol>
				</div>
			</xsl:for-each>
		</div>
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
					<!-- <span style="font-size:.25em;"> </span><br /> -->
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
						<!-- <span style="font-size:.25em;"> </span><br /> -->
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
						<!-- <span style="font-size:.25em;"> </span><br /> -->
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
						<!-- <span style="font-size:.25em;"> </span><br /> -->
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

	<xsl:template match="prep|instruction|note|modification">
		<xsl:param name="linkPrefix" />

		<li>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates>
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>
		</li>
	</xsl:template>

</xsl:stylesheet>
