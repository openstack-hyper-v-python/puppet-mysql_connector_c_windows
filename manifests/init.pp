class mysql_connector_c_windows (
    $version     = $mysql_connector_c_windows::params::version,
    $url         = $mysql_connector_c_windows::params::url,
    $package     = $mysql_connector_c_windows::params::package,
    $file_path   = false,
) inherits mysql_connector_c_windows::params {
    if $file_path {
        $mysql_connector_installer_path = $file_path
    } else {
        $mysql_connector_installer_path = "${::temp}\\${package}-${version}.msi"
    }
    windows_common::remote_file{'mysql_connector':
        source      => $url,
        destination => $mysql_connector_installer_path,
        before      => Package[$package],
    }
        
    package { $package:
        ensure          => installed,
        source          => $mysql_connector_installer_path,
        install_options => ['/quiet'],
    }

    $mysql_connector_path = 'C:\\Program Files (x86)\\MySQL\\MySQL Connector C 6.0.2\\bin'
 
    windows_path { $mysql_connector_path:
        ensure  => present,
        require => Package[$package],
    }
}
