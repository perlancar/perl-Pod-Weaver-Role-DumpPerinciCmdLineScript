package Pod::Weaver::Role::DumpPerinciCmdLineScript;

# DATE
# VERSION

use 5.010001;
use Moose::Role;

use Perinci::CmdLine::Dump;

sub dump_perinci_cmdline_script {
    my ($self, $input) = @_;

    my $filename = $input->{filename};

    # find file object
    my $file;
    for (@{ $input->{zilla}->files }) {
        if ($_->name eq $filename) {
            $file = $_;
            last;
        }
    }
    die "Can't find file object for $filename" unless $file;

    # if file object is not a real file on the filesystem, put it in a temporary
    # file first so Perinci::CmdLine::Dump can see it.
    unless ($file->isa("Dist::Zilla::File::OnDisk")) {
        my ($fh, $tempname) = tempfile();
        print $fh $file->content;
        close $fh;
        $filename = $tempname;
    }

    Perinci::CmdLine::Dump::dump_perinci_cmdline_script(
        filename => $filename,
        libs => ['lib'],
    );
}

no Moose::Role;
1;
# ABSTRACT: Role to dump Perinci::CmdLine script

=head1 METHODS

=head2 $obj->dump_perinci_cmdline_script($input)

