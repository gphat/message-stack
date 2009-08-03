package Message::Stack;
use Moose;
use MooseX::AttributeHelpers;

use Carp qw(croak);
use Check::ISA;

our $VERSION = '0.02';

has messages => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef[Message::Stack::Message]',
    default => sub { [] },
    provides => {
        clear => 'reset',
        count => 'count',
        empty => 'has_messages',
        first => 'first_message',
        get => 'get_message',
        last => 'last_message',
    }
);

sub add {
    my ($self, $message) = @_;

    return unless defined($message);

    if(obj($message, 'Message::Stack::Message')) {
        push(@{ $self->messages }, $message);
    } elsif(ref($message) eq 'HASH') {
        my $mess = Message::Stack::Message->new($message);
        push(@{ $self->messages }, $mess);
    } else {
        croak('Message must be either a Message::Stack::Message or hashref');
    }
}

sub get_messages_for_level {
    my ($self, $level) = @_;

    return 0 unless $self->has_messages;

    my @messages = ();
    foreach my $m (@{ $self->messages }) {
        next unless defined($m->level);
        push(@messages, $m) if $m->level eq $level;
    }

    return Message::Stack->new(
        messages => \@messages
    );
}

sub get_messages_for_scope {
    my ($self, $scope) = @_;

    return 0 unless $self->has_messages;

    my @messages = ();
    foreach my $m (@{ $self->messages }) {
        next unless defined($m->scope);
        push(@messages, $m) if $m->scope eq $scope;
    }

    return Message::Stack->new(
        messages => \@messages
    );
}

sub get_messages_for_subject {
    my ($self, $subject) = @_;

    return 0 unless $self->has_messages;

    my @messages = ();
    foreach my $m (@{ $self->messages }) {
        next unless defined($m->subject);
        push(@messages, $m) if $m->subject eq $subject;
    }

    return Message::Stack->new(
        messages => \@messages
    );
}

sub has_messages_for_level {
    my ($self, $level) = @_;

    return 0 unless $self->has_messages;

    foreach my $m (@{ $self->messages }) {
        next unless defined($m->level);
        return 1 if $m->level eq $level;
    }

    return 0;
}

sub has_messages_for_scope {
    my ($self, $scope) = @_;

    return 0 unless $self->has_messages;

    foreach my $m (@{ $self->messages }) {
        next unless defined($m->scope);
        return 1 if $m->scope eq $scope;
    }

    return 0;
}

sub has_messages_for_subject {
    my ($self, $subject) = @_;

    return 0 unless $self->has_messages;

    foreach my $m (@{ $self->messages }) {
        next unless defined($m->subject);
        return 1 if $m->subject eq $subject;
    }

    return 0;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__

=head1 NAME

Message::Stack - Deal with a "stack" of messages

=head1 SYNOPSIS

  my $stack = Message::Stack->new;

  $stack->add(Message::Stack::Message->new(
      id        => 'something_happened',
      level     => 'error',
      scope     => 'login_form',
      subject   => 'username',
      text      => 'Something happened!'
  ));
  ...
  my $errors = $stack->get_messages_for_level($error);
  # Or
  my $login_form_errors = $stack->get_messges_for_scope('login_form');

=head1 DESCRIPTION

Message::Stack provides a mechanism for storing messages until they can be
consumed.  A stack is used to retain order of occurrence.  Each message may
have a level, scope, subject and text.  Consult the documentation for
L<Message::Stack::Message> for an explanation of these attributes.

This is not a logging mechanism.  The original use was to store various errors
or messages that occur during processing for later display in a web
application.  The messages are added via C<add_message>.

=head1 METHODS

=head2 add ($message)

Adds the supplied message to the stack.  C<$message> may be either a
L<Message::Stack::Message> object or a hashref with similar keys.

=head2 count

Returns the number of messages in the stack.

=head2 first_message

Returns the first message (if there is one, else undef)

=head2 get_message ($index)

Get the message at the supplied index.

=head2 get_messages_for_level ($level)

Returns a new Message::Stack containing only the message objects with the
supplied level. If there are no messages for that level then the stack
returned will have no messages.

=head2 get_messages_for_scope ($scope)

Returns a new Message::Stack containing only the message objects with the
supplied scope. If there are no messages for that scope then the stack
returned will have no messages.

=head2 get_messages_for_subject ($subject)

Returns a new Message::Stack containing only the message objects with the
supplied subject. If there are no messages for that subject then the stack
returned will have no messages.

=head2 has_messages

Returns true if there are messages in the stack, else false

=head2 has_messages_for_level ($level)

Returns true if there are messages with the supplied level.

=head2 has_messages_for_scope ($scope)

Returns true if there are messages with the supplied scope.

=head2 has_messages_for_subject ($subject)

Returns true if there are messages with the supplied subject.

=head2 last_message

Returns the last message (if there is one, else undef)

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
