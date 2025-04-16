<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common">

	<xsl:include href="common.xsl" />

	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@                        Main Template                       @@@@@@@@@@@@@@@@@@@@ -->
	<!-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	<xsl:template match="Index">
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
				<title>
					<xsl:if test="Section != 'VanOrman Family Recipes'">
						VanOrman Family Recipes:
					</xsl:if>
					<!-- TODO QZX: Handle multiple levels of Sections in the title. E.G.: Entrees/StoveTop -->
					<xsl:value-of select="Section" />
				</title>
			</head>

			<body>
				<xsl:apply-templates select="Section" />
				<xsl:apply-templates select="Summary" />

				<hr />
				<xsl:apply-templates select="Pages">
					<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					<xsl:with-param name="folder" select="Section/section/@folder" />
				</xsl:apply-templates>

				<div class="FOOTER">
					<hr />
					<table class="DIVIDER">
						<tr>
							<td class="no-print">
								<a href="/">Home</a>
								<xsl:choose>
									<xsl:when test="ParentSection">
										<b> / </b>
										<a href="../..">Recipes</a>
										<b> / </b>
										<a href="..">
											<xsl:copy-of select="ParentSection/section/text()|ParentSection/section/*" />
										</a>
									</xsl:when>
									<xsl:otherwise>
										<b> / </b>
										<a href="..">Recipes</a>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td class="LAST_MODIFIED" style="text-align:right;"> Last updated: <xsl:apply-templates select="LastModified" />
							</td>
						</tr>
					</table>
				</div>

				<!-- This is placed here so it will run after the page is parsed but before it is actually displayed -->
				<script src="/sections.js"></script>
			</body>
		</html>

	</xsl:template>

	<xsl:template name="LinkPrefix">
		<xsl:param name="depth" />

		<xsl:choose>
			<xsl:when test="$depth > 1">
				<xsl:value-of select="'../'" />
				<xsl:call-template name="LinkPrefix">
					<xsl:with-param name="depth" select="$depth - 1" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'.'" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ************************************************************************************************************************ -->
	<!--  Templates for sub-items                                                                                                 -->
	<!-- ************************************************************************************************************************ -->
	<xsl:template match="Section">
		<div class="TITLE">
			<xsl:copy-of select="*" />
		</div>
	</xsl:template>

	<!-- Handles stuff from section.xml files. -->
	<xsl:template match="section">
		<xsl:param name="linkPrefix" />

		<div>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="starts-with($linkPrefix, '../..')">SUBSUBSECTION_HEADER</xsl:when>
					<xsl:when test="starts-with($linkPrefix, '..')">SUBSECTION_HEADER</xsl:when>
					<xsl:otherwise>SECTION_HEADER</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<a class="no-print">
				<xsl:attribute name="href">
					<xsl:value-of select="concat($linkPrefix, '/',  @folder, '/index.xml')" />
				</xsl:attribute>
				<xsl:copy-of select="." />
			</a>
			<span class="no-screen">
				<xsl:copy-of select="." />
			</span>
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
				<xsl:value-of select="@folder" />
			</xsl:attribute>

			<summary>
				<xsl:apply-templates select="document(concat(@folder, '/section.xml'))">
					<xsl:with-param name="linkPrefix" select="$linkPrefix" />
				</xsl:apply-templates>

				<div class="SUBSECTION_DESCRIPTION">
					<xsl:apply-templates select="document(concat(@folder, '/summary.xml'))">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>
				</div>
			</summary>

			<ul>
				<xsl:apply-templates select="document(concat(@folder, '/pages.xml'))">
					<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					<xsl:with-param name="folder" select="@folder" />
				</xsl:apply-templates>
			</ul>
		</details>
		<br />
	</xsl:template>

	<xsl:template match="page">
		<xsl:param name="linkPrefix" />
		<xsl:param name="folder" />
		<li>
			<xsl:variable name="a">
				<a>
					<xsl:copy-of select="@class" />
					<xsl:attribute name="href">
						<xsl:value-of select="concat($linkPrefix, '/', $folder, '/', @href)" />
					</xsl:attribute>

					<xsl:value-of select="@title" />
				</a>
			</xsl:variable>
			<xsl:apply-templates select="exsl:node-set($a)">
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>
		</li>
	</xsl:template>

	<xsl:template match="inline">
		<xsl:param name="linkPrefix" />

		<xsl:apply-templates select="*">
			<xsl:with-param name="linkPrefix" select="$linkPrefix" />
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
