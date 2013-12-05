#!/bin/env ruby
# encoding: utf-8
require 'colorize'
require 'fileutils'

class Executor
  def self.grab_profile(github_name)
    system ("curl -s https://raw.github.com/#{github_name}/drive/master/drive.txt > ~/drive.txt")

    if self.correct_download?
      puts "🚘  Thanks for using Drive\n"
      puts "🚘  #{github_name}'s bash_profile is now on your computer"
      puts "🚘  Type source ~/.drive.txt to load it into this window"
      puts "🚘  Changes will revert when this window closes"
    else
      puts "Incorrect username. Please try again."
    end
  end

  def create_new_user()
    puts "Github Username (case-sensitive):"
    github_username = gets.strip 
    system("curl -s -u#{github_username} https://api.github.com/user/repos -d '{\"name\":\"drive\"}'")
    Dir.chdir `echo ~`.chomp
    system("mkdir drive")
    system("cp .bash_profile drive/drive.txt")
    Dir.chdir `echo drive`.chomp
    system("git init")
    system("git add .")
    system("git commit -am 'Add bash_profile to drive repo'")
    system("git remote add origin git@github.com:#{github_username}/drive.git")
    system("git push -u origin master")
  end



  def self.correct_download?
    Dir.chdir `echo ~`.chomp
    file = File.open('drive.txt', 'r')
    good_request = true
    file.each_line do |line|
      if line[/Page not found/]
        good_request = false
      end
    end
    good_request
  end


  def self.call_help
    puts "🚘\nDrive helps you use your familiar keyboard shortcuts\nwhen you are using someone else's computer.\nType `drive [NAME]` to download someone's drive profile from Github.\n\nType `drive new [YOURNAME] to create a\nnew drive profile (based on your bash profile)\nand create a repo for it on Github.\n"
  end

  def self.new_error_message
    puts "🚘\nYou entered 'new', but must specify your github user name"   
  end
end


class Brancher
  def self.call
    puts "Welcome to Drive"
    if !ARGV
    elsif ARGV.first == "new" && ARGV[1]
      puts "We will create a new drive profile with the name #{ARGV[1]}"
      Executor. create_new_user(ARGV[1])
    elsif ARGV.first == "new"
      Executor.new_error_message
    elsif ARGV.first == "help"
      Executor.call_help
    else
      Executor.grab_profile(ARGV.first)
    end
  end
end

Brancher.call
