#!perl
use strict;
use Test::More;

use Message::Stack;
use Message::Stack::Message;

my $msg1 = Message::Stack::Message->new({
    msgid => 'messageone',
    text => 'Foo',
    level => 'error',
    scope => 'bar',
    subject => 'ass'
});

my $msg2 = Message::Stack::Message->new({
    msgid => 'messagetwo',
    text => 'Foo',
    level => 'info',
    scope => 'baz',
    subject => 'clown'
});

# reset_for_scope
my $scope_stack = Message::Stack->new;
$scope_stack->add($msg1);
$scope_stack->add($msg2);

cmp_ok($scope_stack->count, '==', 2, 'Two in the scope stack before');
$scope_stack->reset_for_scope('bar');
cmp_ok($scope_stack->count, '==', 1, 'One in the scope stack after');


# reset_for_subject
my $subject_stack = Message::Stack->new;
$subject_stack->add($msg1);
$subject_stack->add($msg2);

cmp_ok($subject_stack->count, '==', 2, 'Two in the subject stack before');
$subject_stack->reset_for_subject('clown');
cmp_ok($subject_stack->count, '==', 1, 'One in the subject stack after');


# reset_for_level
my $level_stack = Message::Stack->new;
$level_stack->add($msg1);
$level_stack->add($msg2);

cmp_ok($level_stack->count, '==', 2, 'Two in the level stack before');
$level_stack->reset_for_level('info');
cmp_ok($level_stack->count, '==', 1, 'One in the level stack after');


# reset_for_msgid
my $msgid_stack = Message::Stack->new;
$msgid_stack->add($msg1);
$msgid_stack->add($msg2);

cmp_ok($msgid_stack->count, '==', 2, 'Two in the msgid stack before');
$msgid_stack->reset_for_msgid('messagetwo');
cmp_ok($msgid_stack->count, '==', 1, 'One in the msgid stack after');


done_testing;
