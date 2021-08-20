aliBuild Prerequisites for CentOS 7
===================================

For ALICE O2, CERN CentOS 7 (CC7)is the [officialy supported target platform](https://indico.cern.ch/event/642232/#3-wp3-common-tools-and-softwar). Since CC7 is CentOS 7 with additional CERN packages, instructions apply to vanilla CentOS 7 as well.

## Install or Upgrade the Required Packages

With root permissions, i.e. `sudo` or as `root` install the prerequisites using:

```bash
cat << EOF > /etc/yum.repos.d/alice-system-deps.repo
[alice-system-deps]
name=alice-system-deps
baseurl=https://s3.cern.ch/swift/v1/alibuild-repo/RPMS/o2-full-deps_x86-64/
enabled=1
gpgcheck=0
EOF
yum update -y
yum install -y alice-o2-full-deps 
yum update -y
yum install -y alibuild
```

You are now ready to [start building ALICE software](README.md#get-or-upgrade-alibuild)

