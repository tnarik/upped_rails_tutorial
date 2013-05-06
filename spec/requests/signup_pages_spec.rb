require 'spec_helper'

describe "signup page" do
  subject { page }

  before { visit signup_path }
  let(:submit) { "Create my account" }

  describe "with invalid information" do
    it "should not create a user" do
      expect { click_button submit }.not_to change(User, :count)
    end

    describe "after submission" do
      before { click_button submit }

      it { should have_selector('title', text: 'Sign up') }
      it { should have_content('error') }
    end
  end

  describe "with valid information" do
    before do
      fill_in "Name", with: "Example User"
      fill_in "Email", with: "user@example.com"
      fill_in "Password", with: "foobar"
      fill_in "Confirm Password", with: "foobar"
    end
    
    it "should create a user" do
      expect { click_button submit }.to change(User, :count).by(1)
    end

    describe "after saving the user" do
      before do
        click_button submit
      end

      describe "the user requires verification" do
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: "Waiting for verification") }
        it { should have_success_message('Welcome') }

        it "a verification e-mail is sent" do
          UserMailer.deliveries.length.should == 1
          last_email.should_not be_blank
        end

        describe "while not verified" do
          let(:user) { User.find_by_email('user@example.com') }

          it "login attempts render errors and redirect to the sign in" do
            visit signin_path
            fill_in "Email",    with: "user@example.com"
            fill_in "Password", with: "foobar"
            click_button "Sign in"

            should have_selector('title', text: 'Waiting for verification')
            should have_notice_message('requires verification')

            should_not have_link('Profile')
            should_not have_link('Settings')  
          end

          it "received the correct verify link" do
            last_email.parts[0].text_part.body.encoded.should match(email_verification_url(user.verification_token))
          end

          it "can visit the correct verify link" do
            visit email_verification_url(user.verification_token)
          end

          it "cannot visit protected pages" do
            visit user_path(user)
            current_path.should eq root_path
            should have_selector('title', text: full_title(""))
            visit edit_user_path(user)
            current_path.should eq signin_path
            should have_selector('title', text: full_title("Sign in"))
            visit users_path(user)
            current_path.should eq signin_path
            should have_selector('title', text: full_title("Sign in"))
          end
        end
      end

      describe "after verifying the user e-mail" do
        let(:user) { User.find_by_email('user@example.com') }

        before do
          visit email_verification_url(user.verification_token)
        end

        it { should have_selector('title', text: user.name) }
        it { should have_link('Sign out') }

        it "the user is active" do
          user.reload
          user.should be_active
        end

        it "cannot visit the verify link" do
          visit email_verification_url(user.verification_token)
        end

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end

  end

end