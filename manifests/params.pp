class pe_caproxy::params
{
    $puppetmaster_conf = '/etc/puppetlabs/httpd/conf.d/puppetmaster.conf'
    $certname          = $::clientcert
    $ca_server         = $settings::ca_server
}
