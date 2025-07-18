---
- name: Install Keepalived and HAProxy
  hosts: masters  # Change this to your target group or hosts
  become: true  # Run tasks with sudo privileges
  user: root
  tasks:
    - name: Update and upgrade packages
      apt:
        update_cache: yes
        upgrade: dist

    - name: Install Keepalived
      apt:
        name: keepalived
        state: present

    - name: Copy check_apiserver.sh to /etc/keepalived/
      copy:
        src: check_apiserver.sh
        dest: /etc/keepalived/check_apiserver.sh
        mode: '0755'

    - name: Copy keepalived.cfg to /etc/keepalived/
      copy:
        src: keepalived_{{ inventory_hostname }}.cfg
        dest: /etc/keepalived/keepalived.conf

    - name: Create keepalived_script group
      group:
        name: keepalived_script
        state: present
        system: yes

    - name: Create keepalived_script user
      user:
        name: keepalived_script
        shell: /sbin/nologin
        group: keepalived_script
        system: yes
        create_home: no

    - name: Enable and start Keepalived service
      systemd:
        name: keepalived
        enabled: true
        state: started

    - name: Install HAProxy
      apt:
        name: haproxy
        state: present

    - name: Backup original HAProxy configuration
      command: cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.ORG

    - name: Append custom HAProxy configuration to the default config
      blockinfile:
         path: /etc/haproxy/haproxy.cfg
         block: |
           {{ lookup('file', 'haproxy.cfg') }}
         create: no
         backup: yes

    - name: Enable and start HAProxy service
      systemd:
        name: haproxy
        enabled: true
        state: started

    - name: Check status of Keepalived service
      command: systemctl status keepalived
      register: keepalived_status
      ignore_errors: yes

    - name: Print Keepalived status
      debug:
        var: keepalived_status.stdout_lines

    - name: Check status of HAProxy service
      command: systemctl status haproxy
      register: haproxy_status
      ignore_errors: yes

    - name: Print HAProxy status
      debug:
        var: haproxy_status.stdout_lines

