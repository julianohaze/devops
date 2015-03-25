class mysql::server {
	#instala o mysql-server
	package { "mysql-server":
		ensure => installed,
	}
	
	#cria o arquivo allow_external.cnf para permitir acesso externo ao mysql
	file { "/etc/mysql/conf.d/allow_external.cnf":
		owner   => mysql,
		group   => mysql,
		mode    => 0644,
		content => template("mysql/allow_ext.cnf"),
		require => Package["mysql-server"],
		notify  => Service["mysql"],
	}
   
   #inicia o serviço do mysql-server
	service { "mysql":
		ensure     => running,
		enable     => true,
		hasstatus  => true,
		hasrestart => true,
		require    => Package["mysql-server"],
	}
	
	#remove o usuário anônimo do mysql
	exec { "remove-anonymous-user":
		command => "mysql -uroot -e \"DELETE FROM mysql.user \
	                                  WHERE user=''; \
	                                  FLUSH PRIVILEGES\"",
		onlyif  => "mysql -u' '",
		path    => "/usr/bin",
		require => Service["mysql"],
	}
}
