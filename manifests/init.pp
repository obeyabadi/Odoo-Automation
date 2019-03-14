class odoo11 {
$ftp_server = "ftp://172.16.31.190"
$untar = "tar -xzvf "
	package { 'wget' :
		ensure => installed,
		}
	
	file { '/root/centos-req.tar.gz' :
		ensure => present,
		source => "puppet:///modules/odoo11/centos-req.tar.gz",
		}
	
	file { '/root/yum-utils.tar.gz' :
		ensure => present,
		source => "puppet:///modules/odoo11/yum-utils.tar.gz",
		}
	
	exec { 'Untar centos-req & yum-utils ' :
		cwd => "/root",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "tar -xzvf centos-req.tar.gz && tar -xzvf yum-utils.tar.gz",
		creates => "/root/yum-utils",
		} 
		
	#exec { 'Get centos-req and yum-utils' :
	#	cwd => "/root",
	#	path => '/usr/bin:/usr/sbin:/bin',
	#	command => "/usr/bin/wget ${ftp_server}/centos-req.tar.gz && ${untar} centos-req.tar.gz && wget ${ftp_server}/yum-utils.tar.gz && ${untar} yum-utils.tar.gz",
	#	creates => "/root/yum-utils",
	#	}
	
	exec { 'Install centos-req' :
		cwd => "/root/centos-req/",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "yum localinstall --disablerepo=* *.rpm -y",
		}
	
	exec { 'Install yum-utils' :
		cwd => "/root/yum-utils/",
		path => '/usr/bin:/usr/sbin:/bin',
		command => "yum localinstall --disablerepo=* *.rpm -y",
		}

include odoo11::post
include odoo11::pyth
include odoo11::dep
include odoo11::systemd
include odoo11::conf

	file { '/opt/odoo/req.tar.gz' :
		ensure => present,
		source => "puppet:///modules/odoo11/req.tar.gz",
		}
	
	file { '/opt/odoo/odoo.tar.gz' :
		ensure => present,
		source => "puppet:///modules/odoo11/odoo.tar.gz",
		}
		
	exec { 'Untar odoo req & create odoo11 directory' :
		cwd => "/opt/odoo",
		path => '/usr/bin:/usr/sbin:/bin',		
		command => "${untar} req.tar.gz && mkdir odoo11 && chown -R odoo:odoo /opt/odoo/odoo11/",
		creates => "/opt/odoo/odoo11",
		}
	
	exec { 'untar odoo clone ' :
		cwd => "/opt/odoo/odoo11",
		command => "/usr/bin/${untar} /opt/odoo/odoo.tar.gz",
		creates => "/opt/odoo/odoo11/odoo", 
			}
		
	exec { 'Create environment and install modules' :
		user => "odoo",
		cwd => "/opt/odoo",
		path => '/usr/bin:/usr/sbin:/bin:/opt/rh/rh-python35/root/usr/bin:/usr/pgsql-10/bin:/opt/odoo/odoo11-venv/bin:/usr/local/bin:/usr/local/sbin',
		command => "python3 -m venv odoo11-venv &&  bash -c 'source odoo11-venv/bin/activate' ; /opt/odoo/odoo11-venv/bin/pip3 install --no-index --find-links=/opt/odoo/root/req/ -r odoo11/odoo/requirements.txt",
		timeout => 1000,
		creates => "/opt/odoo/odoo11-venv", 
		}  
		
	service { 'odoo11' :
		ensure => running,
		enable => true,
		}
 
}
