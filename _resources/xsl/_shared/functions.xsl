<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY amp   "&#38;">
<!ENTITY copy   "&#169;">
<!ENTITY gt   "&#62;">
<!ENTITY hellip "&#8230;">
<!ENTITY laquo  "&#171;">
<!ENTITY lsaquo   "&#8249;">
<!ENTITY lsquo   "&#8216;">
<!ENTITY lt   "&#60;">
<!ENTITY nbsp   "&#160;">
<!ENTITY quot   "&#34;">
<!ENTITY raquo  "&#187;">
<!ENTITY rsaquo   "&#8250;">
<!ENTITY rsquo   "&#8217;">
]>
<!-- 
Implementations Skeletor v3 - 5/10/2014

FUNCTIONS 
Repository of active functions
See GIT for more functions

Variable Dependencies: (see vars xsl)
$server-type

Contributors: cwilson
Last Updated: 1/2016
-->
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">

	<!--
	ou:include-file()
	The following function takes in two parameters
	(directory name and file name) and outputs the 
	proper code to include the file on the page.
	-->
	<xsl:function name="ou:include-file">
		<!-- directory name + file name -->
		<xsl:param name="fullpath" />
		<!-- on publish, it will output the proper SSI code, but on staging we require the omni div tag -->
		<xsl:choose>
			<xsl:when test="$ou:action = 'pub'">
				<xsl:copy-of select="ou:ssi($fullpath)" />
			</xsl:when>
			<xsl:otherwise>
				<!-- <ouc:div label="{$fullpath}" path="{$fullpath}" /> -->
				<xsl:comment> ouc:div label="<xsl:value-of select="$fullpath"/>" path="<xsl:value-of select="$fullpath"/>"</xsl:comment> <xsl:comment> /ouc:div </xsl:comment> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="ou:ssi">
		<xsl:param name="fullpath"/>
		<!--<xsl:comment>#include virtual="<xsl:value-of select="$fullpath" />" </xsl:comment>-->
		<xsl:processing-instruction name="php"> include($_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="$fullpath" />"); ?</xsl:processing-instruction>
	</xsl:function>
		
	<!-- 
	PCF PARAMS
	An extremely useful function for getting page properties without needing to type the full xpath.
	How to use:
	The pcf has a parameter, name="page-type". To get the value and store it in an XSL param : 
	<xsl:param name="page-type" select="ou:pcf-param('page-type')"/> 
	Use wherever you need it
	-->
	<xsl:param name="pcf-params" select="/document/descendant::parameter"/> <!-- save all page properties in a variable -->

	<xsl:function name="ou:pcf-param">
		<xsl:param name="name"/>
		<xsl:variable name="parameter" select="$pcf-params[@name=$name]"/>
		<xsl:choose>
			<xsl:when test="$parameter/@type = 'select' or $parameter/@type = 'radio'">
				<xsl:value-of select="$parameter/option[@selected = 'true']/@value"/>
			</xsl:when>
			<xsl:when test="$parameter/@type = 'checkbox'">
				<xsl:copy-of select="$parameter/option[@selected = 'true']/@value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$parameter/text()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
		
	<!-- 
	ASSIGN VARIABLE
	Concisely assign fallback variables to prevent unexpected errors in development and post implementation.
	
	How to use:
	<xsl:param name="galleryType" select="ou:assign-variable('galleryType','PrettyPhoto')"/>	
	<xsl:variable name="navfile" select="ou:assign-variable('page-nav',$ou:navigation,$local-nav)"/>
	
	Third parameter may be a string or variable. The first parameter must always be a string, as required by the pcf-param function.
	
	Second version requires overwrite-directory variable, which is typically defined in vars xsl.
	
	<xsl:variable name="overwrite-directory" select="ou:assign-variable('overwrite-directory','no')"/> 
	
	
	Note: requires the function ou:pcf-param
	-->
	<xsl:function name="ou:assign-variable"> <!-- test if page property has value, give default value if none -->
		<xsl:param name="var"/>
		<xsl:param name="fallback"/>
		<xsl:variable name="pcf-var" select="ou:pcf-param($var)"/>
		<xsl:choose>	
			<xsl:when test="string-length($pcf-var) > 0"><xsl:value-of select="$pcf-var"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$fallback"/></xsl:otherwise>
		</xsl:choose>	
	</xsl:function>		
	
	<xsl:function name="ou:assign-variable"> <!-- pcf - dir var - fallback precedence, also tests if there is a value for each -->
		<xsl:param name="var"/>
		<xsl:param name="dir-var"/>
		<xsl:param name="fallback"/>
		<xsl:variable name="overwrite-directory" select="ou:pcf-param('overwrite-directory')"/>
		<xsl:variable name="pcf-var" select="ou:pcf-param($var)"/>
		<xsl:choose>	
			<xsl:when test="string-length($pcf-var) > 0 and $overwrite-directory='yes'"><xsl:value-of select="$pcf-var"/></xsl:when>
			<xsl:when test="string-length($dir-var) > 0 and $dir-var!='[auto]'" ><xsl:value-of select="$dir-var"/></xsl:when> 
			<xsl:otherwise><xsl:value-of select="$fallback"/></xsl:otherwise>
		</xsl:choose>	
	</xsl:function>
		
	<!-- 
	TEST VARIABLE
	A simpler version of Assign Variable, if you are not dealing with page properties.
	-->		
	<xsl:function name="ou:test-variable"> <!-- test if variable has value, give default value if none -->
		<xsl:param name="var"/>
		<xsl:param name="fallback"/>
		<xsl:choose>	
			<xsl:when test="string-length($var) > 0"><xsl:value-of select="$var"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$fallback"/></xsl:otherwise>
		</xsl:choose>	
	</xsl:function>	
		
	<!--
	FIND PREVIOUS DIRECTORY
	Used by breadcrumbs xsl.
	-->
	<xsl:function name="ou:find-prev-dir"> <!-- outputs parent directory path with trailing '/': /path/to/parent/ -->
		<xsl:param name="path" />
		<xsl:variable name="token-path" select="tokenize(substring($path, 2), '/')[if(substring($path,string-length($path)) = '/') then position() != last() else position()]" />
		<xsl:variable name="new-path" select="concat('/', string-join(remove($token-path, count($token-path)), '/') ,'/')"/>
		<xsl:value-of select="if($new-path = '//') then '/' else $new-path" />
	</xsl:function>
	
	<!--
	OUC MULTIEDIT
	Manually create multiedit button so that users can access multiedit, if no multiedit nodes are being copied (ie, value-of is used)
	-->		
	<xsl:function name="ou:multiedit-button"> <!-- call function to activate the multiedit button in edit mode -->
		<xsl:if test="$ou:action='edt'">
			<ouc:div label="multiedit" group="everyone" button="hide"><ouc:multiedit /></ouc:div>
		</xsl:if>
	</xsl:function>

	<!--
	HAS CLASS
	boolean that returns whether an element contains a class, much like JQuery's hasClass function
	-->
	<xsl:function name="ou:has-class">
		<xsl:param name="element"/>
		<xsl:param name="class-name"/>
		<xsl:value-of select="boolean($element/@class) and contains(concat(' ', $element/@class, ' '), concat(' ', $class-name, ' '))"/>
	</xsl:function>	
	
	<!--
	GET CURRENT FOLDER
	-->
	<xsl:function name="ou:current-folder">
		<xsl:param name="string"/>
		<xsl:variable name="chars" select="tokenize(substring-after($string,'/'), '/')"/>
		<xsl:for-each select="$chars">
			<xsl:if test="position()=last()">
				<xsl:variable name="result"><xsl:value-of select="."/></xsl:variable>
				<!-- <xsl:value-of select="ou:capital(replace($result,'-',' '))" /> -->
				<!-- copy the when statement for more cleaning options -->
				<xsl:choose>
					<xsl:when test="contains($result,'_')">
						<xsl:value-of select="ou:clean($result,'_')"/>
					</xsl:when>
					<xsl:when test="contains($result,'-')">
						<xsl:value-of select="ou:clean($result,'-')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ou:capital($result)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<!--
	CAPITALIZE THE FIRST LETTER OF EVERY WORD
	-->
	<xsl:function name="ou:capital">
		<xsl:param name="string"/>
		<xsl:variable name="chars" select="tokenize($string, ' ')"/>
		<xsl:for-each select="$chars">
			<xsl:variable name="key"><xsl:value-of select="."/></xsl:variable>
			<xsl:variable name="first-letter-1"><xsl:value-of select="upper-case(substring($key,1,1))" /></xsl:variable>
			<xsl:variable name="rest-1"><xsl:value-of select="lower-case(substring($key,2))" /></xsl:variable>
			<xsl:variable name="result"><xsl:value-of select="concat($first-letter-1,$rest-1,' ')" /> </xsl:variable>
			<xsl:value-of select="$result" />
		</xsl:for-each>
	</xsl:function>
	
	<!--
	Clean content by replacing content with space
	-->
	<xsl:function name="ou:clean">
		<xsl:param name="string"/>
		<xsl:param name="deliminator"/>
		<xsl:variable name="chars" select="tokenize($string,$deliminator)"/>
		<xsl:for-each select="$chars">
			<xsl:variable name="key"><xsl:value-of select="."/></xsl:variable>
			<xsl:variable name="first-letter-1"><xsl:value-of select="upper-case(substring($key,1,1))" /></xsl:variable>
			<xsl:variable name="rest-1"><xsl:value-of select="lower-case(substring($key,2))" /></xsl:variable>
			<xsl:variable name="result"><xsl:value-of select="concat($first-letter-1,$rest-1,' ')" /> </xsl:variable>
			<xsl:value-of select="$result" />
		</xsl:for-each>
	</xsl:function>
	
	<!--output eg. Thurs, 1 Jan 2015 20:26:39 -08:00-->
	<!--RSS requires "RFC822" formated dateTime, http://www.w3.org/Protocols/rfc822/#z28 -->
	<xsl:function name="ou:to-pub-date" as="xs:string">
		<xsl:param name="dateTime"/>
		<!--eg. xs:dateTime('2015-01-01T20:26:39-08:00')-->
		<xsl:variable name="date" select="ou:to-dateTime($dateTime)"/>
		<xsl:variable name="tZ" select="timezone-from-dateTime($date)"/>
		<xsl:variable name="time">
			<xsl:value-of select="substring-before(substring-after(string($date), 'T'), '-')" />
			<xsl:sequence select="if (string($tZ) = ('PT0S','-PT0S')) then 'Z' else if (matches(string($tZ),'-PT[1-9]H')) then replace(string($tZ),'PT([1-9])H','0$1:00') else if (matches(string($tZ),'PT[1-9]H')) then replace(string($tZ),'PT([1-9])H','+0$1:00') else if (matches(string($tZ),'-PT1[0-4]H')) then replace(string($tZ),'PT(1[0-4])H','$1:00') else if (matches(string($tZ),'PT1[0-4]H')) then replace(string($tZ),'PT(1[0-4])H','+$1:00') else error(xs:QName('ou:Invalid_Duration_Value'))"/>
		</xsl:variable>
		<xsl:value-of select="concat(ou:day-of-week-abbrev-en(substring-before(string($date), 'T')), ', ', day-from-dateTime(xs:dateTime($date)), ' ', ou:month-abbrev-en($date), ' ', year-from-dateTime(xs:dateTime($date)), ' ', $time)"/>
	</xsl:function>
	
	<!--use format-dateTime() with ou:to-dateTime eg: <xsl:value-of select="format-dateTime($dateTime, ', [D01] [M] [Y0001] [H01]:[m01]:[s01] [z]')"/>-->
	<xsl:function name="ou:to-dateTime" as="xs:dateTime">
		<xsl:param name="pcf-date"/>
		<!--define time zone-->
		<xsl:variable name="time-zone" select="'-08:00'"/>
		<!--tokenize date from PCF, which uses datetime param-->
		<xsl:variable name="token-date" select="tokenize($pcf-date, ' ')"/>
		<!--calculate date depending on TCF or PCF dateTime-->
		<xsl:variable name="date">
			<xsl:choose>
				<xsl:when test="matches($pcf-date,'^\S+, \S+ \d{1,2}, \d{4} \d{1,2}:\d{2}:\d{2} [AP]M [A-Z]{3}$')">
					<!--TCF format 'Monday, January 26, 2015 2:13:39 PM PST' to '2015-01-26'-->
					<xsl:value-of select="concat($token-date[4], '-', ou:month-num($token-date[2], 'long'), '-', ou:double-digit(substring-before($token-date[3], ',')))"/>
				</xsl:when>
				<xsl:otherwise>
					<!--PCF format '01/26/2015 08:26:39 PM' to '2015-01-26'-->
					<xsl:value-of select="concat(tokenize($token-date[1], '/')[3], '-', ou:double-digit(tokenize($token-date[1], '/')[1]), '-', ou:double-digit(tokenize($token-date[1], '/')[2]))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="time">
			<xsl:choose>
				<xsl:when test="matches($pcf-date,'^\S+, \S+ \d{1,2}, \d{4} \d{1,2}:\d{2}:\d{2} [AP]M [A-Z]{3}$')">
					<!--convert 'Monday, January 26, 2015 2:13:39 PM PST' to '2015-01-26'-->
					<xsl:value-of select="concat(ou:double-digit(if ($token-date[6] = 'PM' and number(tokenize($token-date[5], ':')[1]) &lt; 12) then number(tokenize($token-date[5], ':')[1]) + 12 else if ($token-date[6] = 'PM' and number(tokenize($token-date[5], ':')[1]) = 12) then '00' else tokenize($token-date[5], ':')[1]), ':', ou:double-digit(tokenize($token-date[5], ':')[2]), ':', ou:double-digit(tokenize($token-date[5], ':')[3]))"/>
				</xsl:when>
				<xsl:otherwise>
					<!--convert '01/26/2015 08:26:39 PM' to '20:26:39'-->
					<xsl:value-of select="concat(ou:double-digit(if ($token-date[3] = 'PM' and number(tokenize($token-date[2], ':')[1]) &lt; 12) then number(tokenize($token-date[2], ':')[1]) + 12 else if ($token-date[3] = 'PM' and number(tokenize($token-date[2], ':')[1]) = 12) then '00' else tokenize($token-date[2], ':')[1]), ':', ou:double-digit(tokenize($token-date[2], ':')[2]), ':', ou:double-digit(tokenize($token-date[2], ':')[3]))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--new object xs:dateTime('2015-01-01T20:26:39-08:00')-->
		<xsl:value-of select="dateTime(xs:date($date), xs:time(concat($time, $time-zone)))" />
	</xsl:function>
	
	<xsl:function name="ou:double-digit">
		<xsl:param name="num"/>
		<xsl:value-of select="format-number(number($num), '00')"/>
	</xsl:function>
	
	<xsl:function name="ou:month-abbrev-en" as="xs:string?">
		<xsl:param name="date" as="xs:anyAtomicType?"/>
		<xsl:sequence select="('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')[month-from-date(xs:date($date))]"/>
	</xsl:function>
	
	<xsl:function name="ou:day-of-week" as="xs:integer?">
		<xsl:param name="date" as="xs:anyAtomicType?"/>
		<xsl:sequence select="if (empty($date)) then () else xs:integer((xs:date($date) - xs:date('1901-01-06')) div xs:dayTimeDuration('P1D')) mod 7"/>
	</xsl:function>
	
	<xsl:function name="ou:day-of-week-abbrev-en" as="xs:string?">
		<xsl:param name="date" as="xs:anyAtomicType?"/>
		<xsl:sequence select="('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat')[ou:day-of-week($date) + 1]"/>
	</xsl:function>
	
	<xsl:function name="ou:month-name">
		<xsl:param name="month-num" />
		<xsl:value-of select="ou:month-name($month-num,'long')" />	
	</xsl:function>
	
	<xsl:function name="ou:month-name">
		<xsl:param name="month-num" />
		<xsl:param name="length" />
		<xsl:variable name="months" select="('January','February','March','April','May','June','July','August','September','October','November','December')" />
		<xsl:variable name="months-short" select="('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')" />
		<xsl:value-of select="if($length = 'short') then $months-short[number($month-num)] else $months[number($month-num)]" />
	</xsl:function>
	
	<xsl:function name="ou:month-num">
		<xsl:param name="month-name" />
		<xsl:value-of select="ou:month-num($month-name,'long')" />	
	</xsl:function>
	
	<xsl:function name="ou:month-num">
		<xsl:param name="month-name" />
		<xsl:param name="length" />
		<xsl:variable name="months" select="('January','February','March','April','May','June','July','August','September','October','November','December')" />
		<xsl:variable name="months-short" select="('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')" />
		<xsl:value-of select="ou:double-digit(if ($length = 'short') then index-of($months-short,$month-name) else index-of($months,$month-name))" />
	</xsl:function>
	
	<xsl:function name="ou:display-long-date">
		<xsl:param name="str" />
		<xsl:variable name="dateTime" select="ou:to-dateTime($str)"/>
		<xsl:variable name="day" select="format-dateTime($dateTime, '[D1]')"/>
		<xsl:variable name="month" select="format-dateTime($dateTime, '[M1]')"/>
		<xsl:variable name="year" select="format-dateTime($dateTime, '[Y0001]')"/>
		<xsl:try>
			<xsl:value-of select="concat(ou:month-name($month),' ',$day,', ',$year)" />
			<xsl:catch />
		</xsl:try>
	</xsl:function>
	
	<!--
		OU GET TEXTUAL CONTENT
		Use when checking for any content (prep for an "if empty" check)
		Gets string representation of any node and its subnodes, replaces &nbsp; with space, and trims all whitespace
	-->
	<xsl:function name="ou:textual-content">
		<xsl:param name="element"/>
		<xsl:value-of select="normalize-space(replace(string($element), '&nbsp;', ' '))" />
	</xsl:function>

</xsl:stylesheet>
