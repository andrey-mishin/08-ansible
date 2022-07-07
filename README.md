## Домашнее задание к занятию "08.03 Использование Yandex Cloud"

### Подготовка инфраструктуры 
Очень хотел поднять всю инфраструктуру в Yandex Cloud с помощью Terraform. Это оказалось сложнее чем я думал 
и заняло намного больше времени чем я рассчитывал.  
На текущий момент, переделал *inventory* под инфраструктуру Yandex Cloud. Добавил переменную для *lighthouse*  
со ссылкой на репозиторий. В *playbook* начал писать новый *play* для установки и запуска *lighthouse*. Сделал  
и проверил работу подготовительных *tasks*:
- установка *git*
- скачивание *lighthouse* из репозитория *git*

```
- name: Install Lighthouse
  hosts: lighthouse
  tags:
    - lh-inst
  pre_tasks:
    - name: Install Git
      become: true
      ansible.builtin.yum:
        name: git
      tags:
        - git-inst
  tasks:
    - name: Download Lighthouse
      ansible.builtin.git:
        repo: "{{ lighthouse_repo }}"
        dest: ./lighthouse
      tags:
        - lh-down
```

Работу продолжаю.
