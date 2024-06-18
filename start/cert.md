Get a Grid certificate
======================

We will illustrate how to get, renew, register and prepare your digital certificates to use the
ALICE Grid services.


## Obtain a digital certificate

Your home institute may provide you with a digital certificate. However, we reccommend you get one
from CERN, because the procedure is very easy and automated when you have a CERN account.

* [Generate a new CERN Grid User
   certificate](https://ca.cern.ch/ca/user/Request.aspx?template=EE2User)

You will be asked whether you want to protect your certificate with a password. Note that in most
cases you will not be allowed to import the certificate if you don't specify a password, so please
protect it with a password.

_⚠️ This is not your CERN password. Use a new, arbitrary one._

Proceed until you get a message saying that your certificate is ready to be downloaded: click on it
and a file called `myCertificate.p12` will be downloaded.


## Register your certificate in your browser

There are several ways to add your newly downloaded certificate to your browser, and they depend on
the browser and the operating system. We will focus on Firefox as an example.

Open Firefox, go to the **Preferences**, select **Privacy and security** on the left hand menu.
Scroll the settings page to the bottom and click on the **Show certificates...** button.

A new window will open: click the **Personal certificates** tab. Click **Import...** and select the
`myCertificate.p12` file you have just generated. Type the password you have used in the
previous step (this is not your CERN password).

Your newly imported certificate will appear in the list.


## Add the CERN Grid certificates to your browser

In case you navigate to an ALICE HTTPS site and you get a security warning, it is probably because
your browser does not have any means to recognize the site as valid.

_⚠️ Most people ignore security exceptions. **Do not do that, ever.** This is bad, very bad. Someone
can steal your data. For real. Without you knowing it._

Go to [this site](https://cafiles.cern.ch/cafiles/certificates/Grid.aspx), there are two links at
the bottom of the page saying "CERN Root/Grid Certification Authority", etc.: with Firefox as your
browser, click on both of them, and Firefox will ask you if you want to "trust" them: say "yes" to
all questions.


## Test your browser setup

Navigate to the [ALICE Grid monitoring](https://alimonitor.cern.ch/) page. If you have your personal
certificate installed, and the CERN Grid certificates installed as well, Firefox should ask you to
select a certificate to be used to authenticate to the site.

In case you have many, select the one that identifies you (it should have your full name somewhere)
issued by the CERN Grid Certification Authority, and tell Firefox to remember it.

You should be able to see the page without further ado. Next to the address bar, a green lock icon
should appear. If you see broken locks, red icons, warnings of various kinds, then there is some
kind of security problem and you should repeat the steps above.


## Register your certificate to the ALICE Grid

This operation needs to be performed only once. With Firefox, click on [this
link](https://voms2.cern.ch:8443/voms/alice](https://alien.web.cern.ch/content/register-alice-virtual-organization) and follow the guided procedure, after having selected
your personal certificate for authenticating.


## Convert your certificate for using the Grid tools

Keep at hand the `myCertificate.p12` file you have previously downloaded. You need to convert it
into two files (a "certificate" and a "key") in order to use the ALICE Grid services from the
command line.

You will export your certificates to the following directory:

```
~/.globus
```

Now export the **certificate** with the following command (you will be prompted for the export
password you have selected when you have generated it):

```bash
openssl pkcs12 -clcerts -nokeys -in ~/Downloads/myCertificate.p12 -out ~/.globus/usercert.pem
```

The result will be a file called `usercert.pem` in your `~/.globus` directory. Note that
your input file ending with `.p12` may have a different name and may be stored in a different
location.

Time to export the **private key**:

```bash
openssl pkcs12 -nocerts -in ~/Downloads/myCertificate.p12 -out ~/.globus/userkey.pem
chmod 0400 ~/.globus/userkey.pem
```

When it says:

```
Enter Import Password:
```

you should provide it with the export password you have entered when you generated it. The next
question will be:

```
Enter PEM pass phrase:
```

You should provide it with _another_ password that will be used to protect the private key. You can
use the same password as before if you want, but please **do not use your CERN password** (yes, we
are stressing this point _a lot_). This question will be asked twice for confirmation.


## Test your certificate

Your certificate will be available to the ALICE Grid command line client.

Enter your ALICE environment and create a "temporary access token":

```bash
alienv enter AliPhysics/latest
alien-token-destroy
alien-token-init YOUR_ALIEN_USERNAME
```

_⚠️ This assumes you have completed your [installation](../building/README.md). You do not have
either `alienv` or the `alien-token-*` commands available in case you have never done it._

The `alien-token-init` command will ask you for a password. This is the last password you have used
when you have converted your `.p12` certificate into two `.pem` files.

{% callout "Creating JAliEn and AliEn tokens" %}
Note that the new JAliEn Grid clients automatically create tokens, while AliEn-ROOT-Legacy (ROOT5) requires running _alien-token-init_ manually.
There is _alien-token-init_ for JAliEn, and you can use it to test your credentials or (re)create tokens manually.
{% endcallout %}
