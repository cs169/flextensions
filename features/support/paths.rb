module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^Home\s?page$/
      '/'

    when /^bCourses login page$/
      '/login/canvas'

    when /^Courses page$/
      if @current_path == '/courses' && @logged_in
        @current_path
      else
        '/courses'
      end

    when /^Offerings page$/
      # For now, treat "Offerings page" as Courses page
      # since Offerings doesn't seem to exist yet
      '/courses'

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = ::Regexp.last_match(1).split(/\s+/)
        send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
              "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
