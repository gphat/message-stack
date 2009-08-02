#!/usr/bin/perl
use strict;
use Test::More;

use Message::Stack;
use Message::Stack::Message;

my $stack = Message::Stack->new;
isa_ok($stack, 'Message::Stack');

ok(!$stack->has_messages, 'stack is empty');

$stack->add_to_messages({ text => 'Foo' });

cmp_ok($stack->count, '==', 1, 'message count after hash');

ok($stack->has_messages, 'stack has messages');

$stack->add_to_messages(Message::Stack::Message->new(
    text => 'Bar'
));

cmp_ok($stack->count, '==', 2, 'message count after obj');

ok(defined($stack->first_message), 'first message');
cmp_ok($stack->first_message->text, 'eq', 'Foo', 'first message text');
cmp_ok($stack->last_message->text, 'eq', 'Bar', 'last message');

cmp_ok($stack->get_message(0)->text, 'eq', 'Foo', 'get message 0');

$stack->reset;

ok(!$stack->has_messages, 'stack is empty');

done_testing;

