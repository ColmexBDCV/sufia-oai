default['yum']['rpmforge-extras']['repositoryid'] = 'rpmforge-extras'
default['yum']['rpmforge-extras']['description'] = 'RHEL $releasever - RPMforge.net - extras'
case platform_version.to_i
when 5
  default['yum']['rpmforge-extras']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge-extras'
when 6
  default['yum']['rpmforge-extras']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge-extras'
when 2013
  default['yum']['rpmforge-extras']['mirrorlist'] = 'http://repoforge.mirror.digitalpacific.com.au/redhat/el6/en/mirrors-rpmforge-extras'
end
default['yum']['rpmforge-extras']['enabled'] = true
default['yum']['rpmforge-extras']['managed'] = true
default['yum']['rpmforge-extras']['gpgcheck'] = true
default['yum']['rpmforge-extras']['gpgkey'] = 'ftp://ftp.is.freebsd.org/pub/repoforge/RPM-GPG-KEY.dag.txt'
