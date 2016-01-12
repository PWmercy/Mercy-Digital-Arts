# This is NOT complete
# Script to get all OD users (members of group Staff in this case)
# Text manipulation needs fixing
g=staff

dscl /LDAPv3/127.0.0.1 -list /Users | while read l

do printf %s "$l "

dsmemberutil checkmembership -U $l -G $g
 done | grep 'is a member' | cut -d' ' -f1 | while read l
 do echo  "$l \t $(dscl /LDAPv3/127.0.0.1 -read /Users/$l UniqueID | tail -n1 | cut -c2-)"

 done > ~/Desktop/file.csv
