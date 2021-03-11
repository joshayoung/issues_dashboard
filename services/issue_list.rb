class IssueList
  include Http

  def initialize(override: false)
    @override = override
  end

  def repos
    RepoList.new.list
  end

  def list
    return static_list if @override

    @val = []
    repos.each do |repo|
      next if repo.open_issues_count == 0

      value = issues(repo)
      # TODO: Fix this so this is not created if empty:
      next if value[:issues].empty?

      @val.push(value)
    end
    @val.sort! { |a, b| b[:count] <=> a[:count] }
  end

  def issues(repo)
    part = {
      repo: repo.name,
      url: repo.url,
      issues: []
    }
    response(repo.issue_link).each do |r|
      next if r['author_association'] != 'OWNER'

      part[:issues].push(r['title'])
    end
    # TODO: Utilize a combo of 'open_issue_count' and 'author_association' instead of recounting:
    part[:count] = part[:issues].count
    part
  end
end
