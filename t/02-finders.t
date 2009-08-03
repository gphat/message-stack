#!/usr/bin/perl
use strict;
use Test::More;

use Message::Stack;
use Message::Stack::Message;

my $stack = Message::Stack->new;

$stack->add({
    text => 'Foo',
    level => 'error',
    scope => 'bar',
    subject => 'ass'
});

$stack->add({
    text => 'Foo',
    level => 'info',
    scope => 'baz',
    subject => 'clown'
});

ok($stack->has_messages_for_level('info'), 'has_messages_for_level');
my $errors = $stack->get_messages_for_level('error');
cmp_ok($errors->count, '==', 1, 'get_messages_for_level: 1');
cmp_ok($errors->has_messages_for_level('info'), '==', 0, 'has_messages_for_level on retval');

ok($stack->has_messages_for_scope('bar'), 'has_messages_for_scope');
my $bazes = $stack->get_messages_for_scope('baz');
cmp_ok($bazes->count, '==', 1, 'get_messages_for_scope: 1');
cmp_ok($bazes->has_messages_for_scope('bar'), '==', 0, 'has_messages_for_scope on retval');

ok($stack->has_messages_for_subject('ass'), 'has_messages_for_subject');
my $asses = $stack->get_messages_for_subject('ass');
cmp_ok($asses->count, '==', 1, 'get_messages_for_subject: 1');
cmp_ok($asses->has_messages_for_subject('clown'), '==', 0, 'has_messages_for_subject on retval');

done_testing;