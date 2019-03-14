class odoo11::systemd {
	file { '/etc/systemd/system/odoo11.service' :
		ensure => 'file',
		source => "puppet:///modules/odoo11/odoo11.service",
}
}
