package Message::Stack::Message;
use Moose;

# ABSTRACT: Message!

use MooseX::Aliases;
use MooseX::Storage;

with 'MooseX::Storage::Deferred';

=head1 SYNOPSIS

  my $stack = Message::Stack->new;

  $stack->add(
    Message::Stack::Message->new(
        msgid => 'I18NName',
        level => 'error',
        scope => 'loginform'
        subject => 'username',
        text => 'You forgot a password'
    )
  );

=head1 DESCRIPTION

The Message object formalizes the messages that are added to the stack.  None
of the fields are required, as it's up to the developer to decide what to use.

=begin :prelude

=head1 NOTES

=head2 Note About msgid

msgid used to be id.  It was renamed to be a bit more description.  All the
methods that existed for id still exist and the id attribute is now aliased
to msgid. In other words if you create an object using C<id> then the msgid
methods B<and> the C<id> methods will work, and vice versa.

=end :prelude

=attr msgid

String identifier for this message.  Intended for use with gettext or similar
I18N mechanisms wherein a message id is used to identity the translated
text for a message.

=method has_msgid

Returns true if this Message has a msgid.

=cut

has msgid => (
    is => 'rw',
    isa => 'Maybe[Str]',
    predicate => 'has_msgid',
    alias => 'id'
);

=attr level

String attribute used to describe the level of this message.  Intended for use
with strings like 'error' or 'info'.

=method has_level

Returns true if this Message has a level.

=cut

has level => (
    is => 'rw',
    isa => 'Maybe[Str]',
    predicate => 'has_level'
);

=attr params

An optional ArrayRef of params.  This is provided for localization of messages,
where id may correspond to a Gettext style string and the params may
represent some placeholder values.

=method has_params

Returns true if this Message has params.

=cut

has params => (
    is => 'rw',
    isa => 'ArrayRef',
    predicate => 'has_params'
);

=attr scope

String identitying the scope of a message.  Used for cases when multiple
subsystems might be emitting messages and a mechanism for grouping them is
necessary.  A common case would be a form with multiple fieldsets.

=method has_scope

Returns true if this Message has a scope.

=cut

has scope => (
    is => 'rw',
    isa => 'Maybe[Str]',
    predicate => 'has_scope'
);

=attr subject

String identifying the subject of a message.  Used to identify a particular
element to which this message is pertinent.  Common case is an individual
field in a form.

=method has_subject

Returns true if this Message has a subject.

=cut

has subject => (
    is => 'rw',
    isa => 'Maybe[Str]',
    predicate => 'has_subject'
);

=attr text

String containing the human readable form of the message.  Often used in
situations when I18N is not required.

=method has_text

Returns true if this Message has text.

=cut

has text => (
    is => 'rw',
    isa => 'Maybe[Str]',
    predicate => 'has_text'
);

sub has_id {
    my ($self) = @_;

    return $self->has_msgid;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;