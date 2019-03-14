# minimal : use postgres10.tar.gz instead of postgres.tar.gz
# if you use test provisioning template you can use postgres.tar.gz
class odoo11::postgres {
$ftp_server="172.16.31.190"
	exec { 'Get postgresql10' :
		cwd => "/root",
		path => '/usr/bin:/usr/sbin:/bin',		
		command => "wget ftp://${ftp_server}/postgres.tar.gz && tar -xzvf postgres.tar.gz",	
		creates => "/root/postgres",
		}

	exec { 'Install postgresql10' :
		cwd => "/root/postgres",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "mount /dev/sr0 /mnt && rpm -ivh /mnt/Packages/libicu-50.1.2-15.el7.x86_64.rpm && yum localinstall --disablerepo=* *.rpm -y",
		}	

	exec { 'Create odoo user ' :
		path => '/usr/bin:/usr/sbin:/bin',
		command => "useradd -m -U -r -d /opt/odoo -s /bin/bash odoo ; /usr/pgsql-10/bin/postgresql-10-setup initdb && sed -i \"59c\listen_addresses = \'*\' \" /var/lib/pgsql/10/data/postgresql.conf && sed -i \"60c\port = 5432\" /var/lib/pgsql/10/data/postgresql.conf && /usr/bin/sed -i \"81c\host    all             all             0.0.0.0/0               md5 \" /var/lib/pgsql/10/data/pg_hba.conf",
                creates => "/var/lib/pgsql/10/data/pg_hba.conf",
			}

         service { 'postgresql-10':
                ensure => running,
                enable => true,
                }
      
        exec {'create user in postgres' :
		cwd => "/home",
		user => "postgres",
		command => "/usr/bin/createuser -s odoo && /usr/bin/psql -c \" alter user odoo with password \'odoo\'; \" && /usr/bin/touch /tmp/test", 
		creates => "/tmp/test",		
		}

	exec { 'Get wkhtmltox' :
		cwd => "/root",
		command => "/usr/bin/wget ftp://${ftp_server}/wkhtmltox.tar.gz && /usr/bin/tar -xzvf wkhtmltox.tar.gz",
		creates => "/root/wkhtmltox",
		}

	exec {'Install wkhtmltox' :
		cwd => "/root/wkhtmltox",
		command => "/usr/bin/yum localinstall --disablerepo=* *.rpm -y",                                                                       
		}
} 
