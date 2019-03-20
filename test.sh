#! /usr/bin/env bash

function testDebruijn() {
	echo "--------------------"
	echo "./deBruijn $@"
	diff <(./deBruijn $@) <(./reference $@) && echo -e "\e[32mPASSED\e[0m" || echo -e "\e[31mFAILED\e[0m"
	./deBruijn $@ > /dev/null
	local ret=$?
	./reference $@ > /dev/null
	local refRet=$?
	if [ $ret -ne $refRet ]; then
		echo -e "\e[33mWrong exit number. Expected $refRet, had $ret\e[0m"
	fi
}

testDebruijn 2 'abc'
testDebruijn 3 'ab'
testDebruijn 4 'abcd'
testDebruijn '-1' 'abcd'
