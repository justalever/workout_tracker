module ApplicationHelper

  def workout_author(workout)
    user_signed_in? && current_user.id == workout.user_id
  end

  def verbose_date(date)
    date.strftime('%B %d, %Y')
  end

  def has_subdomain
    user_signed_in? && current_user.subdomain
  end

  def verify_subdomain_presence
    request.subdomains.present?
  end

end
