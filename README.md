# Домашнее задание к занятию "08.05 Тестирование Roles"

## Подготовка к выполнению

1. Установка molecule и зависимостей на ubuntu 20.04 по инструкции https://molecule.readthedocs.io/en/latest/installation.html
```
$ sudo apt update
$ sudo apt install -y python3-pip libssl-dev
$ python3 -m pip install "molecule==3.4.0"
$ python3 -m pip install "ansible-lint<6.0.0" 
$ python3 -m pip install "molecule-docker<2.0.0"
```
2. Проверка соответствия версий **molecule** и её модулей тем, что были в лекции
```
$ molecule --version
    molecule 3.4.0 using python 3.8
    ansible:2.12.7
    delegated:3.4.0 from molecule
    docker:1.1.0 from molecule_docker requiring collections: community.docker>=1.9.1
```
3. Добавил путь к **molecule** в **~/.bashrc**
```
$ cat .bashrc | grep -A2 molecule
> # add PATH for molecule
> export PATH=$PATH:/home/baloo/.local/bin
```

## Выполнение

1. Сразу наткнулся на проблему при запуске **molecule test -s centos_7** в директории clickhouse-role
```
docker.errors.DockerException: Error while fetching server API version: ('Connection aborted.', PermissionError(13, 'Permission denied'))
```
Эту проблему решил установкой **molecule** и всех модулей для пользователя **root**.

2. После решения проблемы с правами получил следующую проблему при новом прогоне **molecule test -s centos_7**: 
```
TASK [Apply Clickhouse Role] ***************************************************
ERROR! the role 'ansible-clickhouse' was not found in /home/baloo/.git/08-ansible/roles/clickhouse/molecule/resources/playbooks/roles:  
/root/.cache/molecule/clickhouse/centos_7/roles:/home/baloo/.git/08-ansible/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:  
/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/0ae698/roles:  
/home/baloo/.git/08-ansible/roles/clickhouse/molecule/resources/playbooks

The error appears to be in '/home/baloo/.git/08-ansible/roles/clickhouse/molecule/resources/playbooks/converge.yml': line 7, column 15, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

      include_role:
        name: ansible-clickhouse
              ^ here
```
Эту проблему устранил исправив **ansible-clickhouse** на **clickhouse** в файле **/home/baloo/.git/08-ansible/roles/clickhouse/molecule/resources/playbooks/converge.yml**

3. В директории vector-role выполняем:
```
$ molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/baloo/.git/08-ansible/roles/vector-role/molecule/default successfully.
```
Тут всё прошло штатно.

4. В файле **vector_role/molecule/default/molecule.yml** добавил ещё один инстанс **ubuntu_latest**. А также изменил дефолтный instance на centos_7 и ubuntu_latest. В итоге файл стал выглядеть так:
```yaml
$ cat molecule/default/molecule.yml
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:
  - name: centos_7
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
  - name: ubuntu_latest
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
```

5. Запуская **molecule test -s default** из директории **/vector-role** получаю ошибку при запуске **handler**:
```
RUNNING HANDLER [vector-role : Start Vector] ***********************************
fatal: [centos_7]: FAILED! => {"changed": false, "msg": "Service is in unknown state", "status": {}}
```
При этом **vector** на docker образ **centos 7** установился.

Перезапустил тест роли с флагом **--destroy never** чтобы сохранить контейнер работающим.
Зашёл в контейнер. Вижу, что **vector** установился:
```
$ sudo docker exec -it centos_7 bash
[root@centos_7 /]# yum list installed | grep vector
vector.x86_64                              0.22.3-1                @/vector-0.22.3-1.x86_64
```
Но проверить статус сервиса нет возможности, т.к. получаю ошибку:
```
[root@centos_7 /]# systemctl status vector        
Failed to get D-Bus connection: Operation not permitted
```
### На этом моменте остановился. Не понимаю как действовать дальше.

Всё что касается тестирования роли для **ubuntu** игнорировал, т.к. роль изначально писалась под **centos 7** и работать в **ubuntu** она бы не смогла.
