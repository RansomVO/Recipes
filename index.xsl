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
					<xsl:if test="ParentSection">
						<xsl:value-of select="ParentSection" /> /</xsl:if>
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

				<!-- This is placed here so it will run after the page is parsed but before it is actually displayed -->
				<script src="/sections.js"></script>
			</body>
		</html>

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
							<!-- TODO QZX: Figure out why the externalEntities.dtd causes this to fail. -->
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
							<!-- TODO QZX: Figure out why the externalEntities.dtd causes this to fail. -->
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
		<li>
			<xsl:variable name="a">
				<a>
					<xsl:copy-of select="@*[name() != 'href']" />
					<xsl:attribute name="href">
						<xsl:value-of select="concat($linkPrefix, '/',$folder, '/', @href)" />
					</xsl:attribute>

					<xsl:value-of select="@title" />
				</a>
			</xsl:variable>
			<xsl:apply-templates select="exsl:node-set($a)">
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>
			<xsl:if test="./*">
				<div style="margin-left:2em;">
					<xsl:apply-templates>
						<xsl:copy-of select="./*" />
					</xsl:apply-templates>
				</div>
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
