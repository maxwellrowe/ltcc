<?php

/**
* The WNL class uses PHP's built in simplexml_load_file function to open the file.
* It uses xpath to get the collection of items you want. 
*/
class WNL {
    var $wnl;
    var $dataType = "xml";
    var $url;
    var $xml;
    var $items;
    var $byPubdate = array();
    var $mostRecent = array();
    var $Count;
    var $isGood;
    var $exceptions = array();
    /**
    * Constructor for the WNL class
    *
    * @param    $_url       url to the RSS feed to be parsed.
    * @param    $_xpath     The xpath to each RSS item in the feed. (optional)
    * @param    $_type      (optional)
    */
    function __construct($_url,$_xpath = "/rss/channel/item",$_type = "xml")
    {
        try
        {
            if(!strncmp($_url, "/", strlen("/")) == 1 && ($_url != "//"))
            {
				$wnl = simplexml_load_file($_SERVER['DOCUMENT_ROOT'].$_url,'SimpleXMLElement', LIBXML_NOCDATA);
            }
            else
            {
                $wnl = simplexml_load_file($_url,'SimpleXMLElement', LIBXML_NOCDATA);
            }
        }
        catch(Exception $e)
        {
            $this->exceptions[] = $e;
            throw new Exception("Could not load xml exception", 0, $e);
            $this->isGood = FALSE;   
        }
        
        if($wnl)
        {
            $this->xml = $wnl;
            $this->items = $wnl->xpath($_xpath);
            $this->isGood = TRUE;
            $this->Count = count($this->items);
        }
        else
        {
            $this->exceptions[] = "No Wnl Object";
            $this->isGood = FALSE;   
        }
        
        $this->Count = count($this->items);
    } // end Construct
    
    
    /**
    * The Iterate function iterates through a particular range of items and displays them, 
    * based on the number of items to display, the categories to display and the current page to display.
    *
    * @param    $delegate   The name of the display function that should be used.
    * @param    $numItems        The number of items that should be displayed (optional, defaults to all items).
    * @param    $cat        Only items from the given categories will be displayed (optional, defaults to all categories displayed).
    * @param    $page       The current page to display, which in conjunction with $numItems determines which item to start with (optional, defaults to first page).  
    */
    function Iterate($delegate, $numItems = "All", $cat = array("All"), $page = 1)
    {
        try
        {
			$rssItems = array(); // array to hold all the items that fit the category given
			// if we don't have a positive page number, set it to 1
            if ($page < 1) { $page = 1; }
			
			// get the total number of items we're dealing with
			$totalItems = 0;
			
			// loop through each item
			foreach($this->items as $item)
			{
				if ($cat[0] == "All")
				{
					array_push($rssItems, $item); // add the item to the $rssItems array
				}
				elseif ($this->IsInCats($item, $cat))
				{
					array_push($rssItems, $item); // add the item to the $rssItems array
				}
			}
			$totalItems = count($rssItems);
			$sorted = usort($rssItems, 'cmpPubdate');
			//var_dump($sorted);
			//array_reverse($sorted);
			//uasort($rssItems, 'cmpPubdate');	
			// $descending_array = array_reverse(uasort($rssItems, 'cmpPubdate'));
			// if the number of items is "All", display the total number of items
			if ($numItems == "All") { $numItems = $totalItems; }
			
			// if our page is past the upper range, set it to a valid value
			if ($page > $totalItems / $numItems)
			{
				if ($totalItems == $numItems)
				{
					$page = 1;
				}
				else
				{
					$page = floor($totalItems / $numItems) + 1;
				}
			}
			
            // get the start number
            $start = $page * $numItems - $numItems;
			$end = $start + $numItems;
			
			foreach($rssItems as $i=>$item)
			{
				if ($i >= $start && $i < $end)
				{
					$delegate($item, $cat);
				}
			}
        }
        catch(Exception $e)
        {
            echo('<p> WNL.php - Iterate exception</p>');
        }
    }
	
	/* Simple function to run through all items */
	function IterateAll($delegate)
    {
        foreach($this->items as $item)
        {
            $delegate($item);
        }
    }
	
