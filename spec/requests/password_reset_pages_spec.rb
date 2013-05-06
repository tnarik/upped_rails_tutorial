require 'spec_helper'

describe "password resets" do
  subject { page }

  before { visit signin_path }
  let(:forgot) { "password" }
  let(:reset_request) { "reset" }
  let(:user) { FactoryGirl.create(:active_user) }

  context "when trying to sign in" do
    it { should have_link(forgot, href: new_password_reset_path) }
  
    describe "in the password reset page" do
      before { click_link forgot }

      it { should have_field('Email') }
      it { should have_button(reset_request) }

      describe "a non existing e-mail is provided" do
        before do
          fill_in "Email", with: "wrong@email.com"
          click_button reset_request
        end

        it "should display an error" do
          should have_error_message('that e-mail is unknown to us')
        end

        it "not e-mail should be sent" do
          last_email.should be_blank
        end
      end

      describe "an existing e-mail is provided" do
        before do
          fill_in "Email", with: user.email
          click_button reset_request
          user.reload
        end

        it "should sent an email" do
          last_email.should_not be_blank
          last_email.to.should include(user.email)
          last_email.body.encoded.should match(edit_password_reset_url(user.password_reset_token))
        end
        it "should display a password reset e-mail sent page" do
          current_path.should eq password_resets_path
          should have_selector('title', text: full_title("Password reset sent"))
          should have_content("e-mail sent")
        end

        describe "after visiting the reset link" do
          before do
            visit edit_password_reset_url(user.password_reset_token)
          end

          it { should have_field('Password') }
          it { should have_field('Confirm Password') }
          it "the password should be updated if recently requested" do
            fill_in "Password",         with: "new_password"
            fill_in "Confirm Password", with: "new_password"
            click_button "password"
            page.should have_success_message("Password has been reset")
          end

          it "the password should be not updated if recently requested" do
            user.password_reset_sent_at = 25.hour.ago
            user.save
            fill_in "Password",         with: "new_password"
            fill_in "Confirm Password", with: "new_password"
            click_button "password"
            page.should have_error_message("Password reset has expired")
          end

          it "raises record not found when password token is invalid" do
            lambda {
              visit edit_password_reset_url("invalid")
            }.should raise_exception(ActiveRecord::RecordNotFound)
          end
        end

      end
    end
  end
end