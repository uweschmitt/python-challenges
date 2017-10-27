#!/bin/bash

for U in solution_proposal*.ipynb; do
    HTML=${U%.ipynb}.html
    grep -v "%%capture" $U > /tmp/$U
    # convert and remove code cell tags:
    jupyter nbconvert --to html --stdout /tmp/$U | sed  -e "s/Out\[.*://" | sed  -e "s/In&nbsp;\[.*://" > $HTML
    # remove formatting cell at end
    perl -i -0pe 's/#REMOVEBEGIN(.|\n)*.*#REMOVEEND//' $HTML
    PASSWORD=$(md5 -q -s $HTML | cut -b1-10)
    echo $HTML $PASSWORD >> passwords
    zip -e -P $PASSWORD $HTML.zip $HTML
    course-tool upload python_challenges $HTML.zip && rm $HTML && rm $HTML.zip
done

sort passwords | uniq > /tmp/passwords
mv /tmp/passwords passwords
echo
cat passwords
echo
