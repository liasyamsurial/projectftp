####################
# SEND FILE CLIENT #
####################

  use IO::Socket ;
  $bandwidth = 1024*5 ; # 5Kb/s 
  
  #{0} filename, 1 port
  &send_file( $ARGV[0] , $ARGV[1]||'localhost' , $ARGV[2]||6898 ) ;
  
  exit;

#############
# SEND_FILE method #
#############

#definition 
sub send_file {
  my ( $file , $host , $port ) = @_ ; #taknak value 0
  
  if (! -s $file) { die "ERROR! Can't find or blank file $file" ;}
  my $file_size = -s $file ; #-s size file
  
  my ($file_name) = ( $file =~ /([^\\\/]+)[\\\/]*$/gs ); #excludekan tanda semua after ~
  
  my $sock = new IO::Socket::INET( #buat socket
     PeerAddr => $host,
     PeerPort => $port,
     Proto    => 'tcp',
     Timeout  => 30) ;

  if (! $sock) { die "ERROR! Can't connect\n" ;}
  $sock->autoflush(1); #hantar/flush data stream
  
  print "Sending $file_name\n$file_size bytes." ;
  
  print $sock "$file_name#:#" ; # send the file name.
  print $sock "$file_size\_" ; # send the size of the file to server.

  open (FILE,$file) ; binmode(FILE) ; #binary mode

  my $buffer ;
  while( sysread(FILE, $buffer , $bandwidth) ) {
    print $sock $buffer ;
    print "." ;
    sleep(1) ; #delay 1 s
  }
  
  print "OK\n\n" ;
  
  close (FILE) ;
  close($sock) ;
}

#######
# END #
#######
