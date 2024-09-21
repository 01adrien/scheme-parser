plt-r5rs tests/test-token-types.scm < tests/$1-tokens.in > tests/$1-tokens.out
diff tests/$1-tokens.out tests/$1-tokens.expect
[[ $? == 0 ]] && printf "[\033[0;32mX\033[0m] tests passed\n" 
