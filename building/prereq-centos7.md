aliBuild Prerequisites for CentOS 7
===================================

<!-- Dockerfile UPLOAD_NAME alisw/o2-cc7 -->
<!-- Dockerfile FROM centos:7 -->
<!-- Dockerfile RUN rpmdb --rebuilddb && yum clean all -->
For ALICE O2, CERN CentOS 7 (CC7)is the [officialy supported target platform](https://indico.cern.ch/event/642232/#3-wp3-common-tools-and-softwar). Since CC7 is CentOS 7 with additional CERN packages, instructions apply to vanilla CentOS 7 as well.

## Install or Upgrade the Required Packages

With root permissions, i.e. `sudo` or as `root` install the prerequisites using:

<!-- Dockerfile RUN_INLINE -->
```bash
cat << EOF > /etc/yum.repos.d/alice-system-deps.repo
[alice-system-deps]
name=alice-system-deps
baseurl=https://s3.cern.ch/swift/v1/alibuild-repo/RPMS/o2-full-deps_x86-64/
enabled=1
gpgcheck=0
EOF
yum update -y
yum install -y alice-o2-full-deps alibuild
```

You are now ready for [installing aliBuild and start building ALICE
software](README.md#get-or-upgrade-alibuild)

<!-- Dockerfile RUN yum install -y vim-enhanced emacs-nox -->
<!-- Dockerfile RUN rpmdb --rebuilddb && yum clean all -->
<!-- Dockerfile RUN echo "source scl_source enable devtoolset-7" >> /etc/profile -->
<!-- Dockerfile RUN echo "source scl_source enable devtoolset-7" >> /etc/bashrc -->
<!-- Dockerfile RUN pip install alibuild -->
<!-- Dockerfile RUN mkdir /lustre /cvmfs -->
<!-- Dockerfile ENTRYPOINT ["/bin/bash"] -->
