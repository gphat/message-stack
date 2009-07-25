package Message::Stack::Types;
use Moose;

use MooseX::Types -declare => [qw(Message)];
use MooseX::Types::Moose qw(HashRef);

use Message::Stack::Message;

subtype Message,
    as class_type 'Message::Stack::Message';

coerce Message,
    from HashRef,
    via {
        print STDERR "WTF\n";
        Message::Stack::Message->new(
            id      => $_->{id},
            level   => $_->{level},
            scope   => $_->{scope},
            subject => $_->{subject},
            text    => $_->{scope}
        )
    };

no Moose;
1;