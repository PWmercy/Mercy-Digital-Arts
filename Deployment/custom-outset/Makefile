PKGTITLE="outset-login-every-custom"
PKGVERSION="20230216.2"
PKGID=mercy.digiarts.outset_login_every.custom
PROJECT="outset-login-every-custom"

#################################################

##Help - Show this help menu
help: 
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

##  clean - Clean up temporary working directories
clean:
	rm -f ./outset*.pkg
	rm -f ./pkgroot/usr/local/outset/*/*.pyc

##  pkg - Create a package using pkgbuild
pkg: clean
	pkgbuild --root pkgroot --identifier ${PKGID} --version ${PKGVERSION} --ownership recommended ./${PKGTITLE}-${PKGVERSION}.component.pkg
	productbuild --identifier ${PKGID}.${PKGVERSION} --package ./${PKGTITLE}-${PKGVERSION}.component.pkg ./${PKGTITLE}-${PKGVERSION}.pkg
	rm -f ./${PKGTITLE}-${PKGVERSION}.component.pkg
