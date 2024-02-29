#!/bin/sh
# Скрипт для сканирования уязвимостей с nuclei

# Читаем из файла с открытыми портами, полученного на этапе 2
nuclei -l /data/open_ports.txt -o /data/vulnerabilities.json
