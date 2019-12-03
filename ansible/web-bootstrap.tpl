- name: bootstrap-www
  hosts: localhost
  vars:
    db_master_ip: ${db_master_ip}
    db_slave_ip: ${db_slave_ip}
    db_wordpress_password: ${db_wordpress_password}
    domain: ${domain}
    fqdn: ${glb-hostname}.${domain}
  tasks:
    - name: Clone official openshift-ansible 3.11 Repository
      git:
         repo: https://github.com/jonghall/wordpress-ansible-install.git
         dest: ~/wordpress-ansible-install
    - import_tasks: ~/tasks/web/tasks/configure-wordpress.yaml