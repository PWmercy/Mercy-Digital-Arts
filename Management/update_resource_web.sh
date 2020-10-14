#!/bin/sh

docs_folder="/Volumes/Macintosh HD/Development/GitHub/Mercy-Digital-Arts/Documentation"
web_folder="/Volumes/Macintosh HD/Development/GitHub/TestRepo/Testweb"

cd "$docs_folder" || exit

/usr/local/bin/asciidoctor StudentandFacultyresources.adoc
/usr/local/bin/asciidoctor labs.adoc
/usr/local/bin/asciidoctor wacom.adoc
/usr/local/bin/asciidoctor studentworkers.adoc
/usr/local/bin/asciidoctor "howto/avid_falcon.adoc"


mv StudentandFacultyresources.html "$web_folder"/index.html
mv labs.html "$web_folder"/labs.html
mv wacom.html "$web_folder"/wacom.html
mv studentworkers.html "$web_folder"/studentworkers.html
mv "howto/avid_falcon.html" "$web_folder"/howto/avid_falcon.html

cd "$web_folder" || exit

/usr/local/bin/git add -u
/usr/local/bin/git commit -m "Update resource pages" && /usr/local/bin/git push --all

exit 0
