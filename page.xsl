<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="common.xsl" />

	<xsl:template match="Page">
		<!-- section.xml can never carry its own <!DOCTYPE (it's also loaded standalone via document() from
			OTHER pages' CollapseSection listings, and per the XML spec an external general entity's
			replacement text can't contain a doctypedecl); so, uniformly, this page's own Section is fetched
			via document() too, rather than via the &section; entity this file used to declare. That lets
			section.xml keep its own <!DOCTYPE with entities.dtd, so named entities like &eacute; work there
			like anywhere else. -->
		<xsl:variable name="section" select="document('section.xml', .)/Section" />
		<xsl:variable name="depth">
			<xsl:choose>
				<xsl:when test="$section/@folder = '.'">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string-length($section/@folder) - string-length(translate($section/@folder, '/', '')) + 1" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- No Page-type file currently supplies a ParentSection, even 2 levels deep; this preserves that
			existing behavior. Only fetched when needed, same reasoning as recipe.xsl/index.xsl. -->
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

		<html>
			<head>
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				<link rel="stylesheet" type="text/css" href="styles.css" />
				<xsl:apply-templates select="html/head/*">
					<xsl:with-param name="linkPrefix" select="$linkPrefix" />
				</xsl:apply-templates>
			</head>

			<body>
				<div class="FLEX_CONTENT">
					<xsl:apply-templates select="html/body/*">
						<xsl:with-param name="linkPrefix" select="$linkPrefix" />
					</xsl:apply-templates>
				</div>

				<footer class="FLEX_FOOTER">
					<table class="DIVIDER">
						<tr>
							<td class="no-print">
								<a href="/">Home</a> / <xsl:choose>
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
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
