aliBuild Prerequisites for Alma 9
===================================

## Install or Upgrade the Required Packages

With root permissions, i.e. `sudo` or as `root` install the prerequisites using:

<!-- Dockerfile RUN_INLINE -->
```bash
dnf install -y epel-release dnf-plugins-core
dnf update -y
dnf group install -y 'Development Tools'
cat << EOF > /etc/yum.repos.d/alice-system-deps.repo
[alice-system-deps]
name=alice-system-deps
baseurl=https://s3.cern.ch/swift/v1/alibuild-repo/RPMS/o2-full-deps_el9.x86-64/
enabled=1
gpgcheck=0
EOF
dnf update -y
dnf install -y alice-o2-full-deps alibuild
```

You are now ready to [start building ALICE software](README.md#get-or-upgrade-alibuild)
