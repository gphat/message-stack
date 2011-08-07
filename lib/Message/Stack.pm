package Message::Stack;
use Moose;

# ABSTRACT: Deal with a "stack" of messages

use Carp qw(croak);
use MooseX::Storage;
use MooseX::Types::Moose qw(HashRef);
use Message::Stack::Message;
use Message::Stack::Types qw(MessageStackMessage);

with 'MooseX::Storage::Deferred';

=head1 SYNOPSIS

    my $stack = Message::Stack->new;

    $stack->add(Message::Stack::Message->new(
      msgid     => 'something_happened',
      level     => 'error',
      scope     => 'login_formm',
      subject   => 'username',
      text      => 'Something happened!'
    ));
    # Or... for those that want to type less
    $stack->add({
      msgid     => 'something_else_happened',
      level     => 'error',
      scope     => 'login_form',
      subject   => 'password',
      text      => 'Something else happened!'
    });

    ...
    my $errors = $stack->for_level($error);
    # Or
    my $login_form_errors = $stack->for_scope('login_form');
    $login_form_errors->for_subject('username');
    print "Username has ".$login_form_errors->count." errors.\n";

=head1 DESCRIPTION

Message::Stack provides a mechanism for storing messages until they can be
consumed.  A stack is used to retain order of occurrence.  Each message may
have a id, level, scope, subject and text.  Consult the documentation for
L<Message::Stack::Message> for an explanation of these attributes.

This is not a logging mechanism.  The original use was to store various errors
or messages that occur during processing for later display in a web
application.  The messages are added via C<add>.

=begin :prelude

=head1 NOTES

=head2 Note About msgid

msgid used to be id.  It was renamed to be a bit more description.  All the
methods that existed for id still exist and the id attribute is now aliased
to msgid. In other words if you create an object using C<id> then the msgid
methods B<and> the C<id> methods will work, and vice versa.

=head1 SERIALIZATION

This module uses L<MooseX::Storage::Deferred> to facilitate easy serialization.
Consult the documentation for L<MooseX::Storage::Deferred> options, but the
gist is:

  my $json = $stack->freeze({ format => 'JSON' });
  ...
  my $stack = Message::Stack->thaw($json, { format => 'JSON' });

=end :prelude

=attr messages

Returns the full arrayref of messages for this stack.

=method count

Returns the number of messages in the stack.

=method first_message

Returns the first message (if there is one, else undef)

=method get_message ($index)

Get the message at the supplied index.

=method has_messages

Returns true if there are messages in the stack, else false

=method last_message

Returns the last message (if there is one, else undef)

=method reset

Clear all messages, resetting this stack.

=cut

has messages => (
    traits => [ 'Array' ],
    is => 'rw',
    isa => 'ArrayRef[Message::Stack::Message]',
    default => sub { [] },
    handles => {
        reset           => 'clear',
        count           => 'count',
        has_messages    => 'count',
        first           => [ get => 0 ],
        first_message   => [ get => 0 ],
        _grep_messages  => 'grep',
        get_message     => 'get',
        last            => [ get => -1 ],
        last_message    => [ get => -1 ],
    }
);

=method add ($message)

Adds the supplied message to the stack.  C<$message> may be either a
L<Message::Stack::Message> object or a hashref with similar keys.

=cut

sub add {
    my ($self, $message) = @_;

    return unless defined($message);

    if(is_MessageStackMessage($message)) {
        push(@{ $self->messages }, $message);
    } elsif(is_HashRef($message)) {
        my $mess = Message::Stack::Message->new($message);
        push(@{ $self->messages }, $mess);
    } else {
        croak('Message must be either a Message::Stack::Message or hashref');
    }
}

sub for_id {
    my $self = shift;
    $self->for_msgid(@_);
}

=method for_msgid ($msgid)

Returns a new Message::Stack containing only the message objects with the
supplied msgid. If there are no messages for that level then the stack
returned will have no messages.

=cut

sub for_msgid {
    my ($self, $msgid) = @_;

    return $self->search(sub { $_->msgid eq $msgid if $_->has_msgid });
}

