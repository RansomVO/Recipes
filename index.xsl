<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common">

	<xsl:include href="common.xsl" />

	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@                        Main Template                       @@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<xsl:template match="Index">
		<!-- section.xml/summary.xml/pages.xml can never carry their own <!DOCTYPE (they're also loaded
			standalone via document() below, from CollapseSection, when a DIFFERENT page needs them; and per
			the XML spec an external general entity's replacement text can't contain a doctypedecl); so,
			uniformly, this folder's own Section/Summary/Pages/ParentSection are fetched via document() too,
			rather than via the &section;/&summary;/&pages;/&parentSection; entities this file used to
			declare. That lets section.xml etc. keep their own <!DOCTYPE with entities.dtd, so named entities
			like &eacute; work there like anywhere else. -->
		<xsl:variable name="section" select="document('section.xml', .)/Section" />
		<xsl:variable name="summary" select="document('summary.xml', .)/Summary" />
		<xsl:variable name="pages" select="document('pages.xml', .)/Pages" />
		<xsl:variable name="depth">
			<xsl:choose>
				<xsl:when test="$section/@folder = '.'">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string-length($section/@folder) - string-length(translate($section/@folder, '/', '')) + 1" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Only fetched when needed: at depth <= 1, "../section.xml" is either the site root's own
			section.xml (Recipes/section.xml, not a meaningful "parent") or, at depth 0, outside Recipes/
			entirely and likely missing; so the document() call itself is gated, not just its display. -->
		<xsl:variable name="parentSectionName">
			<xsl:if test="$depth > 1">
				<xsl:value-of select="document('../section.xml', .)/Section" />
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
				<link rel="stylesheet" type="text/css" href="styles.css" />
				<title>
					<xsl:if test="$section != 'VanOrman Family Recipes'">
						VanOrman Family Recipes:
					</xsl:if>
					<!-- QZX TODO: Handle multiple levels of Sections in the title. E.G.: Entrees/StoveTop -->
					<xsl:if test="$depth > 1"><xsl:value-of select="$parentSectionName" /> /</xsl:if>
					<xsl:value-of select="$section" />
				</title>
			</head>

			<body>
				<xsl:apply-templates select="$section">
					<xsl:with-param name="linkPrefix" select="''" />
				</xsl:apply-templates>

				<xsl:apply-templates select="$summary" />

				<hr />
				<xsl:apply-templates select="$pages">
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
											<xsl:value-of select="$section" />
										</a>
									</xsl:when>
									<xsl:otherwise>
										<a href="..">Recipes</a> / <a href=".">
											<xsl:value-of select="$section" />
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
				<xsl:when test="$linkPrefix = ''"><xsl:copy-of select="." /></xsl:when>
				<xsl:otherwise>
					<a class="no-print">
						<xsl:attribute name="href">
							<xsl:value-of select="concat($linkPrefix, '/',  @folder, '/index.xml')" />
						</xsl:attribute>
						<xsl:copy-of select="." />
					</a>
					<span class="no-screen">
						<xsl:copy-of select="." />
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<!-- Handles stuff from pages.xml files. -->
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
						<xsl:apply-templates select="document(concat(@folder, '/section.xml'))">
							<xsl:with-param name="linkPrefix" select="$linkPrefix" />
						</xsl:apply-templates>

						<div class="SUBSECTION_DESCRIPTION">
							<!-- document() parses summary.xml standalone, with no DOCTYPE (it can't have one;
								see FilenameDocumentTypes in RecipeFixer/XmlFixer.cs), so entities.dtd's named
								entities (e.g. &eacute;, &smiley;) are undefined here and fail the parse,
								silently emptying this apply-templates. Use numeric character references
								(&#xE9;, &#x1F600;) in section.xml/summary.xml/pages.xml instead. -->
							<xsl:apply-templates select="document(concat(@folder, '/summary.xml'))">
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
						<xsl:apply-templates select="document(concat(@folder, '/pages.xml'))">
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
		<li><a href="{concat($linkPrefix, '/',$folder, '/', @href)}"><xsl:copy-of select="." /></a></li>
	</xsl:template>

	<xsl:template match="inline">
		<xsl:param name="linkPrefix" />

		<xsl:apply-templates select="*">
			<xsl:with-param name="linkPrefix" select="$linkPrefix" />
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
