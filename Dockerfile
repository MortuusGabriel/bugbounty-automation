# Этап 1: Поиск поддоменов и IP-адресов
FROM alpine:latest as stage1

# Установка необходимых инструментов
RUN apk add --no-cache git go bind-tools && \
    mkdir /subdomain_tools

# Переходим в рабочую директорию, где будем хранить утилиты
WORKDIR /subdomain_tools

# Клонируем и компилируем Subfinder, Amass как примеры утилит для поиска поддоменов
RUN git clone https://github.com/projectdiscovery/subfinder.git && \
    cd subfinder/v2/cmd/subfinder && \
    go build . && \
    mv subfinder /usr/local/bin/ && \
    cd ../../../ && \
    rm -rf subfinder

ENV GOPATH=/root/go
ENV PATH=$PATH:/root/go/bin

RUN go install -v github.com/owasp-amass/amass/v4/...@master

# Создаем точку монтирования для файлов субдоменов
VOLUME /data

# Сценарий для запуска поиска поддоменов и IP-адресов
COPY find_domains.sh /subdomain_tools/find_domains.sh
COPY domains.txt /subdomain_tools/domains.txt
RUN chmod +x /subdomain_tools/find_domains.sh

# Запуск скрипта поиска поддоменов и IP-адресов
ENTRYPOINT ["/subdomain_tools/find_domains.sh"]


# Этап 2: Сканирование портов с nmap
FROM alpine:latest as stage2

# Установка nmap и других зависимостей
RUN apk add --no-cache nmap python3 py3-pip

# Создаем точку монтирования для файлов результатов сканирования портов
VOLUME /data

# Сценарий для запуска nmap
COPY scan_ports.sh /scan_ports.sh
COPY parse_nmap.py /parse_nmap.py
RUN chmod +x /scan_ports.sh

# Запуск nmap с использованием списка поддоменов и IP-адресов
ENTRYPOINT ["/scan_ports.sh"]


# Этап 3: Сканирование уязвимостей с nuclei
FROM projectdiscovery/nuclei:latest as stage3

# Установка nuclei и других необходимых зависимостей
# Так как мы используем официальный docker образ nuclei, он уже содержит все необходимые зависимости

# Создаем точку монтирования для файлов результатов сканирования уязвимостей
VOLUME /data

# Сценарий для запуска nuclei
COPY scan_vulnerabilities.sh /scan_vulnerabilities.sh
RUN chmod +x /scan_vulnerabilities.sh

# Запуск nuclei с использованием списка открытых портов
ENTRYPOINT ["/scan_vulnerabilities.sh"]
