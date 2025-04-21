<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="common.xsl" />

	<xsl:template match="HTML">
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

		<html>
			<xsl:apply-templates select="html/head">
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>

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

</xsl:stylesheet>
