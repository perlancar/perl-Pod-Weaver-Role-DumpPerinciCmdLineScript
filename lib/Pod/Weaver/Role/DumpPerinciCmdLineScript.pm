package Pod::Weaver::Role::DumpPerinciCmdLineScript;

# DATE
# VERSION

use 5.010001;
use Moose::Role;

use File::Slurper qw(write_binary);
use Perinci::CmdLine::Dump;

sub dump_perinci_cmdline_script {
    my ($self, $input) = @_;

    # find file object
    my $file;
    for (@{ $input->{zilla}->files }) {
        if ($_->name eq $input->{filename}) {
            $file = $_;
            last;
        }
    }
    die "Can't find file object for $input->{filename}" unless $file;

    # because we need an actual file for Perinci::CmdLine::Dump, we'll dump the
    # content of the file object to a temp file first. this includes DZF:OnDisk
    # object too, because the content and the name might not match actual file
    # on the filesystem anymore (e.g. see DZP:AddFile::FromFS where the file
    # object has its name() changed).
    my $tempname;
    {
        require File::Temp;
        (undef, $tempname) = File::Temp::tempfile();
        write_binary($tempname, $file->content);
    }

    Perinci::CmdLine::Dump::dump_perinci_cmdline_script(
        filename => $tempname,
        libs => ['lib'],
    );
}

no Moose::Role;
1;
# ABSTRACT: Role to dump Perinci::CmdLine script

=head1 METHODS

=head2 $obj->dump_perinci_cmdline_script($input)


=head1 SEE ALSO

L<Dist::Zilla::Role::DumpPerinciCmdLineScript>
