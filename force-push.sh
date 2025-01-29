from_root_cp()
{
	mkdir -p onRoot/$1
	cp -r /$1/$2 onRoot/$1
}

git init
git remote add origin https://github.com/lukacerr/dotfiles.git

# Non $HOME extras to-sync
mkdir onRoot
from_root_cp etc/greetd .
from_root_cp etc/default .
from_root_cp usr/share/icons .

git add .
git commit -m "$(date '+%Y-%m-%d %H:%M:%S')"
git push --force origin main

rm -rf .git
rm -rf onRoot
