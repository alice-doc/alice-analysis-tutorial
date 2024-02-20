# Fall-back manual installation method

In the first instance, you should always follow the instructions for your operating system [linked under "Prerequisites" here](custom.md#prerequisites).
This ensures that you only have a single installation of aliBuild, and that it is updated automatically with the rest of your system.

If you cannot follow the instructions linked above for any reason (such as if you are using a shared machine and you do not have administrative access), see below for alternative ways to install aliBuild.

If you follow these instructions, you are responsible for keeping aliBuild up to date manually.
Please remember to update aliBuild before asking for support, as any issues you encounter may already be solved in the latest version.

### I don't have root permissions

In case you don't have root permissions, one of the possibilities is installing aliBuild under a
user-owned directory. Start with opening your `~/.bashrc`, `~/.bash_profile`, `~/.zshrc` or `~/.zprofile`
(this depends on your system), and add the following line at the end:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Now close all your terminals and reopen them to load the new configuration.
The operations above need to be performed only once. Now, to install or upgrade aliBuild, just do:

```bash
python3 -m pip install alibuild --upgrade --user
```

> This time we did not specify `sudo` and we have added the `--user` option.

Verify you have `aliBuild` in your path:

```bash
type aliBuild
```

You are responsible for keeping aliBuild up to date manually.
You can update by running the following command:

```bash
python3 -m pip install alibuild --upgrade --user
```

Now continue by [configuring aliBuild](custom.md#configure-alibuild).

### I need a special version of aliBuild

In some cases you might want to install a "release candidate" version, or you want to get the code
directly from GitHub. By default, the last stable version is installed. **Do not install a special
version of aliBuild if you were not instructed to do so or if you don't know what you are doing, we
provide no support for unstable releases!**

First, remove any other copy of aliBuild installed on your system in any other way, to avoid conflicts.

To install a release candidate (for instance, `v1.5.1rc3`):

```bash
python3 -m pip install --user --upgrade alibuild==v1.5.1rc3
```

To install from GitHub (you can specify a tag or a hash, or another branch, instead of `master`):

```bash
python3 -m pip install --user --upgrade 'git+https://github.com/alisw/alibuild@master'
```

Now continue by [configuring aliBuild](custom.md#configure-alibuild).
