- name: bootstrap-slave
  hosts: localhost
  tasks:
  - name: Run mysql-secure-installation
    shell: |
      mysql_secure_installation <<EOF

      n
      n
      y
      y
      y
      y
      EOF
  - name: Create wordpress database on the server
    mysql_db:
      name: wordpress
      login_user: root
      login_unix_socket: /var/lib/mysql/mysql.sock
      state: present

  - name: Create wordpress user
    mysql_user:
      login_user: root
      login_unix_socket: /var/lib/mysql/mysql.sock
      name: wpuser
      password: "${db_wordpress_password}"
      priv: 'wordpress.*:ALL,GRANT'
      host: '%'
      state: present

  - name: Add replication settings to server-id my.cnf for master
    ini_file:
      path: /etc/my.cnf.d/server.cnf
      section: mysqld
      option: server-id
      value: "1"
      backup: yes

  - name: create log directory
    file:
      path: /var/log/mysql
      state: directory
      owner: mysql
      group: mysql
      mode: 0755

  - name: Add replication settings to server-id my.cnf for slave
    ini_file:
      path: /etc/my.cnf.d/server.cnf
      section: mysqld
      option: server-id
      value: "2"
      backup: yes

  - name: Add replication settings to relay-log my.cnf for master
    ini_file:
      path: /etc/my.cnf.d/server.cnf
      section: mysqld
      option: relay-log
      value: /var/log/mysql/mysql-relay-bin.log
      backup: yes

  - name: Add replication settings to log_bin my.cnf for master
    ini_file:
      path: /etc/my.cnf.d/server.cnf
      section: mysqld
      option: log_bin
      value: /var/log/mysql/mysql-bin.log
      backup: yes

  - name: Add replication settings to binlog_do_db my.cnf for master
    ini_file:
      path: /etc/my.cnf.d/server.cnf
      section: mysqld
      option: binlog_do_db
      value: wordpress
      backup: yes

  - name: Add sql_mode
    ini_file:
      path: /etc/my.cnf.d/server.cnf
      section: mysqld
      option: sql_mode
      value: NO_ENGINE_SUBSTITUTION
      backup: yes

  - name: restart mariadb
    service:
      name: mariadb
      state: restarted

  - name: Create slave user
    mysql_user:
      login_user: root
      login_unix_socket: /var/lib/mysql/mysql.sock
      name: slave
      password: "${db_replication_password}"
      priv: '*.*:ALL,GRANT'
      host: '%'
      state: present

  - name: Stop Slave
    mysql_replication:
      login_user: root
      login_unix_socket: /var/lib/mysql/mysql.sock
      mode: stopslave

  - name: Configure Slave Replication
    mysql_replication:
      login_user: root
      login_unix_socket: /var/lib/mysql/mysql.sock
      mode: changemaster
      master_user: slave
      master_password: "${db_replication_password}"
      master_host: "${db_master_ip}"

  - name: Start Slave
    mysql_replication:
      login_user: root
      login_unix_socket: /var/lib/mysql/mysql.sock
      mode: startslave