=method for_level ($level)

Returns a new Message::Stack containing only the message objects with the
supplied level. If there are no messages for that level then the stack
returned will have no messages.

=cut

sub for_level {
    my ($self, $level) = @_;

    return $self->search(sub { $_->level eq $level if $_->has_level });
}

=method for_scope ($scope)

Returns a new Message::Stack containing only the message objects with the
supplied scope. If there are no messages for that scope then the stack
returned will have no messages.

=cut

sub for_scope {
    my ($self, $scope) = @_;

    return $self->search(sub { $_->scope eq $scope if $_->has_scope });
}

=method for_subject ($subject)

Returns a new Message::Stack containing only the message objects with the
supplied subject. If there are no messages for that subject then the stack
returned will have no messages.

=cut

sub for_subject {
    my ($self, $subject) = @_;

    return $self->search(sub { $_->subject eq $subject if $_->has_subject });
}

sub has_id {
    my $self = shift;
    $self->has_msgid(@_);
}

=method has_msgid ($msgid)

Returns true if there are messages with the supplied msgid.

=cut

sub has_msgid {
    my ($self, $msgid) = @_;

    return 0 unless $self->has_messages;

    return $self->for_msgid($msgid)->count ? 1 : 0;
}

=method has_level ($level)

Returns true if there are messages with the supplied level.

=cut

sub has_level {
    my ($self, $level) = @_;

    return 0 unless $self->has_messages;

    return $self->for_level($level)->count ? 1 : 0;
}

=method has_scope ($scope)

Returns true if there are messages with the supplied scope.

=cut

sub has_scope {
    my ($self, $scope) = @_;

    return 0 unless $self->has_messages;

    return $self->for_scope($scope)->count ? 1 : 0;
}

=method has_subject ($subject)

Returns true if there are messages with the supplied subject.

=cut

sub has_subject {
    my ($self, $subject) = @_;

    return 0 unless $self->has_messages;

    return $self->for_subject($subject)->count ? 1 : 0;
}

=method search (CODEREF)

Returns a Message::Stack containing messages that return true when passed
to the coderef argument.

  $stack->search( sub { $_[0]->id eq 'someid' } )
  
=cut

sub search {
    my ($self, $coderef) = @_;

    my @messages = $self->_grep_messages($coderef);
    return Message::Stack->new(messages => \@messages);
}

=method reset_scope($scope)

Clears the stack of all messages of scope $scope.

=cut

sub reset_scope {
    my ($self, $scope) = @_;

    return 0 unless $self->has_messages;

    my $filtered = [];
    foreach my $message (@{$self->messages}) {
        next if($message->scope eq $scope);
        push @{$filtered}, $message;
    }

    $self->messages($filtered);
}

=method reset_level($level)

Clears the stack of all messages of level $level.

=cut

sub reset_level {
    my ($self, $level) = @_;

    return 0 unless $self->has_messages;

    my $filtered = [];
    foreach my $message (@{$self->messages}) {
        next if($message->level eq $level);
        push @{$filtered}, $message;
    }

    $self->messages($filtered);
}

=method reset_msgid($msgid)

Clears the stack of all messages of msgid $msgid.

=cut

sub reset_msgid {
    my ($self, $msgid) = @_;

    return 0 unless $self->has_messages;

    my $filtered = [];
    foreach my $message (@{$self->messages}) {
        next if($message->msgid eq $msgid);
        push @{$filtered}, $message;
    }

    $self->messages($filtered);
}

=method reset_subject($subject)

Clears the stack of all messages of subject $subject.

=cut

sub reset_subject {
    my ($self, $subject) = @_;

    return 0 unless $self->has_messages;

    my $filtered = [];
    foreach my $message (@{$self->messages}) {
        next if($message->subject eq $subject);
        push @{$filtered}, $message;
    }

    $self->messages($filtered);
}

=begin :postlude

=head1 CONTRIBUTORS

Jay Shirley

Stevan Little

Justin Hunter

Jon Wright

Mike Eldridge

Tomohiro Hosaka

Andrew Nelson

=end :postlude

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;