	/**
	* The IsInCats function checks if any of the given item's categories are within the given catgories list.
	* @param	$item	an item with categories to be checked.
	* @param	$cat	The categories list (as an array) that the item will be matched to.
	* return	bool	Returns true if at least one of the item's categories is in one of the given categories.
	*/
	function IsInCats($item, $cat)
	{
		if (!is_array($cat))
		{
			$cat = array($cat);
		}
		// get the categories from the given item
		$y = new CategoryRssItem($item);
		$categories = explode(",", trim($y->category));
		
		// check if it's in the category given
		$catsFound = array_intersect($categories, $cat);
		//print_r($catsFound);
		if (empty($catsFound))
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	
	/**
	* The GetCatsFromUrl function returns all the categories that are associated with the feed item that matches the given url.
	* @param	$url	The url used to find the current item in the feed.
	* return	array(string)	The categories associated with the item found in the feed. If no item is found, returns all categories.
	*/
	function GetCatsFromUrl($url)
	{
		foreach($this->items as $item)
		{
			$y = new CategoryRssItem($item);
			// check if we found the item for the current page
			if ($y->link == $url)
			{
				return explode(",", $y->category); // return array of categories for the current item
			}
		}
		return array("All"); // return all categories if item not found
	}
    
    
    /**
    * The DisplayCategories function displays all unique categories in the feed as list items. 
    */
    function DisplayCategories()
    {
        $catlist = array();
        echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '">All</a></li>';
        
        // loop through all items to get unique categories
        foreach($this->items as $item)
        {
            $y = new CategoryRssItem($item);
            $categories = explode(",", $y->category); // create array of categories for the current item
            
            // loop through all categories for current item
            foreach($categories as $cat)
            {
                $cat = trim($cat);
                if ($cat != '')
                {
                    // if the current category is not in the list, add it
                    if (!in_array($cat, $catlist))
                    {
                        $catlist[] = $cat;
                    }
                }
            }
        }
        
        // sort category list alphabetically
        asort($catlist);
        
        // display all categories
        foreach($catlist as $cat)
        {
            echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '?cat=' . $cat . '">' . $cat . '</a></li>';
        }
    }
    
    
    /**
    * The DisplayPagination function displays pagination for rss items. 
    *
    * @param    $page       The current page that is being displayed. The page's pagination item will be set to active. 
    * @param    $numItems   The number of items that are displayed on each page, which is used to determine the number of pages in the pagination.
    * @param    $cat        Only items from the given categories will be used to generate the pagination (optional, defaults to all categories).
    */
    function DisplayPagination($page = 1, $numItems = 4, $cat = array("All"))
    {
		try
        {
        	// set global pagination variables
			$dividerContent = '<li><a href="#">&hellip;</a></li>'; // divider html that appears when there are more pages than the page gaps
			$pageGapStart = 1; // the number of pages to display after the first page
			$pageGapEnd = 1; // the number of pages to display before the last page
			$pageGapMidBefore = 5; // the number of pages to display before the current page
			$pageGapMidAfter = 2; // the number of pages to display after the current page
			
			$rssItems = array(); // array to hold all the items that fit the category given
			
			// if we don't have a positive page number, set it to 1
            if ($page < 1) { $page = 1; }
			
			// get the total number of items we're dealing with
			$totalItems = 0;
			foreach($this->items as $item) // loop through each item
			{
				if ($cat == "All")
				{
					array_push($rssItems, $item); // add the item to the $rssItems array
				}
				elseif ($this->IsInCats($item, $cat))
				{
					array_push($rssItems, $item); // add the item to the $rssItems array
				}
			}
			$totalItems = count($rssItems);
			
			// if our page is past the upper range, set it to a valid value
			if ($page > $totalItems / $numItems)
			{
				if ($totalItems == $numItems)
				{
					$page = 1;
				}
				else
				{
					$page = floor($totalItems / $numItems) + 1;
				}
			}
			
			// display the "Previous" link if needed
			if ($page > 1)
			{
				echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '?cat=' . $cat . '&amp;page=' . ($page-1) . '">Previous</a></li>';
			}
			
			// get the start number
			$start = $page * $numItems - $numItems;
			
			$pageLinkDisplayed = false;
			$curPage = 1;
			$dispItemTotal = 0;
			$dividerBeforeDisplayed = false;
			
			$pageGapInitialStart = $pageGapMidBefore + $pageGapMidAfter + $pageGapStart + 1;
			
			// loop through the items to display the pagination
			foreach($rssItems as $i=>$item)
			{
				//echo "<li>i: " . $i . "</li>";
				$dispItemTotal = $i+1;
				
				// every numItems number of items, display a new page link
				if ($i % $numItems == 0)
				{
					$pageNum = ceil(($i+1) / $numItems);
					
					// if the page we're looking at is the same as the page number we're looping through, make the current link active
					if ($pageNum == $page)
					{
						echo '<li><a href="#" class="current">' . $pageNum . '</a></li>';
						$pageLinkDisplayed = true;
						
						$curPage = $pageNum;
					}
					// if we're on one of the first pages, display the link
					else if ($pageNum <= (1 + $pageGapStart))
					{
						echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '?cat=' . $cat . '&amp;page=' . $pageNum . '">' . $pageNum . '</a></li>';
						$pageLinkDisplayed = true;
					}
					// if we're within the page gap before the current page, display the link
					else if ($page-$pageNum > 0 && $page-$pageNum <= $pageGapMidBefore)
					{
						echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '?cat=' . $cat . '&amp;page=' . $pageNum . '">' . $pageNum . '</a></li>';
						$pageLinkDisplayed = true;
					}
					// if we're within the page gap after the current page, display the link
					else if ($pageNum-$page > 0 && $pageNum-$page <= $pageGapMidAfter)
					{
						echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '?cat=' . $cat . '&amp;page=' . $pageNum . '">' . $pageNum . '</a></li>';
						$pageLinkDisplayed = true;
					}
					// display divider before current page if needed
					else if (!$dividerBeforeDisplayed && $page-$pageNum > 2 && $pageNum < $page)
					{
						echo $dividerContent;
						$dividerBeforeDisplayed = true;
					}
					// if we're on the first page, display the link
					else if ($pageNum == 1)
					{
						echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '?cat=' . $cat . '&amp;page=' . $pageNum . '">' . $pageNum . '</a></li>';
						$pageLinkDisplayed = true;
					}
					
					// reset current item total
					$curItemTotal = 0;
				}
			}
			
			// display the first page if none were displayed
			if (!$pageLinkDisplayed)
			{
				echo '<li><a href="#" class="current">1</a></li>';
			}
			
			$lastPageNum = ceil($dispItemTotal / $numItems);
			// display the second divider if needed
			if ($curPage+$pageGapMidAfter+1 < $lastPageNum-$pageGapEnd)
			{
				echo $dividerContent;
			}
			// loop through and display the last pages
			for ($i = $lastPageNum - $pageGapEnd; $i <= $lastPageNum; $i++)
			{
				if ($i > 1 && $i > $curPage+$pageGapMidAfter)
				{
					$pageNum = $i;
					echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '?cat=' . $cat . '&amp;page=' . $pageNum . '">' . $pageNum . '</a></li>';
				}
			}
			
			// display the "Next" link if needed
			if ($curPage < ($dispItemTotal / $numItems))
			{
				echo '<li><a href="' . strtok($_SERVER["REQUEST_URI"],'?') . '?cat=' . $cat . '&amp;page=' . ($page+1) . '">Next</a></li>';
			}
        }
        catch(Exception $e)
        {
            echo('<p> WNL.php - Display Pagination exception</p>');
        }
    }
    
    
    /**
    * The DisplayNewsBoardCategories function displays a list of categories that are being used in the RSS items.
    */
    function DisplayNewsBoardCategories()
    {
        try
        {
            $catlist = array();
            
            // loop through all items to get unique categories
            foreach($this->items as $item)
            {
                $y = new CategoryRssItem($item);
                $categories = explode(",", $y->category); // create array of categories for the current item
                
                // loop through all categories for current item
                foreach($categories as $cat)
                {
                    $cat = trim($cat);
                    if ($cat != '')
                    {
                        // if the current category is not in the list, add it
                        if (!in_array($cat, $catlist))
                        {
                            $catlist[] = $cat;
                        }
                    }
                }
            }
            
            // sort category list alphabetically
            asort($catlist);
            
            // display all categories
            foreach($catlist as $cat)
            {
                echo '<li><a href="#" data-filter=".' . strtolower($cat) . '">' . $cat . '</a></li>';
            }
        }
        catch(Exception $e)
        {
            echo('<p> wnl.php - Display News Board Categories exception</p>');
        }
    }
    
    
    function Take($qty)
    {
        $taken = array();
        if($this->Count > $qty)
        {
           for($i = 0 ; $i < $qty ; $i++)
           {
               $taken[] = $this->items[$i];
           }
        }
        else
        {
          foreach($this->items as $item)
          {
              $taken[] = $item;
          }
        }
        return $taken;
    }
    
    
    function AsJson(){
        return json_encode($this->items);
    }
    
    
    //  byNodeValue returns items that have a specified node value
    // $newArrayOfNodesWithTheSameValue = $wnl->byNodeValue("category","athletics"); - $newArrayOfNodesWithTheSameValue will contain items in which the <category> node value is "athletics"
    function byNodeValue($node,$value)
    {
        $byNodeValue = array();
        foreach($this->items as $item)
        {
          if(strtolower($item->$node) == strtolower($value))
          {
              $byNodeValue[] = $item;
          }
        }
        return $byNodeValue;
    }
    
    
    function getItemsByPubdate()
    {
        foreach($this->items as $item)
        {
            $this->byPubdate[] = $item;
        }
        usort($this->byPubdate, 'cmpPubdate');
     
        return $this->byPubdate;
    }
     
    
    // gets a specified number of the most recently published items.
    function getMostRecent($number)
    {
        $mostRecentToReturn = array();
        
        foreach($this->items as $item)
        {
        $this->mostRecent[] = $item;
        }
        usort($this->mostRecent, 'cmpPubdate');
        
        if($this->Count >= $number)
        {
            for($i = 0; $i < $number; $i ++)
            {
                $mostRecentToReturn[] = $this->mostRecent[$i];
            }
        }
        else
        {
            $mostRecentToReturn = $this->items;
        }
        
        return $mostRecentToReturn;
    }
    
}//END WNL class

// XML COLLECTION

    
class XmlCollection {
    // the $items variable is an array of item Objects
    public $items;
    
