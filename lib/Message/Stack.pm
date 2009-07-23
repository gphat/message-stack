package Message::Stack;
use Moose;
use MooseX::AttributeHelpers;

our $VERSION = '0.01';

has messages => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        clear => 'reset',
        count => 'count',
        empty => 'has_messages',
        first => 'first_message',
        get => 'get_message',
        last => 'last_message',
        push => 'add_to_messages',
    }
);

1;

__END__

=head1 NAME

Message::Stack - Deal with a "stack" of messages

=head1 SYNOPSIS

  my $stack = Message::Stack->new;

  $stack->add_to_messages(...);

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 ACKNOWLEDGEMENTS

Jay Shirley
Jon Wright
Mike Eldridge

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
