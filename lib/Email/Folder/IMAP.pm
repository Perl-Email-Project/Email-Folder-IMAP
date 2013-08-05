use strict;
use warnings;
package Email::Folder::IMAP;
# ABSTRACT: Email::Folder Access to IMAP Folders

our $VERSION = '1.102';

use parent qw[Email::Folder::Reader];
use Net::IMAP::Simple 0.95; # :port support
use URI;

sub _imap_class {
  'Net::IMAP::Simple';
}

sub _uri {
  my $self = shift;
  return $self->{_uri} ||= URI->new($self->{_file});
}

sub _server {
  my $self = shift;
  return $self->{_server} if $self->{_server};

  my $uri = $self->_uri;

  my $host   = $uri->host_port;
  my $server = $self->_imap_class->new($host);

  my ($user, $pass) = @{$self}{qw[username password]};
  ($user, $pass) = split ':', $uri->userinfo, 2 unless $user;

  $server->login($user, $pass) if $user;

  my $box = substr $uri->path, 1;
  $server->select($box) if $box;

  $self->{_next} = 1;
  return $self->{_server} = $server;
}

sub next_message {
  my $self    = shift;
  my $message = $self->_server->get($self->{_next});
  if ($message) {
    ++$self->{_next};
    return join '', @{$message};
  }
  $self->{_next} = 1;
  return;
}

1;

=head1 SYNOPSIS

  use Email::Folder;
  use Email::FolderType::Net;
  
  my $folder = Email::Folder->new('imap://example.com'); # read INBOX
  
  print $_->header('Subject') for $folder->messages;

=head1 DESCRIPTION

This software adds IMAP functionality to L<Email::Folder|Email::Folder>.
Its interface is identical to the other
L<Email::Folder::Reader|Email::Folder::Reader> subclasses.

=head2 Parameters

C<username> and C<password> parameters may be sent to C<new()>. If
used, they override any user info passed in the connection URI.

=head2 Folder Specification

Folders are specified using a simplified form of the IMAP URL Scheme
detailed in RFC 2192. Not all of that specification applies. Here
are a few examples.

Selecting the INBOX.

  imap://foo.com

Selecting the INBOX using URI based authentication. Remember that the
C<username> and C<password> parameters passed to C<new()> will override
anything set in the URI.

  imap://user:pass@foo.com

Selecting the p5p list.

  imap://foo.com/perl/perl5-porters

=head1 SEE ALSO

L<Email::Folder>,
L<Email::Folder::Reader>,
L<Email::FolderType::Net>,
L<URI::imap>,
L<Net::IMAP::Simple>.
