#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for file in $DIR/*.pdf
    do
        pdf2svg "$file" "${file%.pdf}.svg"
    done

