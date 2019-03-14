class odoo11::pyth {
$ftp_server="172.16.31.190"
 	
	file { '/root/rh-python35.tar.gz' :
		ensure => present,
		source => "puppet:///modules/odoo11/rh-python35.tar.gz",
		}
		
	exec { 'Untar python3' :
		cwd => "/root",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "tar -xzvf rh-python35.tar.gz",
		creates => "/root/rh-python35",
		} ->
	
	exec { 'Install python3':
		cwd => "/root/rh-python35",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "yum localinstall --disablerepo=* *.rpm -y",
		creates => "/etc/scl/conf/rh-python35",
		}
	
	
	exec { 'Enable python3' :
		cwd => "/root" ,
		path => '/usr/bin:/usr/sbin:/bin',
		command => "echo -e \"source scl_source enable rh-python35\" >> /root/.bashrc && touch /tmp/test1 && reboot",	
		creates => "/tmp/test1",	
		}

}
