git config --global push.default matching
git config --global push.default simple

git add _posts
git add _includes
git add posts
git add _config.yml
git add assets
git add index.html
git add source_codes
git add commit.sh
git commit -m "xx"
git push --set-upstream origin master
echo `date`
