# frozen_string_literal: true

class Repo
  def initialize; end

  def list
    names = []
    @list ||= begin
      all_repos.each { |resp| names << "#{resp['url']}/issues" }
      names
    end
  end

  def all_repos
    @all_repos ||= begin
      repos = HTTParty.get(ENV['REPOS'], headers: authorization_header)
      JSON.parse(repos.body)
    end
  end

  def authorization_header
    { 'Authorization' => "token #{ENV['TOKEN']}" }
  end
end