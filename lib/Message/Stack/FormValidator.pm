package Message::Stack::FormValidator;
use Moose;

use Message::Stack::Message;

sub parse {
    my ($self, $stack, $scope, $results) = @_;

    if($results->success) {
        return 1;
    }

    foreach my $f ($results->missing) {
        $stack->add(Message::Stack::Message->new(
            id      => "missing_$f",
            scope   => $scope,
            subject => $f,
            level   => 'error'
        ));
    }

    foreach my $f ($results->invalid) {
        $stack->add(Message::Stack::Message->new(
            id      => "invalid_$f",
            scope   => $scope,
            subject => $f,
            level   => 'error'
        ));
    }

    return 0;
}

1;
