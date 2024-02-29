import xml.etree.ElementTree as ET

# Распарсим XML файл
tree = ET.parse('/data/open_ports.xml')
root = tree.getroot()

# Откроем файл для записи результатов
with open('/data/open_ports.txt', 'w') as file:
    for host in root.findall('host'):
        # Проверим, что хост "живой"
        if host.find('status').get('state') == 'up':
            # Получим адрес хоста
            address = host.find('address').get('addr')
            # Для каждого порта создадим запись
            for port in host.find('ports').findall('port'):
                # Проверим, что порт открыт
                if port.find('state').get('state') == 'open':
                    service = port.find('service')
                    # Запись в файл в нужном формате
                    file.write(f"{address}:{port.get('portid')}\n")