    public $type;
    
    function __construct($xml, $xpath)
    {
        $this->items = $xml->xpath($xpath);
    }
    
    function Iterate($delegate ,$qty = "All")
    {
        if($qty == "All")
        {
            $this->IterateAll($delegate);
        }
        else
        {
            if(count($this->items) >= $qty)
            {
                for($i = 0 ; $i < $qty ; $i++)
                {
                    $delegate($this->items[$i]);
                }
            }
            else
            {
                $this->IterateAll($delegate);
            }
        }
    }
    
    
    function IterateAll($delegate)
    {
        foreach($this->items as $item)
        {
            $delegate($item);
        }
    }
    
    function AsJson()
    {
        return json_encode($this->items);
    }
    
}


// WNL ITEM
class WnlItem {
    public $original_element;
    public $title = "title";
    public $description = "description";
    public $link = "#";
    public $pubDate = "Fri, 07 Dec 2012 09:29:55 -0800";
    
    
    function __construct($element)
    {
        $this->original_element = $element;
        $this->title = $this->getChildNodeValue('title');
        $this->description = $this->getChildNodeValue('description');
        $this->link = $this->getChildNodeValue('link');
        $this->author = $this->getChildNodeValue('author');
    } 
    
    function getChildNodeValue($nodename){
        return $this->original_element->$nodename;
    }
    
