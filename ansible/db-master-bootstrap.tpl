- name: bootstrap-master-db
  hosts: localhost
  vars:
    db_master_ip: ${db_master_ip}
    db_slave_ip: ${db_slave_ip}
    db_wordpress_password: ${db_wordpress_password}
    db_replication_password: ${db_replication_password}
  tasks:
    - name: Clone wordpress-ansible-install repo
      git:
        repo: https://github.com/jonghall/wordpress-ansible-install.git
        dest: wordpress-ansible-install
    - include_tasks: wordpress-ansible-install/db/tasks/configure-mariadb.yaml
    - include_tasks: wordpress-ansible-install/db/tasks/configure-replication-master.yaml