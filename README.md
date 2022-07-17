## Домашнее задание к занятию "08.03 Использование Yandex Cloud"

### Подготовка инфраструктуры 
Инфрастуктура поднималась с помощью terraform.  
Для clickhouse использовалась ОС Ubuntu 20.04, для Vector и Lighthouse - Centos 7.  

### Последняя работающая инфраструктура
```
yc compute instance list
+----------------------+------------+---------------+---------+----------------+---------------+
|          ID          |    NAME    |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP  |
+----------------------+------------+---------------+---------+----------------+---------------+
| epda2pev3ibvgsratsj2 | vector     | ru-central1-b | RUNNING | 84.252.140.18  | 192.168.10.11 |
| epdji0tj9qfem6mqdr50 | lighthouse | ru-central1-b | RUNNING | 84.201.179.211 | 192.168.10.5  |
| epdjq08cnajg0re2bpqn | clickhouse | ru-central1-b | RUNNING | 84.201.164.40  | 192.168.10.12 |
+----------------------+------------+---------------+---------+----------------+---------------+
```

**Результат прохода Playbook**
```
PLAY RECAP *************************************************************************************************
clickhouse-01              : ok=27   changed=10   unreachable=0    failed=0    skipped=10   rescued=0    ignored=0
lighthouse-01              : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

### Ход работы
- с помощью команды ansible-galaxy role init <имя роли> создал директории для ролей vector и lighthouse
- новые роли заполнил tasks из старого playbook
- tasks установки git и nginx для lighthouse вынес в отдельные файлы, в main.yml использовал модуль include_tasks
- шаблоны конфигов роли lighthouse-role перенёс в директорию templates
- переработал playbook на использование ролей
- описал роли в README.md
- выложил роли в отдельные репозитории на github.com, добавил описание в requirements.yml
