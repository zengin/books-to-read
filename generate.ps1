Param(
  [string]$directory = "~",
  [switch]$lastYear  
)

$shelf = "to-read"
if ($lastYear.IsPresent)
{
  $shelf = "read"
}

$year = (Get-Date).Year

$goodreadsDeveloperKeyFile = Join-Path $directory "goodreadsDeveloperKey.txt"
$goodreadsUserIdFile = Join-Path $directory "goodreadsUserId.txt"

If (!(Test-Path $goodreadsDeveloperKeyFile) -or !(Test-Path $goodreadsUserIdFile))
{
  Write-Host "please create goodreadsDeveloperKey.txt and goodreadsUserId.txt file in $directory directory to hold your developer key and user id" -ForegroundColor Red
  exit
}

$developerKey = Get-Content $goodreadsDeveloperKeyFile
$userId = Get-Content $goodreadsUserIdFile

$url = "https://www.goodreads.com/review/list?v=2&key=$developerKey&shelf=$shelf&per_page=200&id=$userId"

$response = (Invoke-WebRequest $url)
$xmlResponse = [xml]$response.Content
$reviews = $xmlResponse.GoodreadsResponse.reviews.review

if ($lastYear.IsPresent)
{
  $reviews = $reviews | Where-Object read_at -like "*$year"
}

$books = $reviews.book

echo "<html>"
echo "<head>"
echo "<link rel=`"stylesheet`" href=`"https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css`" integrity=`"sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk`" crossorigin=`"anonymous`">"
echo "</head>"
echo "<body class=`"bg-info`">"
echo "<div class=`"container text-center`">"

$backgrounds = @("bg-dark text-white", "bg-secondary text-white")

$skip = 0;
$colSkipBase = 0;
while ($true)
{
  $rowBooks = $books | Select-Object -Skip $skip -First 4
  if ($rowBooks -eq $null)
  {
    break
  }

  $colSkip = $colSkipBase;
  echo "<div class=`"row`">"
  foreach ($book in $rowBooks)
  {
    $background = $backgrounds[$colSkip % 2]
    $colSkip++
    echo "<div class=`"col-md-3 pt-3 $background`">"
    echo "<img src=`"$($book.image_url)`" class=`"rounded mx-auto d-block`">"
    echo "</div>"
  }
  echo "</div>"

  $colSkip = $colSkipBase;
  echo "<div class=`"row`">"
  foreach ($book in $rowBooks)
  {
    $background = $backgrounds[$colSkip % 2]
    $colSkip++
    echo "<div class=`"col-md-3 $background`">"
    echo $book.title
    echo "</div>"
  }
  echo "</div>"

  $colSkip = $colSkipBase;
  echo "<div class=`"row`">"
  foreach ($book in $rowBooks)
  {
    $background = $backgrounds[$colSkip % 2]
    $colSkip++
    echo "<div class=`"col-md-3 $background`">"
    echo $book.authors.author.name
    echo "</div>"
  }
  echo "</div>"
  
  $colSkip = $colSkipBase;
  echo "<div class=`"row`">"
  foreach ($book in $rowBooks)
  {
    $background = $backgrounds[$colSkip % 2]
    $colSkip++
    echo "<div class=`"col-md-3 pb-2 $background`">"
    echo $book.num_pages
    echo "</div>"
  }
  echo "</div>"

  $skip += 4
  $colSkipBase++
}

echo "</div>"
echo "</body>"
echo "</html>"
