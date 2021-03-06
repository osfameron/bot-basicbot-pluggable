=head1 NAME

Bot::BasicBot::Pluggable::Module::Title - speaks the title of URLs mentioned

=head1 IRC USAGE

None. If the module is loaded, the bot will speak the titles of all URLs mentioned.

=head1 VARS

=over 4

=item asciify

Defaults to 1; whether or not we should convert all titles to ascii from Unicode

=item ignore_re

If set to a nonempty string, ignore URLs matching this re

=back

=head1 REQUIREMENTS

L<URI::Title>

L<URI::Find::Simple>

=head1 AUTHOR

Tom Insam <tom@jerakeen.org>

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut

package Bot::BasicBot::Pluggable::Module::Title;
use base qw(Bot::BasicBot::Pluggable::Module);
use warnings;
use strict;

use Text::Unidecode;
use URI::Title qw(title);
use URI::Find::Simple qw(list_uris);
use URI;
sub help {
    return "Speaks the title of URLs mentioned.";
}

sub init {
    my $self = shift;
    $self->set("user_asciify",   1 ) unless defined($self->get("user_asciify"));
    $self->set("user_ignore_re", '') unless defined($self->get("user_ignore_re"));
    $self->set("user_be_rude",   0 ) unless defined($self->get("user_be_rude"));
}

sub admin {
    # do this in admin so we always get a chance to see titles
    my ($self, $mess) = @_;

    my $ignore_regexp = $self->get('user_ignore_re');

    my $reply = "";
    for (list_uris($mess->{body})) {
        next if $ignore_regexp && /$ignore_regexp/;
        my $uri   = URI->new($_);
        next unless $uri;
        if ($uri->scheme eq "file") {
             next unless $self->get("user_be_rude");
             my $who  = $mess->{who};
             $self->reply($mess, "Nice try $who, you tosser");
             return undef;
        }

        my $title = title("$_");
        next unless defined $title;
        $title = unidecode($title) if $self->get("user_asciify");
        $reply .= "[ $title ] ";
    }

    if ($reply) { $self->reply($mess, $reply) }

    return undef; # Title.pm is passive, and doesn't intercept things.
}

1;

