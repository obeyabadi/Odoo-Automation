class odoo11::conf {
$my_ip=$::ipaddress	
	file {'/etc/odoo.conf':
		ensure => 'file',
		content	=> template('odoo11/odoo.conf'),
}
}
