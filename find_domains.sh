#!/bin/sh
# Скрипт для поиска поддоменов и IP-адресов, используя установленные утилиты и список доменов из файла

# Убедитесь, что файл domains.txt находится в той же директории, что и скрипт
# Формат файла domains.txt:
# example1.com
# example2.com
# ...

while read -r domain; do
  echo "Поиск поддоменов для $domain"
  subfinder -d "$domain" | tee -a "/data/subdomains.txt"
#  amass enum -d "$domain" | tee -a "/data/subdomains.txt"
done < "domains.txt"

sort -u /data/subdomains.txt -o /data/subdomains.txt
