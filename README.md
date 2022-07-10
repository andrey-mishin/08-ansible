## Домашнее задание к занятию "08.03 Использование Yandex Cloud"

### Подготовка инфраструктуры 
Очень хотел поднять всю инфраструктуру в Yandex Cloud с помощью Terraform. Это оказалось сложнее чем я думал 
и заняло намного больше времени чем я рассчитывал.  

### Последняя работающая инфраструктура
```
yc compute instance list
+----------------------+------------+---------------+---------+----------------+---------------+
|          ID          |    NAME    |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP  |
+----------------------+------------+---------------+---------+----------------+---------------+
| epd5sv9dq6lsitcbi88t | vector     | ru-central1-b | RUNNING | 51.250.102.119 | 192.168.10.14 |
| epdesq8oc342p26m9eqo | lighthouse | ru-central1-b | RUNNING | 51.250.28.239  | 192.168.10.11 |
| epdo2633f66il4uu6ulj | clickhouse | ru-central1-b | RUNNING | 51.250.101.143 | 192.168.10.4  |
+----------------------+------------+---------------+---------+----------------+---------------+
```

Переделал *inventory* под инфраструктуру **Yandex Cloud**. Добавил переменные для *lighthouse* как в лекции. 
В *playbook* сделал новый *play* для установки и запуска *lighthouse* со всеми необходимыми зависимостями.  

Т.к. в качестве базы использовал образы Centos 7, то пришлось добавить *task* с динамическим отключением SELinux,  иначе неизменно получал *"403: Forbidden"*. Из-за этого последняя таска и хэндлеры всегда выполняются и имеют статус **changed**.

Добился чтобы ansible-lint проходил без ошибок.  


**Результат первого прохода Playbook**
```
PLAY RECAP **********************************************************************************************************
clickhouse-01              : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=9    changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

**Результат повтороного прохода Playbook**
```
PLAY RECAP **********************************************************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=9    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

### Описание Playbook
Playbook стоит из трёх play.  
Первый play скачивает, устанавливает и запускает службу clickhouse.  
Второй play скачивает, устанавливает и запускает службу vector.  
Третий play скачивает *Lighthouse*, для чего требуется предварительная установка *git* и *nginx*. Также  
требуется редактирование конфигов *nginx* для работы *Lighthouse*.  
С последним play пригодился флаг --diff, т.к. это первый play где используется модуль template.  

**Добавил тэгов:**
```
ansible-playbook site.yml -i inventory/prod.yml --list-tags

playbook: site.yml

  play #1 (clickhouse): Install Clickhouse	TAGS: []
      TASK TAGS: []

  play #2 (vector): Install Vector	TAGS: []
      TASK TAGS: [v-down, v-inst]

  play #3 (lighthouse): Install Lighthouse	TAGS: [lh-inst]
      TASK TAGS: [git-inst, lh-down, lh-inst]
```

