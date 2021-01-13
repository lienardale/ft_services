#! /usr/bin env sh
pgrep php-fpm > /dev/null
TEST1="$?"
echo $TEST1
pgrep nginx > /dev/null
TEST2="$?"
echo $TEST2
if [ "$TEST1" != "0" -o "$TEST2" != "0" ]
then
    return "1"
else
    return "0"
fi