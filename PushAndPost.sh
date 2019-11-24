#! /bin/bash
git checkout hexo
git pull origin hexo
git add .
git commit -m "updated"
git push origin hexo
hexo clean
hexo g
hexo d