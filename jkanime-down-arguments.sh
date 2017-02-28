#!/bin/bash
# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -s|--serie)
    SERIE="$2"
    shift # past argument
    ;;
    -i|--inicio)
    START="$2"
    shift # past argument
    ;;
    -f|--fin)
    END="$2"
    shift # past argument
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done
echo SERIE   $SERIE   # = "${SERIE}"
echo START   $START   # = "${START}"
echo END     $END     # = "${END}"

#echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
	exit 1
fi

#SI NO TIENE END
if [[ ! -n $END ]]; then
    printf -v j "%03d" $START
    echo "===============> ANIME $SERIE CAPITULO $j"
	echo "===============> SE DESCARGARA $SERIE-$j.mp4"
	mkdir -p $SERIE
    curl -sL http://jkanime.net/"$SERIE"/"$START"/ | sed -ne 's/.*iframe.*\(https:\/\/jkanime[^"]*\).*/\1/p' |  xargs wget -O /dev/stdout | sed -ne "s/.*&file=\(http:\/\/jkanime[^\']*\).*/\1/p" | xargs wget -O "$SERIE/$SERIE-$j.mp4"

	exit 1
    #tail -1 $1
fi

# SI TIENE END
if [[ -n $END ]]; then
    echo "DOWNLOAD > $SERIE - $START - $END"
	
for ((i=$START; i<=$END; i++ ))
do
   printf -v j "%03d" $i
   echo "===============> ANIME $SERIE CAPITULO $j"
   echo "===============> SE DESCARGARA $SERIE-$j.mp4"
   mkdir -p $SERIE
   curl -sL http://jkanime.net/"$SERIE"/"$i"/ | sed -ne 's/.*iframe.*\(https:\/\/jkanime[^"]*\).*/\1/p' |  xargs wget -O /dev/stdout | sed -ne "s/.*&file=\(http:\/\/jkanime[^\']*\).*/\1/p" | xargs wget -O "$SERIE/$SERIE-$j.mp4"

done

	exit 1
	
fi

