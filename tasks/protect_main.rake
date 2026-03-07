desc "Protect main branch using GitHub API"
task :protect_main do
  unless system('command -v gh > /dev/null 2>&1')
    puts "Error: gh CLI is not installed. Please install GitHub CLI (https://cli.github.com/) and authenticate before running this task."
    exit 1
  end

  # Autodetect owner and repo from git remote
  git_remote = `git remote get-url origin`.strip
  unless git_remote =~ /github.com[:\/](?<owner>[^\/]+)\/(?<repo>[^\/]+)(?:\.git)?$/
    puts "Could not detect GitHub repository from git remote URL: #{git_remote}"
    exit 1
  end
  owner = Regexp.last_match[:owner]
  repo = Regexp.last_match[:repo]

  # Detect default branch using GitHub CLI
  branch = `gh repo view #{owner}/#{repo} --json defaultBranchRef --jq .defaultBranchRef.name`.strip
  if branch.empty?
    puts "Could not detect default branch for #{owner}/#{repo}"
    exit 1
  end

  body = <<~JSON
    {
      "required_pull_request_reviews": {
        "require_code_owner_reviews": false
      },
      "enforce_admins": true,
      "required_linear_history": true,
      "allow_force_pushes": false,
      "allow_deletions": false,
      "required_status_checks": {
        "strict": true,
        "contexts": []
      },
      "restrictions": null
    }
  JSON

  puts "Applying branch protection to: #{owner}/#{repo} (branch: #{branch})"
  cmd = "gh api --method PUT \"/repos/#{owner}/#{repo}/branches/#{branch}/protection\" --input - --header 'Accept: application/vnd.github.luke-cage-preview+json'"
  response = nil
  IO.popen(cmd, 'r+') do |io|
    io.puts body
    io.close_write
    response = io.read
  end
  begin
    json = JSON.parse(response)
    if json['message']
      puts "GitHub API error: #{json['message']}"
      puts "See: #{json['documentation_url']}"
      puts "Response status: #{json['status']}"
      exit 1
    else
      puts "Branch protection applied successfully!"
    end
  rescue JSON::ParserError
    puts "Branch protection applied. Response:\n#{response}"
  end
end
