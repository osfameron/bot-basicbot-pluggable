=head1 NAME

Bot::BasicBot::Pluggable::Module::Infotweet - tweet some factoids

=head1 SYNOPSIS

=head1 IRC USAGE

  <user> bot: gbjk is also secretly a furry
   <bot> user: okay.

=head1 METHODS

=cut

package Bot::BasicBot::Pluggable::Module::Infotweet;
use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;

use Data::Dumper;
use Net::Twitter;

sub init {
    my $self = shift;
    $self->set('user_username', '') unless $self->get('user_username');
    $self->set('user_password', '') unless $self->get('user_password');
    $self->set('user_tweetwords', '') unless $self->get('user_tweetwords');
}

sub help {
    return "Tweeter";
}

sub seen { # priority 0, so will see it
    my ($self, $mess) = @_;
    my $body = $mess->{body} || "";

    my $is_priv = !defined $mess->{channel} || $mess->{channel} eq 'msg';

    my %tweetwords = map { lc($_) => 1 } split(/\s*[\s,\|]\s*/, $self->get("user_tweetwords"));

    my $nick = $self->bot->nick;
    my ($object, $is, $factoid) = $body=~/^(?:no(?:, $nick, )?\s*)?(\w+)\s+(is|are)\s+(.*$)/;
    return unless $tweetwords{$object};

    my $username = $self->get('user_username');
    my $password = $self->get('user_password');

    return unless $username && $password;

    my $twit = Net::Twitter->new({username=>$username, password => $password});

    my $result = $twit->update({status => "#$object $is $factoid"});
}

=head1 VARS

=over 4

=item tweetwords

=item username

=item password

=back

=head1 BUGS

=head1 REQUIREMENTS

=head1 AUTHOR

osfameron April 2009

Based on ::Infobot by Tom Insam <tom@jerakeen.org>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut

1;
