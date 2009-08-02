#!/usr/bin/perl
use strict;
use Test::More;

use Message::Stack;
use Message::Stack::Message;

my $stack = Message::Stack->new;

$stack->add_to_messages({
    text => 'Foo',
    level => 'error',
    scope => 'bar'
});

$stack->add_to_messages({
    text => 'Foo',
    level => 'info',
    scope => 'baz'
});

ok($stack->has_messages_for_level('info'), 'has_messages_for_level');
my $errors = $stack->get_messages_for_level('error');
cmp_ok($errors->count, '==', 1, 'get_messages_for_level: 1 error');
cmp_ok($errors->has_messages_for_level('info'), '==', 0, 'has_messages_for_level on retval');

ok($stack->has_messages_for_scope('bar'), 'has_messages_for_scope');
my $bazes = $stack->get_messages_for_scope('baz');
cmp_ok($bazes->count, '==', 1, 'get_messages_for_scope: 1 error');
cmp_ok($bazes->has_messages_for_scope('bar'), '==', 0, 'has_messages_for_scope on retval');

done_testing;