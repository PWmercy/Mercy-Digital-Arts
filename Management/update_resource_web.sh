#!/bin/sh

docs_folder="/Volumes/Macintosh HD/Development/GitHub/Mercy-Digital-Arts/Documentation"
web_folder="/Volumes/Macintosh HD/Development/GitHub/TestRepo/Testweb"

cd "$docs_folder" || exit

/usr/local/bin/asciidoctor StudentandFacultyresources.adoc
mv StudentandFacultyresources.html "$web_folder"/index.html

cd "$web_folder" || exit

/usr/local/bin/git add "index.html"
/usr/local/bin/git commit -m "Update index.html"
/usr/local/bin/git push
