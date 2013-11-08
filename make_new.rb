
def create_new_user()
  puts "Github Username (case-sensitive):"
  github_username = gets.strip 
  system("curl -s -u#{github_username} https://api.github.com/user/repos -d '{\"name\":\"drive\"}'")
  Dir.chdir `echo ~`.chomp
  system("mkdir drive")
  system("cp .bash_profile drive/drive_profile.txt")
  Dir.chdir `echo drive`.chomp
  system("git init")
  system("git add .")
  system("git commit -am 'Add bash_profile to drive repo'")
  system("git remote add origin git@github.com:#{github_username}/drive.git")
  system("git push -u origin master")
end






