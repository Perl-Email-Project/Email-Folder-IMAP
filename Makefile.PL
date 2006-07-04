use ExtUtils::MakeMaker;

WriteMakefile (
               AUTHOR        => 'Casey West <casey@geeknest.com>',
               ABSTRACT      => "Email::Folder Access to IMAP Folders",
               NAME          => 'Email::Folder::IMAP',
               PREREQ_PM     => {
                                 'Test::More'             => '0.47',
                                 'Email::FolderType::Net' => '',
                                 'Email::Folder::Reader'  => '',
                                 'Net::IMAP::Simple'      => '',
                                 'URI::imap'              => '',
                                },
               VERSION_FROM  => 'lib/Email/Folder/IMAP.pm',
              );
