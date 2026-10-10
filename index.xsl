<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="common.xsl" />

	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@                        Main Template                       @@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<xsl:template match="Index">
		<!-- Section/Summary/Pages were merged into one file 2026-10-09 (see FormattingNotes.md), so a
			category's summary and page list now come from $section/Summary and $section/Pages directly,
			rather than their own separate document() fetches. -->
		<xsl:variable name="section" select="document('section.xml', .)/Section" />
		<xsl:variable name="depth">
			<xsl:choose>
				<xsl:when test="$section/@folder = '.'">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string-length($section/@folder) - string-length(translate($section/@folder, '/', '')) + 1" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="parentSectionName">
			<xsl:if test="$depth > 1">
				<xsl:value-of select="normalize-space(document('../section.xml', .)/Section/Name)" />
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="linkPrefix">
			<xsl:call-template name="LinkPrefix">
				<xsl:with-param name="depth" select="$depth" />
			</xsl:call-template>
		</xsl:variable>

		<html lang="en">
			<head>
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				<link rel="stylesheet" type="text/css" href="{$linkPrefix}/styles.css" />
				<title>
					<xsl:if test="$depth > 1"><xsl:value-of select="$parentSectionName" /> / </xsl:if>
					<xsl:value-of select="normalize-space($section/Name)" />
					| VanOrman Family Recipes
				</title>
			</head>

			<body>
				<xsl:apply-templates select="$section">
					<xsl:with-param name="linkPrefix" select="''" />
				</xsl:apply-templates>

				<xsl:apply-templates select="$section/Summary" />

				<hr />
				<xsl:apply-templates select="$section/Pages">
					<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					<xsl:with-param name="folder" select="$section/@folder" />
				</xsl:apply-templates>

				<footer class="FLEX_FOOTER">
					<table class="DIVIDER">
						<tr>
							<td class="no-print">
								<a href="/">Home</a> / <xsl:choose>
									<!-- At the Recipes root itself, "current section" IS the recipes root; so unlike
										the other two cases, there's no separate ancestor level to link to. Show one
										"Recipes" crumb (self-linked, matching how the last crumb in the other cases
										also links to its own page) instead of an extra, redundant $section crumb. -->
									<xsl:when test="$depth = 0">
										<a href=".">Recipes</a>
									</xsl:when>
									<xsl:when test="$depth > 1">
										<a href="../..">Recipes</a> / <a href="..">
											<xsl:value-of select="$parentSectionName" />
										</a> / <a href=".">
											<xsl:value-of select="normalize-space($section/Name)" />
										</a>
									</xsl:when>
									<xsl:otherwise>
										<a href="..">Recipes</a> / <a href=".">
											<xsl:value-of select="normalize-space($section/Name)" />
										</a>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="LAST_MODIFIED" style="text-align:right;"> Last updated: <xsl:apply-templates select="LastModified" />
							</td>
						</tr>
					</table>
				</footer>

				<!-- This is placed here so it will run after the page is parsed but before it is actually displayed -->
				<script src="/sections.js"></script>
			</body>
		</html>

	</xsl:template>

	<!-- ************************************************************************************************************************ -->
	<!--  Templates for sub-items                                                                                                 -->
	<!-- ************************************************************************************************************************ -->
	<!-- Handles stuff from section.xml files. -->
	<xsl:template match="Section">
		<xsl:param name="linkPrefix" />

		<div>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="$linkPrefix = ''">TITLE</xsl:when>
					<xsl:when test="starts-with($linkPrefix, '../..')">SUBSUBSECTION_HEADER</xsl:when>
					<xsl:when test="starts-with($linkPrefix, '..')">SUBSECTION_HEADER</xsl:when>
					<xsl:otherwise>SECTION_HEADER</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$linkPrefix = ''"><xsl:copy-of select="Name/node()" /></xsl:when>
				<xsl:otherwise>
					<a class="no-print">
						<xsl:attribute name="href">
							<xsl:value-of select="concat($linkPrefix, '/',  @folder, '/index.xml')" />
						</xsl:attribute>
						<xsl:copy-of select="Name/node()" />
					</a>
					<span class="no-screen">
						<xsl:copy-of select="Name/node()" />
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<!-- Handles a section's page list: a folder's section.xml <Pages> child, since the 2026-10-09 merge
		(see FormattingNotes.md); previously that folder's own standalone pages.xml. -->
	<xsl:template match="Pages">
		<xsl:param name="linkPrefix" />
		<xsl:param name="folder" />

		<xsl:apply-templates select="*">
			<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			<xsl:with-param name="folder" select="$folder" />
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="CollapseSection">
		<xsl:param name="linkPrefix" />

		<details class="DESCRIPTION" open="true">
			<xsl:attribute name="section">
				<xsl:choose>
					<xsl:when test="@title">
						<xsl:value-of select="@title" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@folder" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<summary>
				<xsl:choose>
					<xsl:when test="inline">
						<div class="SUBSECTION_HEADER">
							<xsl:apply-templates select="@title">
								<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							</xsl:apply-templates>
						</div>

						<div class="SUBSECTION_DESCRIPTION">
							<xsl:apply-templates select="inline/description">
								<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							</xsl:apply-templates>
						</div>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="document(concat(@folder, '/section.xml'))/Section">
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
						</xsl:apply-templates>

						<div class="SUBSECTION_DESCRIPTION">
							<xsl:apply-templates select="document(concat(@folder, '/section.xml'))/Section/Summary">
								<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							</xsl:apply-templates>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</summary>

			<ul>
				<xsl:choose>
					<xsl:when test="inline">
						<xsl:apply-templates select="inline/*[name() != 'description']">
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							<xsl:with-param name="folder" select="'.'" />
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="document(concat(@folder, '/section.xml'))/Section/Pages">
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
							<xsl:with-param name="folder" select="@folder" />
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</ul>
		</details>
		<br />
	</xsl:template>

	<xsl:template match="page">
		<xsl:param name="linkPrefix" />
		<xsl:param name="folder" />

		<xsl:variable name="displayContent">
			<xsl:copy>
				<xsl:copy-of select="@*" />
				<xsl:copy-of select="node()[not(self::Simple or self::Note)]" />
				<xsl:if test="Simple">
					<span class="SMALL_NOTE">(<xsl:call-template name="RenderTrimmedContent"><xsl:with-param name="node" select="Simple" /><xsl:with-param name="linkPrefix" select="$linkPrefix" /></xsl:call-template>)</span>
				</xsl:if>
			</xsl:copy>
		</xsl:variable>

		<li>
			<xsl:choose>
				<xsl:when test="contains(concat(' ', @class, ' '), ' qzxDisabled ')">
					<span><xsl:copy-of select="$displayContent" /></span>
				</xsl:when>
				<xsl:otherwise>
					<a href="{concat($linkPrefix, '/',$folder, '/', @href)}"><xsl:copy-of select="$displayContent" /></a>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="Note">
				<br />
				&#xA0;&#xA0;&#xA0;&#xA0;<span class="SMALL_NOTE">(<xsl:call-template name="RenderTrimmedContent"><xsl:with-param name="node" select="Note" /><xsl:with-param name="linkPrefix" select="$linkPrefix" /></xsl:call-template>)</span>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match="inline">
		<xsl:param name="linkPrefix" />

		<xsl:apply-templates select="*">
			<xsl:with-param name="linkPrefix" select="$linkPrefix" />
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
