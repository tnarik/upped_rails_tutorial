require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'Sample App') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
  
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
      let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet") }

      before do
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "pagination of microposts" do

        before(:all) { 60.times { FactoryGirl.create(:micropost, user: user, content: "some content") } }
        after(:all) { user.microposts.destroy }
        it "should paginate" do
          page.should have_selector('div.pagination')
        end
  
        it "should list each micropost" do
          user.microposts.paginate(page: 1).each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
        end
      end

      describe "count of microposts" do
        before do
          m1.destroy
          m2.destroy
          visit root_path
        end

        it "should have the correct starting count for microposts" do
          page.should have_content("#{user.feed.count} microposts")
        end

        it "should have the correct count for microposts for 1" do
          FactoryGirl.create(:micropost, user: user, content: "A new microposts 1")
          visit root_path
          page.should have_content("#{user.feed.count} micropost")
          page.should_not have_content("#{user.feed.count} microposts")
        end

        it "should have the correct count for microposts for several" do
          FactoryGirl.create(:micropost, user: user, content: "A new microposts 2")
          FactoryGirl.create(:micropost, user: user, content: "A new microposts 3")
          visit root_path
          page.should have_content("#{user.feed.count} microposts")
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1',    text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1',    text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
  end
end