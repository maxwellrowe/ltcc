<?php /* Referenced only by xsl/_shared/header-nav-215303.xsl, an older navigation template whose PCF is archived. */ ?>
<ouc:editor wysiwyg="no"/>
<!--
	<input type="text" placeholder="Search Site" /> MT
-->
<!--
	Old search console script, updated 7/30/24 MT

<script type="text/javascript">  
	(function(){
		var a="000195051684040632380:csrjr1rjpds";
		var c=document.createElement("script");
		c.type="text/javascript";
		c.async=true;
		c.src=(document.location.protocol=="https:"?"https:":"http:")+"//www.google.com/cse/cse.js?cx="+a;
		var b=document.getElementsByTagName("script")[0];
		b.parentNode.insertBefore(c,b);
	})();  
</script>
-->
<script async src="https://cse.google.com/cse.js?cx=97cb6a9fb7e594710">
</script>
<script>const myWebSearchStartingCallback = (gname, query) => {
  console.log("Search term captured:", query);
  gtag("event", "search", { search_term: query });
  return '';
};

window.__gcse || (window.__gcse = {});
window.__gcse.searchCallbacks = {
  web: {
    starting: myWebSearchStartingCallback,
  },
};</script>
<gcse:searchbox></gcse:searchbox>
