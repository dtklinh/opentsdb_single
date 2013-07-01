<h1>*** Ubuntu & Debian</h1>
Highlight note for definition file definition.rb:
<pre>
:boot_cmd_sequence => [
  '<Esc><Esc><Enter>',
    '/install/vmlinuz noapic preseed/url=http://%IP%:%PORT%/preseed.cfg ',
    'debian-installer=en_US auto locale=en_US kbd-chooser/method=us ',
    'hostname=%NAME% ',
    'fb=false debconf/frontend=noninteractive ',
    'keyboard-configuration/modelcode=DE keyboard-configuration/layout=DE     'keyboardconfiguration/variant=DE console-setup/ask_detect=false ',
'partman-basicfilesystems/no_swap=false ',
    'initrd=/install/initrd.gz -- <Enter>'
],
</pre>
