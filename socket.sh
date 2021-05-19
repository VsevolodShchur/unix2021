#!/bin/bash
# 
#HOST=www.mit.edu
#PORT=80
# 
#(echo >/dev/tcp/${HOST}/${PORT}) &>/dev/null
#if [ $? -eq 0 ]; then
#    echo "Соединение успешно установлено"
#else
#    echo "Не удалось установить соединение"
#fi

exec 3<>/dev/tcp/127.0.0.1/1234

echo "Write this to the socket" >&3
cat <&3

exec 3<&-
exec 3>&-