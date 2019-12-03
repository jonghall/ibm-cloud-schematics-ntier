- name: bootstrap-www
  hosts: localhost
  vars:
    db_master_ip: ${db_master_ip}
    db_slave_ip: ${db_slave_ip}
    db_wordpress_password: ${db_wordpress_password}
    domain: ${domain}
    fqdn: ${glb-hostname}.${domain}
  tasks:
    - name: Clone wordpress-ansible-install repo
      git:
        repo: https://github.com/jonghall/wordpress-ansible-install.git
        dest: wordpress-ansible-install
    - include_tasks: ~/wordpress-ansible-install/web/tasks/configure-wordpress.yaml