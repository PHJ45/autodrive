#!/bin/env ruby
# encoding: utf-8
require 'pry'
require 'colorize'
require 'fileutils'

class Executor
  def self.grab_profile(github_name)
    system ("curl -s https://raw.github.com/#{github_name}/dotfiles/master/.bash_profile > ~/hello.txt")

    if self.correct_download?
      puts "🚘  Thanks for using Drive\n"
      puts "🚘  #{github_name}'s bash_profile is now on your computer"
      puts "🚘  Type ~/.drive_profile to load it into this window"
      puts "🚘  Changes will revert when this window closes"
    else
      puts "Incorrect username. Please try again."
    end
  end

  def self.correct_download?
    Dir.chdir `echo ~`.chomp
    file = File.open('hello.txt', 'r')
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
    if !ARGV
      ##You didn't enter anything and thus need to provide an argument
    elsif ARGV.first.downcase == "new" && ARGV[1]
      puts "We will create a new drive profile with the name #{ARGV[1]}"
    elsif ARGV.first.downcase == "new"
      Executor.new_error_message
    elsif ARGV.first.downcase == "help"
      Executor.call_help
    else
      Executor.grab_profile(ARGV.first)
    end
  end
end

Brancher.call
