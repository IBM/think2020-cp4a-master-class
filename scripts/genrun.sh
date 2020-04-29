display=0
lineCount=0
while IFS= read -r line
do
    lineCount=$((lineCount+1))
    if [ "$line" == "\`\`\`sh" ]
    then
        display=1
        echo
        echo "# New code block, line: ${lineCount}"
        continue
    fi
    if [ ${display} -eq 1 ] && [ "$line" == "\`\`\`" ]
    then
        display=0
        echo "# End code block, line: ${lineCount}"
        echo
        continue
    fi
    if [ $display -eq 1 ]
    then
        printf '%s\n' "$line"
    fi
done < ../README.md