Found at [Hexnode](https://www.hexnode.com/blogs/mac-secure-token-everything-it-admins-should-know/#how-to-manage-secure-tokens-using-sysadminctl-commands)


## Check Secure Token status

`sysadminctl -secureTokenStatus (username)`

**OR**

`dscl . -read /Users/(username) AuthenticationAuthority`

## Manually generate secure 

`sysadminctl -adminUser "ourAdminAccount" -adminPassword "password" -secureTokenOn (username that needs secure token) -password (password of user that needs secure token)`

Alternatively, if you would like to enter the password separately in the password dialog box, run the following command.

`sudo sysadminctl -adminUser “ourAdminAccount” -adminPassword "password"`
`sysadminctl -secureTokenOn (username that needs secure token) -password -`

## Remove secure token

`sudo sysadminctl -adminUser “ourAdminAccount” -adminPassword “password”`

`sysadminctl -secureTokenOff (username that needs secure token) -password (password of user that needs secure token)`

Alternatively, if you would like to enter the password separately in the password dialog box, run the following command.

`sudo sysadminctl -adminUser “ourAdminAccount” -adminPassword “password”`

`sysadminctl -secureTokenOff (username that needs secure token) -password -`

## Who has a token

`diskutil apfs listCryptoUsers /`

then identify by name

`dscl . -search /Users GeneratedUID 124A872D-48AC-4894-9E16-C9C2A13E9BDD`