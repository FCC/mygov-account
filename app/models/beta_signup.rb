class BetaSignup < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email, {:allow_blank => true}
  validates_email_format_of :email, {:allow_blank => true}
  before_create :approve_dot_gov_emails
  after_save :send_beta_invite

  attr_accessible :email, :ip_address, :referrer, :as => [:default, :admin]
  attr_accessible :is_approved, :as => :admin
  
  private
  
  def send_beta_invite
    (rand(2) == 0 ? UserMailer.beta_invite_a(self.email).deliver : UserMailer.beta_invite_b(self.email).deliver) if is_approved_changed? && is_approved == true
  end
  
  def approve_dot_gov_emails    
    self.is_approved = true if self.email.end_with?(".gov")
  end
end
