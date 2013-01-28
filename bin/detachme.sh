#/bin/sh
git rm --cached .
git commit -am "detached ${PWD}"
git init .
git add .
git commit -am "initialized subdirectory ${PWD} as new repository"
