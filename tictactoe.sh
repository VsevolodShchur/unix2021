game=(1 2 3 4 5 6 7 8 9)

print_game()
{
    echo
    echo ${game[0]} │ ${game[1]} │ ${game[2]}
    echo ──┼───┼──
    echo ${game[3]} │ ${game[4]} │ ${game[5]}
    echo ──┼───┼──
    echo ${game[6]} │ ${game[7]} │ ${game[8]}
    echo
}

print_game
a=0
while true
do
    read -n1 -s ind
    if [[ ! " ${game[@]} " =~ " $ind " ]]; then
        continue
    fi
    game[$ind-1]='X'
    print_game
    let a=a+1
    if [ "$a" == "9" ]; then
        break
    fi
done