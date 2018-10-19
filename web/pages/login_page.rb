class LoginPage < Howitzer::Web::Page
  path '/'
  validate :url, %r{^.*:\/\/#{Regexp.escape(Howitzer.app_host)}\/(#|\?next=home)?$}
  validate :element_presence, :signup_container

  element :signup_container, '.landing-page .main-header-wrapper > div > div'
  element :reset_password, '[role=button][data-name=toggle-reset-password-form-button]'
  element :email_reset, :fillable_field, 'input-landingpage-email-reset'
  element :reset_button, '[role=button][data-name=reset-password-submit-button]'
  element :error_message, :xpath, ".//*[contains(@d,'M23.693')]/../../following-sibling::*"
  element :field, :xpath, ->(type) { ".//fieldset/*[.//input[@type='#{type}']]" }
  element :modal_content, '.modal-content'
  element :login, :fillable_field, 'email'
  element :password, :fillable_field, 'password'
  element :init_login, :xpath, ".//*[@role='button' and .='Log in']"
  element :init_signup, :xpath, ".//*[@role='button' and .='Sign up']"
  element :login_button, '[role=button][data-name=login-submit-button]'
  element :signup_button, '[role=button][data-name=signup-form-submit-button]'
  element :signup_w_email, '[role=button][data-name=reveal-password-form-button]'
  element :toggle_login_signup, '[role=button][data-name=toggle-between-login-and-signup-button]'
  element :message, '[data-name=snackbar] > *'

  def signup_as(params)
    puts Capybara.current_session.evaluate_script('navigator.userAgent;')
    Howitzer::Log.info "Sign up as: #{params}"
    retryable(tries: 3) do |try|
      reload unless try.zero?
      open_modal { init_signup_element.click }
      within_modal_content_element do
        toggle_login_signup_element.click if has_login_button_element?(wait: 0.5)
        signup_w_email_element.click if has_signup_w_email_element?(wait: 0.5)
        fill_in(login_element, params[:login])
        fill_in(password_element, params[:password])
        signup_button_element(wait: 0.5).click
      end
      msg = error_message('email')
      msg = error_message('password') if msg.empty?
      msg = message if msg.empty?
      break if (!msg.empty? && msg != 'Too many requests. Try it later, please.' && msg != 'No internet connection.') ||
               has_no_signup_container_element?(wait: 5) || current_url.include?('onboarding')
      Howitzer::Log.warn(msg.empty? ? 'retrying...' : msg)
      raise
    end
  end

  def open_modal
    retryable(tries: 3, sleep: 1) do
      break if has_modal_content_element?(wait: 0.5)
      within_signup_container_element(match: :first) { yield }
      raise
    end
  end

  def fill_in(element, text)
    retryable(tries: 5, sleep: 0.5) do
      break if element.value == text
      element.set ''
      element.set text
      raise
    end
  end

  def reset_password(email)
    open_modal { init_login_element.click }
    within_modal_content_element do
      toggle_login_signup_element.click if has_signup_w_email_element?(wait: 0.5)
      Howitzer::Log.info "Click on 'Reset password?'"
      reset_password_element.click
      Howitzer::Log.info "Fill in email field with: #{email} and apply"
      email_reset_element.set email
      reset_button_element.click
    end
  end

  # CHECKS

  def message
    has_message_element?(wait: 3, match: :first) ? message_element(match: :first).text : ''
  end

  def error_message(type)
    within_modal_content_element(wait: 0.5) do
      within_field_element(type, wait: 0.5) do
        has_error_message_element?(wait: 3) ? error_message_element.text : ''
      end
    end
  rescue
    ''
  end
end
