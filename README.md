# Odinbook

[Odinbook](https://dna-odinbook.herokuapp.com/ "Odinbook") is a [test-driven development](http://en.wikipedia.org/wiki/Test-driven_development "Test Driven Development") of a Facebook clone. It was created as the final project for The Odin Project's [Ruby on Rails](http://www.theodinproject.com/ruby-on-rails/final-project "Ruby on Rails Final Project") and [Javascript and jQuery](http://www.theodinproject.com/javascript-and-jquery/final-project "Javascript jQuery Final Project") courses.

See the log in/sign up page below

![Odinbook Log In/Sign Up page](/public/assets/images/login_signup.png "Odinbook Log In/Sign Up page")

### [_See Odinbook on Heroku here_](https://dna-odinbook.herokuapp.com/ "Odinbook")

You are encouraged to create an account, but if you want to get a feel of Odinbook first, you may log in with any of the following emails (all having a password of `password`):

- socrates@example.com
- plato@example.com
- aristotle@example.com
- locke@example.com
- nietzsche@example.com

## Tests

Run the test suite with `rake` or `rspec spec/`.

## Main Features

1. [Log in required to view content](#log-in-required "Log In Required")
1. [Social network style friending](#friending "Friending")
1. [Lists of users with different friendship categories](#lists-of-users "Lists of Users")
1. [Posts, comments, and likes](#posts-comments-likes "Posts, Comments, Likes")
1. [Newsfeed and timeline](#newsfeed-and-timeline "Newsfeed and Timeline")
1. [User profile with picture](#profile-with-picture "Profile with Picture")
1. [Customizable access](#customizable-access "Customizable Access")
1. [Email](#email "Email")
1. [Search](#search "Search")
1. [Overall look and styling](#look-and-styling "Look and Styling")

## Enhancing Features

To improve user experience, several of the features listed above incorporate one or more of the following enhancing features

- **Ajax requests** (_used extensively_): When an action affects a small section of the page you are viewing (for example, if you like a post), an Ajax request is used to update just that page section without a full page reload.

- **Realtime updates**: When another user of Odinbook performs an action that affects the page you are viewing (for example, comment on a post you are viewing), your page is instantly notified of the change and updated to reflect the change. Realtime updates uses [websockets](https://github.com/websocket-rails/websocket-rails "Websocket-Rails") and Ajax requests.

- **Infinite scroll**: For pages with potentially lots of content (for example, your newsfeed), new content is loaded as you scroll through the page. Infinite scroll uses [pagination](https://github.com/mislav/will_paginate "Will Paginate") and Ajax requests.

The details of main features below states which main features have these enhancement.

## Details of Main Features

#### Log In Required

Authentication checks permit a non-logged in user to see only the log in/sign up page and static pages. Log in/sign up is done with [Devise](https://github.com/plataformatec/devise "Devise") including Facebook log in/sign up using [OmniAuth with Devise](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview "OmniAuth: Overview").

Static pages include: [_About_](https://dna-odinbook.herokuapp.com/about "About"), [_Contact/Help_](https://dna-odinbook.herokuapp.com/contact_help "Contact or Help"), [_Privacy Policy_](https://dna-odinbook.herokuapp.com/privacy "Privacy Policy"), and [_Terms of Service_](https://dna-odinbook.herokuapp.com/terms "Terms of Service").

#### Friending

Users can send friend requests, which must be accepted before two users become friends. Friend requests may also be rejected.

Realtime update for notification of friend request is shown in a user's header navbar.

#### Lists of Users

A user can see lists of users in the following categories, relative to themselves

- _All Users_: all users of Odinbook
- _Friends_: all their friends
- _Friend Requests_: all users who have sent them a friend request
- _Find Friends_: users not friends with them and who have no friend request from or to them

Users in each list are displayed with buttons for friending (ie, sending a friend request), unfriending, or accepting or rejecting a friend request (depending on their category). All these lists of users use Ajax requests and infinite scroll

#### Posts, Comments, Likes

Users can create and delete posts, create and delete comments on posts, and like/unlike posts and comments. They all use Ajax requests and realtime updates. Liking/unliking posts or comments is implemented as a polymorphic association.

A post is associated with 2 users (a creator and a receiver) who may be the same (when a user posts on their own newsfeed or timeline) or different (when a user posts on a friend's timeline).

#### Newsfeed and Timeline

Newsfeed contains all posts created or received by a user or a user's friends; timeline contains all posts created or received by a user.

Infinite scroll is used for the posts in newsfeeds and timelines; realtime updates and Ajax requests are used for post and comment creation and deletion, and liking/unliking, in newsfeeds and timelines.

#### Profile with Picture

A user's profile may be modified at any time and consists of a few optional pieces of information and two required ones

- choice of who can access their posts and profile (all users or only friends)
- choice of whether they want to receive email of notifications (yes or no)

The form used to update profiles and the one used for sign up have both client-side validation (with [jQuery Validate](https://github.com/jzaefferer/jquery-validation "jQuery Validation")) and server-side validation (with the sign up form using an Ajax request to ensure that a new user's email is not already in use).

Users may upload a profile picture (limited to 500KB). **_Uploading a profile picture can take about 5 to 7 seconds...be patient._** This picture is processed with [Paperclip](https://github.com/thoughtbot/paperclip "Paperclip") and stored with AWS S3 storage. If a user does not have a picture uploaded, there is a graceful degradation to the gravatar image associated with the user's email.

#### Customizable Access

Odinbook implements a number of sensible authorizations, like allowing only a comment's creator, or a post's creator or receiver, or a like's creator, or the sender or receiver of a friend request to destroy the comment/post/like/friendship; and allowing only a profile's owner to edit the profile.

In addition, as stated in the preceding section, a user may restrict who can view their posts and profile information to only friends (or leave it at all users). This setting is used to guide part of the authorization in Odinbook, given below

- users have access to only their newsfeed and they may create posts, comments, and likes there
- users have access to their timeline as well as that of their friends, from where they may create posts, comments, and likes
- users may visit the timeline of non-friends who have a public profile and view posts and comments there as well as like those posts and comments, but they may not comment on those posts or create posts
- users may visit the timeline of non-friends with access restricted to friends, but they will see no posts or profile there

#### Email

A onetime welcome email is sent to a new user during sign up. After that, an email is sent to a user when she/he has a new notification; however, this may be disabled from a user's profile.

#### Search

Users may use the search form in the header to search for other users of Odinbook. Results are displayed in a specialized page with infinite scroll.

#### Look and Styling

Overall, Odinbook is made to have a close look to Facebook (obviously, with less content and features). To achieve this, styling was done without external styling frameworks (except for jQuery UI dialog modal used to replace the default browser confirmation dialog).

A little unobtrusive Javascript is also used to

- replace pagination with infinite scroll
- shrink and expand the textarea used to make posts
- show a post's comment link and focus on the post's comment input when that comment link is clicked
- limit comments displayed for a post initially to 4 and show all comments for the post when the 'View more comments' link is clicked.

---

If you've made it through reading all this, congratulation...now you really should head over to [**_Odinbook_**](https://dna-odinbook.herokuapp.com/ "Odinbook").
