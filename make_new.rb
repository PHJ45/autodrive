puts "Github User Name?"
gitname = gets.strip 

system("curl -s -u#{gitname} https://api.github.com/user/repos -d '{\"name\":\"autodrive_profile\"}'")
Dir.chdir `echo ~`.chomp
system("mkdir autodrive")
system("pwd")
system("cp .bash_profile autodrive/autodrive_profile.txt")
Dir.chdir `echo autodrive`.chomp
system("git init")
system("git add .")
system("git commit -am 'Create autodrive_profile'")
system("git remote add origin git@github.com:#{gitname}/autodrive_profile.git")
system("git push -u origin master")






