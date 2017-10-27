#!/bin/bash

for U in $*; do
    HTML=${U%.ipynb}.html
    grep -v "%%capture" $U > /tmp/$U
    # convert and remove code cell tags:
    jupyter nbconvert --to html --stdout /tmp/$U | sed  -e "s/Out\[.*://" | sed  -e "s/In&nbsp;\[.*://" > $HTML
    # remove formatting cell at end
    perl -i -0pe 's/#REMOVEBEGIN(.|\n)*.*#REMOVEEND//' $HTML
    course-tool upload python_challenges $HTML && rm $HTML
    # scp $HTML sis-website:htdocs/python_dbiol && rm $HTML
done
