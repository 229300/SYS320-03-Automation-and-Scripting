$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://localhost/ToBeScraped.html

# Get a count of the LINKS in the page
$scraped_page.Links.Count

# Display links as HTML Element
$scraped_page.Links

# Display only URL and its text
$scraped_page.Links | Select-Object href, outerText

$h2s= $scraped_page.ParsedHtml.body.getElementsByTagName("h2") | ForEach-Object { $_.outerText }

$h2s

# Print innerText of every div element that has the class as "div-1"
$divs1= $scraped_page.ParsedHtml.body.getElementsByTagName("div") | Where {
$_.getAttributeNode("class").value -ilike "div-1" } | Select innerText

$divs1