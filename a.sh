

git status

git add *
git commit -m"feat: add some files"

spawn git push origin master
expect "*Username*"
send "edte\r"
expect "Password"
send "520onlyeandx\r"
cd ~
interact

git status
