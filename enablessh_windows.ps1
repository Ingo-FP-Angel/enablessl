Param(
   [Parameter(HelpMessage="Please specify your public ssh key to be transferred to the phone")]
   [string]$keyfile
)

if ([string]::IsNullOrWhiteSpace($keyfile)) {
    echo "Please specify your public ssh key to be transferred to the phone"
    exit 1
}

function Check-Keyfile {
param (
	[string]$filename
)
	[string]$content = Get-Content $filename

	if ($content.StartsWith("ssh-dss")) { return $true }
	if ($content.StartsWith("ssh-rsa")) { return $true }
	if ($content.StartsWith("ecdsa-sha2-nistp")) { return $true }
	return $false
}

if (!(Check-Keyfile $keyfile)) {
    echo "$keyfile does not seem to be a public key file or has the wrong format (OpenSSH public key format required)"
    exit 2
}

echo "Connect phone with USB mode 'MTP' and 'USB debugging' enabled"
echo "(CTRL-C to abort)"

adb wait-for-device

echo ""
echo "Create /home/phablet/.ssh if necessary"
adb shell test -d /home/phablet/.ssh "||" mkdir /home/phablet/.ssh "&&" chmod 700 /home/phablet/.ssh "&&" chown -R phablet.phablet /home/phablet/.ssh

echo ""
echo "Transferring keyfile $keyfile"
adb push $keyfile /home/phablet/.ssh/tempkey.pub
adb shell chmod 600 /home/phablet/.ssh/tempkey.pub

echo ""
echo "Adding key to /home/phablet/.ssh/authorized_keys if necessary"
adb shell test -f /home/phablet/.ssh/authorized_keys "||" touch /home/phablet/.ssh/authorized_keys "&&" chmod 600 /home/phablet/.ssh/authorized_keys "&&" chown -R phablet.phablet /home/phablet/.ssh/authorized_keys
adb shell grep -q -f /home/phablet/.ssh/tempkey.pub /home/phablet/.ssh/authorized_keys "||" cat /home/phablet/.ssh/tempkey.pub ">>" /home/phablet/.ssh/authorized_keys

echo ""
echo "Enabling SSH"
adb shell android-gadget-service enable ssh

echo ""
echo "Use the following IP(s) to connect"
adb shell ip addr show wlan0 "|" grep inet "|" cut -d "' '" -f 6 "|" cut -d "'/'" -f 1
