CREATE TABLE "authorizations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "provider" varchar(255) NOT NULL, "uid" varchar(255) NOT NULL, "user_id" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "feeds" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "url" varchar(255) NOT NULL, "description" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "subscriptions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "feed_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) NOT NULL, "nickname" varchar(255) NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_authorizations_on_provider_and_uid" ON "authorizations" ("provider", "uid");
CREATE INDEX "index_authorizations_on_user_id" ON "authorizations" ("user_id");
CREATE INDEX "index_feeds_on_url" ON "feeds" ("url");
CREATE INDEX "index_subscriptions_on_feed_id" ON "subscriptions" ("feed_id");
CREATE INDEX "index_subscriptions_on_user_id" ON "subscriptions" ("user_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20111105064342');

INSERT INTO schema_migrations (version) VALUES ('20111105064431');

INSERT INTO schema_migrations (version) VALUES ('20111109075036');

INSERT INTO schema_migrations (version) VALUES ('20111122094116');

INSERT INTO schema_migrations (version) VALUES ('20111216025752');