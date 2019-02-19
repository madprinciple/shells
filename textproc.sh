sed -n '/PRETTY_NAME/p' /etc/*release | cut -d '=' -f2

# -n ==do not print everything exept what "p" is asked
# pattern must between "/ /"
# p ==print whole line which maches.
# cut -d cut by delemeter , here i used '=' to seprate the words and print the 2nd field
