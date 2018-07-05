oldcmd=$(history | tail -n 1 | cut -d' '  -f5)
oldpara=$(history | tail -n 1 | cut -d' '  -f6-)

if echo $oldpara | grep -E "^'(.*)'$" ; then
    echo "haha"
else
    echo "xixi"
fi

