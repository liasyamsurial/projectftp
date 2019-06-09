#!/usr/bin/perl

####################
# SEND FILE SERVER #
####################

  use IO::Socket ; #input output socket import

#save directory
  my $port = $ARGV[0] || 6898; #port number
  my $save_dir = './files' ; #save dir kat .file
  
#############
# START SRV #
#############

  if (! -d $save_dir) {   
    mkdir($save_dir,0755) ;
    print "Save directory created: $save_dir\n" ;
  }
  
  my $server = IO::Socket::INET->new( #server socket
      Listen => 5,
      LocalAddr => '10.0.2.15', 
      LocalPort => $port , 
      Proto     => 'tcp'
  ) or die "Can't create server socket: $!"; #if takde, keluar text
  
  print "Server opened: 10.0.2.15:$port\nWaiting clients...\n\n" ; #if boleh
  
  while( my $client = $server->accept ) { 
    print "\nNew client!\n" ;
    my ($buffer,%data,$data_content) ; #file yang dihantar
    my $buffer_size = 1 ; #means ada
    
    #data
    while( sysread($client, $buffer , $buffer_size) ) {. 
      if    ($data{filename} !~ /#:#$/) { $data{filename} .= $buffer ;}
      elsif ($data{filesize} !~ /_$/) { $data{filesize} .= $buffer ;}
      elsif ( length($data_content) < $data{filesize}) {
      
      #convert buffered jadi data
        if ($data{filesave} eq '') {
          $data{filesave} = "$save_dir/$data{filename}" ;
          $data{filesave} =~ s/#:#$// ;
          $buffer_size = 1024*10 ; #max data size
          if (-e $data{filesave}) { unlink ($data{filesave}) ;}
          print "Saving: $data{filesave} ($data{filesize}bytes)\n" ;
        }

        open (FILENEW,">>$data{filesave}") ; binmode(FILENEW) ;
        print FILENEW $buffer ;
        close (FILENEW) ;
        print "." ;        
      }
      else { last ;} 
    }
    
    print "OK\n\n" ; #if takde data dah
  }
  
#######
# END #
#######
