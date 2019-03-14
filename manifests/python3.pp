class odoo11::python3 {
$ftp_server="172.16.31.190"
 	exec { 'Get python3' :
		cwd => "/root",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "wget ftp://${ftp_server}/test1.tar.gz && tar -xzvf test1.tar.gz",
		creates => "/root/test1",
		} ->
	
	exec { 'Install python3':
		cwd => "/root/test1",
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
