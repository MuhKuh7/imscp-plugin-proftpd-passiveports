# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# @category    i-MSCP
# @copyright   2010-2013 by i-MSCP | http://i-mscp.net
# @author      Peter Wyss <github@obanax.ch>
# @link        http://i-mscp.net i-MSCP Home Site
# @license     http://www.gnu.org/licenses/gpl-2.0.html GPL v2

=head1 NAME

 Plugins::Proftpd::PassivePorts - Plugin allowing to configure passive ports for ProFTPD

=cut

package Plugins::Proftpd::PassivePorts;

use strict;
use warnings;

use iMSCP::Debug;
use iMSCP::HooksManager;
use iMSCP::Execute;
use iMSCP::File;

# Configuration variables.
my $portMin = '49152';
my $portMax = '65534';

=head1 DESCRIPTION

 Plugin allowing to configure passive ports for ProFTPD.

 How to install:
 - Edit configuration variables above
 - Put this file into the /etc/imscp/hooks.d directory (create it if it doesn't exists)
 - Make this file only readable by root user (chmod 0600);

=head1 PUBLIC METHODS

=over 4

=item configurePassivePorts()

 Add the passive ports to proftpd.conf

 Return int 0

=cut

sub configurePassivePorts
{
	my $fileContent = shift;

	my $newFileContent = '';
	my $found = 0;

	my $passivePorts = "PassivePorts               $portMin $portMax";

	
	# handle case when PassivePorts is already in the file but commented out
	if ($$fileContent =~ /^#PassivePorts/m && $$fileContent !~ /^PassivePorts/m) {
		$$fileContent =~ s/^#PassivePorts.*/$passivePorts/m;
	}
	# handle case when PassivePorts is already in the file
	elsif ($$fileContent =~ /^PassivePorts/m) {
		$$fileContent =~ s/^PassivePorts.*/$passivePorts/m;
	}
	# otherwise put the line at the end
	else {
		$$fileContent .= "\n$passivePorts";
	}

    0;
}

my $hooksManager = iMSCP::HooksManager->getInstance();
$hooksManager->register('afterFtpdBuildConf', \&configurePassivePorts);

=back

=head1 AUTHOR

 Peter Wyss <github@obanax.ch>

=cut

1;