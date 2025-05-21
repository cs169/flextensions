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
      '/courses'

    when /^Course page$/
      "/courses/#{@course.id}"

    when /^Course Enrollments page$/
      "courses/#{@course.id}/enrollments"

    when /^Course Settings page$/
      "/courses/#{@course.id}/edit"

    when /^Form Settings page$/
      "/courses/#{@course.id}/form_setting/edit"

    when /^Requests page$/
      "/courses/#{@course.id}/requests"

    when /^Request Extension page$/
      "/courses/#{@course.id}/requests/new"

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
