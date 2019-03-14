class odoo11::post {

	file { '/root/postgres10.tar.gz' :
		ensure => present,
		source => "puppet:///modules/odoo11/postgres10.tar.gz",
	}
		
	file { '/root/wkhtmltox1.tar.gz' :
		ensure => present,
		source => "puppet:///modules/odoo11/wkhtmltox1.tar.gz",
	}
		
	exec { 'Untar postgres10 and wkhtmltox'	:
		cwd => "root",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "tar -xzvf postgres10.tar.gz && tar -xzvf wkhtmltox1.tar.gz ",
		creates => "/root/wkhtmltox",
	}

	exec { 'Install postgresql10' :
		cwd => "/root/postgres10",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "yum localinstall --disablerepo=* *.rpm -y",
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

	
		
	#exec { 'Get wkhtmltox' :
	#	cwd => "/root",
	#	command => "/usr/bin/wget ftp://${ftp_server}/wkhtmltox1.tar.gz && /usr/bin/tar -xzvf wkhtmltox1.tar.gz",
	#	creates => "/root/wkhtmltox",
	#}

	exec {'Install wkhtmltox1' :
		cwd => "/root/wkhtmltox",
		command => "/usr/bin/yum localinstall --disablerepo=* *.rpm -y",                                                                       
	}
} 