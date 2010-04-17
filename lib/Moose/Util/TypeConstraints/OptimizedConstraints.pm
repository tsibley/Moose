package Moose::Util::TypeConstraints::OptimizedConstraints;

use strict;
use warnings;

use Class::MOP;

our $VERSION   = '1.01';
$VERSION = eval $VERSION;
our $AUTHORITY = 'cpan:STEVAN';


sub InlineValue {
    'defined($_[0]) && !ref($_[0])';
}
sub InlineRef { 'ref($_[0])' }

# We need to use a temporary here to flatten LVALUEs, for instance as in
# Str(substr($_,0,255)).
sub InlineStr {
    q{my $value = $_[0];}
        . q{defined($value) && ref(\$value) eq 'SCALAR'}
}

sub InlineNum {
    q{!ref($_[0]) && Scalar::Util::looks_like_number($_[0])}
}

sub InlineInt {
    q{defined($_[0]) && !ref($_[0]) && $_[0] =~ /^-?[0-9]+$/}
}

sub InlineScalarRef { q{ref($_[0]) eq 'SCALAR' || ref($_[0]) eq 'REF'} }
sub InlineArrayRef  { q{ref($_[0]) eq 'ARRAY'}                         }
sub InlineHashRef   { q{ref($_[0]) eq 'HASH'}                          }
sub InlineCodeRef   { q{ref($_[0]) eq 'CODE'}                          }
sub InlineRegexpRef { q{ref($_[0]) eq 'Regexp'}                        }
sub InlineGlobRef   { q{ref($_[0]) eq 'GLOB'}                          }

sub InlineFileHandle {
        q{(ref($_[0]) eq 'GLOB' && Scalar::Util::openhandle($_[0]))}
  . q{ or (Scalar::Util::blessed($_[0]) && $_[0]->isa('IO::Handle'))}
}

sub InlineObject {
    q{Scalar::Util::blessed($_[0]) && Scalar::Util::blessed($_[0]) ne 'Regexp'}
}

sub Role { Carp::cluck('The Role type is deprecated.'); Scalar::Util::blessed($_[0]) && $_[0]->can('does') }

sub InlineClassName { q{Class::MOP::is_class_loaded($_[0])} }

sub InlineRoleName {
    InlineClassName()
  . q{ && (Class::MOP::class_of($_[0]) || return)->isa('Moose::Meta::Role')}
}

# NOTE:
# we have XS versions too, ...
# 04:09 <@konobi> nothingmuch: konobi.co.uk/code/utilsxs.tar.gz
# 04:09 <@konobi> or utilxs.tar.gz iirc

1;

__END__

=pod

=head1 NAME

Moose::Util::TypeConstraints::OptimizedConstraints - Optimized constraint
bodies for various moose types

=head1 DESCRIPTION

This file contains the hand optimized versions of Moose type constraints,
no user serviceable parts inside.

=head1 FUNCTIONS

=over 4

=item C<InlineValue>

=item C<InlineRef>

=item C<InlineStr>

=item C<InlineNum>

=item C<Int>

=item C<ScalarRef>

=item C<ArrayRef>

=item C<HashRef>

=item C<CodeRef>

=item C<RegexpRef>

=item C<GlobRef>

=item C<FileHandle>

=item C<Object>

=item C<Role>

=item C<ClassName>

=item C<RoleName>

=back

=head1 BUGS

See L<Moose/BUGS> for details on reporting bugs.

=head1 AUTHOR

Yuval Kogman E<lt>nothingmuch@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2009 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
