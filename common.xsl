<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
				<xsl:with-param name="string" select="$string" />
				<xsl:with-param name="oldValue" select="'Teaspoon'" />
				<xsl:with-param name="newValue" select="'teaspoon'" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="step2"> <!-- tablespoon - Tablespoon -->
			<xsl:call-template name="replace_all">
				<xsl:with-param name="string" select="$step1" />
				<xsl:with-param name="oldValue" select="'tablespoon'" />
				<xsl:with-param name="newValue" select="'Tablespoon'" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:copy-of select="$step2" />
	</xsl:template>
	<xsl:template name="section-link">
		<xsl:param name="section" />

		<a class="no-print">
			<xsl:attribute name="href">#<xsl:value-of select="translate($section, ' ', '')" /></xsl:attribute>
			<xsl:value-of select="$section" />
		</a>
		<span class="no-screen">
			<xsl:value-of select="$section" />
		</span>
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

	<xsl:template match="a">
		<xsl:param name="linkPrefix" />

		<a>
			<xsl:attribute name="class">
				<xsl:value-of select="concat('no-print ', @class)" />
			</xsl:attribute>
			<xsl:copy-of select="@*[name() != 'href' and name() != 'class']" />
			<xsl:attribute name="href">
				<xsl:call-template name="replace_all">
					<xsl:with-param name="string" select="@href" />
					<xsl:with-param name="oldValue" select="'.../'" />
					<xsl:with-param name="newValue" select="concat($linkPrefix, '/')" />
				</xsl:call-template>
			</xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>
		</a>
		<span class="no-screen">
			<xsl:value-of select="text()" />
		</span>
	</xsl:template>

	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		In order to let "<xsl:apply-templates />" work, it is necessary to use this to copy standard HTML nodes and address their contents.
		As new HTML elements are used in the Recipes, make sure to add them to this template.
		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template match="details|summary|
		head|title|link|body|
		blockquote|div|p|span|
		br|hr|
		img|
		table|td|th|tr|
		ul|ol|li|
		b|i|u">
		<xsl:param name="linkPrefix" />

		<xsl:element name="{name()}">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates>
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>
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

	<xsl:template match="Summary">
		<xsl:param name="linkPrefix" />

		<div class="DESCRIPTION" style="padding-top:.5em;">
			<xsl:apply-templates>
				<xsl:with-param name="linkPrefix" select="$linkPrefix" />
			</xsl:apply-templates>
		</div>
	</xsl:template>
</xsl:stylesheet>
