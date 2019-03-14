class odoo11::dep {
$ftp_server="172.16.31.190"
    #    exec { 'Get dependencies' :
    #            cwd => "/root",
    #            path => '/usr/bin:/usr/sbin:/bin',
	#	command => "wget ftp://${ftp_server}/dep.tar.gz && tar -xzvf dep.tar.gz",
    #            creates => "/root/dep",
    #            } ->
	file { '/root/dep.tar.gz' :
		ensure => present,
		source => "puppet:///modules/odoo11/dep.tar.gz",
		}
		
	exec { 'Untar dependencies' :
		cwd => "/root",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "tar -xzvf dep.tar.gz",
		creates => "/root/dep",
		} 
		
    exec { 'Install dependencies':
        cwd => "/root/dep",
        path => '/usr/bin:/usr/sbin:/bin',
		command => "yum localinstall --disablerepo=* *.rpm -y && ln -s /usr/libexec/gcc/x86_64-redhat-linux/4.8.5/cc1plus /usr/local/bin/",
        }
}

