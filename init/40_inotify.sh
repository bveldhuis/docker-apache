#!/bin/sh

while inotifywait -e modify /etc/apache2/sites-available/; do
    sv down /etc/service/reverseproxy/
    sv up /etc/service/reverseproxy/
    echo "File in Config Folder Changed, Restarted"
done
