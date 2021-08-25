require "octokit"

# these need to be set
GH_TOKEN = ""
CHECKOUT = "../"

JAM_REPO = "langjam/jam0001"

Octokit.configure do |c|
  c.access_token = GH_TOKEN
  c.auto_paginate = true
end

CLIENT = Octokit::Client.new


participants_by_teamname = Dir.glob("#{CHECKOUT}/*/TEAM").filter_map do |file|
  teamname = file.split("/")[-2]
  next nil if teamname == "TEMPLATE"
  [teamname, File.read(file).split.map(&:downcase).to_set]
end.to_h

all_participants = participants_by_teamname.values.inject(Set.new, &:union)
puts "all participants: \n#{all_participants.join("\n")}"
puts

issues = CLIENT.issues(JAM_REPO).filter {|issue| issue.title.start_with? "Team:"}

def get_reactions(issue)
  acc = []
  page_number = 1
  loop do
    reactions = CLIENT.issue_reactions(JAM_REPO, issue.number, per_page: 100,
                                       page: page_number)
    break if reactions.empty?
    acc.concat(reactions)
    page_number += 1
  end

  acc
end

thumbs_up_givers_by_teamname = issues.map do |issue|
  teamname = issue.title.delete_prefix("Team: ").strip
  givers = get_reactions(issue).filter {|reaction| reaction.content == "+1"}
                               .map {|reaction| reaction.user.login.downcase}
  [teamname, givers.to_set]
end.to_h

thumbs_up_givers_by_teamname.each do |teamname, givers|
  (givers - all_participants).each do |non_participant|
    puts "non-participant #{non_participant} voted for #{teamname}, removing"
    givers.delete(non_participant)
  end

  (givers & participants_by_teamname.fetch(teamname)).each do |self_voter|
    puts "team member #{self_voter} voted for #{teamname}, removing"
    givers.delete(self_voter)
  end
end

thumbs_up_givers_by_teamname.sort_by {|_, givers| givers.size}.each do |teamname, givers|
  puts "#{teamname}: #{givers.size}"
end
