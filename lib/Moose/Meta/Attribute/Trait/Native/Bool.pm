package Moose::Meta::Attribute::Trait::Native::Bool;
use Moose::Role;
use Moose::Meta::Attribute::Trait::Native::MethodProvider::Bool;

our $VERSION   = '0.87';
$VERSION = eval $VERSION;
our $AUTHORITY = 'cpan:STEVAN';

with 'Moose::Meta::Attribute::Trait::Native';

sub _default_is { 'rw' }
sub _helper_type { 'Bool' }

# NOTE: we don't use the method provider for this module since many of
# the names of the provided methods would conflict with keywords - SL

has 'method_provider' => (
    is        => 'ro',
    isa       => 'ClassName',
    predicate => 'has_method_provider',
    default   => 'Moose::Meta::Attribute::Trait::Native::MethodProvider::Bool'
);

no Moose::Role;

1;

=pod

=head1 NAME

Moose::Meta::Attribute::Trait::Native::Bool

=head1 SYNOPSIS

  package Room;
  use Moose;
  use Moose::AttributeHelpers;

  has 'is_lit' => (
      metaclass => 'Bool',
      is        => 'rw',
      isa       => 'Bool',
      default   => 0,
      handles   => {
          illuminate  => 'set',
          darken      => 'unset',
          flip_switch => 'toggle',
          is_dark     => 'not',
      }
  );

  my $room = Room->new();
  $room->illuminate;     # same as $room->is_lit(1);
  $room->darken;         # same as $room->is_lit(0);
  $room->flip_switch;    # same as $room->is_lit(not $room->is_lit);
  return $room->is_dark; # same as !$room->is_lit

=head1 DESCRIPTION

This provides a simple boolean attribute, which supports most of the
basic math operations.

=head1 METHODS

=over 4

=item B<meta>

=item B<method_constructors>

=item B<has_method_provider>

=item B<method_provider>

=back

=head1 PROVIDED METHODS

It is important to note that all those methods do in place
modification of the value stored in the attribute.

=over 4

=item I<set>

Sets the value to C<1>.

=item I<unset>

Set the value to C<0>.

=item I<toggle>

Toggle the value. If it's true, set to false, and vice versa.

=item I<not>

Equivalent of 'not C<$value>'.

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Jason May

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2009 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
