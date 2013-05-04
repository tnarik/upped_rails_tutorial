require "spec_helper"

describe UserMailer do
  describe "signup_confirmation" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      UserMailer.signup_confirmation(user).deliver
    end

    it "delivers the mail" do
      UserMailer.deliveries.length.should  == 1
      last_email.should_not be_blank
    end

    describe "the mail delivered" do
      subject(:mail) { last_email }

      it "is sent with the right subject" do
        mail.subject.should eq("Please verify your e-mail address to access: Tnarik's great app")
      end
      it "is sent to the right address" do
        mail.to.should include(user.email)
      end
      it "is sent from registrations@upped.me" do
        mail.from.should include("registrations@upped.me")
      end

      it { should be_multipart }
      it { should have(1).attachments }
      describe "the first part" do
        subject(:first_part) { mail.parts[0] }

        it "has alternatives" do
          should be_multipart
          first_part.mime_type.should match("multipart/alternative")
        end

        describe "the text version" do
          subject(:text_part) { first_part.text_part }

          its(:mime_type) { should match("text/plain") }
          it "renders the body" do
            text_part.body.encoded.should match("Hi #{user.name}")
            text_part.body.encoded.should match(verify_url(user.verification_token))
          end
        end

        describe "the html version" do
          subject(:html_part) { first_part.html_part }

          its(:mime_type) { should match("text/html") }
          it "renders the body" do
            html_part.body.encoded.should match("Hi #{user.name}")
            html_part.body.encoded.should have_link("Verification", href: verify_url(user.verification_token))
          end
          it "uses the inline attachment" do
            html_part.body.should match("src=\"cid:#{mail.attachments[0].cid}")
          end
        end
      end

      describe "the first attachment" do
        subject(:first_attachment) { mail.attachments[0] }

        it { should be_inline }
        its(:mime_type) { should match("image/png") }
        its(:filename) { should match("rails.png") }
      end
    end

  end
end