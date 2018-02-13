default['yum']['rpmforge']['repositoryid'] = 'rpmforge'
default['yum']['rpmforge']['description'] = 'RHEL $releasever - RPMforge.net - dag'
case platform_version.to_i
when 5
  default['yum']['rpmforge']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge'
when 6
  default['yum']['rpmforge']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge'
when 2013
  default['yum']['rpmforge']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge'
end
default['yum']['rpmforge']['enabled'] = true
default['yum']['rpmforge']['managed'] = true
default['yum']['rpmforge']['gpgcheck'] = true
default['yum']['rpmforge']['gpgkey'] = 'ftp://ftp.is.freebsd.org/pub/repoforge/RPM-GPG-KEY.dag.txt'
