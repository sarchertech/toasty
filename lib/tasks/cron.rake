require "heroku"
require "heroku/command"
require 'heroku/command/auth'
require 'heroku/command/pgbackups'
require "aws/s3"

task :cron => :environment do
  Rake::Task['backups:backup'].invoke
end

namespace :backups do
  desc "create a pg_dump and send to S3"
  task :backup => :environment do
  
    HEROKU_USERNAME = 'learc83@gmail.com'
    HEROKU_PASSWORD = 'archer83'
    APP_NAME = ENV['APP_NAME_ENV']#'toasty24-test'
    BACKUP_BUCKET = APP_NAME + '-daily-backups'#'toasty24-test-daily-backups'
    PATH_INSIDE_BUCKET = ''
    
    class Heroku::Auth
      def self.client
        Heroku::Client.new 'learc83@gmail.com', 'archer83'
      end
    end
    
    #this is needed because run pgbackups:url returns nil, but prints url to stdout
    def capture_stdout
      out = StringIO.new
      $stdout = out
      yield
      return out.string
    ensure
      $stdout = STDOUT
    end
   
    puts "Backup started @ #{Time.now}"

    heroku = Heroku::Client.new HEROKU_USERNAME, HEROKU_PASSWORD

    puts "Capturing new pg_dump"
    Heroku::Command.run 'pgbackups:capture', ['--expire', '--app', APP_NAME]
    
    puts "Opening S3 connection"
    config = YAML.load(File.open("#{RAILS_ROOT}/config/s3.yml"))[RAILS_ENV]
    AWS::S3::Base.establish_connection!(
      :access_key_id     => config['access_key_id'],
      :secret_access_key => config['secret_access_key']
    )

    begin
      bucket = AWS::S3::Bucket.find(BACKUP_BUCKET)
    rescue AWS::S3::NoSuchBucket
      AWS::S3::Bucket.create(BACKUP_BUCKET)
      bucket = AWS::S3::Bucket.find(BACKUP_BUCKET)
    end
    
    puts "getting pg_dump url"
    url = capture_stdout { Heroku::Command.run 'pgbackups:url', ['--app', APP_NAME] }
    
    puts "Opening new pg_dump"
    #pg_backup = Heroku::Command::Pgbackups.new(['--app', APP_NAME], heroku)
    #local_pg_dump = open(pg_backup.pgbackup_client.get_latest_backup['public_url'])
    local_pg_dump = open(url)
    puts "Finished opening new pg_dump"

    puts "Uploading to S3 bucket"
    AWS::S3::S3Object.store(Time.now.to_s(:number), local_pg_dump, bucket.name + PATH_INSIDE_BUCKET)

    puts "Backup completed @ #{Time.now}"
  end
end
