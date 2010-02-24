package Message::Stack::Types;
use MooseX::Types -declare => [ qw( MessageStackMessage ) ];

class_type MessageStackMessage, { class => 'Message::Stack::Message' };

1;
