#!/bin/sh
# Скрипт для сканирования портов с использованием nmap

# Читаем из файла поддоменов и IP-адресов, полученного на этапе 1
nmap -iL /data/subdomains.txt --min-rate 10000 -T4 -oX /data/open_ports.xml
python3 parse_nmap.py
