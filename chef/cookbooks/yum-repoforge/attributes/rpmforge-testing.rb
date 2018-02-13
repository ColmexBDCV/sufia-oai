default['yum']['rpmforge-testing']['repositoryid'] = 'rpmforge-testing'
default['yum']['rpmforge-testing']['description'] = 'RHEL $releasever - RPMforge.net - testing'
case platform_version.to_i
when 5
  default['yum']['rpmforge-testing']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge-testing'
when 6
  default['yum']['rpmforge-testing']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge-testing'
when 2013
  default['yum']['rpmforge-testing']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge-testing'
end
default['yum']['rpmforge-testing']['enabled'] = false
default['yum']['rpmforge-testing']['managed'] = false
default['yum']['rpmforge-testing']['gpgcheck'] = true
default['yum']['rpmforge-testing']['gpgkey'] = 'ftp://ftp.is.freebsd.org/pub/repoforge/RPM-GPG-KEY.dag.txt'
