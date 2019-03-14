class odoo11::dependencies {
$ftp_server="172.16.31.190"
        exec { 'Get dependencies' :
                cwd => "/root",
                path => '/usr/bin:/usr/sbin:/bin',
		command => "wget ftp://${ftp_server}/dependencies.tar.gz && tar -xzvf dependencies.tar.gz",
                creates => "/root/dependencies",
                } ->

        exec { 'Install dependencies':
                cwd => "/root/dependencies",
                path => '/usr/bin:/usr/sbin:/bin',
		command => "yum localinstall --disablerepo=* *.rpm -y",
                }
}