    function h3(){
        echo('<h3><a href="'.$this->link.'">'.$this->title.'</a></h3>');
    }
    
    function li(){
        return '<li><a href="'.$this->link.'">'.$this->title.'</a></li>';
    }
    
    function p($chars = 100,$read_more = TRUE)
    {
        $res = '<p>';
        $res .= substr($this->description, 0,$chars);
        if($read_more){
            $res .= '...<a href="'.$this->link.'">Read More</a>';
        }
        $res .= '</p>';
        return $res;
    }
} 


//  YahooRssItem
class YahooRssItem extends WnlItem {
    
    var $yns = "http://search.yahoo.com/mrss/"; //$yns = yahoo media namespace
    var $ouns = "http://omniupdate.com/XSL/Variables"; //$ouns = omniupdate namespace
    function __construct($element)
    {
        parent::__construct($element);
        $this->pubDate = $this->getChildNodeValue('pubDate');
        
        if($this->original_element->children($this->yns))
        {
            $y = $this->yns;
            
            $this->murl = $this->original_element->children($y)->attributes()->url;
            $this->mtitle = $this->original_element->children($y)->children($y)->title;
            $this->mkey = $this->original_element->children($y)->children($y)->keywords;
            $this->mdesc = $this->original_element->children($y)->children($y)->description;
            $this->mthumb = $this->original_element->children($y)->children($y)->thumbnail->attributes()->url;
        }
    } // end construct

}




// CategoryRssItem
class CategoryRssItem extends WnlItem {
    var $yns = "http://search.yahoo.com/mrss/"; //$yns = yahoo media namespace
    var $ouc = "http://omniupdate.com/XSL/Variables"; //$ouc = ouc namespace
    
    function __construct($element)
    {
        parent::__construct($element);
        
        $this->title = $this->getChildNodeValue('title');
        $this->link = $this->getChildNodeValue('link');
        $this->description = $this->original_element->description;
        $this->pubDate = $this->getChildNodeValue('pubDate');
        
        $this->category = $this->original_element->children($this->ouc)->category;
        
        if($this->original_element->children($this->yns))
        {
            $y = $this->yns;
            
            $this->murl = $this->original_element->children($y)->attributes()->url;
            $this->mtitle = $this->original_element->children($y)->children($y)->title;
            $this->mkey = $this->original_element->children($y)->children($y)->keywords;
            $this->mdesc = $this->original_element->children($y)->children($y)->description;
            $this->mthumb = $this->original_element->children($y)->children($y)->thumbnail->attributes()->url;
        }
    } // end construct
}



// compares the pubDate of an XmlItem
function cmpPubdate($a, $b)
{
    $atime = strtotime($a->pubDate);
    $btime = strtotime($b->pubDate);
    if ($atime == $btime) 
    {
        return 0;
    }
    return ($btime < $atime) ? -1 : 1;
}
?>
