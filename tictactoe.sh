#!/bin/bash

print_game()
{
    clear
    echo
    echo  ${game[0]} │ ${game[1]} │ ${game[2]}
    echo ──┼───┼──
    echo  ${game[3]} │ ${game[4]} │ ${game[5]}
    echo ──┼───┼──
    echo  ${game[6]} │ ${game[7]} │ ${game[8]}
    echo
}

check_win() {
    if [[ ${game[0]} == $player_char && ${game[1]} == $player_char && ${game[2]} == $player_char ||
          ${game[3]} == $player_char && ${game[4]} == $player_char && ${game[5]} == $player_char ||
          ${game[6]} == $player_char && ${game[7]} == $player_char && ${game[8]} == $player_char ||
          ${game[0]} == $player_char && ${game[3]} == $player_char && ${game[6]} == $player_char ||
          ${game[1]} == $player_char && ${game[4]} == $player_char && ${game[7]} == $player_char ||
          ${game[2]} == $player_char && ${game[5]} == $player_char && ${game[8]} == $player_char ||
          ${game[0]} == $player_char && ${game[4]} == $player_char && ${game[8]} == $player_char ||
          ${game[2]} == $player_char && ${game[4]} == $player_char && ${game[6]} == $player_char ]]
    then
        echo "Вы выиграли!"
        echo "win" $input > pipe
        rm pipe
        exit 0
    fi
}

check_draw() {
    if [[ ${game[0]} != 1 && ${game[1]} != 2 && ${game[2]} != 3 && 
          ${game[3]} != 4 && ${game[4]} != 5 && ${game[5]} != 6 &&
          ${game[6]} != 7 && ${game[7]} != 8 && ${game[8]} != 9 ]]
    then
        echo "Ничья"
        if [[ $player_char = "X" ]]
        then
            rm pipe
        fi				
        exit 0
    fi
}

game=(1 2 3 4 5 6 7 8 9)
IFS=' '

if [[ -e pipe ]]
then
    player_char="O"
    other="X"
    end_of_move=true
else
    mknod pipe p
    player_char="X"
    other="O"
    end_of_move=false
fi

while true
do
    print_game
    check_draw

    if "$end_of_move"
    then
        echo "Ход другого игрока ($other)"
        read -a strarr <<< $( cat pipe )
        case $strarr in
        "exit") echo "Другой игрок вышел"
                break ;;
        *"win") ind=strarr[1]
                game[$ind-1]=$other
                print_game
                echo "Вы проиграли"
                break ;;
        esac
        end_of_move=false
        read -a game <<< ${strarr[@]}
    else
        echo "Ваш ход ($player_char)"
        read  -n1 -s input
        end_of_move=true
        case $input in
            $'\e')  echo "exit" > pipe
                    rm pipe
                    break ;;
        esac
        if [[ ! " ${game[@]} " =~ " $input " ]]; then
            end_of_move=false
        else
            game[$input-1]=$player_char
            print_game
            check_win
        fi
    fi

    if "$end_of_move"
    then
        echo ${game[@]} > pipe
    fi
done