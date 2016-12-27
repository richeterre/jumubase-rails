Jumubase
========

Jumubase is a tool for organizers of Germany's largest youth music competition – [Jugend musiziert][jugend-musiziert], or "Jumu" in short. The software currently powers [jumu-nordost.eu][jumu-nordost], a competition hub for various German schools in Europe.

The application serves two main user groups:

* Jumu __participants__ and their families, friends and teachers; they can sign up for a contest, edit their information, and check schedules and results __without a user account.__
* Jumu __organizers__ on both the local and international level, who can manage contest data, enter results and print contest-related material. The permissions for this are granted via __personal user accounts.__

Jumubase also exposes some of its public data via a JSON API that serves mobile clients for [Android][jumu-nordost-react-native] and [iOS][jumu-nordost-ios].

[jugend-musiziert]: https://en.wikipedia.org/wiki/Jugend_musiziert
[jumu-nordost]: http://www.jumu-nordost.eu
[jumu-nordost-react-native]: https://github.com/richeterre/jumu-nordost-react-native
[jumu-nordost-ios]: https://github.com/richeterre/jumu-nordost-ios

## Setup instructions

0. Clone this codebase
0. Copy `.env-example` file to `.env`, and adjust values as needed
0. Install PostgreSQL, e.g. through [Postgres.app][postgres-app]

_You'll need to run all `rails` and `rake` commands through a command-line tool that makes configuration variables from your `.env` file available, such as [Heroku Local][heroku-local] or [dotenv][dotenv]. This means that you might need to prefix the commands below with `heroku local:run` or a similar command._

0. Create the local development database: `rake:db:create`
0. Set up the database: `rake db:setup`
0. Run the Rails server: `rails server`

[postgres-app]: http://postgresapp.com/
[heroku-local]: https://devcenter.heroku.com/articles/heroku-local
[dotenv]: https://github.com/bkeepers/dotenv

## Documentation

### Domain-related models

Most models of this app are inextricably linked with the "Jugend musiziert" competition. The following list serves as a brief explanation to those unfamiliar with the domain:

__User__<br />
A user of the software, [identified](#authentication) by their email and password.

__Host__<br />
An institution, typically a school, that can host contests.

__Venue__<br />
A physical location, associated with a host, where performances are held.

__Contest__<br />
A single or multi-day event that forms the basic entity of Jugend musiziert. It has a _season_ (= competition year), and a _round_ (RW, LW or BW).

__Category__<br />
A set of constraints for participating in a contest. There are solo and ensemble categories, e.g. "Violine solo" and "Vokal-Ensemble". Categories also mandate what pieces can be performed, as well as a min/max duration that depends on the performance's age group.

__Contest category__<br />
A manifestation of a category when offered within a particular contest. This model exists to hold additional constraints: Some contests might offer a category only for certain age groups, or not at all.

__Performance__<br />
A musical entry taking place within a contest category, at a given time and venue. It is associated with an age group calculated from the participants' birth dates.

__Appearance__<br />
A single participant's contribution to a performance. Each appearance is awarded points by the jury, and a certificate is given to its participant afterwards.

__Participant__<br />
A person appearing in one or more performances within a contest.

__Instrument__<br />
A musical instrument used in an appearance.

__Piece__<br />
A piece of music presented during a performance. It is associated with a composer or other artist, as well as a musical epoch.

### Parameters

The following information is unlikely to change much over time and therefore hard-coded into the `jumu_params.rb` file.

Each annual season of "Jugend musiziert" consists of three __rounds__:

1. Regionalwettbewerb (RW)
2. Landeswettbewerb (LW)
3. Bundeswettbewerb (BW)

When appearing in a performance, a __participant's role__ is any of the following:

1. Soloist
2. Ensemblist
3. Accompanist

There are three possible __"genres" for categories__, the availability of which depends on the contest. Not all contests offer Kimu categories, for instance.

1. Classical (Klassik)
2. Popular (Pop)
3. Kinder musizieren (Kimu)

To denote the __musical epoch of a piece__, the letters _a_ through _f_ are used.

### Authentication

[Devise][devise] is used for user authentication. Users can be associated with one or several hosts, typically for the reason of being employed there and acting as local organizers. They can only manipulate resources "belonging" to those hosts.

Apart from __regular users__ with their host-based access rights, there are __admin__ users with full privileges, denoted by an `admin` flag on the `User` model.

[devise]: https://github.com/plataformatec/devise

## License

Jumubase is published under the [MIT License][mit-license].

[mit-license]: https://opensource.org/licenses/MIT
