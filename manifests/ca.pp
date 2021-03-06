class pe_caproxy::ca {

  $masters_normalized = regsubst($::non_ca_servers,'\s', '', G)
  $masters_list = split($masters_normalized, ',')
  $fact_save_allowed = stradd($masters_list, $::clientcert)

  class { 'auth_conf::defaults':
    master_certname => $::fact_puppetmaster_certname,
  }
  augeas {'puppet.conf ca_server' :
    context       => '/files//puppet.conf/main',
    changes       => "set ca_server ${::clientcert}",
  }
  auth_conf::acl { '/certificate_revocation_list':
    auth       => 'any',
    acl_method => ['find'],
    allow      => '*',
    order      => 085,
  }
  Auth_conf::Acl <| title == 'save-/facts'|> {
    path       => '/facts',
    auth       => 'yes',
    acl_method => 'save',
    allow      => $fact_save_allowed,
    order      => 095,
  }
  exec { 'node:parameters':
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "rake node:parameters name=${::clientcert} parameters=custom_auth_conf=false",
    #  refreshonly => true,
  }
}
