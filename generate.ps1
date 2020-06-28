Param(
  [string]$directory = "~"
)

$goodreadsDeveloperKeyFile = Join-Path $directory "goodreadsDeveloperKey.txt"
$goodreadsUserIdFile = Join-Path $directory "goodreadsUserId.txt"

If (!(Test-Path $goodreadsDeveloperKeyFile) -or !(Test-Path $goodreadsUserIdFile))
{
  Write-Host "please create goodreadsDeveloperKey.txt and goodreadsUserId.txt file in $directory directory to hold your developer key and user id" -ForegroundColor Red
  exit
}

$developerKey = Get-Content $goodreadsDeveloperKeyFile
$userId = Get-Content $goodreadsUserIdFile

$url = "https://www.goodreads.com/review/list?v=2&key=$developerKey&shelf=to-read&per_page=200&id=$userId"

$response = (Invoke-WebRequest $url)
$xmlResponse = [xml]$response.Content 
$books = $xmlResponse.GoodreadsResponse.reviews.review.book

echo "<html>"
echo "<head>"
echo "<link rel=`"stylesheet`" href=`"https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css`" integrity=`"sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk`" crossorigin=`"anonymous`">"
echo "</head>"
echo "<body>"
echo "<div class=`"container text-center`">"

$backgrounds = @("bg-primary", "bg-info", "bg-primary", "bg-info")

$skip = 0;
while ($true)
{
  $rowBooks = $books | Select-Object -Skip $skip -First 4
  if ($rowBooks -eq $null)
  {
    break
  }

  echo "<div class=`"row pt-3`">"
  foreach ($book in $rowBooks)
  {
    echo "<div class=`"col-md-3`">"
    echo "<img src=`"$($book.image_url)`" class=`"rounded mx-auto d-block`">"
    echo "</div>"
  }
  echo "</div>"

  $colSkip = 0;
  echo "<div class=`"row m-3`">"
  foreach ($book in $rowBooks)
  {
    $background = $backgrounds[$colSkip++]
    echo "<div class=`"col-md-3 $background text-white`">"
    echo $book.title
    echo "</div>"
  }
  echo "</div>"

  $colSkip = 0;
  echo "<div class=`"row m-3`">"
  foreach ($book in $rowBooks)
  {
    $background = $backgrounds[$colSkip++]
    echo "<div class=`"col-md-3 $background text-white`">"
    echo $book.authors.author.name
    echo "</div>"
  }
  echo "</div>"
  
  $colSkip = 0;
  echo "<div class=`"row m-3`">"
  foreach ($book in $rowBooks)
  {
    $background = $backgrounds[$colSkip++]
    echo "<div class=`"col-md-3 $background text-white`">"
    echo $book.num_pages
    echo "</div>"
  }
  echo "</div>"

  $skip += 4
}

echo "</div>"
echo "</body>"
echo "</html>"
