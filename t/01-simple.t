#!/usr/bin/perl
use strict;
use Test::More;

use Message::Stack;

my $stack = Message::Stack->new;
isa_ok($stack, 'Message::Stack');

ok(!$stack->has_messages, 'stack is empty');

$stack->add_to_messages('Foo');

cmp_ok($stack->count, '==', 1, 'message count');

ok($stack->has_messages, 'stack has messages');

$stack->add_to_messages('Bar');

cmp_ok($stack->first_message, 'eq', 'Foo', 'first message');
cmp_ok($stack->last_message, 'eq', 'Bar', 'last message');

cmp_ok($stack->get_message(0), 'eq', 'Foo', 'get message 0');

$stack->reset;

ok(!$stack->has_messages, 'stack is empty');

done_testing;

