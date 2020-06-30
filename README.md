# books-to-read
Powershell script to show books to read from Goodreads API.

How to run:
```
generate.ps1 > output.html
```

The script assumes that there are two files containing authentication info.
1. `goodreadsDeveloperKey.txt` : obtained from [Goodreads API page](https://www.goodreads.com/api)
2. `goodreadsUserId.txt` : user id, whose shelves will be requested.

These two files are assumed to be located in user profile folder, a.k.a. `~/`. If you want to place them elsewhere, you can set the optional directory parameter:

```
generate.ps1 -directory custom_directory > output.html
```

It is also assumed that the user profile in Goodreads is public. Goodreads API requires oauth flow to authenticate private profiles, but this is not supported at the moment.
