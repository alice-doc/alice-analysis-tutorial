aliBuild Prerequisites for CentOS 8
===================================

For ALICE O2, CentOS 8 (CC8) is not yet an [officialy supported target platform](https://indico.cern.ch/event/642232/#3-wp3-common-tools-and-softwar).


## Install or Upgrade the Required Packages

With root permissions, i.e. `sudo` or as `root` install the prerequisites using:

<!-- Dockerfile RUN_INLINE -->
```bash
yum install -y epel-release
yum install -y dnf-plugins-core
yum config-manager --set-enabled powertools
yum update -y

dnf group install -y "Development Tools"

cat << EOF > /etc/yum.repos.d/alice-system-deps.repo
[alice-system-deps]
name=alice-system-deps
baseurl=https://s3.cern.ch/swift/v1/alibuild-repo/RPMS/o2-full-deps_el8.x86-64/
enabled=1
gpgcheck=0
EOF
yum update -y
yum install -y alice-o2-full-deps alibuild
```

You are now ready to [start building ALICE software](README.md#get-or-upgrade-alibuild)
