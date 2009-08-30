package Message::Stack::DataVerifier;
use Moose;

use Message::Stack::Message;

sub parse {
    my ($self, $stack, $scope, $results) = @_;

    foreach my $f ($results->missings) {
        $stack->add(Message::Stack::Message->new(
            id      => "missing_$f",
            scope   => $scope,
            subject => $f
        ));
    }

    foreach my $f ($results->invalids) {
        $stack->add(Message::Stack::Message->new(
            id      => "invalid_$f",
            scope   => $scope,
            subject => $f
        ));
    }
}

1;