package Moose::Exception::Role::Class;

use Moose::Util 'throw_exception';
use Moose::Role;

has 'class' => (
    is        => 'rw',
    isa       => 'Class::MOP::Class',
    lazy      => 1,
    builder   => '_build_class',
    predicate => 'is_class_set',
);

has 'class_name' => (
    is        => 'ro',
    isa       => 'Str',
    lazy      => 1,
    builder   => '_build_class_name',
    predicate => 'is_class_name_set',
);

sub _build_class {
    my $self = $_[0];
    Class::MOP::class_of( $self->class_name );
}

sub _build_class_name {
    my $self = $_[0];
    $self->class->name;
}

sub _has_class_or_class_name {
    my $self = shift;

    return ( $self->is_class_name_set || $self->is_class_set );
}

after "BUILD" => sub {
    my $self = $_[0];

    if( !$self->_has_class_or_class_name() )
    {
        throw_exception("NeitherClassNorClassNameIsGiven");
    }
    elsif( $self->is_class_set && $self->is_class_name_set &&
           ( $self->class->name ne $self->class_name ) )
    {
        throw_exception( ClassNamesDoNotMatch => class_name => $self->class_name,
                                                 class      => $self->class,
                       );
    }
};

1;
